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

#import "CaptureThumbCell.h"
#import "UIColor+HexString.h"
#import "StoreManager.h"
#import "AbstractSubTaskCapture.h"
#import "SubTaskScan.h"
#import "SubTaskPicture.h"
#import "CaptureImage.h"
#import "Task.h"
#import "UIStyle.h"

@interface CaptureThumbCell()
{
    UIImage *_image;
    AbstractSubTaskCapture *_subTask;
    UIStyle *_style;
    NSInteger _imageIndex;
}
@property (weak, nonatomic) IBOutlet UIImageView *captureImageView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *btnRotate;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructions;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *btnTrash;
@property (weak, nonatomic) IBOutlet UIButton *btnViewer;
@property (weak, nonatomic) id<CaptureThumbCellDelegate> delegate;
@end

@implementation CaptureThumbCell
- (void)awakeFromNib {
	[super awakeFromNib];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.backgroundColor = [UIColor clearColor];
    self.actionView.backgroundColor = [UIColor colorWithHexString:colorLightGrey andAlpha:0.6f];
    self.actionView.layer.cornerRadius = 3.0f;
    self.actionView.layer.borderColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f].CGColor;
    self.actionView.layer.borderWidth = 1.0f;
    self.actionView.hidden = YES;
	self.lblTitle.font = [UIFont fontWithName:boldFontName size:normalFontSize];
	[self.lblTitle setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	self.lblTitle.text = @"";
	self.lblTitle.hidden = YES;
	self.lblInstructions.font = [UIFont fontWithName:normalFontName size:normalFontSize];
	[self.lblInstructions setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	self.lblInstructions.text = @"";
	self.lblInstructions.hidden = YES;
	self.btnAdd.hidden = YES;
    self.captureImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.captureImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    if(_image == nil) {
        self.layer.shadowColor = [UIColor colorWithHexString:colorBlack andAlpha:1.0f].CGColor;
        self.layer.shadowOffset = CGSizeMake(2.0f, 4.0f);
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowRadius = 2.0f;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    } else {
        self.layer.shadowPath = nil;
    }
}

- (void)setSelected:(BOOL)selected{
	[super setSelected:selected];
	CaptureImage *image = [_subTask imageAtIndex:_imageIndex];
    [UIView animateWithDuration:0.4 animations:^{
        self.actionView.hidden = !(selected && image.certified);
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)setSubTask:(AbstractSubTaskCapture *)subTask imageIndex:(NSInteger)index delegate:(id<CaptureThumbCellDelegate>)delegate {
	self.delegate = delegate;
	_subTask = subTask;
    _style = (UIStyle *)subTask.abstractService.uiStyle;
	_imageIndex = index;
	_image = nil;
    self.actionView.backgroundColor = [UIColor colorWithHexString:_style.thumbnailBackgroundColor andAlpha:0.6f];
    self.actionView.layer.borderColor = [UIColor colorWithHexString:_style.thumbnailBackgroundColor andAlpha:1.0f].CGColor;
    [self.btnRotate setTintColor:[UIColor colorWithHexString:_style.thumbnailColor andAlpha:1.0f]];
    [self.btnTrash setTintColor:[UIColor colorWithHexString:_style.thumbnailColor andAlpha:1.0f]];
    [self.btnViewer setTintColor:[UIColor colorWithHexString:_style.thumbnailColor andAlpha:1.0f]];
    [self.lblTitle setTextColor:[UIColor colorWithHexString:_style.thumbnailColor andAlpha:1.0f]];
    [self.lblInstructions setTextColor:[UIColor colorWithHexString:_style.thumbnailColor andAlpha:1.0f]];
	if([subTask.images count] > 0) {
		CaptureImage *subTaskImage = [subTask imageAtIndex:index];
		_image = subTaskImage.image;
	}
	[self.captureImageView setImage:_image];
	if(!_image) {
		int minItems = [subTask.minItems intValue];
		int maxItems = [subTask.maxItems intValue];
		BOOL isRequired = index < minItems;
		if([subTask isKindOfClass:[SubTaskPicture class]]) {
			[self.lblTitle setText:[NSString stringWithFormat:NSLocalizedString(@"CAPTURE_TASK_PICTURE", nil), (int) (index+1), maxItems]];
			[self.btnAdd setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
		} else if([subTask isKindOfClass:[SubTaskScan class]]) {
			[self.lblTitle setText:[NSString stringWithFormat:NSLocalizedString(@"CAPTURE_TASK_PAGE", nil), (int) (index+1), maxItems]];
			[self.btnAdd setImage:[UIImage imageNamed:@"scanner"] forState:UIControlStateNormal];
		}
        [self.btnAdd setTintColor:[UIColor colorWithHexString:_style.thumbnailColor andAlpha:1.0f]];
		if(index+1 <= minItems) {
			[self.lblInstructions setTextColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
		} else {
            [self.lblInstructions setTextColor:[UIColor colorWithHexString:_style ? _style.thumbnailColor : colorWhite andAlpha:1.0f]];
		}
		[self.lblInstructions setText:[NSString stringWithFormat:@"%@", isRequired ? NSLocalizedString(@"CAPTURE_TASK_REQUIRED", nil):NSLocalizedString(@"CAPTURE_TASK_OPTIONAL", nil)]];
		[self setCellEmpty];
	} else {
		[self setCellComplete];
	}
	[self layoutIfNeeded];
}

- (void)setCellEmpty {
    self.backgroundColor = [UIColor colorWithHexString:_style ? _style.thumbnailBackgroundColor : colorLightGrey andAlpha:_style ? 1.0f : 0.6f];
	self.btnAdd.hidden = ![self.delegate respondsToSelector:@selector(didCaptureThumbCellRequestCapture:)];
	self.lblInstructions.hidden = NO;
	self.lblTitle.hidden = NO;
	self.layer.cornerRadius = 3.0f;
	self.layer.masksToBounds = YES;
}

- (void)setCellComplete {
	self.backgroundColor = [UIColor clearColor];
	self.btnAdd.hidden = YES;
	self.lblInstructions.hidden = YES;
	self.lblTitle.hidden = YES;
	self.layer.cornerRadius = 0;
	self.layer.masksToBounds = YES;
}

- (void)startAnimation {
    [self.activityIndicator startAnimating];
}

- (void)stopAnimation {
    [self.activityIndicator stopAnimating];
}

- (IBAction)rotate:(id)sender {
	if([self.delegate respondsToSelector:@selector(didCaptureThumbCellRequestRotate:)]) {
		[self.delegate didCaptureThumbCellRequestRotate:self];
	}
}

- (IBAction)delete:(id)sender {
	if([self.delegate respondsToSelector:@selector(didCaptureThumbCellRequestDelete:)]){
		[self.delegate didCaptureThumbCellRequestDelete:self];
	}
}

- (IBAction)view:(id)sender {
    if([self.delegate respondsToSelector:@selector(didCaptureThumbCellRequestView:)]) {
        [self.delegate didCaptureThumbCellRequestView:self];
    }
}

- (IBAction)add:(id)sender {
	if([self.delegate respondsToSelector:@selector(didCaptureThumbCellRequestCapture:)]) {
		[self.delegate didCaptureThumbCellRequestCapture:self];
	}
}
@end
