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

#import "GravatarPicker.h"
#import "UIColor+HexString.h"
#import "NSString+Email.h"
#import "NSString+MD5.h"
#import "UIView+FirstResponder.h"

static const CGFloat GAP = 8;
static const CGFloat HEADER_HEIGHT = 40;
static const CGFloat LABEL_HEIGHT = 21;
static const CGFloat MESSAGE_HEIGHT = 80;
static const CGFloat TEXT_HEIGHT = 30;
static const CGFloat BUTTON_HEIGHT = 40;
static const CGFloat MAX_WIDTH = viewMaxWidth;

@interface GravatarPicker ()
{
	CGFloat _viewHeight;
	CGFloat _viewWidth;
}
@property (strong, nonatomic) UIView *modalView;
@property (strong, nonatomic) UITextField *emailTextField;
@property (weak, nonatomic) id<GravatarPickerDelegate> delegate;
@property (nonatomic) NSUInteger imageSize;
@end

@implementation GravatarPicker
- (id)initWithDelegate:(id<GravatarPickerDelegate>)delegate email:(NSString *)email imageSize:(NSUInteger)size {
	self = [super init];
	if(self) {
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
		self.delegate = delegate;
		self.imageSize = size;
		if(self.imageSize < 1) {
			self.imageSize = 1;
		}
		if(self.imageSize > 2048) {
			self.imageSize = 2048;
		}
		CGRect contentFrame = [[[UIApplication sharedApplication] keyWindow] frame];
		CGSize availableSize = contentFrame.size;
		_viewHeight = HEADER_HEIGHT + GAP + MESSAGE_HEIGHT + 3*GAP + TEXT_HEIGHT + 3*GAP + BUTTON_HEIGHT;
		_viewWidth = ((availableSize.width - (2 * GAP)) < MAX_WIDTH) ? availableSize.width - (2 * GAP):MAX_WIDTH;
		CGRect viewFrame = CGRectMake((availableSize.width - _viewWidth) / 2, (availableSize.height - _viewHeight) / 2, _viewWidth, _viewHeight);
		self.frame = viewFrame;
		self.layer.cornerRadius = 4.0f;
		self.backgroundColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f];
		self.layer.borderColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f].CGColor;
		self.layer.borderWidth = 1.0f;
		self.layer.shadowColor = [UIColor colorWithHexString:colorBlack andAlpha:1.0f].CGColor;
		self.layer.shadowOpacity = 0.5;
		self.layer.shadowRadius = 4;
		self.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
		self.layer.masksToBounds = NO;
		CGRect headerFrame = CGRectMake(0, 0, _viewWidth, HEADER_HEIGHT);
		UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
		UIBezierPath *headerMaskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds
															 byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
																   cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *headerMaskLayer = [[CAShapeLayer alloc] init];
		headerMaskLayer.frame = headerView.bounds;
		headerMaskLayer.path = headerMaskPath.CGPath;
		[headerView.layer setMask:headerMaskLayer];
		[headerView setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[headerView.layer setBorderColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f].CGColor];
		[headerView.layer setBorderWidth:1.0f];
		[self addSubview:headerView];
		CGRect headerLabelFrame = CGRectMake(GAP, (HEADER_HEIGHT - LABEL_HEIGHT) / 2, _viewWidth - (2 * GAP), LABEL_HEIGHT);
		UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerLabelFrame];
		[headerLabel setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
		[headerLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[headerLabel setText:NSLocalizedString(@"TITLE_GRAVATAR", nil)];
		[headerView addSubview:headerLabel];
		CGRect messageFrame = CGRectMake(GAP, HEADER_HEIGHT + GAP, _viewWidth - (2 * GAP), MESSAGE_HEIGHT);
		UILabel *messageLabel = [[UILabel alloc] initWithFrame:messageFrame];
		[messageLabel setNumberOfLines:0];
		NSAttributedString *normalText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"GRAVATAR_PICKER_MESSAGE", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:colorBlack andAlpha:1.0f], NSFontAttributeName:[UIFont fontWithName:normalFontName size:normalFontSize]}];
		NSAttributedString *highlightedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"GRAVATAR_PICKER_URL", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:colorBlue andAlpha:1.0f], NSFontAttributeName:[UIFont fontWithName:normalFontName size:normalFontSize], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
		NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] init];
		[messageText appendAttributedString:normalText];
		[messageText appendAttributedString:highlightedText];
		[messageLabel setAttributedText:messageText];
		UITapGestureRecognizer *linkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGravatarUrl)];
		[messageLabel setUserInteractionEnabled:YES];
		[messageLabel addGestureRecognizer:linkTap];
		[self addSubview:messageLabel];
		CGRect textFrame = CGRectMake(GAP, HEADER_HEIGHT + GAP + MESSAGE_HEIGHT + 3*GAP, _viewWidth - (2 * GAP), TEXT_HEIGHT);
		self.emailTextField = [[UITextField alloc] initWithFrame:textFrame];
		[self.emailTextField setTextColor:[UIColor colorWithHexString:colorBlack andAlpha:1.0f]];
		[self.emailTextField setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
		[self.emailTextField setPlaceholder:NSLocalizedString(@"GRAVATAR_PICKER_EMAIL_PLACEHOLDER", nil)];
		[self.emailTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[self.emailTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
		[self.emailTextField setSpellCheckingType:UITextSpellCheckingTypeNo];
		[self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
		[self.emailTextField setReturnKeyType:UIReturnKeyDone];
		[self.emailTextField setDelegate:self];
		[self.emailTextField setBorderStyle:UITextBorderStyleRoundedRect];
		[self.emailTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[self.emailTextField setText:email];
		[self addSubview:self.emailTextField];
		CGRect confirmFrame = CGRectMake(0, HEADER_HEIGHT + GAP + MESSAGE_HEIGHT + 3*GAP + TEXT_HEIGHT + 3*GAP, (_viewWidth/ 2), BUTTON_HEIGHT);
		UIButton *confirmButton = [[UIButton alloc] initWithFrame:confirmFrame];
		UIBezierPath *confirmMaskPath;
		confirmMaskPath = [UIBezierPath bezierPathWithRoundedRect:confirmButton.bounds
												byRoundingCorners:UIRectCornerBottomLeft
													  cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *confirmMaskLayer = [[CAShapeLayer alloc] init];
		confirmMaskLayer.frame = confirmButton.bounds;
		confirmMaskLayer.path = confirmMaskPath.CGPath;
		[confirmButton.layer setMask:confirmMaskLayer];
		[confirmButton setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[confirmButton.layer setBorderColor:[[UIColor colorWithHexString:colorWhite andAlpha:1.0f] CGColor]];
		[confirmButton.layer setBorderWidth:1.0f];
		[confirmButton setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
		[[confirmButton titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[confirmButton setTitle:NSLocalizedString(@"BUTTON_OK", nil) forState:UIControlStateNormal];
		[confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
		[confirmButton addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:confirmButton];
		CGRect cancelFrame = CGRectMake((_viewWidth / 2), HEADER_HEIGHT + GAP + MESSAGE_HEIGHT + (3 * GAP) + TEXT_HEIGHT + (3 * GAP), (_viewWidth / 2), BUTTON_HEIGHT);
		UIButton *cancelButton = [[UIButton alloc] initWithFrame:cancelFrame];
		UIBezierPath *cancelMaskPath = [UIBezierPath bezierPathWithRoundedRect:cancelButton.bounds
													   byRoundingCorners:UIRectCornerBottomRight
															 cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *cancelMaskLayer = [[CAShapeLayer alloc] init];
		cancelMaskLayer.frame = cancelButton.bounds;
		cancelMaskLayer.path = cancelMaskPath.CGPath;
		[cancelButton.layer setMask:cancelMaskLayer];
		[cancelButton setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[cancelButton.layer setBorderColor:[[UIColor colorWithHexString:colorWhite andAlpha:1.0f] CGColor]];
		[cancelButton.layer setBorderWidth:1.0f];
		[cancelButton setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
		[[cancelButton titleLabel] setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[cancelButton setTitle:NSLocalizedString(@"BUTTON_CANCEL", nil) forState:UIControlStateNormal];
		[cancelButton addTarget:self action:@selector(cancel) forControlEvents: UIControlEventTouchUpInside];
		[cancelButton addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:cancelButton];
		[self setHidden:YES];
	}
	return self;
}

- (void)changeButtonBackGroundColor:(UIButton*) sender{
	if ([sender.backgroundColor isEqual:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]]){
		[sender setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:0.5f]];
	} else {
		[sender setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	}
}

- (void)orientationChanged:(NSNotification *)notification{
	CGRect contentFrame = [[[UIApplication sharedApplication] keyWindow] frame];
	self.modalView.frame = contentFrame;
	CGSize availableSize = contentFrame.size;
	CGRect viewFrame = CGRectMake((availableSize.width - _viewWidth) / 2, (availableSize.height - _viewHeight) / 2, _viewWidth, _viewHeight);
	self.frame = viewFrame;
}

#pragma text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self confirm];
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	//
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	//
}

#pragma public methods
- (void)show {
	if(!self.modalView) {
		self.modalView = [[UIView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
		[self.modalView setBackgroundColor:[UIColor colorWithHexString:colorLightGrey andAlpha:0.5f]];
		[self.modalView setUserInteractionEnabled:YES];
		[UIApplication.sharedApplication.keyWindow addSubview:self.modalView];
		[self.modalView addSubview:self];
	}
	[self.modalView setHidden:NO];
	[self setHidden:NO];
}

- (void)hide {
	[self.modalView setHidden:YES];
	[self setHidden:YES];
}

#pragma button events
- (void)confirm {
	[[self findFirstResponder] resignFirstResponder];
    [self hide];
	self.emailTextField.text = [[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
	if([self.emailTextField.text length] == 0) {
		[self.emailTextField setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:0.3f]];
		[self showGravatarPickerErrorWithMessage:NSLocalizedString(@"GRAVATAR_ERROR_EMAIL_EMPTY", nil)];
	} else if(![self.emailTextField.text isValidEmail]) {
		[self.emailTextField setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:0.3f]];
		[self showGravatarPickerErrorWithMessage:NSLocalizedString(@"GRAVATAR_ERROR_EMAIL_INVALID", nil)];
	} else {
		[self.emailTextField setBackgroundColor:[UIColor colorWithHexString:(colorWhite) andAlpha:0.3f]];
		[self getGravatar];
	}
}

- (void)cancel {
	if([self.delegate respondsToSelector:@selector(didGravatarPickerCancel)]) {
		[self.delegate didGravatarPickerCancel];
	}
	[self cancelPicker];
}

#pragma helper to get gravatar from email
- (void)getGravatar {
	NSString *gravatarEndPoint = [NSString stringWithFormat:gravatarUrl, [self.emailTextField.text MD5], (int)self.imageSize];
	if([self.delegate respondsToSelector:@selector(didGravatarPickerReturnUrl:email:)]) {
		[self.delegate didGravatarPickerReturnUrl:gravatarEndPoint email:self.emailTextField.text];
	}
	[self cancelPicker];
}

#pragma helper to start safari on gravatar web site;
- (void)openGravatarUrl {
	[UIApplication.sharedApplication openURL:[NSURL URLWithString:NSLocalizedString(@"GRAVATAR_PICKER_URL", nil)]];
}

- (void)showGravatarPickerErrorWithMessage:(NSString *)message {
	[[[Dialog alloc] initWithType:DialogTypeError title:NSLocalizedString(@"TITLE_ERROR", nil) message:message confirmButtonTitle:NSLocalizedString(@"BUTTON_OK", nil) confirmTag:nil cancelButtonTitle:nil target:self] show];
}

- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
	[self show];
	[self.emailTextField becomeFirstResponder];
}

#pragma cancel the picker dialog
- (void)cancelPicker {
	[NSNotificationCenter.defaultCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[self.modalView removeFromSuperview];
	[self removeFromSuperview];
	[NSNotificationCenter.defaultCenter removeObserver:self];
}
@end
