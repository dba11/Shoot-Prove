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
#import "MapViewController.h"
#import "TaskInfoViewController.h"

@class Task;
@protocol TaskDetailsViewControllerDelegate <NSObject>
- (void)didTaskDetailsViewControllerReturnTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath withUpdates:(BOOL)update;
@end
@interface TaskDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, MapViewControllerDelegate, TaskInfoViewControllerDelegate>
- (id)initWithTask:(Task *)task indexPath:(NSIndexPath *)indexPath readOnly:(BOOL)readOnly delegate:(id<TaskDetailsViewControllerDelegate>)delegate;
@end
