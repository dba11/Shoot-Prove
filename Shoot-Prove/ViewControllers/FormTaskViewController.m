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

#import "FormTaskViewController.h"
#import "ImageHelper.h"
#import "StyleHelper.h"
#import "IndexesView.h"
#import "UIColor+HexString.h"
#import "UIScrollView+FirstResponder.h"
#import "Task.h"
#import "UIStyle.h"
#import "SubTaskForm.h"
#import "AbstractIndex.h"
#import "DefaultIndex.h"
#import "ListIndex.h"
#import "Item.h"

@interface FormTaskViewController ()
{
	Task *_task;
	SubTaskForm *_subTaskForm;
	NSInteger _stepCount;
	NSInteger _totalSteps;
    BOOL _indexComplete;
	UIBarButtonItem *_btnBack;
	UIBarButtonItem *_btnCancel;
	UIBarButtonItem *_btnDone;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet IndexesView *indexesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexesViewHeightConstraint;
@property (weak, nonatomic) id<FormTaskViewControllerDelegate> delegate;
@end

@implementation FormTaskViewController
#pragma - view life cycle
- (id)initWithSubTaskForm:(SubTaskForm *)subTaskForm stepCount:(NSInteger)stepCount delegate:(id<FormTaskViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		_task = (Task *) subTaskForm.abstractService;
		_subTaskForm = subTaskForm;
		_stepCount = stepCount;
		_totalSteps = _task.subTasks.count;
        _indexComplete = NO;
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self buildBackAndCancelButtons];
	[self buildDoneButton];
    
	self.title = _task.title;
	
    [self.scrollView setBackgroundColor:[UIColor colorWithHexString:_task.uiStyle.viewBackgroundColor andAlpha:1.0f]];
	[self.headerView setBackgroundColor:[UIColor colorWithHexString:_task.uiStyle.headerBackgroundColor andAlpha:1.0f]];
    [self.headerImageView setTag:99]; //used by displayImageData to identify the target imageView where the icon shall be displayed
    [ImageHelper displayImageData:_task.serviceIconData url:_task.icon_url mime:_task.icon_mime name:@"cloud_question" inView:self.headerView waitColor:[UIColor colorWithHexString:_task.uiStyle.headerColor andAlpha:1.0f] block:^(NSData *data, NSString *mime) {
        if(_task.serviceIconData.hash != data.hash)
            _task.serviceIconData = data;
    }];
    
	[self.lblTitle setFont:[UIFont fontWithName:boldFontName size:mediumFontSize]];
	[self.lblTitle setTextColor:[UIColor colorWithHexString:_task.uiStyle.headerColor andAlpha:1.0f]];
	[self.lblTitle setNumberOfLines:1];
    [self.lblTitle setText:[NSString stringWithFormat:@"%d/%d%@", (int)_stepCount, (int)_totalSteps, _subTaskForm.title ? [NSString stringWithFormat:@": %@", _subTaskForm.title]:@""]];
	
	[self.lblDescription setFont:[UIFont fontWithName:normalFontName size:smallFontSize]];
	[self.lblDescription setTextColor:[UIColor colorWithHexString:_task.uiStyle.headerColor andAlpha:1.0f]];
	[self.lblDescription setNumberOfLines:0];
	[self.lblDescription setText:_subTaskForm.desc];
	
    [self.indexesView setIndexes:_subTaskForm.indexes readOnly:NO style:_task.uiStyle];
	[self.indexesViewHeightConstraint setConstant:[self.indexesView preferredHeight]];
	
	_subTaskForm.startDate = [NSDate date];
	
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	CGFloat availableWidth = self.view.frame.size.width;
	CGRect frame;
	if(availableWidth > viewMaxWidth) {
		frame = CGRectMake((self.scrollView.frame.size.width - viewMaxWidth)/2, 0, viewMaxWidth, self.indexesViewHeightConstraint.constant);
	} else {
		frame = CGRectMake((self.scrollView.frame.size.width - availableWidth)/2, 0, availableWidth, self.indexesViewHeightConstraint.constant);
	}
	self.contentView.frame = frame;
	[self.scrollView addSubview:self.contentView];
	[self.scrollView setContentSize:frame.size];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [StyleHelper setStyle:_task.uiStyle viewController:self];
    if(_stepCount>1)
        [self.navigationItem setLeftBarButtonItems:@[_btnBack, _btnCancel]];
    else
        [self.navigationItem setLeftBarButtonItems:@[_btnCancel]];
	[self.navigationItem setRightBarButtonItems:@[_btnDone]];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	if(![self.indexesView hasValue]) {
		[self.indexesView setFocus];
	}
}

#pragma - build buttons
- (void)buildBackAndCancelButtons {
	
	_btnBack = [[UIBarButtonItem alloc] init];
	[_btnBack setImage:[UIImage imageNamed:@"back"]];
	[_btnBack setTarget:self];
	[_btnBack setAction:@selector(back)];
	
	_btnCancel = [[UIBarButtonItem alloc] init];
	[_btnCancel setImage:[UIImage imageNamed:@"close"]];
	[_btnCancel setTarget:self];
	[_btnCancel setAction:@selector(cancel)];
	
}

- (void)buildDoneButton {
	_btnDone = [[UIBarButtonItem alloc] init];
	if(_stepCount == _totalSteps) {
		[_btnDone setImage:[UIImage imageNamed:@"done"]];
	} else {
		[_btnDone setImage:[UIImage imageNamed:@"next"]];
	}
	[_btnDone setTarget:self];
	[_btnDone setAction:@selector(done)];
}

#pragma - button actions
- (void)back {
	[[self.scrollView findFirstResponder] resignFirstResponder];
	
	if([self.delegate respondsToSelector:@selector(didFormTaskViewControllerRequestBackOnSubTask:)]) {
		[self.delegate didFormTaskViewControllerRequestBackOnSubTask:_subTaskForm];
	}
}

- (void)cancel {
	[[self.scrollView findFirstResponder] resignFirstResponder];
	if([self.delegate respondsToSelector:@selector(didFormTaskViewControllerCancelSubTask:)]) {
		[self.delegate didFormTaskViewControllerCancelSubTask:_subTaskForm];
	}
}

- (void)done {
	[[self.scrollView findFirstResponder] resignFirstResponder];
	if([self.delegate respondsToSelector:@selector(didFormTaskViewControllerCompleteSubTask:)]) {
		[self.delegate didFormTaskViewControllerCompleteSubTask:_subTaskForm];
	}
}

@end
