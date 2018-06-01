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

#import "FileView.h"
#import <CoreLocation/CoreLocation.h>
#import "StoreManager.h"
#import "UIColor+HexString.h"
#import "DateTimeHelper.h"
#import "CaptureImage.h"

NSString *(^FormatLocation)(CLLocation *location) = ^(CLLocation *location) {
	long longDeg, longMin, longSec, latDeg, latMin, latSec;
	char longLetter, latLetter;
	CLLocationDegrees longitude = location.coordinate.longitude;
	if(longitude > 0)
		longLetter = 'E';
	else {
		longLetter = 'W';
		longitude *= -1;
	}
	longDeg = floor( longitude );
	const double longTemp = (longitude - (double)longDeg) * 60.0;
	longMin = floor(longTemp);
	longSec = lround((longTemp - (double)longMin) * 60.0);
	CLLocationDegrees latitude = location.coordinate.latitude;
	if(latitude > 0)
		latLetter = 'N';
	else {
		latLetter = 'S';
		latitude *= -1;
	}
	latDeg = floor( latitude );
	const double latTemp = (latitude - (double)latDeg) * 60.0;
	latMin = floor(latTemp);
	latSec = lround((latTemp - (double)latMin) * 60.0);
	return [NSString stringWithFormat:@"%c %ld°%ld'%ld\" %c %ld°%ld'%ld\"", longLetter, longDeg, longMin, longSec, latLetter, latDeg, latMin, latSec];
};

@interface FileView()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFile;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeStamp;
@property (weak, nonatomic) IBOutlet UILabel *lblHash;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblCertified;
@end

@implementation FileView
- (id)initWithFrame:(CGRect)frame image:(CaptureImage *)captureImage {
	self = [super initWithFrame:frame];
	if(self) {
		[NSBundle.mainBundle loadNibNamed:@"FileView" owner:self options:nil];
        self.backgroundColor = [UIColor whiteColor];
		self.contentView.frame = self.bounds;
		[self.contentView setUserInteractionEnabled:YES];
        self.contentView.backgroundColor = [UIColor clearColor];
		[self addSubview:self.contentView];
		CGFloat fileSize = [captureImage.size floatValue] / 1024;
		UIImage *image = captureImage.image;
		[self.imageViewFile setImage:image];
		[self.lblInfo setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
        [self.lblInfo setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
		[self.lblInfo setText:[NSString stringWithFormat:@"%@, %0.0f x %0.0f, %0.2f KB", captureImage.mimetype, image.size.width * image.scale, image.size.height * image.scale, fileSize]];
		[self.lblTimeStamp setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
        [self.lblTimeStamp setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
		if(captureImage.timestamp) {
			[self.lblTimeStamp setText:[DateTimeHelper gmtDateTime:captureImage.timestamp]];
		} else {
			[self.lblTimeStamp setText:NSLocalizedString(@"TASK_DETAILS_NA", nil)];
		}
		[self.lblHash setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
        [self.lblHash setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
		[self.lblHash setNumberOfLines:0];
		[self.lblHash setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"TASK_DETAILS_HASH", nil), captureImage.sha1]];
		[self.lblLocation setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
        [self.lblLocation setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
		CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([captureImage.latitude doubleValue], [captureImage.longitude doubleValue]);
		CLLocation *location = [[CLLocation alloc] initWithCoordinate:coord altitude:0 horizontalAccuracy:[captureImage.accuracy doubleValue] verticalAccuracy:0 timestamp:[NSDate date]];
		if(location) {
			[self.lblLocation setText:[NSString stringWithFormat:@"%@ (±%.0ld %@)", FormatLocation(location), (long)location.horizontalAccuracy, NSLocalizedString(@"TASK_DETAILS_ACCURACY_UNIT", nil)]];
		} else {
			[self.lblLocation setText:NSLocalizedString(@"TASK_DETAILS_NA", nil)];
		}
		[self.lblCertified setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
		if([captureImage.certified isEqualToNumber:@1]) {
			if([captureImage.errors count] > 0) {
				[self.lblCertified setText:NSLocalizedString(@"TASK_DETAILS_CERTIFIED_WITH_ERRORS", nil)];
                [self.lblCertified setTextColor:[UIColor colorWithHexString:colorOrange andAlpha:1.0f]];
			} else {
				[self.lblCertified setText:NSLocalizedString(@"TASK_DETAILS_CERTIFIED", nil)];
                [self.lblCertified setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
			}
		} else {
			[self.lblCertified setText:NSLocalizedString(@"TASK_DETAILS_NOT_CERTIFIED", nil)];
            [self.lblCertified setTextColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
		}
	}
	return self;
}
@end
