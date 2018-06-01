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

#import "DeviceCell.h"
#import "UIColor+HexString.h"
#import "DeviceHelper.h"
#import "Device.h"

@interface DeviceCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRadio;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUsage;
@end

@implementation DeviceCell
- (void)awakeFromNib {
	[super awakeFromNib];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.lblName setFont:[UIFont fontWithName:boldFontName size:normalFontSize]];
	[self.lblName setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0]];
	[self.lblDetails setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
	[self.lblDetails setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0]];
    [self.lblLastUsage setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
    [self.lblLastUsage setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0]];
	[self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setDevice:(Device *)device {
	DeviceProperties *deviceProperties = [DeviceHelper getDeviceProperties];
	if([device.uid isEqualToString:deviceProperties.uid]) {
		[self.imageViewRadio setImage:[UIImage imageNamed:@"radio_selected_16"]];
	} else {
		[self.imageViewRadio setImage:[UIImage imageNamed:@"radio_16"]];
	}
	[self.lblName setText:[NSString stringWithFormat:@"%@", device.name]];
	[self.lblDetails setText:[NSString stringWithFormat:NSLocalizedString(@"ACCOUNT_DEVICE_BUILD", nil), device.buildNumber]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    [self.lblLastUsage setText:[NSString stringWithFormat:NSLocalizedString(@"ACCOUNT_DEVICE_LAST_USAGE", nil), device.lastSeen ? [df stringFromDate:device.lastSeen]:[df stringFromDate:[NSDate date]]]];
}
@end
