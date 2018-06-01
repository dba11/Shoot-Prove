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

#import "DateTimePicker.h"
#import "UIColor+HexString.h"
#import "UIStyle.h"

static const CGFloat HEADER_HEIGHT = 40;
static const CGFloat LABEL_HEIGHT = 21;
static const CGFloat PICKER_HEIGHT = 150;
static const CGFloat BUTTON_HEIGHT = 40;
static const CGFloat MAX_WIDTH = viewMaxWidth;

@interface DateTimePicker() {
	CGFloat _viewHeight;
	CGFloat _viewWidth;
}
@property (strong, nonatomic) UIView *modalView;
@property (weak, nonatomic) id<DateTimePickerDelegate>delegate;
@property (nonatomic) BOOL displayDate;
@property (nonatomic) BOOL displayTime;
@property (strong, nonatomic) UIDatePicker *picker;
@end

@implementation DateTimePicker
- (id)initWithCurrentDate:(NSDate *)currentDate displayDate:(BOOL)displayDate displayTime:(BOOL)displayTime maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate style:(UIStyle *)style delegate:(id<DateTimePickerDelegate>)delegate tag:(NSInteger)tag {
	self = [super init];
	if(self) {
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
		if(!(displayDate || displayTime))
			displayDate = YES;
		self.delegate = delegate;
		self.displayDate = displayDate;
		self.displayTime = displayTime;
		self.tag = tag;
		CGRect contentFrame = [[[UIApplication sharedApplication] keyWindow] frame];
		CGSize availableSize = contentFrame.size;
		_viewHeight = HEADER_HEIGHT + 8 + PICKER_HEIGHT + 8 + BUTTON_HEIGHT;
		_viewWidth = ((availableSize.width - 16) < MAX_WIDTH) ? availableSize.width - 16:MAX_WIDTH;
		CGRect viewFrame = CGRectMake((availableSize.width - _viewWidth) / 2, (availableSize.height - _viewHeight) / 2, _viewWidth, _viewHeight);
		self.frame = viewFrame;
		[self setHidden:YES];
		[self setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:1.0f]];
		self.layer.cornerRadius = 4.0f;
		self.layer.borderColor = [UIColor colorWithHexString:style.toolbarBackgroundColor andAlpha:1.0f].CGColor;
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
		[[header layer] setMask:headerMaskLayer];
		[header setBackgroundColor:[UIColor colorWithHexString:style.toolbarBackgroundColor andAlpha:1.0f]];
		[[header layer] setBorderColor:[UIColor colorWithHexString:style.toolbarBackgroundColor andAlpha:1.0f].CGColor];
		[[header layer] setBorderWidth:1.0f];
		[self addSubview:header];
		CGRect dateLabelFrame = CGRectMake(8, (HEADER_HEIGHT - LABEL_HEIGHT) / 2, _viewWidth - 16, LABEL_HEIGHT);
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];
		[dateLabel setTextColor:[UIColor colorWithHexString:style.toolbarColor andAlpha:1.0f]];
		[dateLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		if(displayDate && displayTime) {
			[dateLabel setText:NSLocalizedString(@"DATE_TIME_PICKER_TITLE_DUAL", nil)];
		} else if(displayDate) {
			[dateLabel setText:NSLocalizedString(@"DATE_TIME_PICKER_TITLE_DATE", nil)];
		} else if(displayTime) {
			[dateLabel setText:NSLocalizedString(@"DATE_TIME_PICKER_TITLE_TIME", nil)];
		}
		[header addSubview:dateLabel];
		CGRect datePickerFrame = CGRectMake(8, HEADER_HEIGHT + 8, _viewWidth - 16, PICKER_HEIGHT);
		self.picker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
		if(displayDate && displayTime) {
			[self.picker setDatePickerMode:UIDatePickerModeDateAndTime];
		} else if(displayDate) {
			[self.picker setDatePickerMode:UIDatePickerModeDate];
		} else if(displayTime) {
			[self.picker setDatePickerMode:UIDatePickerModeTime];
		}
		if(minDate != nil && currentDate != nil && [minDate compare:currentDate] == NSOrderedDescending)
			currentDate = minDate;
		if(maxDate != nil && currentDate != nil && [currentDate compare:maxDate] == NSOrderedDescending)
			currentDate = maxDate;
		if(maxDate != nil)
		   [self.picker setMaximumDate:maxDate];
		if(minDate != nil)
			[self.picker setMinimumDate:minDate];
		if(currentDate != nil) {
			[self.picker setDate:currentDate];
		} else {
			[self.picker setDate:[NSDate date]];
		}
		[self addSubview:self.picker];
		CGRect btnOkFrame = CGRectMake(0, HEADER_HEIGHT + 8 + PICKER_HEIGHT + 8, (_viewWidth/ 2), BUTTON_HEIGHT);
		UIButton *btnOk = [[UIButton alloc] initWithFrame:btnOkFrame];
		UIBezierPath *okMaskPath = [UIBezierPath bezierPathWithRoundedRect:btnOk.bounds
															 byRoundingCorners:UIRectCornerBottomLeft
																   cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *okMaskLayer = [[CAShapeLayer alloc] init];
		okMaskLayer.frame = btnOk.bounds;
		okMaskLayer.path = okMaskPath.CGPath;
		btnOk.layer.mask = okMaskLayer;
		btnOk.backgroundColor = [UIColor colorWithHexString:style.toolbarBackgroundColor andAlpha:1.0f];
		btnOk.layer.borderColor = [UIColor colorWithHexString:style.toolbarColor andAlpha:1.0f].CGColor;
		btnOk.layer.borderWidth = 1.0f;
		[btnOk setTitleColor:[UIColor colorWithHexString:style.toolbarColor andAlpha:1.0f] forState:UIControlStateNormal];
		btnOk.titleLabel.font = [UIFont fontWithName:boldFontName size:largeFontSize];
		[btnOk setTitle:NSLocalizedString(@"BUTTON_OK", nil) forState:UIControlStateNormal];
		[btnOk addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
		[btnOk addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btnOk];
		CGRect btnCancelFrame = CGRectMake((_viewWidth/ 2), HEADER_HEIGHT + 8 + PICKER_HEIGHT + 8, (_viewWidth/ 2), BUTTON_HEIGHT);
		UIButton *btnCancel = [[UIButton alloc] initWithFrame:btnCancelFrame];
		UIBezierPath *cancelMaskPath = [UIBezierPath bezierPathWithRoundedRect:btnCancel.bounds
														 byRoundingCorners:UIRectCornerBottomRight
															   cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *cancelMaskLayer = [[CAShapeLayer alloc] init];
		cancelMaskLayer.frame = btnCancel.bounds;
		cancelMaskLayer.path = cancelMaskPath.CGPath;
		btnCancel.layer.mask = cancelMaskLayer;
		btnCancel.backgroundColor = [UIColor colorWithHexString:style.toolbarBackgroundColor andAlpha:1.0f];
		btnCancel.layer.borderColor = [UIColor colorWithHexString:style.toolbarColor andAlpha:1.0f].CGColor;
		btnCancel.layer.borderWidth = 1.0f;
		[btnCancel setTitleColor:[UIColor colorWithHexString:style.toolbarColor andAlpha:1.0f] forState:UIControlStateNormal];
		btnCancel.titleLabel.font = [UIFont fontWithName:boldFontName size:largeFontSize];
		[btnCancel setTitle:NSLocalizedString(@"BUTTON_CANCEL", nil) forState:UIControlStateNormal];
		[btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
		[btnCancel addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btnCancel];
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

- (void)orientationChanged:(NSNotification *)notification {
	CGRect contentFrame = [[[UIApplication sharedApplication] keyWindow] frame];
	self.modalView.frame = contentFrame;
	CGSize availableSize = contentFrame.size;
	CGRect viewFrame = CGRectMake((availableSize.width - _viewWidth) / 2, (availableSize.height - _viewHeight) / 2, _viewWidth, _viewHeight);
	self.frame = viewFrame;
}

- (void)show {
	self.modalView = [[UIView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
	[self.modalView setBackgroundColor:[UIColor colorWithHexString:colorLightGrey andAlpha:0.5f]];
	[self.modalView setUserInteractionEnabled:YES];
	[[[UIApplication sharedApplication] keyWindow] addSubview:self.modalView];
	[self.modalView addSubview:self];
	[self.modalView setHidden:NO];
	[self setHidden:NO];
}

- (void)ok {
	if([self.delegate respondsToSelector:@selector(didDateTimePickerReturnDate:tag:)]){
		NSDate *returnDate;
		if(self.displayDate && self.displayTime) {
			NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSIntegerMax fromDate: self.picker.date];
			[comps setSecond:0];
			returnDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
		} else if(self.displayDate) {
			NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSIntegerMax fromDate: self.picker.date];
			[comps setHour:0];
			[comps setMinute:0];
			[comps setSecond:0];
			returnDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
		} else if(self.displayTime) {
			NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSIntegerMax fromDate: self.picker.date];
			[comps setYear:0];
			[comps setMonth:0];
			[comps setDay:0];
			returnDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
		}
		[self.delegate didDateTimePickerReturnDate:returnDate tag:self.tag];
	}
	[self cancel];
}

- (void)cancel {
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[self.modalView removeFromSuperview];
	[self removeFromSuperview];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
