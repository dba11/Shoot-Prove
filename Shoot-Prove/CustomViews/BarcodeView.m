/*************************************************************************
 *
 * SHOOT&PROVE CONFIDENTIAL
 * __________________
 *
 *  [2016]-[2018] Shoot&Prove SA/NV
 *  www.shootandprove.com
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property
 * of Shoot&Prove SA/NV. The intellectual and technical concepts contained
 * herein are proprietary to Shoot&Prove SA/NV.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Shoot&Prove SA/NV.
 */

#import "BarcodeView.h"
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <GLKit/GLKit.h>

@interface BarcodeView()
@property (nonatomic, weak) id<BarcodeViewDelegate> delegate;
@end

@implementation BarcodeView
{
	BOOL _isStopped;
	BOOL _forceStop;
	AVCaptureSession *_captureSession;
	AVCaptureVideoPreviewLayer *_previewLayer;
	dispatch_queue_t _captureQueue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_backgroundMode) name:UIApplicationWillResignActiveNotification object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_foregroundMode) name:UIApplicationDidBecomeActiveNotification object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
	_captureQueue = dispatch_queue_create("com.shootandprove.AVBarcodeCaptureQueue", DISPATCH_QUEUE_SERIAL);
}

- (void)layoutSubviews {
	if(_previewLayer) {
		CGRect bounds = self.layer.bounds;
		_previewLayer.bounds=bounds;
		_previewLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
	}
}

- (void)_backgroundMode {
	_forceStop = YES;
}

- (void)_foregroundMode {
	_forceStop = NO;
}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)_orientationChanged {
	if(!_previewLayer)
		return;
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	AVCaptureConnection *previewLayerConnection=_previewLayer.connection;
	if ([previewLayerConnection isVideoOrientationSupported]) {
		if (deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			[previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
		} else if (deviceOrientation == UIInterfaceOrientationPortrait) {
			[previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
		} else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft) {
			[previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
		} else if (deviceOrientation == UIInterfaceOrientationLandscapeRight) {
			[previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
		} else {
			[previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
		}
	}
}

- (void)setupBarcodeViewWithDelegate:(id<BarcodeViewDelegate>)delegate {
	self.delegate = delegate;
	NSArray *possibleDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	AVCaptureDevice *device = [possibleDevices firstObject];
	if (!device) return;
	_captureSession = [[AVCaptureSession alloc] init];
	[_captureSession beginConfiguration];
	_captureSession.sessionPreset = AVCaptureSessionPreset640x480;
	AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
	[_captureSession addInput:videoInput];
	AVCaptureMetadataOutput *dataOutput = [[AVCaptureMetadataOutput alloc] init];
	[_captureSession addOutput:dataOutput];
	[dataOutput setMetadataObjectsDelegate:self queue:_captureQueue];
	[dataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
	[_captureSession commitConfiguration];
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.masksToBounds                 = YES;
    _previewLayer.needsDisplayOnBoundsChange    = YES;
    _previewLayer.frame                         = self.layer.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _previewLayer.position = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
    _previewLayer.backgroundColor               = [[UIColor blackColor] CGColor];
	[self _orientationChanged];
	[self.layer addSublayer:_previewLayer];
}

- (void)start {
	_isStopped = NO;
	if(![_captureSession isRunning])
		[_captureSession startRunning];
}

- (void)stop {
	_isStopped = YES;
	if([_captureSession isRunning])
		[_captureSession stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
	if(_isStopped || _forceStop)
		return;
	NSString *qrCode;
	for (AVMetadataObject *metadataObject in metadataObjects) {
		if([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
			AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
			qrCode = readableObject.stringValue;
			break;
		}
	}
	if (qrCode && [self.delegate respondsToSelector:@selector(didBarcodeViewDetectQRcode:)]) {
		__weak typeof (self) weakSelf = self;
		dispatch_async(dispatch_get_main_queue(), ^ {
			dispatch_suspend(_captureQueue);
			[weakSelf.delegate didBarcodeViewDetectQRcode:qrCode];
			dispatch_resume(_captureQueue);
		});
	}
}
@end
