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

#import <UIKit/UIKit.h>

#import "TaskDetailViewController.h"
#import "SyncManager.h"
#import "Dialog.h"
#import "EnumHelper.h"
#import "TaskCell.h"

@class Task;
@class User;
@protocol TaskViewControllerDelegate <NSObject>
- (void)didTaskViewControllerRequestStartTask:(Task *)task;
- (void)didTaskViewControllerRequestDisplayAccount;
@end
@interface TaskViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, TaskDetailsViewControllerDelegate, TaskCellDelegate, DialogDelegate>
- (id)initWithUser:(User *)user displayMode:(SPTaskDisplayMode)displayMode delegate:(id <TaskViewControllerDelegate>)delegate;
@end
