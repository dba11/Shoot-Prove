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

#import "TaskInfoViewController.h"
#import <SPCertificationSDK/SPCertificationQueue.h>
#import <SPCertificationSDK/SPCertificationItem.h>
#import "UIColor+HexString.h"
#import "CaptureImage.h"
#import "CertificationError.h"

#define ROW_HEIGHT 60

@interface TaskInfoViewController ()
{
	CaptureImage *_image;
	UIBarButtonItem *_btnBack;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<TaskInfoViewControllerDelegate> delegate;
@end

@implementation TaskInfoViewController
#pragma - view life cycle
- (id)initWithImage:(CaptureImage *)image delegate:(id<TaskInfoViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		_image = image;
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self buildBackButton];
	self.title = NSLocalizedString(@"TITLE_CERTIFICATION_ERRORS", nil);
	[self.tableView setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationItem setLeftBarButtonItems:@[_btnBack]];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma - build buttons
- (void)buildBackButton {
	_btnBack = [[UIBarButtonItem alloc] init];
	[_btnBack setImage:[UIImage imageNamed:@"back"]];
	[_btnBack setTarget:self];
	[_btnBack setAction:@selector(back)];
}

#pragma - table view data source and delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_image.errors count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CertificationError *error = [_image.errors objectAtIndex:indexPath.row];
	NSString *identitifer = @"errorCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identitifer];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identitifer];
	}
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	if([error.domain isEqualToString:SPCertificationErrorDomain]) {
		[cell.imageView setImage:[UIImage imageNamed:@"error"]];
	} else if([error.domain isEqualToString:SPCertificationWarningDomain]) {
		[cell.imageView setImage:[UIImage imageNamed:@"warning"]];
	}
	[cell.textLabel setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[cell.textLabel setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[cell.textLabel setNumberOfLines:0];
    [cell.textLabel setText:[self descriptionFromCertificationError:error]];
	return cell;
}

#pragma - helper to convert certification error code into human text
- (NSString *)descriptionFromCertificationError:(CertificationError *)error {
    switch ([error.code intValue]) {
        case SPCertificationCriticalError:
            return NSLocalizedString(@"CERTIFICATION_ERROR_NO_DATA", nil);
            break;
        case SPCertificationWarningMissingGeolocation:
            return NSLocalizedString(@"CERTIFICATION_ERROR_MISSING_LOCATION", nil);
            break;
        case SPCertificationWarningDeniedGeolocation:
            return NSLocalizedString(@"CERTIFICATION_ERROR_DENIED_LOCATION", nil);
            break;
        case SPCertificationWarningLargerAccuracy:
            return NSLocalizedString(@"CERTIFICATION_ERROR_LARGER_ACCURACY", nil);
            break;
        case SPCertificationWarningMissingTimestamp:
            return NSLocalizedString(@"CERTIFICATION_ERROR_MISSING_TIMESTAMP", nil);
            break;
        case SPCertificationWarningMissingWatermark:
            return NSLocalizedString(@"CERTIFICATION_ERROR_MISSING_WATERMARK", nil);
            break;
        case SPCertificationWarningMissingExif:
            return NSLocalizedString(@"CERTIFICATION_ERROR_MISSING_EXIF", nil);
            break;
        default:
            return error.desc;
            break;
    }
}

#pragma - button actions
- (void)back {
	if([self.delegate respondsToSelector:@selector(didTaskInfoViewControllerCancel)]) {
		[self.delegate didTaskInfoViewControllerCancel];
	}
}


@end
