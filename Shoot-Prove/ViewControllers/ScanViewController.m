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

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <math.h>
#import <stdio.h>
#import "ErrorHelper.h"
#import "EnumHelper.h"
#import "Dialog.h"
#import "UIColor+HexString.h"
#import "UIView+Toast.h"
#import "BEMCheckBox.h"
#import "StoreManager.h"
#import "SettingsManager.h"
#import "ScanGuide.h"

#define scannerConfidenceThreshold 5.0

static inline AVCaptureVideoOrientation videoOrientationFromInterfaceOrientation(UIInterfaceOrientation orientation) {
	switch (orientation) {
		case UIInterfaceOrientationPortrait:
			return AVCaptureVideoOrientationPortrait;
		case UIInterfaceOrientationPortraitUpsideDown:
			return AVCaptureVideoOrientationPortraitUpsideDown;
		case UIInterfaceOrientationLandscapeLeft:
			return AVCaptureVideoOrientationLandscapeLeft;
		case UIInterfaceOrientationLandscapeRight:
			return AVCaptureVideoOrientationLandscapeRight;
		default:
			return AVCaptureVideoOrientationLandscapeLeft;
	}
}

static inline CGAffineTransform affineTransformForInterfaceOrientation(UIInterfaceOrientation orientation) {
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return CGAffineTransformMakeRotation(M_PI + M_PI_2);
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(M_PI_2);
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(M_PI);
        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(0.0);
        default:
            return CGAffineTransformMakeRotation(M_PI+ M_PI_2);
    }
}

@interface ScanViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *viewAdjust;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfPages;
@property (weak, nonatomic) IBOutlet UIButton *btnTorch;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnCapture;
@property (weak, nonatomic) IBOutlet UIButton *btnFormat;
@property (weak, nonatomic) IBOutlet UIButton *btnColorMode;
@property (weak, nonatomic) IBOutlet UIButton *btnDpi;
@property (weak, nonatomic) IBOutlet UIButton *btnScanMode;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (strong, nonatomic) BEMCheckBox *checkboxDone;
@property (weak, nonatomic) id<ScanViewControllerDelegate>delegate;
@end

@implementation ScanViewController
{
	AVCaptureDevice *_device;
	AVCaptureSession *_session;
    AVCaptureDeviceInput *_deviceInput;
	AVCaptureStillImageOutput *_imageOutput;
	AVCaptureVideoPreviewLayer *_previewLayer;
    int _numberOfPages;
	ScanGuide *_scanGuide;
	NSTimer *_detectTimer;
	BOOL _detectEnabled;
	CGFloat _detectConfidence;
	CIRectangleFeature *_detectRectangle;
	SPFormat _format;
	CGFloat _formatRatio;
	CGSize _formatSize;
	int _dpi;
	SPColorMode _colorMode;
    BOOL _deskew;
    BOOL _despekle;
    BOOL _smoothing;
    BOOL _dotRemove;
	BOOL _autoCapture;
    BOOL _flashOn;
	BOOL _freeMode;
    BOOL _continuous;
	BOOL _capturing;
	BOOL _forceStop;
	BOOL _stopped;
	dispatch_queue_t _captureQueue;
}

#pragma public methods
- (id)initWithFormat:(SPFormat)format dpi:(int)dpi colorMode:(SPColorMode)colorMode flashOn:(BOOL)flashOn autoCapture:(BOOL)autoCapture freeMode:(BOOL)freeMode delegate:(id<ScanViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		self.delegate = delegate;
		_freeMode = freeMode;
		_format = format;
		_dpi = dpi;
		_colorMode = colorMode;
        _flashOn = flashOn;
        _autoCapture = autoCapture;
        _continuous = freeMode;
        if(_format != SPFormatAny) {
            _formatSize = [ImageHelper formatSize:_format orientation:[UIApplication sharedApplication].statusBarOrientation resolution:_dpi];
            _formatRatio = _formatSize.width / _formatSize.height;
        } else {
            _formatSize = CGSizeZero;
            _formatRatio = 0.0f;
        }
        _deskew = YES; //[SettingsManager.sharedManager deskew];
        _despekle = NO; //[SettingsManager.sharedManager despekle];
        _smoothing = NO; //[SettingsManager.sharedManager smoothing];
        _dotRemove = NO; //[SettingsManager.sharedManager dotRemove];
		_capturing = NO;
		_forceStop = NO;
		_stopped = YES;
		_detectEnabled = NO;
		_detectConfidence = 0;
        _numberOfPages = 0;
	}
	return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma - view life cycle
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor colorWithHexString:colorBlack andAlpha:1.0f]];
	
	[self.viewAdjust setBackgroundColor:[UIColor clearColor]];
	[self.btnTorch addTarget:self action:@selector(toggleFlash) forControlEvents:UIControlEventTouchUpInside];
	[self.btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	[self.btnCapture addTarget:self action:@selector(capture) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnFormat.backgroundColor = [UIColor colorWithHexString:colorBlack andAlpha:1.0f];
    self.btnFormat.layer.cornerRadius = 4.0f;
    self.btnFormat.layer.masksToBounds = YES;
	[self.btnFormat addTarget:self action:@selector(toggleFormat) forControlEvents:UIControlEventTouchUpInside];
	
    self.btnColorMode.backgroundColor = [UIColor colorWithHexString:colorBlack andAlpha:1.0f];
    self.btnColorMode.layer.cornerRadius = 4.0f;
    self.btnColorMode.layer.masksToBounds = YES;
    [self.btnColorMode addTarget:self action:@selector(toggleColorMode) forControlEvents:UIControlEventTouchUpInside];
	
    self.btnDpi.backgroundColor = [UIColor colorWithHexString:colorBlack andAlpha:1.0f];
    self.btnDpi.layer.cornerRadius = 4.0f;
    self.btnDpi.layer.masksToBounds = YES;
    [self.btnDpi addTarget:self action:@selector(toggleDpi) forControlEvents:UIControlEventTouchUpInside];
	
    [self.btnScanMode addTarget:self action:@selector(toggleScanMode) forControlEvents:UIControlEventTouchUpInside];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_backgroundMode) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_foregroundMode) name:UIApplicationDidBecomeActiveNotification object:nil];
	
	_captureQueue = dispatch_queue_create("com.shootandprove.capture_queue", DISPATCH_QUEUE_SERIAL);
	
	[self setupScannerInterface];
	[self setupScanner];
    [self setupScannerGuide];
    [self startScanner];
    [self setFlashEnabled:_flashOn];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
	[self.navigationController setToolbarHidden:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        if (_previewLayer.connection.isVideoOrientationSupported)
            _previewLayer.connection.videoOrientation = videoOrientationFromInterfaceOrientation([UIApplication sharedApplication].statusBarOrientation);
        [self updateFrames];
    } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[self updateFrames];
    //[self checkScannerQuality:YES];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma - notification center methods
- (void)_backgroundMode {
	_forceStop = YES;
}

- (void)_foregroundMode {
	_forceStop = NO;
}

#pragma - scanner interface setup
- (void)setupScannerInterface {
	
    [self.btnCancel setImage:[UIImage imageNamed:_freeMode ? @"done":@"close"] forState:UIControlStateNormal];
	[self.btnScanMode setTitle:_autoCapture ? @"Auto":@"Man." forState:UIControlStateNormal];
	[self.btnCapture setHidden:_autoCapture];

    self.checkboxDone = [[BEMCheckBox alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) / 2, (self.view.frame.size.height - 50) / 2, 50, 50)];
    self.checkboxDone.boxType = BEMBoxTypeCircle;
    self.checkboxDone.hideBox = NO;
    self.checkboxDone.on = NO;
    self.checkboxDone.tintColor = [UIColor clearColor];
    self.checkboxDone.onTintColor = [UIColor colorWithHexString:colorGreen andAlpha:0.8f];
    self.checkboxDone.onFillColor = [UIColor colorWithHexString:colorGreen andAlpha:0.8f];
    self.checkboxDone.onCheckColor = [UIColor whiteColor];
    self.checkboxDone.lineWidth = 3.0f;
    self.checkboxDone.animationDuration = 0.8f;
    self.checkboxDone.onAnimationType = BEMAnimationTypeFill;
    self.checkboxDone.offAnimationType = BEMAnimationTypeFill;
    self.checkboxDone.userInteractionEnabled = NO;
    
    [_viewAdjust addSubview:self.checkboxDone];

    self.lblNumberOfPages.font = [UIFont fontWithName:boldFontName size:normalFontSize];
    self.lblNumberOfPages.textColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f];
    self.lblNumberOfPages.backgroundColor = [UIColor colorWithHexString:colorGreen andAlpha:0.5f];
    self.lblNumberOfPages.layer.cornerRadius = self.lblNumberOfPages.frame.size.height / 2;
    self.lblNumberOfPages.layer.masksToBounds = YES;
    self.lblNumberOfPages.layer.borderWidth = 1.0f;
    self.lblNumberOfPages.layer.borderColor = [UIColor colorWithHexString:colorGreen andAlpha:1.0f].CGColor;
    self.lblNumberOfPages.alpha = 0.0f;
    
	if(_freeMode) {
		
		NSString *format;
		switch (_format) {
			case SPFormatA4:
				format = NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_A4", nil);
				break;
			case SPFormatA5:
				format = NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_A5", nil);
				break;
			case SPFormatID1:
                format = NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_ID1", nil);
                break;
            case SPFormatAny:
			default:
				format = NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_ANY", nil);
				break;
		}
		[self.btnFormat setTitle:format forState:UIControlStateNormal];
		
		UIImage *image;
		switch (_colorMode) {
			case SPColorModeBlackAndWhite:
				image = [UIImage imageNamed:@"color_mode_bw"];
				break;
			case SPColorModeGrey:
				image = [UIImage imageNamed:@"color_mode_grey"];
				break;
			case SPColorModeColor:
			default:
				image = [UIImage imageNamed:@"color_mode_color"];
				break;
		}
		[self.btnColorMode setImage:image forState:UIControlStateNormal];
		
		[self.btnDpi setTitle:[NSString stringWithFormat:@"%d", _dpi] forState:UIControlStateNormal];
		
		[self.btnFormat setHidden:NO];
		[self.btnColorMode setHidden:NO];
		[self.btnDpi setHidden:NO];
        
	} else {
		
		[self.btnFormat setHidden:YES];
		[self.btnColorMode setHidden:YES];
		[self.btnDpi setHidden:YES];
		
	}
}

#pragma - setup scanner camera and preview
- (void)setupScanner {

	_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (!_device)
		return;
	_session = [[AVCaptureSession alloc] init];
	[_session beginConfiguration];
	[_session setSessionPreset:AVCaptureSessionPresetPhoto];
	_previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
	_previewLayer.masksToBounds                 = YES;
	_previewLayer.needsDisplayOnBoundsChange    = YES;
    _previewLayer.frame                         = _previewView.bounds;
	_previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	_previewLayer.position = CGPointMake(CGRectGetMidX(_previewView.bounds), CGRectGetMidY(_previewView.bounds));
    _previewLayer.backgroundColor               = [[UIColor blackColor] CGColor];
	
    _previewView.backgroundColor                = [UIColor blackColor];
    [_previewView.layer insertSublayer:_previewLayer below:_scanGuide];
	[_previewView setHidden:YES];
	_deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:nil];
	[_session addInput:_deviceInput];
	AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
	output.alwaysDiscardsLateVideoFrames = YES;
	output.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
	[output setSampleBufferDelegate:self queue:_captureQueue];
	[_session addOutput:output];
	_imageOutput = [[AVCaptureStillImageOutput alloc] init];
	[_session addOutput:_imageOutput];
	if (_previewLayer.connection.isVideoOrientationSupported)
		_previewLayer.connection.videoOrientation = videoOrientationFromInterfaceOrientation([UIApplication sharedApplication].statusBarOrientation);
    [_device lockForConfiguration:nil];
	if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		[_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
	}
    if([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }
    [_device unlockForConfiguration];
	[_session commitConfiguration];
}

#pragma - helper to check if the camera resolution is valid for the requested format x resolution
- (BOOL)checkScannerQuality:(BOOL)displayWarning {
    AVCaptureInputPort *inputPort = nil;
    CMFormatDescriptionRef formatDescription = nil;
    for (AVCaptureInputPort *port in _deviceInput.ports) {
        if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
            inputPort = port;
            break;
        }
    }
    if(inputPort) {
        formatDescription= inputPort.formatDescription;
    } else {
        NSLog(@"ScanViewController.checkScannerQuality.inputPort.null");
    }
    if(formatDescription) {
        CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
        NSLog(@"ScanViewController.checkScannerQuality.requestSize:\n%.0f x %.0f\nScanViewController.checkScannerQuality.cameraSize:\n%d x %d", _formatSize.width, _formatSize.height, dimensions.width, dimensions.height);
        if(_formatSize.width > dimensions.width || _formatSize.height > dimensions.height) {
            if(displayWarning) {
                [ErrorHelper popDialogWithTitle:NSLocalizedString(@"TITLE_WARNING", nil) message:[NSString stringWithFormat:@"Requested image size:\n%.0f x %.0f\n\nCamera quality:\n%d x %d", _formatSize.width, _formatSize.height, dimensions.width, dimensions.height] type:DialogTypeWarning];
            }
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

#pragma - setup scanner guide
- (void)setupScannerGuide {
    [self resetScannerGuide];
    if(_format != SPFormatAny) { //guide is created and displayed only if the image format is defined
        _scanGuide = [ScanGuide layer];
        _scanGuide.guideSize = _formatSize;
        _scanGuide.guideColor = [UIColor colorWithHexString:_autoCapture ? colorRed:colorGreen andAlpha:1.0f];
        _scanGuide.frame = _previewView.frame;
        _scanGuide.interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        _scanGuide.needsDisplayOnBoundsChange = YES;
        _scanGuide.contentsGravity = kCAGravityResizeAspect;
        [_previewView.layer addSublayer:_scanGuide];
        [_scanGuide setNeedsDisplay];
    }
}

- (void)resetScannerGuide {
    if(_scanGuide) {
        [_scanGuide removeFromSuperlayer];
    }
    self.previewImage.image = nil;
}

#pragma - rectangle detection setup
- (void)setupDetection {
    if(_autoCapture || _format == SPFormatAny) {
        _detectTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(enableDetection) userInfo:nil repeats:YES];
    } else {
        [_detectTimer invalidate];
        _detectRectangle = nil;
    }
}

- (void)enableDetection {
    _detectEnabled = YES;
}

#pragma - start / stop scanner
- (void)startScanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        _stopped = NO;
        [_session startRunning];
        [self setupDetection];
    });
}

- (void)stopScanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        _stopped = YES;
        [self setFlashEnabled:NO];
        [_detectTimer invalidate];
        [_session stopRunning];
    });
}

#pragma - flash activation / deactivation
- (void)setFlashEnabled:(BOOL)enabled {
    if ([_device hasTorch] && [_device hasFlash]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.btnTorch setImage:enabled ? [UIImage imageNamed:@"flash_on"]:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
        });
        [_device lockForConfiguration:nil];
        [_device setTorchMode:enabled ? AVCaptureTorchModeOn:AVCaptureTorchModeOff];
        [_device unlockForConfiguration];
        [self.btnTorch setHidden:NO];
    } else {
        [self.btnTorch setHidden:YES];
    }
}

#pragma - update preview and guide based on device orientation
- (void)updateFrames {
    CGRect bounds = _previewView.bounds;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        _previewView.bounds = CGRectMake(0, 0, MIN(bounds.size.width, bounds.size.height), MAX(bounds.size.width, bounds.size.height));
    } else {
        _previewView.bounds = CGRectMake(0, 0, MAX(bounds.size.width, bounds.size.height), MIN(bounds.size.width, bounds.size.height));
    }
    _previewView.frame = _previewView.bounds;
    _previewView.hidden = NO;
    _previewLayer.frame = _previewView.bounds;
    if(_format != SPFormatAny) {
        _formatSize = [ImageHelper formatSize:_format orientation:interfaceOrientation resolution:_dpi];
        _formatRatio = _formatSize.width / _formatSize.height;
        _scanGuide.frame = _previewView.frame;
        _scanGuide.guideSize = _formatSize;
        _scanGuide.interfaceOrientation = interfaceOrientation;
    } else {
        _formatSize = CGSizeZero;
        _formatRatio = 0.0;
    }
    _checkboxDone.frame = CGRectMake((_previewView.bounds.size.width - 50)/2, (_previewView.frame.size.height - 50) / 2, 50, 50);
}

#pragma - helper to show/hide the remaining number of pages in progress by scan view controller
- (void)displayNumberOfPages {
    if(_numberOfPages > 1) {
        self.lblNumberOfPages.text = [NSString stringWithFormat:NSLocalizedString(@"SCANNER_PAGES", nil), _numberOfPages];
    } else {
        self.lblNumberOfPages.text = [NSString stringWithFormat:NSLocalizedString(@"SCANNER_PAGE", nil), _numberOfPages];
    }
    if(_numberOfPages > 0 && self.lblNumberOfPages.alpha == 0.0f) {
        [UIView animateWithDuration:0.8 animations:^{
            self.lblNumberOfPages.alpha = 1.0f;
        } completion:^(BOOL finished) {}];
    } else if(_numberOfPages == 0 && self.lblNumberOfPages.alpha == 1.0f) { //should never happen but who knows...
        [UIView animateWithDuration:0.8 animations:^{
            self.lblNumberOfPages.alpha = 0.0f;
        } completion:^(BOOL finished) {}];
    }
}

#pragma - AVCaptureOutput delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	if (_forceStop || _stopped || _capturing || !CMSampleBufferIsValid(sampleBuffer)) return;
    
	CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
	CIImage *image = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    BOOL refreshOverlay = NO;
    
	if(_detectEnabled) {
        _detectRectangle = [ImageHelper biggestRectangleInRectangles:[[ImageHelper rectangleDetectorMinFeatureSize:_format != SPFormatAny ? scanGuideSizeRatio:0 AspectRatio:_formatRatio] featuresInImage:image]];
        refreshOverlay = YES;
        _detectEnabled = NO;
    }
	if (_detectRectangle && _autoCapture &&  ![_device isAdjustingFocus]) {
		_detectConfidence += .1;
	} else {
		_detectConfidence = 0.0f;
	}
    if(_format != SPFormatAny) {
        _scanGuide.guideColor = [UIColor colorWithHexString:((_autoCapture && _detectConfidence > 0.0) || !_autoCapture) ? colorGreen:colorRed andAlpha:1.0f];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_scanGuide setNeedsDisplay];
        });
    } else if(refreshOverlay && _detectRectangle) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            CGImageRef overlayCGImageRef = nil;
            CIImage *overlay = [ImageHelper drawHighlightOverlayForRectangle:image rectangle:_detectRectangle colorMode:_colorMode];
            overlay = [overlay imageByApplyingTransform:affineTransformForInterfaceOrientation([UIApplication sharedApplication].statusBarOrientation)];
            CIContext *context = [CIContext contextWithOptions:nil];
            overlayCGImageRef = [context createCGImage:overlay fromRect:overlay.extent];
            self.previewImage.image = [UIImage imageWithCGImage:overlayCGImageRef];
            [self.previewImage setNeedsDisplay];
            CGImageRelease(overlayCGImageRef);
        });
        refreshOverlay = NO;
    }
	if(_detectConfidence > scannerConfidenceThreshold) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self capture];
        });
	}
}

#pragma - button events
- (void)capture {
    if(_capturing)
        return;
    _detectConfidence = 0.0f;
    _capturing = YES;
    dispatch_suspend(_captureQueue);
    _previewLayer.connection.enabled = _continuous;
    [self resetScannerGuide];
    self.btnCapture.hidden = YES;
    self.btnCancel.hidden = YES;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _imageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) break;
    }
    
    [_imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if([self handleCaptureError:error]) return;
        @autoreleasepool {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            CIImage *image = [[CIImage alloc] initWithData:imageData];
            imageData = nil;

            CIRectangleFeature *rectangle = [ImageHelper biggestRectangleInRectangles:[[ImageHelper rectangleDetectorMinFeatureSize:_format != SPFormatAny ? scanGuideSizeRatio:0 AspectRatio:_formatRatio] featuresInImage:image]];
            if(rectangle) {
                image = [ImageHelper correctPerspectiveForImage:image withFeatures:rectangle];
            }
            
            UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.checkboxDone.animationDuration = 0.4f;
                    [self.checkboxDone setOn:YES animated:YES];
                    if([self.delegate respondsToSelector:@selector(willScanViewControllerReturnRasterImage)]) {
                        [self.delegate willScanViewControllerReturnRasterImage];
                    }
                });
                
                NSError *error;
                LTRasterImage *rasterImage = [ImageHelper rasterImageFromCIImage:image error:&error];
                if([self handleCaptureError:error]) return;
                rasterImage = [ImageHelper correctImageRotation:rasterImage interfaceOrientation:interfaceOrientation error:&error];
                if([self handleCaptureError:error]) return;
                
                LTCropCommand* cropCmd;
                if(rectangle) {
                    cropCmd = [[LTCropCommand alloc] initWithRectangle:[ImageHelper rectangleFromImage:rasterImage reducedOfPixels:_dpi * 0.2]];
                } else if(_scanGuide) {
                    cropCmd = [[LTCropCommand alloc] initWithRectangle:[ImageHelper rectangleFromGuideRect:_scanGuide.guideFrame inPreviewRect:_previewLayer.bounds overRasterImage:rasterImage]];
                }
                if(cropCmd) {
                    [cropCmd run:rasterImage error:&error];
                    if([self handleCaptureError:error]) return;
                }
                
                switch (_colorMode) {
                    case SPColorModeBlackAndWhite:
                        [ImageHelper blackAndWhiteImage:rasterImage error:&error];
                        if(_dotRemove)
                            [ImageHelper dotRemoveImage:rasterImage error:&error];
                        if(_smoothing)
                            [ImageHelper smoothTextImage:rasterImage error:&error];
                        break;
                        
                    case SPColorModeGrey:
                        [ImageHelper grayImage:rasterImage error:&error];
                        if(_despekle)
                            [ImageHelper despekleImage:rasterImage error:&error];
                        break;
                        
                    case SPColorModeColor:
                        if(_despekle)
                            [ImageHelper despekleImage:rasterImage error:&error];
                        break;
                        
                    default:
                        break;
                }
                if([self handleCaptureError:error]) return;
                
                if(_deskew && rectangle)
                    [ImageHelper deskewImage:rasterImage error:&error];

                [ImageHelper resizeImage:rasterImage toSize:_formatSize allowStretch:NO error:&error];
                if([self handleCaptureError:error]) return;
                rasterImage.xResolution = _dpi;
                rasterImage.yResolution = _dpi;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.checkboxDone.animationDuration = 0.2f;
                    [self.checkboxDone setOn:NO animated:YES];
                });
                
                if([self.delegate respondsToSelector:@selector(didScanViewControllerReturnRasterImage:format:dpi:colorMode:flashOn:autoCapture:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate didScanViewControllerReturnRasterImage:rasterImage format:_format dpi:_dpi colorMode:_colorMode flashOn:_flashOn autoCapture:_autoCapture];
                        _numberOfPages++;
                        [self displayNumberOfPages];
                    });
                }
                dispatch_resume(_captureQueue);
                
                if(!_continuous) {
                    [self stopScanner];
                    if([self.delegate respondsToSelector:@selector(didScanViewControllerCancel)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate didScanViewControllerCancel];
                        });
                    }
                } else {
                    _capturing = NO;
                    _previewLayer.connection.enabled = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setupScannerGuide];
                        [self updateFrames];
                        self.btnCapture.hidden = _autoCapture;
                        self.btnCancel.hidden = !_freeMode;
                    });
                }
            });
        }
    }];
}

- (void)toggleFlash {
    _flashOn = !_flashOn;
    [self setFlashEnabled:_flashOn];
}

- (void)toggleFormat {
	NSString *format;
	switch (_format) {
		case SPFormatA4:
			_format = SPFormatA5;
			format = NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_A5", nil);
			break;
		case SPFormatA5:
			_format = SPFormatID1;
			format = NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_ID1", nil);
			break;
		case SPFormatID1:
            _format = SPFormatAny;
            format = NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_ANY", nil);
            break;
        case SPFormatAny:
            _format = SPFormatA4;
            format = NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_A4", nil);
            break;
		default:
            break;
	}
	[self.btnFormat setTitle:format forState:UIControlStateNormal];
    [self setupScannerGuide];
	[self updateFrames];
    [self setupDetection];
    //[self checkScannerQuality:YES];
}

- (void)toggleColorMode {
	UIImage *image;
	switch (_colorMode) {
		case SPColorModeBlackAndWhite:
			_colorMode = SPColorModeGrey;
			image = [UIImage imageNamed:@"color_mode_grey"];
			break;
		case SPColorModeGrey:
			_colorMode = SPColorModeColor;
			image = [UIImage imageNamed:@"color_mode_color"];
			break;
		case SPColorModeColor:
		default:
			_colorMode = SPColorModeBlackAndWhite;
			image = [UIImage imageNamed:@"color_mode_bw"];
			break;
	}
	[self.btnColorMode setImage:image forState:UIControlStateNormal];
    [self updateFrames];
}

- (void)toggleDpi {
	switch (_dpi) {
		case 150:
			_dpi = 200;
			break;
		case 200:
			_dpi = 300;
			break;
		case 300:
		default:
			_dpi = 150;
			break;
	}
	[self.btnDpi setTitle:[NSString stringWithFormat:@"%d", _dpi] forState:UIControlStateNormal];
    [self updateFrames];
    //[self checkScannerQuality:YES];
}

- (void)toggleScanMode {
    _autoCapture = !_autoCapture;
	_detectConfidence = 0.0;
    _detectEnabled = NO;
    [self setupScannerInterface];
    [self setupDetection];
}

- (void)cancel {
	if([self.delegate respondsToSelector:@selector(didScanViewControllerCancel)]) {
		[self stopScanner];
		[self.delegate didScanViewControllerCancel];
	}
}

#pragma - error display helper
- (BOOL)handleCaptureError:(NSError *)error {
    if(error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ErrorHelper popToastWithMessage:[NSString stringWithFormat:@"%@: %@", error.domain, error.localizedDescription] style:ToastHelper.styleError];
        });
        dispatch_resume(_captureQueue);
        _previewLayer.connection.enabled = YES;
        _capturing = NO;
        if(self.checkboxDone.on) {
            self.checkboxDone.animationDuration = 0.2f;
            [self.checkboxDone setOn:NO animated:YES];
        }
        self.btnCancel.hidden = !_freeMode;
        [self.btnCapture setHidden:_autoCapture];
        return YES;
    }
    return NO;
}
@end
