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

#import "Dialog.h"
#import "UIColor+HexString.h"

static const CGFloat GAP = 8;
static const CGFloat HEADER_HEIGHT = 40;
static const CGFloat LABEL_HEIGHT = 21;
static const CGFloat MESSAGE_HEIGHT = 150;
static const CGFloat BUTTON_HEIGHT = 40;
static const CGFloat MAX_WIDTH = viewMaxWidth;

@interface Dialog() {
	CGFloat _viewHeight;
	CGFloat _viewWidth;
}
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *modalView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) NSString *confirmTag;
@property (weak, nonatomic) id<DialogDelegate> delegate;
@end

@implementation Dialog
- (id)initWithConfirmButton:(BOOL)confirmButton cancelButton:(BOOL)cancelButton message:(NSString *)message {
	self = [super init];
	if(self) {
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
		self.topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
		CGRect contentFrame = [self.topView frame];
		CGSize availableSize = contentFrame.size;
		_viewWidth = ((availableSize.width - (2 * GAP)) < MAX_WIDTH) ? availableSize.width - (2 * GAP):MAX_WIDTH;
		NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:normalFontName size:normalFontSize]};
		CGRect messageRect = [message boundingRectWithSize:CGSizeMake(_viewWidth - (2*GAP), MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
		CGFloat messageHeight = messageRect.size.height > MESSAGE_HEIGHT ? messageRect.size.height:MESSAGE_HEIGHT;
		_viewHeight = HEADER_HEIGHT + GAP + messageHeight + GAP + (cancelButton || confirmButton ? BUTTON_HEIGHT:0);
		CGRect viewFrame = CGRectMake((availableSize.width - _viewWidth) / 2, (availableSize.height - _viewHeight) / 2, _viewWidth, _viewHeight);
		self.frame = viewFrame;
		self.layer.cornerRadius = 4.0f;
		self.layer.shadowColor = [UIColor colorWithHexString:colorBlack andAlpha:1.0f].CGColor;
		self.layer.shadowOpacity = 0.5;
		self.layer.shadowRadius = 4;
		self.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
		self.layer.masksToBounds = NO;
		CGRect headerFrame = CGRectMake(0, 0, _viewWidth, HEADER_HEIGHT);
		self.headerView = [[UIView alloc] initWithFrame:headerFrame];
		UIBezierPath *headerMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerView.bounds
															 byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
																   cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *headerMaskLayer = [[CAShapeLayer alloc] init];
		headerMaskLayer.frame = self.headerView.bounds;
		headerMaskLayer.path = headerMaskPath.CGPath;
		[self.headerView.layer setMask:headerMaskLayer];
		[self addSubview:self.headerView];
		CGRect headerLabelFrame = CGRectMake(GAP, (HEADER_HEIGHT - LABEL_HEIGHT) / 2, _viewWidth - (2 * GAP), LABEL_HEIGHT);
		self.headerLabel = [[UILabel alloc] initWithFrame:headerLabelFrame];
		[self.headerLabel setText:@"<NO_TITLE>"];
		[self.headerView addSubview:self.headerLabel];
		CGRect messageFrame = CGRectMake(GAP, HEADER_HEIGHT + GAP, _viewWidth - (2 * GAP), messageHeight);
		self.messageLabel = [[UILabel alloc] initWithFrame:messageFrame];
		[self.messageLabel setNumberOfLines:0];
		[self.messageLabel setText:message];
		[self.messageLabel setTextAlignment:NSTextAlignmentLeft];
		[self addSubview:self.messageLabel];
		CGRect confirmFrame = CGRectZero;
		CGRect cancelFrame = CGRectZero;
		if(confirmButton && cancelButton) {
			confirmFrame = CGRectMake(0, HEADER_HEIGHT + GAP + messageHeight + GAP, (_viewWidth / 2), BUTTON_HEIGHT);
			cancelFrame = CGRectMake((_viewWidth / 2), HEADER_HEIGHT + GAP + messageHeight + GAP, (_viewWidth / 2), BUTTON_HEIGHT);
		} else if(confirmButton) {
			confirmFrame = CGRectMake(0, HEADER_HEIGHT + GAP + messageHeight + GAP, _viewWidth, BUTTON_HEIGHT);
		} else if(cancelButton) {
			cancelFrame = CGRectMake(0, HEADER_HEIGHT + GAP + messageHeight + GAP, _viewWidth, BUTTON_HEIGHT);
		}
		if(confirmButton) {
			self.confirmButton = [[UIButton alloc] initWithFrame:confirmFrame];
			UIBezierPath *confirmMaskPath;
			if(cancelButton) {
				confirmMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.confirmButton.bounds
														 byRoundingCorners:UIRectCornerBottomLeft
															   cornerRadii:CGSizeMake(4.0, 4.0)];
			} else {
				confirmMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.confirmButton.bounds
														byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
															  cornerRadii:CGSizeMake(4.0, 4.0)];
			}
			CAShapeLayer *confirmMaskLayer = [[CAShapeLayer alloc] init];
			confirmMaskLayer.frame = self.confirmButton.bounds;
			confirmMaskLayer.path = confirmMaskPath.CGPath;
			[self.confirmButton.layer setMask:confirmMaskLayer];
			[self.confirmButton setTitle:@"<NO_TITLE>" forState:UIControlStateNormal];
			[self.confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:self.confirmButton];
		} else {
			self.confirmButton = nil;
		}
		if(cancelButton) {
			self.cancelButton = [[UIButton alloc] initWithFrame:cancelFrame];
			UIBezierPath *cancelMaskPath;
			if(confirmButton) {
				cancelMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancelButton.bounds
														byRoundingCorners:UIRectCornerBottomRight
															  cornerRadii:CGSizeMake(4.0, 4.0)];
			} else {
				cancelMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancelButton.bounds
														byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
															  cornerRadii:CGSizeMake(4.0, 4.0)];
			}
			CAShapeLayer *cancelMaskLayer = [[CAShapeLayer alloc] init];
			cancelMaskLayer.frame = self.cancelButton.bounds;
			cancelMaskLayer.path = cancelMaskPath.CGPath;
			[self.cancelButton.layer setMask:cancelMaskLayer];
			[self.cancelButton setTitle:@"<NO_TITLE>" forState:UIControlStateNormal];
			[self.cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:self.cancelButton];
		} else {
			self.cancelButton = nil;
		}
		[self setHidden:YES];
	}
	return self;
}

- (id)initWithType:(DialogType)dialogType title:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)confirmTag cancelButtonTitle:(NSString *)cancelButtonTitle target:(id<DialogDelegate>)target {
	self = [self initWithConfirmButton:(confirmButtonTitle != nil) cancelButton:(cancelButtonTitle != nil) message:message];
	if(self) {
		if(dialogType == DialogTypeError) {
			[self designAsError];
		} else if (dialogType == DialogTypeWarning) {
			[self designAsWarning];
		} else {
			[self designAsInfo];
		}
        [self.headerLabel setText:title];
		if(self.confirmButton)
			[self.confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
		if(self.cancelButton)
			[self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
		self.confirmTag = confirmTag;
		self.delegate = target;
	}
	return self;
}

- (void)designAsError {
	self.backgroundColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f];
	self.layer.borderColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f].CGColor;
	self.layer.borderWidth = 1.0f;
	[self.headerView setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
	[self.headerView.layer setBorderColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f].CGColor];
	[self.headerView.layer setBorderWidth:1.0f];
	[self.headerLabel setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.headerLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
	[self.messageLabel setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.messageLabel setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.messageLabel setTextAlignment:NSTextAlignmentCenter];
	if(self.confirmButton) {
		[self.confirmButton setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
		[self.confirmButton.layer setBorderColor:[[UIColor colorWithHexString:colorWhite andAlpha:1.0f] CGColor]];
		[self.confirmButton.layer setBorderWidth:1.0f];
		[self.confirmButton setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
		[[self.confirmButton titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[self.confirmButton addTarget:self action:@selector(changeErrorButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
	}
	if(self.cancelButton) {
		[self.cancelButton setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
		[[self.cancelButton layer] setBorderColor:[[UIColor colorWithHexString:colorWhite andAlpha:1.0f] CGColor]];
		[[self.cancelButton layer] setBorderWidth:1.0f];
		[self.cancelButton setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
		[[self.cancelButton titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[self.cancelButton addTarget:self action:@selector(changeErrorButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)changeErrorButtonBackGroundColor:(UIButton*) sender {
	if ([sender.backgroundColor isEqual:[UIColor colorWithHexString:colorRed andAlpha:1.0f]]){
		[sender setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	} else {
		[sender setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
	}
}

- (void)designAsWarning {
	[self setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.layer setBorderColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f].CGColor];
	[self.layer setBorderWidth:1.0f];
	[self.layer setShadowColor:[UIColor colorWithHexString:colorBlack andAlpha:1.0f].CGColor];
	[self.layer setShadowOffset:CGSizeZero];
	[self.layer setShadowRadius:4.0f];
	[self.layer setShadowOpacity:0.2f];
	[self.headerView setBackgroundColor:[UIColor colorWithHexString:colorOrange andAlpha:1.0f]];
	[self.headerView.layer setBorderColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f].CGColor];
	[self.headerView.layer setBorderWidth:1.0f];
	[self.headerLabel setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.headerLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
	[self.messageLabel setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.messageLabel setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.messageLabel setTextAlignment:NSTextAlignmentCenter];
	if(self.confirmButton) {
		[self.confirmButton setBackgroundColor:[UIColor colorWithHexString:colorOrange andAlpha:1.0f]];
		[self.confirmButton.layer setBorderColor:[[UIColor colorWithHexString:colorWhite andAlpha:1.0f] CGColor]];
		[self.confirmButton.layer setBorderWidth:1.0f];
		[self.confirmButton setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
		[[self.confirmButton titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[self.confirmButton addTarget:self action:@selector(changeWarningButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
	}
	if(self.cancelButton) {
		[self.cancelButton setBackgroundColor:[UIColor colorWithHexString:colorOrange andAlpha:1.0f]];
		[[self.cancelButton layer] setBorderColor:[[UIColor colorWithHexString:colorWhite andAlpha:1.0f] CGColor]];
		[[self.cancelButton layer] setBorderWidth:1.0f];
		[self.cancelButton setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
		[[self.cancelButton titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[self.cancelButton addTarget:self action:@selector(changeWarningButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)changeWarningButtonBackGroundColor:(UIButton*) sender {
	if ([sender.backgroundColor isEqual:[UIColor colorWithHexString:colorOrange andAlpha:1.0f]]){
		[sender setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	} else {
		[sender setBackgroundColor:[UIColor colorWithHexString:colorOrange andAlpha:1.0f]];
	}
}

- (void)designAsInfo {
	[self setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.layer setBorderColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f].CGColor];
	[self.layer setBorderWidth:1.0f];
	[self.layer setShadowColor:[UIColor colorWithHexString:colorBlack andAlpha:1.0f].CGColor];
	[self.layer setShadowOffset:CGSizeZero];
	[self.layer setShadowRadius:4.0f];
	[self.layer setShadowOpacity:0.2f];
	[self.headerView setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	[self.headerView.layer setBorderColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f].CGColor];
	[self.headerView.layer setBorderWidth:1.0f];
	[self.headerLabel setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	[self.headerLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
	[self.messageLabel setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
	[self.messageLabel setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
	[self.messageLabel setTextAlignment:NSTextAlignmentCenter];
	if(self.confirmButton) {
		[self.confirmButton setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[[self.confirmButton layer] setBorderColor:[[UIColor colorWithHexString:colorWhite andAlpha:1.0f] CGColor]];
		[[self.confirmButton layer] setBorderWidth:1.0f];
		[self.confirmButton setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
		[[self.confirmButton titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[self.confirmButton addTarget:self action:@selector(changeInfoButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
	}
	if(self.cancelButton) {
		[self.cancelButton setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[self.cancelButton.layer setBorderColor:[[UIColor colorWithHexString:colorWhite andAlpha:1.0f] CGColor]];
		[self.cancelButton.layer setBorderWidth:1.0f];
		[self.cancelButton setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
		[[self.cancelButton titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[self.cancelButton addTarget:self action:@selector(changeInfoButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)changeInfoButtonBackGroundColor:(UIButton*) sender {
	if ([sender.backgroundColor isEqual:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]]){
		[sender setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
	} else {
		[sender setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	}
}

- (void)orientationChanged:(NSNotification *)notification{
	CGRect contentFrame = [self.topView frame];
	self.modalView.frame = contentFrame;
	CGSize availableSize = contentFrame.size;
	CGRect viewFrame = CGRectMake((availableSize.width - _viewWidth) / 2, (availableSize.height - _viewHeight) / 2, _viewWidth, _viewHeight);
	self.frame = viewFrame;
}

- (void)show {
	self.modalView = [[UIView alloc] initWithFrame:[self.topView bounds]];
	[self.modalView setBackgroundColor:[UIColor colorWithHexString:colorLightGrey andAlpha:0.5f]];
	[self.modalView setUserInteractionEnabled:YES];
	[self.topView addSubview:self.modalView];
	[self.modalView addSubview:self];
	[self.modalView setHidden:NO];
	[self setHidden:NO];
}

- (void)hide {
	[NSNotificationCenter.defaultCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[self.modalView removeFromSuperview];
	[self removeFromSuperview];
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)confirmClick {
	if([self.delegate respondsToSelector:@selector(didClickConfirmButtonWithTitle:confirmTag:)]) {
		[self.delegate didClickConfirmButtonWithTitle:self.confirmButton.titleLabel.text confirmTag:self.confirmTag];
	}
	[self hide];
}

- (void)cancelClick {
	if([self.delegate respondsToSelector:@selector(didClickCancelButton)]) {
		[self.delegate didClickCancelButton];
	}
	[self hide];
}
@end
