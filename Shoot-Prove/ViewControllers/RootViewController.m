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

#import "RootViewController.h"
#import "SettingsManager.h"
#import "UIColor+HexString.h"
#import "ToastHelper.h"
#import "StyleHelper.h"
#import "ErrorHelper.h"
#import "User.h"
#import "MenuItem.h"

@interface RootViewController ()
{
	SWRevealViewController *_revealViewController;
	UINavigationController *_frontController;
    MenuViewController *_menuViewController;
	MenuItem * _menuItem;
    CGFloat _maxSteps;
    User *_user;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *lblBuildInfo;
@end

@implementation RootViewController
#pragma - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.lblTitle setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.lblTitle setFont:[UIFont fontWithName:thinFontName size:xLargeFontSize]];
	[self.lblTitle setText:NSLocalizedString(@"APPLICATION_TITLE", nil)];
	
	[self.progressView setProgressViewStyle:UIProgressViewStyleBar];
	[self.progressView setProgress:0];
	[self.progressView setUserInteractionEnabled:NO];
	[self.progressView setTrackTintColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.progressView setProgressTintColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 4.0f);
	self.progressView.transform = transform;
	
	[self.lblBuildInfo setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.lblBuildInfo setFont:[UIFont fontWithName:thinFontName size:smallFontSize]];
	[self.lblBuildInfo setText:[NSString stringWithFormat:NSLocalizedString(@"APPLICATION_VERSION", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
	
    _maxSteps = 1.0;
    [self startApp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.toolbarItems = nil;
    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma - Controller methods
- (void)setProgressViewStep:(NSInteger)step async:(BOOL)async {
    if(async) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setProgress:step];
        });
    } else {
        [self setProgress:step];
    }
}

- (void)setProgress:(NSInteger)step {
    step = step > _maxSteps ? _maxSteps:step;
    CGFloat progress = (float)step/_maxSteps;
    [self.progressView setProgress:progress animated:YES];
    [self.progressView setNeedsDisplay];
}

- (void)startApp {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
    _revealViewController = nil;
    _frontController = nil;
    _menuViewController = nil;
    _user = nil;
    [StartManager.sharedManager setDelegate:self];
    [StartManager.sharedManager setNavigationController:self.navigationController];
    [StartManager.sharedManager start];
}

- (void)displayInterfaceWithUser:(User *)user serverOnline:(BOOL)serverOnline {
	
	[self.navigationController popToRootViewControllerAnimated:YES];
    _user = user;
    
	UIViewController *controller;
	NSString *controllerName = [SettingsManager.sharedManager lastViewControllerName];
	SPTaskDisplayMode displayMode = [SettingsManager.sharedManager lastDisplayMode];
	
	if(displayMode > SPTaskDisplayModeHistory)
		controllerName = nil;
	
	if([controllerName isEqualToString:NSStringFromClass([TaskViewController class])]) {
        controller = [[TaskViewController alloc] initWithUser:_user displayMode:displayMode delegate:self];
	} else if([controllerName isEqualToString:NSStringFromClass([TaskViewController_iPad class])]) {
        controller = [[TaskViewController_iPad alloc] initWithUser:_user displayMode:displayMode delegate:self];
	} else if([controllerName isEqualToString:NSStringFromClass([SettingsViewController class])]){
		controller = [[SettingsViewController alloc] initWithUser:_user delegate:self];
	} else if([controllerName isEqualToString:NSStringFromClass([AccountViewController class])]) {
		controller = [[AccountViewController alloc] initWithUser:_user delegate:self];
	} else if([controllerName isEqualToString:NSStringFromClass([ServicesViewController class])]) {
		controller = [[ServicesViewController alloc] initWithUser:_user delegate:self];
    } else if([controllerName isEqualToString:NSStringFromClass([QRCodeViewController class])]) {
        controller = [[QRCodeViewController alloc] initWithDelegate:self];
    } else {
		controller = [[FreeCaptureViewController alloc] initWithUser:_user delegate:self];
	}
	
	_frontController = [[UINavigationController alloc] initWithRootViewController:controller];
	_menuViewController = [[MenuViewController alloc] init];
	[_menuViewController setDelegate:self];
	UINavigationController *rearController = [[UINavigationController alloc] initWithRootViewController:_menuViewController];
	
	_revealViewController = [[SWRevealViewController alloc] initWithRearViewController:rearController frontViewController:_frontController];
	[_revealViewController setDelegate:self];
	[_revealViewController setRightViewController:nil];
	[_revealViewController panGestureRecognizer];
    
    [self.navigationController pushViewController:_revealViewController animated:YES];
    if(serverOnline)
        [self processPendingActions];
    
}

- (void)processPendingActions {
    if([NotificationManager.sharedManager hasPendingNotification]) {
        [NotificationManager.sharedManager setDelegate:self];
        [NotificationManager.sharedManager processPendingNotification];
    } else if([RequestManager.sharedManager hasPendingRequest]) {
        [RequestManager.sharedManager setDelegate:self];
        [RequestManager.sharedManager processPendingRequest];
    } else {
        [SyncManager.sharedManager syncTasks:YES andServices:YES];
    }
}

#pragma MenuViewController delegate
- (void)didClickMenuItem:(MenuItem *)menuItem {
	if([menuItem isEqual:_menuItem]) {
		[_revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
		return;
    } else {
        _menuItem = menuItem;
    }
	UIViewController *controller = nil;
	NSString *controllerName;
	SPTaskDisplayMode displayMode = SPTaskDisplayModeHistory;
	if([menuItem.name isEqualToString:NSLocalizedString(@"MENU_HISTORY", nil)]) {
		displayMode = SPTaskDisplayModeHistory;
		if(isDeviceIPad) {
            controller = [[TaskViewController_iPad alloc] initWithUser:_user displayMode:displayMode delegate:self];
			controllerName = NSStringFromClass([TaskViewController_iPad class]);
		} else {
            controller = [[TaskViewController alloc] initWithUser:_user displayMode:displayMode delegate:self];
			controllerName = NSStringFromClass([TaskViewController class]);
		}
	} else if([menuItem.name isEqualToString:NSLocalizedString(@"MENU_FREE_CAPTURE", nil)]) {
		controller = [[FreeCaptureViewController alloc] initWithUser:_user delegate:self];
		controllerName = NSStringFromClass([FreeCaptureViewController class]);
	} else if ([menuItem.name isEqualToString:NSLocalizedString(@"MENU_INBOX", nil)]) {
		displayMode = SPTaskDisplayModeInbox;
		if(isDeviceIPad) {
            controller = [[TaskViewController_iPad alloc] initWithUser:_user displayMode:displayMode delegate:self];
			controllerName = NSStringFromClass([TaskViewController_iPad class]);
		} else {
            controller = [[TaskViewController alloc] initWithUser:_user displayMode:displayMode delegate:self];
			controllerName = NSStringFromClass([TaskViewController class]);
		}
	} else if ([menuItem.name isEqualToString:NSLocalizedString(@"MENU_SERVICES", nil)]) {
		controller = [[ServicesViewController alloc] initWithUser:_user delegate:self];
		controllerName = NSStringFromClass([ServicesViewController class]);
	} else if ([menuItem.name isEqualToString:NSLocalizedString(@"MENU_ACCOUNT", nil)]) {
		controller = [[AccountViewController alloc] initWithUser:_user delegate:self];
		controllerName = NSStringFromClass([AccountViewController class]);
	} else if ([menuItem.name isEqualToString:NSLocalizedString(@"MENU_SETTINGS", nil)]) {
		controller = [[SettingsViewController alloc] initWithUser:_user delegate:self];
		controllerName = NSStringFromClass([SettingsViewController class]);
	} else if ([menuItem.name isEqualToString:NSLocalizedString(@"MENU_TRASH", nil)]) {
		displayMode = SPTaskDisplayModeTrash;
		if(isDeviceIPad) {
            controller = [[TaskViewController_iPad alloc] initWithUser:_user displayMode:displayMode delegate:self];
			controllerName = NSStringFromClass([TaskViewController_iPad class]);
		} else {
            controller = [[TaskViewController alloc] initWithUser:_user displayMode:displayMode delegate:self];
			controllerName = NSStringFromClass([TaskViewController class]);
		}
    } else if ([menuItem.name isEqualToString:NSLocalizedString(@"MENU_QRCODE", nil)]) {
        controller = [[QRCodeViewController alloc] initWithDelegate:self];
        controllerName = NSStringFromClass([QRCodeViewController class]);
    }
	if(!controller) {
		[_revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    } else {
        [self pushFrontController:controller name:controllerName displayMode:displayMode];
    }
}

- (void)pushFrontController:(UIViewController *)controller name:(NSString *)name displayMode:(SPTaskDisplayMode)displayMode {
    _frontController = [[UINavigationController alloc] initWithRootViewController:controller];
    [_revealViewController pushFrontViewController:_frontController animated:YES];
    [SettingsManager.sharedManager setLastViewControllerName:name];
    [SettingsManager.sharedManager setLastDisplayMode:displayMode];
    [SettingsManager.sharedManager save];
}

#pragma - StartManager delegate methods
- (void)didStartManagerSetMaxSteps:(NSInteger)maxSteps {
    _maxSteps = maxSteps > 0 ? maxSteps:1.0;
}

- (void)didStartManagerSetStep:(NSInteger)step async:(BOOL)async {
    [self setProgressViewStep:step async:async];
}

- (void)didStartManagerRequestReset {
    [self startApp];
}

- (void)didStartManagerRequestDisplayInterfaceWithUser:(User *)user serverOnline:(BOOL)serverOnline {
    [self displayInterfaceWithUser:user serverOnline:serverOnline];
}

#pragma AccountViewController delegate
- (void)didAccountViewControllerUpdateUser:(User *)user {
	_user = user;
}

- (void)didAccountViewControllerRequestReset {
    [StartManager.sharedManager reset];
}

#pragma - service view controller delegate
- (void)didServicesViewControllerRequestStartTask:(Task *)task {
    [self startTask:task popConfirm:NO];
}

- (void)didServicesViewControllerRequestStartQRCodeReader {
    [self didClickMenuItem:_menuViewController.qrCodeReaderMenuItem];
}

#pragma - task view controller delegate
- (void)didTaskViewControllerRequestStartTask:(Task *)task {
    [self startTask:task popConfirm:NO];
}

- (void)didTaskViewControllerRequestDisplayAccount {
    [self didClickMenuItem:_menuViewController.accountMenuItem];
}

#pragma - task view controller iPad delegate
- (void)didTaskViewControllerIpadRequestStartTask:(Task *)task {
    [self startTask:task popConfirm:NO];
}

- (void)didTaskViewControllerIpadRequestDisplayAccount {
    [self didClickMenuItem:_menuViewController.accountMenuItem];
}

#pragma - notification manager delegate methods
- (void)didNotificationManagerRequestStartTask:(Task *)task startNow:(BOOL)startNow {
    [self didClickMenuItem:_menuViewController.inboxMenuItem];
    [self startTask:task popConfirm:!startNow];
}

- (void)didNotificationManagerRequestSyncTasks {
	[SyncManager.sharedManager syncTasks:YES andServices:NO];
}

- (void)didNotificationManagerRequestSyncServices {
	[SyncManager.sharedManager syncTasks:NO andServices:YES];
}

#pragma - request manager delegate methods
- (void)didRequestManagerRequestStartTask:(Task *)task {
    [self didClickMenuItem:_menuViewController.inboxMenuItem];
    [self startTask:task popConfirm:NO];
}

#pragma - settings delegate method
- (void)didSettingsViewControllerRequestRestart {
    [SettingsManager.sharedManager setLastViewControllerName:NSStringFromClass([FreeCaptureViewController class])];
    [SettingsManager.sharedManager setLastDisplayMode:SPTaskDisplayModeHistory]; // or whatever
    [SettingsManager.sharedManager save];
    [self startApp];
}

#pragma - QRCodeViewController delegate methods
- (void)didQRCodeViewControllerRequestRestart {
    [SettingsManager.sharedManager setLastViewControllerName:NSStringFromClass([AccountViewController class])];
    [SettingsManager.sharedManager setLastDisplayMode:SPTaskDisplayModeHistory]; // or whatever
    [SettingsManager.sharedManager save];
    [self startApp];
}

- (void)didQRCodeViewControllerRequestSyncServices {
    [SyncManager.sharedManager syncTasks:NO andServices:YES];
    [self didClickMenuItem:_menuViewController.servicesMenuItem];
}

- (void)didQRCodeViewControllerRequestStartTask:(Task *)task {
    [self didClickMenuItem:_menuViewController.inboxMenuItem];
    [self startTask:task popConfirm:NO];
}

#pragma - free task delegate methods
- (void)didFreeTaskViewControllerRequestDisplayHistory {
    [self didClickMenuItem:_menuViewController.historyMenuItem];
}

- (void)didFreeTaskViewControllerRequestDisplaySettings {
    [self didClickMenuItem:_menuViewController.settingsMenuItem];
}

#pragma - Task manager method and delegate
- (void)startTask:(Task *)task popConfirm:(BOOL)popConfirm {
    UIViewController *controller = [_frontController.viewControllers lastObject];
    if([controller isKindOfClass:[ScanViewController class]]) {
        NSLog(@"RootViewController.ScanViewControllerInUse");
    } else {
        [TaskManager.sharedManager setDelegate:self];
        [TaskManager.sharedManager startTask:task popConfirmation:popConfirm];
    }
}

- (void)didTaskManagerRequestDisplayHistory {
    [self didClickMenuItem:_menuViewController.historyMenuItem];
}

- (void)didTaskManagerRequestDisplayInbox {
    [self didClickMenuItem:_menuViewController.inboxMenuItem];
}

- (void)didTaskManagerRequestPushViewController:(UIViewController *)controller {
    [_frontController pushViewController:controller animated:YES];
}

- (void)didTaskManagerResquestPopViewController {
    [_frontController popViewControllerAnimated:YES];
}

- (BOOL)didTaskManagerRequestPopViewControllersFromStep:(NSInteger)step {
    NSInteger count = [_frontController.viewControllers count];
    UIViewController *controller = [_frontController.viewControllers objectAtIndex:count - step - 1];
    [StyleHelper setDefaultStyleOnViewController:controller];
    [_frontController popToViewController:controller animated:YES];
    return YES;
}
@end
