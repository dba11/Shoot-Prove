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

#import "TaskDetailViewController.h"
#import <SPCertificationSDK/SPCertificationQueue.h>
#import <CoreLocation/CoreLocation.h>
#import "StoreManager.h"
#import "ImageHelper.h"
#import "StyleHelper.h"
#import "Dialog.h"
#import "FileView.h"
#import "IndexesView.h"
#import "UIColor+HexString.h"
#import "Task.h"
#import "UIStyle.h"
#import "AbstractSubTask.h"
#import "SubTaskPicture.h"
#import "SubTaskScan.h"
#import "SubTaskForm.h"
#import "Rendition.h"
#import "CaptureImage.h"

@interface TaskDetailViewController ()
{
	Task *_task;
	NSMutableArray *_taskImages;
	NSIndexPath *_indexPath;
	SubTaskForm *_subTaskForm;
	BOOL _readOnly;
	UIBarButtonItem *_btnBack;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *viewIndexTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewIndexTitleHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblIndexes;
@property (weak, nonatomic) IBOutlet IndexesView *viewIndexes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewIndexesHeightConstraint;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarPages;
@property (weak, nonatomic) IBOutlet UILabel *lblPages;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UIButton *btnError;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewPages;
@property (weak, nonatomic) id<TaskDetailsViewControllerDelegate> delegate;
@end

@implementation TaskDetailViewController
#pragma - view life cycle
- (id)initWithTask:(Task *)task indexPath:(NSIndexPath *)indexPath readOnly:(BOOL)readOnly delegate:(id<TaskDetailsViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
		_task = task;
		_indexPath = indexPath;
		_readOnly = readOnly;
		self.delegate = delegate;
		_taskImages = [[NSMutableArray alloc] init];
		for(AbstractSubTask *subTask in _task.subTasks) {
			if([subTask isKindOfClass:[SubTaskForm class]] && !_subTaskForm) {
				_subTaskForm = (SubTaskForm *)subTask;
			} else if([subTask isKindOfClass:[SubTaskScan class]]) {
				SubTaskScan *scanTask = (SubTaskScan *)subTask;
				for(CaptureImage *image in scanTask.images) {
					[_taskImages addObject:image];
				}
			} else if([subTask isKindOfClass:[SubTaskPicture class]]) {
				SubTaskPicture *pictureTask = (SubTaskPicture *)subTask;
				for(CaptureImage *image in pictureTask.images) {
					[_taskImages addObject:image];
				}
			}
		}
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self buildBackButton];
	self.title = _task.title;
	
    [self.scrollView setBackgroundColor:[UIColor colorWithHexString:_task.uiStyle.viewBackgroundColor andAlpha:1.0f]];
    
	if(isDeviceIPad) {
		[[self.contentView layer] setBorderColor:[UIColor colorWithHexString:colorGrey andAlpha:1.0f].CGColor];
		[[self.contentView layer] setBorderWidth:1.0f];
	}
	
	if([_subTaskForm.indexes count]>0) {
		[self.viewIndexTitle setBackgroundColor:[UIColor colorWithHexString:_task.uiStyle.headerBackgroundColor andAlpha:1.0f]];
		[self.lblIndexes setTextColor:[UIColor colorWithHexString:_task.uiStyle.headerColor andAlpha:1.0f]];
        [self.lblIndexes setText:_task.serviceId ? _subTaskForm.title : _subTaskForm.desc];
	} else {
		[self.viewIndexTitle setHidden:YES];
		[self.viewIndexTitleHeightConstraint setConstant:0];
	}
	
    [self.viewIndexes setIndexes:_subTaskForm.indexes readOnly:_readOnly style:_task.uiStyle];
	[self.viewIndexesHeightConstraint setConstant:[self.viewIndexes preferredHeight]];
	[self.toolbarPages setBarTintColor:[UIColor colorWithHexString:_task.uiStyle.toolbarBackgroundColor andAlpha:1.0f]];
	[self.lblPages setTextColor:[UIColor colorWithHexString:_task.uiStyle.toolbarColor andAlpha:1.0f]];
	[self.lblPages setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
    UIImage *image = [[UIImage imageNamed:@"map"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.btnMap setImage:image forState:UIControlStateNormal];
    [self.btnMap.imageView setTintColor:[UIColor colorWithHexString:_task.uiStyle.toolbarColor andAlpha:1.0f]];
	[self.btnError setHidden:YES];
	[self.pickerViewPages setDelegate:self];
	[self.pickerViewPages setDataSource:self];
	[self.pickerViewPages setShowsSelectionIndicator:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [StyleHelper setStyle:_task.uiStyle viewController:self];
	[self.navigationItem setLeftBarButtonItems:@[_btnBack]];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	CGFloat availableWidth = self.scrollView.frame.size.width;
	CGFloat contentHeight = self.pickerViewPages.frame.origin.y + self.pickerViewPages.frame.size.height + 8;
	CGRect frame;
	if(availableWidth > viewMaxWidth && isDeviceIPad) {
		frame = CGRectMake((self.scrollView.frame.size.width - viewMaxWidth)/2, 0, viewMaxWidth, contentHeight);
	} else {
		frame = CGRectMake((self.scrollView.frame.size.width - availableWidth)/2, 0, availableWidth, contentHeight);
	}
	self.contentView.frame = frame;
	[self.scrollView addSubview:self.contentView];
	[self.scrollView setContentSize:frame.size];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if([_taskImages count] > 0) {
		[self setPageToolbarContentForRow:0];
	}
	if(![self.viewIndexes hasValue]) {
	   [self.viewIndexes setFocus];
	}
}

#pragma - build buttons
- (void)buildBackButton {
	_btnBack = [[UIBarButtonItem alloc] init];
	[_btnBack setImage:[UIImage imageNamed:@"close"]];
	[_btnBack setTarget:self];
	[_btnBack setAction:@selector(back)];
}

#pragma - picker delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if(pickerView == self.pickerViewPages) {
		return [_taskImages count];
	} else {
		return 0;
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	if(pickerView == self.pickerViewPages) {
		return self.pickerViewPages.frame.size.height;
	} else {
		return 0;
	}
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UIView *contentView;
	if(pickerView == self.pickerViewPages) {
		if(view && [view isKindOfClass:[FileView class]]) {
			contentView = (FileView *)view;
		} else {
			CGRect frame = CGRectMake(0, 0, self.pickerViewPages.frame.size.width, self.pickerViewPages.frame.size.height * 0.90);
			contentView = [[FileView alloc] initWithFrame:frame image:[_taskImages objectAtIndex:row]];
		}
	}
	return contentView;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if(thePickerView == self.pickerViewPages) {
		[self setPageToolbarContentForRow:row];
	}
}

#pragma - pages toolbar helper

- (void)setPageToolbarContentForRow:(NSInteger)row {
	[self.lblPages setText:[NSString stringWithFormat:@"%@ %d/%d", NSLocalizedString(@"TASK_DETAILS_PAGE", nil), (int)row+1, (int)_taskImages.count]];
	CaptureImage *image = [_taskImages objectAtIndex:row];
	self.btnMap.enabled = [image.latitude intValue] != 0 || [image.longitude intValue] != 0;
	BOOL hasError = NO;
	BOOL isCritical = NO;
	NSArray *errors = (NSArray *)image.errors;
	if([errors count]>0) {
		hasError = YES;
		for(NSError *err in errors) {
			if([err.domain isEqualToString:SPCertificationErrorDomain]) {
				isCritical = YES;
				break;
			}
		}
	}
	if(isCritical) {
		[self.btnError setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
		[self.btnError setHidden:NO];
	} else if(hasError) {
		[self.btnError setImage:[UIImage imageNamed:@"warning"] forState:UIControlStateNormal];
		[self.btnError setHidden:NO];
	} else {
		[self.btnError setHidden:YES];
	}
}

#pragma - buttons methods
- (void)back {
	if([self.delegate respondsToSelector:@selector(didTaskDetailsViewControllerReturnTask:atIndexPath:withUpdates:)]) {
		_subTaskForm.indexes = self.viewIndexes.indexes;
        [StyleHelper setDefaultStyleOnViewController:self];
		[self.delegate didTaskDetailsViewControllerReturnTask:_task atIndexPath:_indexPath withUpdates:[self.viewIndexes updated]];
	}
}

- (IBAction)map:(id)sender {
	CaptureImage *image = [_taskImages objectAtIndex:[self.pickerViewPages selectedRowInComponent:0]];
	MapViewController *mapViewController = [[MapViewController alloc] initWithImage:image delegate:self];
	[self.navigationController pushViewController:mapViewController animated:YES];
}

- (IBAction)error:(id)sender {
	CaptureImage *image = [_taskImages objectAtIndex:[self.pickerViewPages selectedRowInComponent:0]];
	TaskInfoViewController *certiticationVc = [[TaskInfoViewController alloc] initWithImage:image delegate:self];
	[self.navigationController pushViewController:certiticationVc animated:YES];
}

#pragma - certification view controller delegate
- (void)didTaskInfoViewControllerCancel {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma - map view controller delegate
- (void)didMapViewControllerCancel {
	[self.navigationController popViewControllerAnimated:YES];
}
@end
