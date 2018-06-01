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

#import "CaptureCollectionViewHeader.h"
#import "ImageHelper.h"
#import "UIColor+HexString.h"
#import "AbstractSubTaskCapture.h"
#import "Task.h"
#import "UIStyle.h"

@interface CaptureCollectionViewHeader()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTask;
@property (weak, nonatomic) IBOutlet UILabel *textTitle;
@property (weak, nonatomic) IBOutlet UILabel *textDescription;
@end

@implementation CaptureCollectionViewHeader
- (void)awakeFromNib {
    [super awakeFromNib];
	[self setBackgroundColor:[UIColor colorWithHexString:colorLightGrey andAlpha:0.8f]];
	[self.textTitle setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
	[self.textTitle setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.textTitle setNumberOfLines:1];
	[self.textDescription setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
	[self.textDescription setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.textDescription setNumberOfLines:0];
    [self.imageViewTask setTag:99];
}

- (void)setTask:(Task *)task subTaskCapture:(AbstractSubTaskCapture *)subTaskCapture stepCount:(NSInteger)stepCount totalSteps:(NSInteger)totalSteps {
    [self.textTitle setTextColor:[UIColor colorWithHexString:task.uiStyle.headerColor andAlpha:1.0f]];
    [self.textDescription setTextColor:[UIColor colorWithHexString:task.uiStyle.headerColor andAlpha:1.0f]];
    [self setBackgroundColor:[UIColor colorWithHexString:task.uiStyle.headerBackgroundColor andAlpha:1.0f]];
    [ImageHelper displayImageData:task.serviceIconData url:task.icon_url mime:task.icon_mime name:@"cloud_question" inView:self waitColor:[UIColor colorWithHexString:task.uiStyle.toolbarBackgroundColor andAlpha:1.0f] block:^(NSData *data, NSString *mime) {
        if(task.serviceIconData.hash != data.hash)
            task.serviceIconData = data;
    }];
    [self.textTitle setText:[NSString stringWithFormat:@"%d/%d%@", (int)stepCount, (int)totalSteps, subTaskCapture.title ? [NSString stringWithFormat:@": %@", subTaskCapture.title]: @""]];
	[self.textDescription setText:subTaskCapture.desc];
}
@end
