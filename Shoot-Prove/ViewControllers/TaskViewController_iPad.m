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

#import "TaskViewController_iPad.h"
#import "SWRevealViewController.h"
#import "SettingsManager.h"
#import "StoreManager.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "UIColor+HexString.h"
#import "ImageHelper.h"
#import "TaskHelper.h"
#import "ErrorHelper.h"
#import "DeviceHelper.h"
#import "User.h"
#import "Task.h"
#import "UIStyle.h"
#import "AbstractSubTask.h"
#import "SubTaskForm.h"
#import "DefaultIndex.h"
#import "Rendition.h"
#import "Viewer.h"
#import "ShadowButton.h"

#define spacing 8.0f
#define cellWidth 250.0f
#define cellHeight 330.0f

@interface TaskViewController_iPad ()
{
	UIDocumentInteractionController *_documentInteractionController;
	NSFetchedResultsController *_resultController;
	SPTaskDisplayMode _displayMode;
    UIBarButtonItem *_btnMenu;
    UIBarButtonItem *_btnTrashAll;
    int _itemsPerRow;
    User *_user;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id<TaskViewControllerIpadDelegate> delegate;
@end

@implementation TaskViewController_iPad
#pragma - view life cycle
- (id)initWithUser:(User *)user displayMode:(SPTaskDisplayMode)displayMode delegate:(id <TaskViewControllerIpadDelegate>)delegate {
	self = [super init];
	if(self) {
        _user = user;
		_displayMode = displayMode;
		self.delegate = delegate;
        if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            _itemsPerRow = 3;
        } else {
            _itemsPerRow = 4;
        }
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self buildMenuButton];
    [self buildTrashAllButton];
	
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:spacing];
    [flowLayout setMinimumLineSpacing:spacing];
    [flowLayout setSectionInset:UIEdgeInsetsMake(spacing, spacing, spacing, spacing)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([TaskCell_iPad class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([TaskCell_iPad class])];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:YES];
    
	switch (_displayMode) {
		case SPTaskDisplayModeInbox:
			self.title = NSLocalizedString(@"MENU_INBOX", nil);
            _resultController = [[StoreManager sharedManager] fetchedPendingTasksController];
			break;
		case SPTaskDisplayModeTrash:
			self.title = NSLocalizedString(@"MENU_TRASH", nil);
            _resultController = [[StoreManager sharedManager] fetchedTrashedTasksController];
			break;
		case SPTaskDisplayModeHistory:
			self.title = NSLocalizedString(@"MENU_HISTORY", nil);
            _resultController = [[StoreManager sharedManager] fetchedHistoryTasksController];
            break;
		default:
			self.title = nil;
            _resultController = nil;
			break;
    }
    [_resultController setDelegate:self];
	NSError *error;
	if (![_resultController performFetch:&error]){
        [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
	}
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationItem setLeftBarButtonItems:@[_btnMenu]];
    if(_displayMode == SPTaskDisplayModeTrash) {
        [self.navigationItem setRightBarButtonItems:@[_btnTrashAll]];
    } else {
        [self.navigationItem setRightBarButtonItems:nil];
    }
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.toolbarItems = nil;
	[self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma - orientation change
- (void)orientationChanged:(NSNotification *)notification {
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        _itemsPerRow = 3;
    } else {
        _itemsPerRow = 4;
    }
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

#pragma - build buttons
- (void)buildMenuButton {
	_btnMenu = [[UIBarButtonItem alloc] init];
	[_btnMenu setImage:[UIImage imageNamed:@"menu"]];
	[_btnMenu setTarget:[self revealViewController]];
	[_btnMenu setAction:@selector(revealToggle:)];
}

- (void)buildTrashAllButton {
    _btnTrashAll = [[UIBarButtonItem alloc] init];
    [_btnTrashAll setImage:[UIImage imageNamed:@"trash_forever"]];
    [_btnTrashAll setTarget:self];
    [_btnTrashAll setAction:@selector(trashAll:)];
}

#pragma - generic helpers
- (NSIndexPath *)indexPathForTask:(Task *)task {
	NSIndexPath *indexPath;
	NSInteger index = 0;
	for(Task *currentTask in [_resultController fetchedObjects]) {
		if([task isEqual:currentTask]) {
			indexPath = [NSIndexPath indexPathForRow:index inSection:0];
			break;
		}
		index++;
	}
	return indexPath;
}

#pragma - collection delegate and datasource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [_resultController.sections objectAtIndex:section];
	NSUInteger count = sectionInfo.numberOfObjects;
    if (count > 0) {
        self.collectionView.backgroundView = nil;
        _btnTrashAll.enabled = YES;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.collectionView.bounds.size.width-48)/2, 8, 48, 48)];
        [view addSubview:imageView];
        
        UILabel *messageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, imageView.frame.origin.y + imageView.frame.size.height + 8, self.collectionView.bounds.size.width-16, self.collectionView.bounds.size.height - (imageView.frame.origin.y + imageView.frame.size.height + 16))];
        [view addSubview:messageLabel1];
        
        switch (_displayMode) {
            case SPTaskDisplayModeInbox:
                messageLabel1.text = NSLocalizedString(@"INBOX_NO_CONTENT", nil);
                imageView.image = [[UIImage imageNamed:@"inbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                break;
            case SPTaskDisplayModeTrash:
                messageLabel1.text = NSLocalizedString(@"TRASH_NO_CONTENT", nil);
                imageView.image = [[UIImage imageNamed:@"trash"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                break;
            case SPTaskDisplayModeHistory:
                messageLabel1.text = NSLocalizedString(@"HISTORY_NO_CONTENT_1", nil);
                imageView.image = [[UIImage imageNamed:@"history"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                break;
            default:
                messageLabel1.text = nil;
                break;
        }
        
        imageView.tintColor = [UIColor colorWithHexString:colorGreen andAlpha:0.5f];
        
        messageLabel1.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
        messageLabel1.numberOfLines = 0;
        messageLabel1.textAlignment = NSTextAlignmentCenter;
        messageLabel1.font = [UIFont fontWithName:normalFontName size:normalFontSize];
        [messageLabel1 sizeToFit];
        
        if(_displayMode == SPTaskDisplayModeHistory) {
            ShadowButton *button = [[ShadowButton alloc] initWithFrame:CGRectMake((view.frame.size.width - 48) / 2, messageLabel1.frame.origin.y + messageLabel1.frame.size.height + 8, 48, 48)];
            button.layer.cornerRadius = button.frame.size.height/2;
            [button setBackgroundColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
            [button setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(openAccount:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            UILabel *messageLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(8, button.frame.origin.y + button.frame.size.height + 16, self.collectionView.bounds.size.width-16, self.collectionView.bounds.size.height - (button.frame.origin.y + button.frame.size.height + 24))];
            [view addSubview:messageLabel2];
            messageLabel2.text = NSLocalizedString(@"HISTORY_NO_CONTENT_2", nil);
            messageLabel2.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
            messageLabel2.numberOfLines = 0;
            messageLabel2.textAlignment = NSTextAlignmentCenter;
            messageLabel2.font = [UIFont fontWithName:normalFontName size:normalFontSize];
            [messageLabel2 sizeToFit];
        }
        self.collectionView.backgroundView = view;
        _btnTrashAll.enabled = NO;
    }
	return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat availableWidth = self.collectionView.frame.size.width - ((_itemsPerRow + 1) * spacing);
	CGFloat width = availableWidth / _itemsPerRow;
	CGFloat ratio = cellWidth / width;
	CGFloat height = cellHeight / ratio;
	return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [_resultController objectAtIndexPath:indexPath];
	TaskCell_iPad *cell = (TaskCell_iPad *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TaskCell_iPad class]) forIndexPath:indexPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setTask:task indexPath:indexPath displayMode:_displayMode delegate:self];
    });
	return cell;
}

#pragma - fetchResultController delegate methods
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch (type) {
		case NSFetchedResultsChangeInsert: {
			[self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
			break;
		}
		case NSFetchedResultsChangeDelete: {
			[self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
			break;
		}
		case NSFetchedResultsChangeUpdate: {
			[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
			break;
		}
		default:
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch (type) {
		case NSFetchedResultsChangeInsert: {
			[self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
			break;
		}
		case NSFetchedResultsChangeDelete: {
			[self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
			break;
		}
		case NSFetchedResultsChangeUpdate: {
			[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
			break;
		}
		case NSFetchedResultsChangeMove: {
			[self.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
			break;
		}
		default:
			break;
	}
}

#pragma - task cell iPad delegate methods
- (void)didTaskCelliPadRequestStartTask:(Task *)task {
	if([self.delegate respondsToSelector:@selector(didTaskViewControllerIpadRequestStartTask:)]) {
		[DeviceHelper checkCameraGranted:^(BOOL granted) {
			if(granted) {
				[self.delegate didTaskViewControllerIpadRequestStartTask:task];
			} else {
                [ErrorHelper popDialogWithTitle:NSLocalizedString(@"TITLE_WARNING", nil) message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"DEVICE_CAMERA_DISABLED", nil), NSLocalizedString(@"DEVICE_OPEN_SETTINGS", nil)] type:DialogTypeWarning];
			}
		}];
	}
}

- (void)didTaskCelliPadRequestDisplayDetailsForTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath {
	TaskDetailViewController *detailsViewController = [[TaskDetailViewController alloc] initWithTask:task indexPath:indexPath readOnly:(task.serviceId != nil) delegate:self];
	[self.navigationController pushViewController:detailsViewController animated:YES];
}

- (void)didTaskCelliPadRequestExportTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath {
	dispatch_async(dispatch_get_main_queue(), ^{
        Rendition *rendition = [task.renditions lastObject];
        if(rendition && [NSFileManager.defaultManager fileExistsAtPath:rendition.privatePath]) {
            NSURL *url = [NSURL fileURLWithPath:rendition.privatePath];
            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
            TaskCell_iPad *cell = (TaskCell_iPad *) [self.collectionView cellForItemAtIndexPath:indexPath];
            CGRect rect = cell.frame;
            [_documentInteractionController presentOptionsMenuFromRect:rect inView:self.view animated:YES];
        }
	});
}

- (void)didTaskCelliPadRequestDisplayRenditionForTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath {
	Rendition *rendition = [task.renditions lastObject];
	if([NSFileManager.defaultManager fileExistsAtPath:rendition.privatePath]) {
        [[[Viewer alloc] initWithFilePath:rendition.privatePath mimeType:rendition.mimetype] show];
	} else {
        [ErrorHelper popToastWithMessage:[NSString stringWithFormat:NSLocalizedString(@"ERROR_NO_RENDITION", nil), rendition.privatePath] style:ToastHelper.styleWarning];
	}
}

- (void)didTaskCelliPadRequestDeleteTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath {
	if(_displayMode == SPTaskDisplayModeTrash) {
		if(task.uuid.length == 0) {
			[StoreManager.sharedManager deleteTask:task];
		} else {
			task.status = [NSNumber numberWithInt:SPStatusQueuedForDelete];
			task.lastUpdate = [NSDate date];
			[SyncManager.sharedManager addSyncTaskRequest];
		}
	} else {
		task.status = [NSNumber numberWithInt:SPStatusTrash];
		task.lastUpdate = [NSDate date];
		if([task.uuid length] > 0) {
			[SyncManager.sharedManager addSyncTaskRequest];
		}
	}
}

- (void)didTaskCelliPadRequestRestoreTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath {
	task.status = [NSNumber numberWithInt:task.endDate ? SPStatusCompleted:SPStatusInProgress];
	task.lastUpdate = [NSDate date];
	if([task.uuid length] > 0) {
		[SyncManager.sharedManager addSyncTaskRequest];
	}
}

#pragma - button actions
- (void)trashAll:(id)sender {
    [[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:NSLocalizedString(@"TRASH_CONFIRM_DELETE_ALL", nil) confirmButtonTitle:NSLocalizedString(@"BUTTON_YES", nil) confirmTag:confirmDeleteAllTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
}

- (void)openAccount:(id)sender {
    if([self.delegate respondsToSelector:@selector(didTaskViewControllerIpadRequestDisplayAccount)]) {
        [self.delegate didTaskViewControllerIpadRequestDisplayAccount];
    }
}

#pragma - dialog delegate
- (void)didClickConfirmButtonWithTitle:(NSString *)confirmButtonTitle confirmTag:(NSString *)tag {
    if([tag isEqualToString:openSettingsTag]) {
        [DeviceHelper openDeviceSettings];
    } else if([tag isEqualToString:confirmDeleteAllTag]) {
        [self deleteTrashedTasks];
    }
}

#pragma - helper to delete all tasks in trash
- (void)deleteTrashedTasks {
    if(_displayMode != SPTaskDisplayModeTrash)
        return;
    NSArray *tasks = [_resultController fetchedObjects];
    for(Task *task in tasks) {
        if(task.uuid.length == 0) {
            [StoreManager.sharedManager deleteTask:task];
        } else {
            task.status = [NSNumber numberWithInt:SPStatusQueuedForDelete];
            task.lastUpdate = [NSDate date];
            [SyncManager.sharedManager addSyncTaskRequest];
        }
    }
}

#pragma - details view controller delegate method
- (void)didTaskDetailsViewControllerReturnTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath withUpdates:(BOOL)update {
    [self.navigationController popViewControllerAnimated:YES];
    if(update) {
        task.lastUpdate = [NSDate date];
        if(!task.serviceId) {
            for(AbstractSubTask *abstractSubTask in task.subTasks) {
                if([abstractSubTask isKindOfClass:[SubTaskForm class]]) {
                    SubTaskForm *subTaskForm = (SubTaskForm *)abstractSubTask;
                    if([subTaskForm.indexes count]>0) {
                        DefaultIndex *index = (DefaultIndex *) [subTaskForm.indexes objectAtIndex:0];
                        if([index.value length]>0)
                            task.title = index.value;
                    }
                    if([subTaskForm.indexes count]>1) {
                        DefaultIndex *index = (DefaultIndex *) [subTaskForm.indexes objectAtIndex:1];
                        if([index.value length]>0)
                            task.desc = index.value;
                    }
                    break;
                }
            }
        }
        NSError *error;
        [StoreManager.sharedManager saveContext:&error];
        if(error) {
            [ErrorHelper popToastForStatusCode:0 error:error style:ToastHelper.styleError];
        }
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [SyncManager.sharedManager addSyncTaskRequest];
    }
}
@end
