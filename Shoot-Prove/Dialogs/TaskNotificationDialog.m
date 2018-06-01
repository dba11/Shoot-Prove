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

#import "TaskNotificationDialog.h"
#import "ImageHelper.h"
#import "NetworkManager.h"
#import "UIColor+HexString.h"
#import "Task.h"
#import "UIStyle.h"

static const CGFloat GAP = 8;
static const CGFloat HEADER_HEIGHT = 40;
static const CGFloat MINIMUM_TEXT_HEIGHT = 21;
static const CGFloat BUTTON_HEIGHT = 40;

@interface TaskNotificationDialog()
{
	Task *_task;
	CGFloat _viewHeight;
	CGFloat _viewWidth;
    UIView *_taskImageView;
    UIView *_modalView;
}
@property (weak, nonatomic) id<TaskNotificationDialogDelegate> delegate;
@end

@implementation TaskNotificationDialog
- (id)initWithTask:(Task *)task delegate:(id<TaskNotificationDialogDelegate>)delegate {
	self = [super init];
	if(self) {
		_task = task;
		self.delegate = delegate;
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
		CGRect contentFrame = [[[UIApplication sharedApplication] keyWindow] frame];
		CGFloat availableHeight = contentFrame.size.height - (2*GAP);
		CGFloat availableWidth = contentFrame.size.width > viewMaxWidth ? viewMaxWidth - (2*GAP):contentFrame.size.width - (2*GAP);
		NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:normalFontName size:normalFontSize]};
		NSString *message = [NSString stringWithFormat:NSLocalizedString(@"TASK_NOTIFICATION_MESSAGE", nil) ,_task.provider, _task.desc, _task.cost, [task.cost intValue] > 1 ? @"s":@""];
		CGRect messageRect = [message boundingRectWithSize:CGSizeMake(availableWidth - (2*GAP), MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
		CGFloat messageHeight = messageRect.size.height > MINIMUM_TEXT_HEIGHT ? messageRect.size.height:MINIMUM_TEXT_HEIGHT;
		NSString *question = NSLocalizedString(@"TASK_NOTIFICATION_QUESTION", nil);
		CGRect questionRect = [question boundingRectWithSize:CGSizeMake(availableWidth - (2*GAP), MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
		CGFloat questionHeight = messageRect.size.height > MINIMUM_TEXT_HEIGHT ? messageRect.size.height:MINIMUM_TEXT_HEIGHT;
        _viewWidth = availableWidth - (2 * GAP);
        _viewHeight = HEADER_HEIGHT + GAP + messageHeight + (_task.icon_data || _task.icon_url.length>0 ? GAP + _viewWidth/2:0) + GAP + questionHeight + GAP + BUTTON_HEIGHT;
		_viewHeight = _viewHeight > availableHeight ? availableHeight:_viewHeight;
		CGRect viewFrame = CGRectMake((contentFrame.size.width - _viewWidth) / 2, (contentFrame.size.height - _viewHeight) / 2, _viewWidth, _viewHeight);
		self.frame = viewFrame;
		self.layer.cornerRadius = 4.0f;
		self.backgroundColor = [UIColor colorWithHexString:colorWhite andAlpha:1.0f];
		self.layer.borderColor = [UIColor colorWithHexString:_task.uiStyle.toolbarColor andAlpha:1.0f].CGColor;
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
		[headerView setBackgroundColor:[UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f]];
		[headerView.layer setBorderColor:[UIColor colorWithHexString:_task.uiStyle.toolbarColor andAlpha:1.0f].CGColor];
		[headerView.layer setBorderWidth:1.0f];
		[self addSubview:headerView];
		CGRect headerLabelFrame = CGRectMake(GAP, (HEADER_HEIGHT - MINIMUM_TEXT_HEIGHT) / 2, _viewWidth - (2 * GAP), MINIMUM_TEXT_HEIGHT);
		UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerLabelFrame];
		[headerLabel setTextColor:[UIColor colorWithHexString:_task.uiStyle.toolbarColor andAlpha:1.0f]];
		[headerLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[headerLabel setText:_task.title];
		[headerView addSubview:headerLabel];
		CGRect confirmFrame = CGRectMake((_viewWidth / 2), _viewHeight - BUTTON_HEIGHT, (_viewWidth / 2), BUTTON_HEIGHT);
		UIButton *confirmButton = [[UIButton alloc] initWithFrame:confirmFrame];
		UIBezierPath *confirmMaskPath;
		confirmMaskPath = [UIBezierPath bezierPathWithRoundedRect:confirmButton.bounds
												byRoundingCorners:UIRectCornerBottomRight
													  cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *confirmMaskLayer = [[CAShapeLayer alloc] init];
		confirmMaskLayer.frame = confirmButton.bounds;
		confirmMaskLayer.path = confirmMaskPath.CGPath;
		[confirmButton.layer setMask:confirmMaskLayer];
		[confirmButton setBackgroundColor:[UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f]];
		[confirmButton.layer setBorderColor:[[UIColor colorWithHexString:_task.uiStyle.toolbarColor andAlpha:1.0f] CGColor]];
		[confirmButton.layer setBorderWidth:1.0f];
		[confirmButton setTitleColor:[UIColor colorWithHexString:_task.uiStyle.toolbarColor andAlpha:1.0f] forState:UIControlStateNormal];
		[confirmButton.titleLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[confirmButton setTitle:NSLocalizedString(@"BUTTON_START_TASK", nil) forState:UIControlStateNormal];
		[confirmButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
		[confirmButton addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:confirmButton];
		CGRect cancelFrame = CGRectMake(0, _viewHeight - BUTTON_HEIGHT, (_viewWidth/ 2), BUTTON_HEIGHT);
		UIButton *cancelButton = [[UIButton alloc] initWithFrame:cancelFrame];
		UIBezierPath *cancelMaskPath = [UIBezierPath bezierPathWithRoundedRect:cancelButton.bounds
													   byRoundingCorners:UIRectCornerBottomLeft
																   cornerRadii:CGSizeMake(4.0, 4.0)];
		CAShapeLayer *cancelMaskLayer = [[CAShapeLayer alloc] init];
		cancelMaskLayer.frame = cancelButton.bounds;
		cancelMaskLayer.path = cancelMaskPath.CGPath;
		[cancelButton.layer setMask:cancelMaskLayer];
		[cancelButton setBackgroundColor:[UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f]];
		[cancelButton.layer setBorderColor:[[UIColor colorWithHexString:_task.uiStyle.toolbarColor andAlpha:1.0f] CGColor]];
		[cancelButton.layer setBorderWidth:1.0f];
		[cancelButton setTitleColor:[UIColor colorWithHexString:_task.uiStyle.toolbarColor andAlpha:1.0f] forState:UIControlStateNormal];
		[cancelButton.titleLabel setFont:[UIFont fontWithName:boldFontName size:largeFontSize]];
		[cancelButton setTitle:NSLocalizedString(@"BUTTON_CANCEL", nil) forState:UIControlStateNormal];
		[cancelButton addTarget:self action:@selector(cancel) forControlEvents: UIControlEventTouchUpInside];
		[cancelButton addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:cancelButton];
        UIView *taskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, GAP + messageHeight + (_task.icon_data || _task.icon_url.length>0 ? GAP + _viewWidth/2:0) + GAP + questionHeight + GAP)];
        taskView.backgroundColor = [UIColor clearColor];
		UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(GAP, GAP, messageRect.size.width - GAP, messageRect.size.height)];
		messageLabel.numberOfLines = 0;
		messageLabel.textColor = [UIColor colorWithHexString:_task.uiStyle.promptColor andAlpha:1.0];
		messageLabel.font = [UIFont fontWithName:normalFontName size:normalFontSize];
		messageLabel.text = message;
		[taskView addSubview:messageLabel];
		CGFloat questionY = 0;
		if(_task.icon_data || _task.icon_url.length>0) {
			_taskImageView = [[UIView alloc] initWithFrame:CGRectMake((_viewWidth - _viewWidth/2) / 2, messageLabel.frame.origin.y + messageLabel.frame.size.height + GAP, _viewWidth/2, _viewWidth/2)];
			[taskView addSubview:_taskImageView];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self displayImage];
            });
			questionY = _taskImageView.frame.origin.y + _viewWidth/2 + GAP;
		} else {
			questionY = messageLabel.frame.origin.y + messageLabel.frame.size.height + GAP;
		}
		UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(GAP, questionY, questionRect.size.width, questionRect.size.height)];
		questionLabel.numberOfLines = 0;
		questionLabel.textColor = [UIColor colorWithHexString:_task.uiStyle.promptColor andAlpha:1.0];
		questionLabel.font = [UIFont fontWithName:normalFontName size:normalFontSize];
		questionLabel.text = question;
		[taskView addSubview:questionLabel];
		UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, _viewWidth, _viewHeight - HEADER_HEIGHT - BUTTON_HEIGHT)];
        scrollView.backgroundColor = [UIColor colorWithHexString:_task.uiStyle.viewBackgroundColor andAlpha:1.0f];
		scrollView.contentSize = taskView.frame.size;
		[scrollView addSubview:taskView];
		[self addSubview:scrollView];
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
	_modalView.frame = contentFrame;
	CGSize availableSize = contentFrame.size;
	CGRect viewFrame = CGRectMake((availableSize.width - _viewWidth) / 2, (availableSize.height - _viewHeight) / 2, _viewWidth, _viewHeight);
	self.frame = viewFrame;
}

- (void)displayImage {
    [ImageHelper displayImageData:_task.icon_data url:_task.icon_url mime:_task.icon_mime name:@"cloud_question" inView:_taskImageView waitColor:[UIColor colorWithHexString:_task.uiStyle.headerColor andAlpha:1.0f] block:^(NSData *data, NSString *mime) {
        if(_task.icon_data.hash != data.hash) {
            _task.icon_data = data;
            _task.icon_mime = mime;
        }
    }];
}

#pragma - public methods
- (void)show {
    if(!_modalView) {
		_modalView = [[UIView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
		[_modalView setBackgroundColor:[UIColor colorWithHexString:colorLightGrey andAlpha:0.5f]];
		[_modalView setUserInteractionEnabled:YES];
		[UIApplication.sharedApplication.keyWindow addSubview:_modalView];
		[_modalView addSubview:self];
	}
	[_modalView setHidden:NO];
	[self setHidden:NO];
}

- (void)hide {
	[_modalView setHidden:YES];
	[self setHidden:YES];
}

#pragma button events
- (void)start {
	[self hide];
	if([self.delegate respondsToSelector:@selector(didTaskNotificationDialogRequestStartTask:)]) {
		[self.delegate didTaskNotificationDialogRequestStartTask:_task];
	}
	[self cancelPicker];
}

- (void)cancel {
	if([self.delegate respondsToSelector:@selector(didTaskNotificationDialogCancel)]) {
		[self.delegate didTaskNotificationDialogCancel];
	}
	[self cancelPicker];
}

#pragma - cancel dialog for real
- (void)cancelPicker {
	[NSNotificationCenter.defaultCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[_modalView removeFromSuperview];
	[self removeFromSuperview];
	[NSNotificationCenter.defaultCenter removeObserver:self];
}
@end
