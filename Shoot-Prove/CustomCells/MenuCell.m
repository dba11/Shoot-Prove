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

#import "MenuCell.h"
#import "UIColor+HexString.h"
#import "MenuItem.h"

@interface MenuCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewItemLeftConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblItemNameWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblItemCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblItemCountWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblItemCountHeightConstraint;
@property (strong, nonatomic) NSFetchedResultsController *resultController;
@end

@implementation MenuCell
- (void)awakeFromNib {
	[super awakeFromNib];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self setBackgroundColor:[UIColor clearColor]];
	[self.lblItemName setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.lblItemName setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.lblItemCount setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
	[self.lblItemCount setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.lblItemCount.layer setBorderColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f].CGColor];
	[self.lblItemCount.layer setBorderWidth:1.0f];
	[self.lblItemCount.layer setCornerRadius:self.lblItemCount.frame.size.height/2];
	[self.lblItemCount.layer setMasksToBounds:YES];
	[self.lblItemCountWidthConstraint setConstant:self.lblItemCount.frame.size.height];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected) {
        [UIView animateWithDuration:0.5 animations:^{
            [super setSelected:NO animated:YES];
        } completion:^(BOOL finished) {}];
    }
}

- (void)setMenuItem:(MenuItem *)menuItem {
	self.imageViewItem.image = [menuItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imageViewItem.tintColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f];
    [self.imageViewItemLeftConstraint setConstant:(menuItem.treeLevel * 20) + 8];
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:normalFontName size:mediumFontSize]};
	CGRect rect = [menuItem.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
										  options:NSStringDrawingUsesFontLeading
									   attributes:attributes
										  context:nil];
	[self.lblItemNameWidthConstraint setConstant:rect.size.width];
	[self.lblItemName setText:menuItem.name];
	self.resultController = menuItem.resultController;
	if(self.resultController) {
		[self.resultController setDelegate:self];
		NSInteger count = [[self.resultController fetchedObjects] count];
		[self setMenuItemCount:count];
	} else {
		[self.lblItemCount setHidden:YES];
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	NSInteger count = [[controller fetchedObjects] count];
	[self setMenuItemCount:count];
}

- (void)setMenuItemCount:(NSInteger)count {
	NSString *itemCount = [NSString stringWithFormat:@"%d", (int)count];
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:normalFontName size:normalFontSize]};
	CGRect rect = [itemCount boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
										  options:NSStringDrawingUsesFontLeading
									   attributes:attributes
										  context:nil];
	[self.lblItemCount.layer setCornerRadius:rect.size.height/2];
	[self.lblItemCount.layer setMasksToBounds:YES];
	[self.lblItemCountHeightConstraint setConstant:rect.size.height];
	[self.lblItemCountWidthConstraint setConstant:rect.size.width * (count < 10 ? 3:2)];
	[self.lblItemCount setText:itemCount];
}
@end
