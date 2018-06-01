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

#import "ItemPicker.h"
#import "UIColor+HexString.h"
#import "Item.h"

static const CGFloat HEADER_HEIGHT = 40;
static const CGFloat LABEL_HEIGHT = 21;
static const CGFloat PICKER_HEIGHT = 150;
static const CGFloat BUTTON_HEIGHT = 40;
static const CGFloat MAX_WIDTH = 300;

@interface ItemPicker() {
	CGFloat _viewHeight;
	CGFloat _viewWidth;
}
@property (strong, nonatomic) UIView *modalView;
@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) id<ItemPickerDelegate> delegate;
@property (strong, nonatomic) UIPickerView *picker;
@end

@implementation ItemPicker
#pragma view life cycle
- (id)initWithTitle:(NSString *)title items:(NSArray *)items delegate:(id<ItemPickerDelegate>)delegate tag:(NSInteger)tag {
	self = [super init];
	if(self) {
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
		self.items = items;
		self.delegate = delegate;
		self.tag = tag;
        CGRect contentFrame = [[[UIApplication sharedApplication] keyWindow] frame];
		CGSize availableSize = contentFrame.size;
		_viewHeight = HEADER_HEIGHT + 8 + PICKER_HEIGHT + 8 + BUTTON_HEIGHT;
		_viewWidth = ((availableSize.width - 16) < MAX_WIDTH) ? availableSize.width - 16:MAX_WIDTH;
		CGRect viewFrame = CGRectMake((availableSize.width - _viewWidth) / 2, (availableSize.height - _viewHeight) / 2, _viewWidth, _viewHeight);
		self.frame = viewFrame;
		[self setHidden:YES];
		self.backgroundColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f];
		self.layer.cornerRadius = 4.0f;
		self.layer.borderColor = [UIColor colorWithHexString:colorLightGrey andAlpha:1.0f].CGColor;
		self.layer.borderWidth = 1.0f;
		self.layer.shadowColor = [UIColor colorWithHexString:colorBlack andAlpha:1.0f].CGColor;
		self.layer.shadowOpacity = 0.5;
		self.layer.shadowRadius = 4;
		self.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
		self.layer.masksToBounds = NO;
		CGRect headerFrame = CGRectMake(0, 0, _viewWidth, HEADER_HEIGHT);
		UIView *header = [[UIView alloc] initWithFrame:headerFrame];
		UIBezierPath *headerMaskPath = [UIBezierPath bezierPathWithRoundedRect:header.bounds
															 byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
																   cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *headerMaskLayer = [[CAShapeLayer alloc] init];
		headerMaskLayer.frame = header.bounds;
		headerMaskLayer.path = headerMaskPath.CGPath;
		[header.layer setMask:headerMaskLayer];
		[header setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[header.layer setBorderColor:[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f].CGColor];
		[header.layer setBorderWidth:1.0f];
		[self addSubview:header];
		CGRect titleFrame = CGRectMake(8, (HEADER_HEIGHT - LABEL_HEIGHT) / 2, _viewWidth - 16, LABEL_HEIGHT);
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
		[titleLabel setTextColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
		[titleLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[titleLabel setText:title];
		[header addSubview:titleLabel];
		CGRect pickerFrame = CGRectMake(8, HEADER_HEIGHT + 8, _viewWidth - 16, PICKER_HEIGHT);
		self.picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
		[self.picker setDelegate:self];
		[self.picker setDataSource:self];
		[self addSubview:self.picker];
		CGRect btnOkFrame = CGRectMake(0, HEADER_HEIGHT + 8 + PICKER_HEIGHT + 8, (_viewWidth/ 2), BUTTON_HEIGHT);
		UIButton *btnOk = [[UIButton alloc] initWithFrame:btnOkFrame];
		UIBezierPath *okMaskPath = [UIBezierPath bezierPathWithRoundedRect:btnOk.bounds
														 byRoundingCorners:UIRectCornerBottomLeft
															   cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *okMaskLayer = [[CAShapeLayer alloc] init];
		okMaskLayer.frame = btnOk.bounds;
		okMaskLayer.path = okMaskPath.CGPath;
		[btnOk.layer setMask:okMaskLayer];
		[btnOk setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[btnOk.layer setBorderColor:[[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f] CGColor]];
		[btnOk.layer setBorderWidth:1.0f];
		[btnOk setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
		[btnOk.titleLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[btnOk setTitle:NSLocalizedString(@"BUTTON_OK", nil) forState:UIControlStateNormal];
		[btnOk addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
		[btnOk addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventAllEvents];
		[self addSubview:btnOk];
		CGRect btnCancelFrame = CGRectMake((_viewWidth/ 2), HEADER_HEIGHT + 8 + PICKER_HEIGHT + 8, (_viewWidth/ 2), BUTTON_HEIGHT);
		UIButton *btnCancel = [[UIButton alloc] initWithFrame:btnCancelFrame];
		UIBezierPath *cancelMaskPath = [UIBezierPath bezierPathWithRoundedRect:btnCancel.bounds
															 byRoundingCorners:UIRectCornerBottomRight
																   cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *cancelMaskLayer = [[CAShapeLayer alloc] init];
		cancelMaskLayer.frame = btnCancel.bounds;
		cancelMaskLayer.path = cancelMaskPath.CGPath;
		[btnCancel.layer setMask:cancelMaskLayer];
		[btnCancel setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[btnCancel.layer setBorderColor:[[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f] CGColor]];
		[btnCancel.layer setBorderWidth:1.0f];
        [btnCancel setTitleColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f] forState:UIControlStateNormal];
        [btnCancel.titleLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[btnCancel setTitle:NSLocalizedString(@"BUTTON_CANCEL", nil) forState:UIControlStateNormal];
		[btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
		[btnCancel addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventAllEvents];
		[self addSubview:btnCancel];
		
	}
	
	return self;
}

#pragma picker delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.items.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UIView *contentView;
	if(view && [view isKindOfClass:[UILabel class]]) {
		contentView = (UILabel *)view;
	} else {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , self.picker.frame.size.width, 44)];
		[label setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
		[label setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
		Item *item = (Item *) [self.items objectAtIndex:row];
		[label setText:item.value];
		contentView = label;
	}
	return contentView;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	//
}

#pragma helper to display slight color change when pressing a button
- (void)changeButtonBackGroundColor:(UIButton*) sender{
	if ([sender.backgroundColor isEqual:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]]){
		[sender setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:0.5f]];
	} else {
		[sender setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
	}
}

#pragma - device orientation change method
- (void)orientationChanged:(NSNotification *)notification{
	CGRect contentFrame = UIApplication.sharedApplication.keyWindow.frame;
	self.modalView.frame = contentFrame;
	CGSize availableSize = contentFrame.size;
	CGRect viewFrame = CGRectMake((availableSize.width - _viewWidth) / 2, (availableSize.height - _viewHeight) / 2, _viewWidth, _viewHeight);
	self.frame = viewFrame;
}

#pragma public method
- (void)show {
	if([self.items count] == 0)
	   return;
	[self.picker selectRow:0 inComponent:0 animated:NO];
	self.modalView = [[UIView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
	[self.modalView setBackgroundColor:[UIColor colorWithHexString:colorGrey andAlpha:0.1f]];
	[self.modalView setUserInteractionEnabled:YES];
	[UIApplication.sharedApplication.keyWindow addSubview:self.modalView];
	[self.modalView addSubview:self];
	[self.modalView setHidden:NO];
	[self setHidden:NO];
}

#pragma button events
- (void)ok {
	if([self.delegate respondsToSelector:@selector(didItemPickerReturnItem:tag:)]){
		ListItem *item = (ListItem *) [self.items objectAtIndex:[self.picker selectedRowInComponent:0]];
		NSInteger tag = self.tag;
		[self.delegate didItemPickerReturnItem:item tag:tag];
	}
	[self cancel];
}

- (void)cancel {
	[NSNotificationCenter.defaultCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[self.modalView removeFromSuperview];
	[self removeFromSuperview];
	[NSNotificationCenter.defaultCenter removeObserver:self];
}
@end
