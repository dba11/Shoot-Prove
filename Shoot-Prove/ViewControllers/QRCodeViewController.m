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

#import "QRCodeViewController.h"
#import "SWRevealViewController.h"
#import "RestClientManager.h"
#import "SyncManager.h"
#import "ErrorHelper.h"
#import "TaskHelper.h"
#import "DeviceHelper.h"
#import "UIColor+HexString.h"
#import "BEMCheckBox.h"
#import "Service.h"
#import "Task.h"

@interface QRCodeViewController ()
{
	UIBarButtonItem *_btnMenu;
}
@property (weak, nonatomic) IBOutlet UILabel *lblQrCode;
@property (weak, nonatomic) IBOutlet BarcodeView *viewBarCode;
@property (strong, nonatomic) BEMCheckBox *checkboxDone;
@property (weak, nonatomic) id<QRCodeViewControllerDelegate> delegate;
@end

@implementation QRCodeViewController
#pragma - view life cycle
- (id)initWithDelegate:(id<QRCodeViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    [self buildMenuButton];
    
	self.title = NSLocalizedString(@"TITLE_QRCODE_READER", nil);
	
	[self.lblQrCode setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.lblQrCode setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0]];
	[self.lblQrCode setText:NSLocalizedString(@"QRCODE_READER_SCAN_CODE", nil)];
	
    //prepare the animated 'scan done' checkbox
    self.checkboxDone = [[BEMCheckBox alloc] initWithFrame:CGRectMake((self.viewBarCode.frame.size.width - 50) / 2, (self.viewBarCode.frame.size.height - 50) / 2, 50, 50)];
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
    
    [self.viewBarCode addSubview:self.checkboxDone];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setLeftBarButtonItems:@[_btnMenu]];
    [self.navigationItem setRightBarButtonItems:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.toolbarItems = nil;
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [DeviceHelper checkCameraGranted:^(BOOL granted) {
        if(granted) {
            [self.viewBarCode setupBarcodeViewWithDelegate:self];
            [self.viewBarCode start];
        } else {
            [[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"DEVICE_CAMERA_DISABLED", nil), NSLocalizedString(@"DEVICE_OPEN_SETTINGS", nil)] confirmButtonTitle:NSLocalizedString(@"BUTTON_SETTINGS", nil) confirmTag:openSettingsTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
        }
    }];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
    self.checkboxDone.frame = CGRectMake((self.viewBarCode.frame.size.width - 50) / 2, (self.viewBarCode.frame.size.height - 50) / 2, 50, 50);
    [self.viewBarCode addSubview:self.checkboxDone];
}

#pragma - build buttons
- (void)buildMenuButton {
    _btnMenu = [[UIBarButtonItem alloc] init];
    [_btnMenu setImage:[UIImage imageNamed:@"menu"]];
    [_btnMenu setTarget:[self revealViewController]];
    [_btnMenu setAction:@selector(revealToggle:)];
}

#pragma - dialog delegate
- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
    if([tag isEqualToString:openSettingsTag]) {
        [DeviceHelper openDeviceSettings];
    }
}

#pragma - bar code view delegate method
- (void)didBarcodeViewDetectQRcode:(NSString *)qrCode {
	
    self.checkboxDone.animationDuration = 0.8f;
    [self.checkboxDone setOn:YES animated:YES];
    [self.viewBarCode stop];
	qrCode = [qrCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"QRCode:\n%@", qrCode);
	
    UIView * topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    
    NSError *error = nil;
    NSDictionary *qrCodeDictionary = [NSJSONSerialization JSONObjectWithData:[qrCode dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    if(error) {
        [ErrorHelper popToastWithMessage:error.localizedDescription style:ToastHelper.styleError];
        self.checkboxDone.animationDuration = 0.3f;
        [self.checkboxDone setOn:NO animated:YES];
        return;
    }
    
    [[RestClientManager sharedManager] postQRCode:qrCodeDictionary block:^(NSDictionary *dictionary, NSInteger statusCode, NSError *error) {
        
        self.checkboxDone.animationDuration = 0.3f;
        [self.checkboxDone setOn:NO animated:YES];
        
        if(statusCode <= 204) {
            
            NSString *action = [qrCodeDictionary objectForKey:@"a"];
            
            if([action isEqualToString:@"coupon"]) {
                [topView makeToast:NSLocalizedString(@"QRCODE_ACCOUNT_UPDATED", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageInfo style:ToastHelper.styleInfo completion:^(BOOL didTap) {
                    if([self.delegate respondsToSelector:@selector(didQRCodeViewControllerRequestRestart)]) {
                        [self.delegate didQRCodeViewControllerRequestRestart];
                    }
                }];
            } else if([action isEqualToString:@"start"]) {
                NSError *createTaskError;
                Task *task = [TaskHelper createTaskFromDictionary:dictionary visible:YES error:&createTaskError];
                if(!createTaskError) {
                    if([self.delegate respondsToSelector:@selector(didQRCodeViewControllerRequestStartTask:)]) {
                        [self.delegate didQRCodeViewControllerRequestStartTask:task];
                    }
                } else {
                    [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleWarning];
                    [self.viewBarCode start];
                }
            } else {
                if([self.delegate respondsToSelector:@selector(didQRCodeViewControllerRequestSyncServices)]) {
                    [self.delegate didQRCodeViewControllerRequestSyncServices];
                }
            }
            
        } else {
            [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleWarning];
            [self.viewBarCode start];
        }
    }];
}
@end
