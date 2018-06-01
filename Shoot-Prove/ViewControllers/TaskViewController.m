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

#import "TaskViewController.h"
#import "SWRevealViewController.h"
#import "SettingsManager.h"
#import "StoreManager.h"
#import "UIColor+HexString.h"
#import "ImageHelper.h"
#import "TaskHelper.h"
#import "ErrorHelper.h"
#import "DeviceHelper.h"
#import "ErrorHelper.h"
#import "TaskCellRowAction.h"
#import "ShadowButton.h"
#import "User.h"
#import "Task.h"
#import "UIStyle.h"
#import "AbstractSubTask.h"
#import "SubTaskForm.h"
#import "DefaultIndex.h"
#import "Rendition.h"
#import "Viewer.h"

#define ROW_HEIGHT 130

@interface TaskViewController ()
{
	UIDocumentInteractionController *_documentInteractionController;
	NSFetchedResultsController *_resultController;
	SPTaskDisplayMode _displayMode;
	UIBarButtonItem *_btnMenu;
    UIBarButtonItem *_btnTrashAll;
    User *_user;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<TaskViewControllerDelegate> delegate;
@end

@implementation TaskViewController
#pragma - view life cycle
- (id)initWithUser:(User *)user displayMode:(SPTaskDisplayMode)displayMode delegate:(id <TaskViewControllerDelegate>)delegate {
	self = [super init];
	if(self) {
        _user = user;
		_displayMode = displayMode;
		self.delegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self buildMenuButton];
    [self buildTrashAllButton];
	
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([TaskCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([TaskCell class])];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
	switch (_displayMode) {
		case SPTaskDisplayModeInbox:
			self.title = NSLocalizedString(@"MENU_INBOX", nil);
            _resultController = [StoreManager.sharedManager fetchedPendingTasksController];
			break;
		case SPTaskDisplayModeTrash:
			self.title = NSLocalizedString(@"MENU_TRASH", nil);
            _resultController = [StoreManager.sharedManager fetchedTrashedTasksController];
			break;
		case SPTaskDisplayModeHistory:
			self.title = NSLocalizedString(@"MENU_HISTORY", nil);
            _resultController = [StoreManager.sharedManager fetchedHistoryTasksController];
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
- (Task *)selectedTask {
	return (Task *) [_resultController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
}

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

#pragma - tableview delegate and datasource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [_resultController.sections objectAtIndex:section];
	NSUInteger count = sectionInfo.numberOfObjects;
	if (count > 0) {
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		self.tableView.backgroundView = nil;
        _btnTrashAll.enabled = YES;
	} else {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.tableView.bounds.size.width-48)/2, 8, 48, 48)];
        [view addSubview:imageView];
        
		UILabel *messageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, imageView.frame.origin.y + imageView.frame.size.height + 8, self.tableView.bounds.size.width-16, self.tableView.bounds.size.height - (imageView.frame.origin.y + imageView.frame.size.height + 16))];
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
		
        CGFloat viewHeight;
        
        if(_displayMode == SPTaskDisplayModeHistory) {
            ShadowButton *button = [[ShadowButton alloc] initWithFrame:CGRectMake((view.frame.size.width - 48) / 2, messageLabel1.frame.origin.y + messageLabel1.frame.size.height + 8, 48, 48)];
            button.layer.cornerRadius = button.frame.size.height/2;
            [button setBackgroundColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
            [button setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(openAccount:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            UILabel *messageLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(8, button.frame.origin.y + button.frame.size.height + 16, self.tableView.bounds.size.width-16, self.tableView.bounds.size.height - (button.frame.origin.y + button.frame.size.height + 24))];
            [view addSubview:messageLabel2];
            messageLabel2.text = NSLocalizedString(@"HISTORY_NO_CONTENT_2", nil);
            messageLabel2.textColor = [UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f];
            messageLabel2.numberOfLines = 0;
            messageLabel2.textAlignment = NSTextAlignmentCenter;
            messageLabel2.font = [UIFont fontWithName:normalFontName size:normalFontSize];
            [messageLabel2 sizeToFit];
            
            viewHeight = messageLabel2.frame.origin.y + messageLabel2.frame.size.height + 8;
            
        } else {
            
            viewHeight = messageLabel1.frame.origin.y + messageLabel1.frame.size.height + 8;
            
        }
        
        CGRect frame = CGRectMake(0, 0, view.frame.size.width, viewHeight);
        view.frame = frame;
        [scrollView addSubview:view];
        scrollView.contentSize = frame.size;
        
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		self.tableView.backgroundView = scrollView;
        _btnTrashAll.enabled = NO;
	}
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Task *task = (Task *)[_resultController objectAtIndexPath:indexPath];
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskCell class])];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setTask:task indexPath:indexPath displayMode:_displayMode delegate:self];
    });
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

#if defined __IPHONE_11_0 && __has_builtin(__builtin_available)
- (id)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_displayMode == SPTaskDisplayModeTrash)
        _btnTrashAll.enabled = YES;
    return nil;
}

- (id)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (@available(iOS 11.0, *)) {
        NSMutableArray *actions = [[NSMutableArray alloc] init];
        Task *task = [_resultController objectAtIndexPath:indexPath];
        if(_displayMode == SPTaskDisplayModeTrash) {
            _btnTrashAll.enabled = NO;
            UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                [self deleteTask:task];
                completionHandler(YES);
            }];
            deleteAction.image = [UIImage imageNamed:@"trash_forever"];
            deleteAction.title = nil;
            deleteAction.backgroundColor = [UIColor colorWithHexString:colorRed andAlpha:1.0f];
            [actions addObject:deleteAction];
            UIContextualAction *restoreAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                [self restoreTask:task];
                completionHandler(YES);
            }];
            restoreAction.image = [UIImage imageNamed:@"restore"];
            restoreAction.title = nil;
            restoreAction.backgroundColor = [UIColor colorWithHexString:colorGreen andAlpha:1.0f];
            [actions addObject:restoreAction];
        } else {
            UIContextualAction *trashAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                [self trashTask:task];
                completionHandler(YES);
            }];
            trashAction.image = [UIImage imageNamed:@"trash"];
            trashAction.title = nil;
            trashAction.backgroundColor = [UIColor colorWithHexString:colorRed andAlpha:1.0f];
            [actions addObject:trashAction];
        }
        UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:actions];
        configuration.performsFirstActionWithFullSwipe = YES;
        return configuration;
    }
    return nil;
}
#endif

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	NSMutableArray *buttons = [[NSMutableArray alloc] init];
    Task *task = [_resultController objectAtIndexPath:indexPath];
	if(_displayMode == SPTaskDisplayModeTrash) {
        _btnTrashAll.enabled = NO;
		TaskCellRowAction *buttonDelete = [TaskCellRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"BUTTON_FAKE", nil) icon:[UIImage imageNamed:@"trash_forever"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self deleteTask:task];
		}];
		[buttonDelete setFont:[UIFont fontWithName:normalFontName size:largeFontSize]];
		[buttonDelete setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
		[buttons addObject:buttonDelete];
		
		TaskCellRowAction *buttonRestore = [TaskCellRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"BUTTON_FAKE", nil) icon:[UIImage imageNamed:@"restore"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self restoreTask:task];
		}];
		[buttonRestore setFont:[UIFont fontWithName:normalFontName size:largeFontSize]];
		[buttonRestore setBackgroundColor:[UIColor colorWithHexString:colorGreen andAlpha:1.0f]];
		[buttons addObject:buttonRestore];
	} else {
		TaskCellRowAction *buttonTrash = [TaskCellRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"BUTTON_FAKE", nil) icon:[UIImage imageNamed:@"trash"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self trashTask:task];
		}];
		[buttonTrash setFont:[UIFont fontWithName:normalFontName size:largeFontSize]];
		[buttonTrash setBackgroundColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
		[buttons addObject:buttonTrash];
	}
	return buttons;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	//required to allow custom row action
}

- (void)deleteTask:(Task *)task {
    if(task.uuid.length == 0) {
        [StoreManager.sharedManager deleteTask:task];
    } else {
        task.status = [NSNumber numberWithInt:SPStatusQueuedForDelete];
        task.lastUpdate = [NSDate date];
        [SyncManager.sharedManager addSyncTaskRequest];
    }
    _btnTrashAll.enabled = YES;
}

- (void)restoreTask:(Task *)task {
    task.status = [NSNumber numberWithInt:task.endDate ? SPStatusCompleted:SPStatusInProgress];
    task.lastUpdate = [NSDate date];
    if([task.uuid length] > 0) {
        [SyncManager.sharedManager addSyncTaskRequest];
    }
    _btnTrashAll.enabled = YES;
}

- (void)trashTask:(Task *)task {
    task.status = [NSNumber numberWithInt:SPStatusTrash];
    task.lastUpdate = [NSDate date];
    if([task.uuid length] > 0) {
        [SyncManager.sharedManager addSyncTaskRequest];
    }
}

# pragma - fetch task controller delegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	if(type == NSFetchedResultsChangeInsert) {
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
					  withRowAnimation:UITableViewRowAnimationFade];
	} else if(type == NSFetchedResultsChangeDelete) {
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
					  withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
    atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:@[newIndexPath]
							 withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:@[indexPath]
							 withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeUpdate:
			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

#pragma - task cell delegate methods
- (void)didTaskCellRequestStartTask:(Task *)task {
	if([self.delegate respondsToSelector:@selector(didTaskViewControllerRequestStartTask:)]) {
		[DeviceHelper checkCameraGranted:^(BOOL granted) {
			if(granted) {
				[self.delegate didTaskViewControllerRequestStartTask:task];
			} else {
				[[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"DEVICE_CAMERA_DISABLED", nil), NSLocalizedString(@"DEVICE_OPEN_SETTINGS", nil)] confirmButtonTitle:NSLocalizedString(@"BUTTON_SETTINGS", nil) confirmTag:openSettingsTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
			}
		}];
	}
}

- (void)didTaskCellRequestDisplayDetailsForTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath {
	TaskDetailViewController *detailsViewController = [[TaskDetailViewController alloc] initWithTask:task indexPath:indexPath readOnly:(task.serviceId != nil) delegate:self];
	[self.navigationController pushViewController:detailsViewController animated:YES];
}

- (void)didTaskCellRequestExportTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath {
	dispatch_async(dispatch_get_main_queue(), ^{
        Rendition *rendition = [task.renditions lastObject];
        if(rendition && [[NSFileManager defaultManager] fileExistsAtPath:rendition.privatePath]) {
            NSURL *url = [NSURL fileURLWithPath:rendition.privatePath];
			_documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
			TaskCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			CGRect rect = cell.frame;
			[_documentInteractionController presentOptionsMenuFromRect:rect inView:self.view animated:YES];
		}
	});
}

- (void)didTaskCellRequestDisplayRenditionForTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath {
	Rendition *rendition = [task.renditions lastObject];
	if([NSFileManager.defaultManager fileExistsAtPath:rendition.privatePath]) {
        [[[Viewer alloc] initWithFilePath:rendition.privatePath mimeType:rendition.mimetype] show];
	} else {
        [ErrorHelper popToastWithMessage:[NSString stringWithFormat:NSLocalizedString(@"ERROR_NO_RENDITION", nil), rendition.privatePath] style:ToastHelper.styleWarning];
	}
}

#pragma - button actions
- (void)trashAll:(id)sender {
    [[[Dialog alloc] initWithType:DialogTypeWarning title:NSLocalizedString(@"TITLE_WARNING", nil) message:NSLocalizedString(@"TRASH_CONFIRM_DELETE_ALL", nil) confirmButtonTitle:NSLocalizedString(@"BUTTON_YES", nil) confirmTag:confirmDeleteAllTag cancelButtonTitle:NSLocalizedString(@"BUTTON_NO", nil) target:self] show];
}

- (void)openAccount:(id)sender {
    if([self.delegate respondsToSelector:@selector(didTaskViewControllerRequestDisplayAccount)]) {
        [self.delegate didTaskViewControllerRequestDisplayAccount];
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
        [self deleteTask:task];
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
                        //NSLog(@"free task title: %@", task.title);
                    }
                    if([subTaskForm.indexes count]>1) {
                        DefaultIndex *index = (DefaultIndex *) [subTaskForm.indexes objectAtIndex:1];
                        if([index.value length]>0)
                            task.desc = index.value;
                        //NSLog(@"free task desc: %@", task.desc);
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
		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [SyncManager.sharedManager addSyncTaskRequest];
	}
}
@end
