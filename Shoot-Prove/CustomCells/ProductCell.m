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

#import "ProductCell.h"
#import "InAppPurchaseManager.h"
#import "UIColor+HexString.h"

@interface ProductCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductDescription;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ProductCell
- (void)awakeFromNib {
    [super awakeFromNib];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.lblProductName setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
	[self.lblProductName setTextColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.lblProductName setNumberOfLines:1];
	[self.lblProductDescription setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
	[self.lblProductDescription setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.lblProductDescription setNumberOfLines:0];
	[self.activityIndicator setHidesWhenStopped:YES];
	[self.activityIndicator stopAnimating];
    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected) {
        [UIView animateWithDuration:0.5 animations:^{
            [super setSelected:NO animated:YES];
        } completion:^(BOOL finished) {}];
    }
}

- (void)setProduct:(SKProduct *)product {
	[self.imageViewProduct setImage:[[InAppPurchaseManager sharedManager] productImage:product]];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[formatter setLocale:product.priceLocale];
	[self.lblProductName setText:product.localizedTitle];
	[self.lblProductDescription setText:[NSString stringWithFormat:@"%@ %@", product.localizedDescription, [formatter stringFromNumber:product.price]]];
}

- (void)startAnimation {
	[self.activityIndicator startAnimating];
}

- (void)stopAnimation {
	[self.activityIndicator stopAnimating];
}
@end
