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

#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import "UIColor+HexString.h"
#import "EnumHelper.h"
#import "SettingsManager.h"
#import "StoreManager.h"
#import "Dialog.h"
#import "RestClientManager.h"
#import "User.h"

#define accuracyStepValue 10

@interface SettingsViewController ()
{
	BOOL _didChange;
	UIBarButtonItem *_btnMenu;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblCameraSettingsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPictureSizeTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentPictureSize;
@property (weak, nonatomic) IBOutlet UILabel *lblPaperSizeTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentPaperSize;
@property (weak, nonatomic) IBOutlet UILabel *lblResolutionTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentResolution;
@property (weak, nonatomic) IBOutlet UILabel *lblColorModeTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentColorMode;
@property (weak, nonatomic) IBOutlet UILabel *lblAutoScan;
@property (weak, nonatomic) IBOutlet UISwitch *switchAutoScan;
@property (weak, nonatomic) IBOutlet UILabel *lblCertificationOptionsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAccuracyTitle;
@property (weak, nonatomic) IBOutlet UISlider *slideAccuracy;
@property (weak, nonatomic) IBOutlet UILabel *lblAccuracy;
@property (weak, nonatomic) IBOutlet UILabel *lblWartermarkTitle;
@property (weak, nonatomic) IBOutlet UISwitch *switchWatermark;
@property (weak, nonatomic) IBOutlet UILabel *lbliTunesShareTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbliTunesShareFiles;
@property (weak, nonatomic) IBOutlet UILabel *lbliTunesShareRenditions;
@property (weak, nonatomic) IBOutlet UISwitch *switchiTunesShareFiles;
@property (weak, nonatomic) IBOutlet UISwitch *switchiTunesShareRenditions;
@property (weak, nonatomic) IBOutlet UILabel *lblTestModeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTestMode;
@property (weak, nonatomic) IBOutlet UISwitch *switchTestMode;
@property (weak, nonatomic) IBOutlet UILabel *lblDevMode;
@property (weak, nonatomic) IBOutlet UISwitch *switchDevMode;
@property (weak, nonatomic) IBOutlet UITextField *txtDevUrl;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) id<SettingsViewControllerDelegate> delegate;
@end

@implementation SettingsViewController
#pragma view life cycle
- (id)initWithUser:(User *)user delegate:(id<SettingsViewControllerDelegate>)delegate {
	self = [super init];
    if(self) {
		self.user = user;
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self buildMenuButton];
	self.title = NSLocalizedString(@"MENU_SETTINGS", nil);
	
    [self.lblCameraSettingsTitle setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
	[self.lblCameraSettingsTitle setBackgroundColor:[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f]];
	[self.lblCameraSettingsTitle setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.lblCameraSettingsTitle setText:[NSString stringWithFormat:@" %@", NSLocalizedString(@"SETTINGS_PICTURE", nil)]];
	
    [self.lblPictureSizeTitle setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.lblPictureSizeTitle setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lblPictureSizeTitle setText:NSLocalizedString(@"SETTINGS_PICTURE_SIZE", nil)];
	CGSize size = [EnumHelper sizeFromSPsize:SPsize1200x900];
	[self.segmentPictureSize setTitle:[NSString stringWithFormat:@"%0.0f x %0.0f", size.width, size.height] forSegmentAtIndex:0];
	size = [EnumHelper sizeFromSPsize:SPsize1800x1200];
	[self.segmentPictureSize setTitle:[NSString stringWithFormat:@"%0.0f x %0.0f", size.width, size.height] forSegmentAtIndex:1];
	size = [EnumHelper sizeFromSPsize:SPsize2400x1800];
	[self.segmentPictureSize setTitle:[NSString stringWithFormat:@"%0.0f x %0.0f", size.width, size.height] forSegmentAtIndex:2];
	[self.segmentPictureSize setSelectedSegmentIndex:[[SettingsManager sharedManager] pictureSize]];
	
    [self.lblPaperSizeTitle setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.lblPaperSizeTitle setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lblPaperSizeTitle setText:NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE", nil)];
	[self.segmentPaperSize setTitle:NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_A4", nil) forSegmentAtIndex:0];
	[self.segmentPaperSize setTitle:NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_A5", nil) forSegmentAtIndex:1];
	[self.segmentPaperSize setTitle:NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_ID1", nil) forSegmentAtIndex:2];
    [self.segmentPaperSize setTitle:NSLocalizedString(@"SETTINGS_SCANNER_PAPER_SIZE_ANY", nil) forSegmentAtIndex:3];
	[self.segmentPaperSize setSelectedSegmentIndex:[[SettingsManager sharedManager] scannerFormat]];
	
    [self.lblResolutionTitle setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.lblResolutionTitle setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lblResolutionTitle setText:NSLocalizedString(@"SETTINGS_SCANNER_RESOLUTION", nil)];
	[self.segmentResolution setTitle:NSLocalizedString(@"SETTINGS_SCANNER_RESOLUTION_150", nil) forSegmentAtIndex:0];
	[self.segmentResolution setTitle:NSLocalizedString(@"SETTINGS_SCANNER_RESOLUTION_200", nil) forSegmentAtIndex:1];
	[self.segmentResolution setTitle:NSLocalizedString(@"SETTINGS_SCANNER_RESOLUTION_300", nil) forSegmentAtIndex:2];
	[self.segmentResolution setSelectedSegmentIndex:[[SettingsManager sharedManager] scannerResolution]];
	
    [self.lblColorModeTitle setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.lblColorModeTitle setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lblColorModeTitle setText:NSLocalizedString(@"SETTINGS_SCANNER_COLOR_MODE", nil)];
	[self.segmentColorMode setTitle:NSLocalizedString(@"SETTINGS_SCANNER_COLOR_MODE_BW", nil) forSegmentAtIndex:0];
	[self.segmentColorMode setTitle:NSLocalizedString(@"SETTINGS_SCANNER_COLOR_MODE_GREY", nil) forSegmentAtIndex:1];
	[self.segmentColorMode setTitle:NSLocalizedString(@"SETTINGS_SCANNER_COLOR_MODE_COLOR", nil) forSegmentAtIndex:2];
	[self.segmentColorMode setSelectedSegmentIndex:[[SettingsManager sharedManager] scannerColorMode]];
	
	[self.lblAutoScan setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lblAutoScan setText:NSLocalizedString(@"SETTINGS_SCANNER_AUTO", nil)];
	[self.switchAutoScan setOn:[[SettingsManager sharedManager] scannerAutoScan]];
	
    [self.lblCertificationOptionsTitle setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
	[self.lblCertificationOptionsTitle setBackgroundColor:[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f]];
	[self.lblCertificationOptionsTitle setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.lblCertificationOptionsTitle setText:[NSString stringWithFormat:@" %@", NSLocalizedString(@"SETTINGS_CERTIFICATION", nil)]];
	
	[self.lblAccuracyTitle setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lblAccuracyTitle setText:NSLocalizedString(@"SETTINGS_CERTIFICATION_ACCURACY", nil)];
	[self.slideAccuracy setMinimumValue:10];
	[self.slideAccuracy setMaximumValue:500];
	[self.slideAccuracy setValue:[[SettingsManager sharedManager] minAccuracy]];
	[self.slideAccuracy setContinuous:YES];
	[self.slideAccuracy setEnabled:YES];
	[self.lblAccuracy setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lblAccuracy setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
	[self.lblAccuracy setText:[NSString stringWithFormat:@"%d %@", (int)[[SettingsManager sharedManager] minAccuracy], NSLocalizedString(@"SETTINGS_CERTIFICATION_ACCURACY_UNIT", nil)]];
	
	[self.lblWartermarkTitle setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lblWartermarkTitle setText:NSLocalizedString(@"SETTINGS_CERTIFICATION_WATERMARK", nil)];
	[self.switchWatermark setOn:[[SettingsManager sharedManager] printCertificationInfo]];
	
    [self.lbliTunesShareTitle setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
	[self.lbliTunesShareTitle setBackgroundColor:[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f]];
	[self.lbliTunesShareTitle setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.lbliTunesShareTitle setText:[NSString stringWithFormat:@" %@", NSLocalizedString(@"SETTINGS_ITUNES_SHARE", nil)]];
	[self.lbliTunesShareFiles setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lbliTunesShareFiles setText:NSLocalizedString(@"SETTINGS_ITUNES_SHARE_FILES", nil)];
	[self.switchiTunesShareFiles setOn:[[SettingsManager sharedManager] shareFiles]];
	[self.lbliTunesShareRenditions setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lbliTunesShareRenditions setText:NSLocalizedString(@"SETTINGS_ITUNES_SHARE_RENDITIONS", nil)];
	[self.switchiTunesShareRenditions setOn:[[SettingsManager sharedManager] shareRenditions]];
	
	if([self.user.devUser isEqualToNumber:@1] || [self.user.betaUser isEqualToNumber:@1]) {
		
        [self.lblTestModeTitle setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
		[self.lblTestModeTitle setBackgroundColor:[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f]];
		[self.lblTestModeTitle setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
		[self.lblTestModeTitle setText:[NSString stringWithFormat:@" %@", NSLocalizedString(@"SETTINGS_TEST_MODE", nil)]];
		[self.lblTestMode setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[self.lblTestMode setText:NSLocalizedString(@"SETTINGS_USE_TEST_SERVER", nil)];
		[self.switchTestMode setOn:[[SettingsManager sharedManager] betaMode]];
		
		if([self.user.devUser isEqualToNumber:@1]) {
			[self.lblDevMode setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
			[self.lblDevMode setText:NSLocalizedString(@"SETTINGS_USE_DEV_SERVER", nil)];
			[self.switchDevMode setOn:[[SettingsManager sharedManager] devMode]];
			[self.txtDevUrl setText:[[SettingsManager sharedManager] devUrl]];
			[self.txtDevUrl setDelegate:self];
		} else {
			[self.lblDevMode setHidden:YES];
			[self.switchDevMode setHidden:YES];
			[self.txtDevUrl setHidden:YES];
		}
	} else {
		[self.lblTestModeTitle setHidden:YES];
		[self.lblTestMode setHidden:YES];
		[self.switchTestMode setHidden:YES];
		[self.lblDevMode setHidden:YES];
		[self.switchDevMode setHidden:YES];
		[self.txtDevUrl setHidden:YES];
	}
	_didChange = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationItem setLeftBarButtonItems:@[_btnMenu]];
	[self.navigationItem setRightBarButtonItems:nil];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[SettingsManager.sharedManager setDevMode:self.switchDevMode.isOn];
	[SettingsManager.sharedManager setBetaMode:self.switchTestMode.isOn];
	if([self.txtDevUrl.text length] > 0) {
		[SettingsManager.sharedManager setDevUrl:self.txtDevUrl.text];
	}
	if([SettingsManager.sharedManager devMode]) {
		[RestClientManager.sharedManager setDevServerUrl:[[SettingsManager sharedManager] devUrl]];
	} else if([SettingsManager.sharedManager betaMode]) {
		[RestClientManager.sharedManager useBetaServer];
	} else {
		[RestClientManager.sharedManager useProductionServer];
	}
	[SettingsManager.sharedManager save];
	[StoreManager.sharedManager syncSharedDirectory];
	if(_didChange && [self.delegate respondsToSelector:@selector(didSettingsViewControllerRequestRestart)]) {
		[self.delegate didSettingsViewControllerRequestRestart];
	}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	CGFloat availableWidth = self.view.frame.size.width;
	CGSize contentSize;
	if(self.user.devUser) {
		contentSize  = self.contentView.frame.size;
	} else if(self.user.betaUser) {
		contentSize = CGSizeMake(self.contentView.frame.size.width, self.switchDevMode.frame.origin.y);
	} else {
		contentSize = CGSizeMake(self.contentView.frame.size.width, self.lblTestModeTitle.frame.origin.y);
	}
	CGRect frame;
	if(availableWidth > viewMaxWidth && isDeviceIPad) {
		frame = CGRectMake((self.scrollView.frame.size.width - viewMaxWidth)/2, 0, viewMaxWidth, contentSize.height);
	} else {
		frame = CGRectMake((self.scrollView.frame.size.width - availableWidth)/2, 0, availableWidth, contentSize.height);
	}
	self.contentView.frame = frame;
	[self.scrollView addSubview:self.contentView];
	[self.scrollView setContentSize:frame.size];
}

#pragma - build buttons
- (void)buildMenuButton {
	_btnMenu = [[UIBarButtonItem alloc] init];
	[_btnMenu setImage:[UIImage imageNamed:@"menu"]];
	[_btnMenu setTarget:[self revealViewController]];
	[_btnMenu setAction:@selector(revealToggle:)];
}

- (IBAction)pictureSizeChange:(id)sender {
	[SettingsManager.sharedManager setPictureSize:(SPSize)self.segmentPictureSize.selectedSegmentIndex];
}

- (IBAction)paperSizeChange:(id)sender {
	[SettingsManager.sharedManager setScannerFormat:(SPFormat)self.segmentPaperSize.selectedSegmentIndex];
}

- (IBAction)resolutionChange:(id)sender {
	[SettingsManager.sharedManager setScannerResolution:(SPResolution)self.segmentResolution.selectedSegmentIndex];
}

- (IBAction)colorMoreChange:(id)sender {
	[SettingsManager.sharedManager setScannerColorMode:(SPColorMode)self.segmentColorMode.selectedSegmentIndex];
}

- (IBAction)autoScanChange:(id)sender {
	[SettingsManager.sharedManager  setScannerAutoScan:[self.switchAutoScan isOn]];
}

- (IBAction)accuracyChange:(id)sender {
    [self.slideAccuracy setValue:((int)((self.slideAccuracy.value + (accuracyStepValue/2)) / accuracyStepValue) * accuracyStepValue) animated:NO];
	[self.lblAccuracy setText:[NSString stringWithFormat:@"%d %@", (int)self.slideAccuracy.value, NSLocalizedString(@"SETTINGS_CERTIFICATION_ACCURACY_UNIT", nil)]];
	[SettingsManager.sharedManager setMinAccuracy:(int)self.slideAccuracy.value];
}

- (IBAction)watermarkChange:(id)sender {
	[SettingsManager.sharedManager setPrintCertificationInfo:self.switchWatermark.isOn];
}

- (IBAction)iTunesShareFiles:(id)sender {
	[SettingsManager.sharedManager setShareFiles:self.switchiTunesShareFiles.isOn];
}

- (IBAction)iTunesShareRenditions:(id)sender {
	[SettingsManager.sharedManager setShareRenditions:self.switchiTunesShareRenditions.isOn];
}

- (IBAction)testMode:(id)sender {
	_didChange = YES;
}

- (IBAction)devMode:(id)sender {
	_didChange = YES;
	if(self.switchDevMode.isOn) {
		[self.switchTestMode setOn:NO];
	}
	[self.switchTestMode setEnabled:!self.switchDevMode.isOn];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if([textField isEqual:self.txtDevUrl] && ![textField.text isEqualToString:[[SettingsManager sharedManager] devUrl]]) {
		_didChange = YES;
	}
}

@end
