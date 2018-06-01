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

#import "FreeCaptureThumbCell.h"
#import "FreeCaptureImage.h"
#import "UIColor+HexString.h"
#import "StoreManager.h"

@interface FreeCaptureThumbCell()
@property (weak, nonatomic) IBOutlet UIImageView *captureImageView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id<FreeCaptureThumbCellDelegate> delegate;
@property (strong, nonatomic) FreeCaptureImage *freeCaptureImage;
@end

@implementation FreeCaptureThumbCell
- (void)awakeFromNib {
	[super awakeFromNib];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.backgroundColor = [UIColor clearColor];
	self.actionView.backgroundColor = [UIColor colorWithHexString:colorLightGrey andAlpha:0.6f];
	self.actionView.layer.cornerRadius= 3.0f;
	self.actionView.layer.borderColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f].CGColor;
	self.actionView.layer.borderWidth = 1.0f;
	self.actionView.hidden = YES;
    self.captureImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.captureImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
    [UIView animateWithDuration:0.4 animations:^{
        self.actionView.hidden = !selected;
    } completion:^(BOOL finished) {}];
	
}

- (UIImage *) imageWithContentsOfFile:(NSString *)path withShadow:(BOOL)shadow {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if(!shadow) return image;
    CGFloat gW = image.size.width / 20;
    CGFloat gH = image.size.height / 20;
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width + gW, image.size.height + gH));
    CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(gW / 2, gH / 2), 6.0f);
    [image drawAtPoint:CGPointZero];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (void)setImage:(FreeCaptureImage *)freeCaptureImage delegate:(id<FreeCaptureThumbCellDelegate>)delegate {
	self.delegate = delegate;
	self.freeCaptureImage = freeCaptureImage;
    self.captureImageView.image = [self imageWithContentsOfFile:freeCaptureImage.path withShadow:YES];
	[self layoutIfNeeded];
}

- (void)startAnimation {
    [self.activityIndicator startAnimating];
}

- (void)stopAnimation {
    [self.activityIndicator stopAnimating];
}

- (IBAction)rotate:(id)sender {
	if([self.delegate respondsToSelector:@selector(didFreeCaptureThumbCellRequestRotate:)]) {
		[self.delegate didFreeCaptureThumbCellRequestRotate:self];
	}
}

- (IBAction)delete:(id)sender {
	if([self.delegate respondsToSelector:@selector(didFreeCaptureThumbCellRequestDelete:)]){
		[self.delegate didFreeCaptureThumbCellRequestDelete:self];
	}
}

- (IBAction)view:(id)sender {
    if([self.delegate respondsToSelector:@selector(didFreeCaptureThumbCellRequestView:)]) {
        [self.delegate didFreeCaptureThumbCellRequestView:self];
    }
}
@end
