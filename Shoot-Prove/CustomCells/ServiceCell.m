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

#import "ServiceCell.h"
#import "ImageHelper.h"
#import "UIColor+HexString.h"
#import "AbstractService.h"
#import "Service.h"
#import "UIStyle.h"

@interface ServiceCell()
{
	Service *_service;
	NSIndexPath *_indexPath;
}
@property (weak, nonatomic) IBOutlet UIView *providerView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *lblProvider;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) id<ServiceCellDelegate> delegate;
@end

@implementation ServiceCell
- (void)awakeFromNib {
	[super awakeFromNib];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.lblProvider setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
    [self.lblProvider setNumberOfLines:1];
	[self.lblTitle setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.lblTitle setNumberOfLines:1];
	[self.lblCost setFont:[UIFont fontWithName:boldFontName size:smallFontSize]];
	[self.lblCost setNumberOfLines:1];
	[self.lblDescription setFont:[UIFont fontWithName:normalFontName size:xSmallFontSize]];
	[self.lblDescription setNumberOfLines:0];
    self.btnStart.backgroundColor = [UIColor clearColor];
    self.btnStart.layer.cornerRadius = self.btnStart.frame.size.height/2;
    self.btnStart.layer.masksToBounds = YES;
	[self.btnStart setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.providerView.backgroundColor = [UIColor colorWithHexString:_service.uiStyle.toolbarBackgroundColor andAlpha:1.0f];
    self.titleView.backgroundColor = [UIColor colorWithHexString:_service.uiStyle.headerBackgroundColor andAlpha:1.0f];
    [UIView animateWithDuration:0.8 animations:^{
        [self.btnStart setHidden:!selected];
    } completion:^(BOOL finished) {}];
}

- (void)displayImage {
    [ImageHelper displayImageData:_service.icon_data url:_service.icon_url mime:_service.icon_mime name:@"cloud_question" inView:self.logoView waitColor:[UIColor colorWithHexString:_service.uiStyle.toolbarBackgroundColor andAlpha:1.0f] block:^(NSData *data, NSString *mime) {
        if(_service.icon_data.hash != data.hash) {
            _service.icon_data = data;
            _service.icon_mime = mime;
        }
    }];
}

- (void)setService:(Service *)service delegate:(id<ServiceCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath {
	self.delegate = delegate;
	_indexPath = indexPath;
	_service = service;
    [self displayImage];
    self.contentView.backgroundColor = [UIColor colorWithHexString:_service.uiStyle.viewBackgroundColor andAlpha:1.0f];
    self.contentView.layer.borderColor = [UIColor colorWithHexString:_service.uiStyle.headerBackgroundColor andAlpha:1.0f].CGColor;
    self.contentView.layer.borderWidth = 2.0f;
    self.providerView.backgroundColor = [UIColor colorWithHexString:_service.uiStyle.toolbarBackgroundColor andAlpha:1.0f];
    [self.lblProvider setTextColor:[UIColor colorWithHexString:_service.uiStyle.toolbarColor andAlpha:1.0f]];
    [self.lblCost setTextColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
    self.titleView.backgroundColor = [UIColor colorWithHexString:_service.uiStyle.headerBackgroundColor andAlpha:1.0f];
    [self.lblTitle setTextColor:[UIColor colorWithHexString:_service.uiStyle.headerColor andAlpha:1.0f]];
    [self.lblDescription setTextColor:[UIColor colorWithHexString:_service.uiStyle.promptColor andAlpha:1.0f]];
    self.btnStart.tintColor = [UIColor colorWithHexString:_service.uiStyle.toolbarBackgroundColor andAlpha:1.0f];
	[self.lblTitle setText:_service.title];
	if([service.postPaid isEqualToNumber:[NSNumber numberWithBool:NO]]) {
		[self.lblCost setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SERVICE_COST", nil), service.cost]];
		[self.lblCost setHidden:NO];
	} else {
        [self.lblCost setText:[NSString stringWithFormat:@"%@: 0", NSLocalizedString(@"SERVICE_COST", nil)]];
		[self.lblCost setHidden:YES];
	}
	[self.lblProvider setText:_service.provider];
	[self.lblDescription setText:_service.desc];
}

- (IBAction)start:(id)sender {
	if([self.delegate respondsToSelector:@selector(didServiceCellRequestStartTaskWithService:)]) {
		[self.delegate didServiceCellRequestStartTaskWithService:_service];
	}
}
@end
