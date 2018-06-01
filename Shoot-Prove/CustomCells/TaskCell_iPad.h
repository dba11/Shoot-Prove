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

#import "EnumHelper.h"

@class Task;
@protocol TaskCelliPadDelegate <NSObject>
- (void)didTaskCelliPadRequestStartTask:(Task *)task;
- (void)didTaskCelliPadRequestDisplayDetailsForTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath;
- (void)didTaskCelliPadRequestDisplayRenditionForTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath;
- (void)didTaskCelliPadRequestExportTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath;
- (void)didTaskCelliPadRequestDeleteTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath;
- (void)didTaskCelliPadRequestRestoreTask:(Task *)task atIndexPath:(NSIndexPath *)indexPath;
@end
@interface TaskCell_iPad : UICollectionViewCell
- (void)setTask:(Task *)task indexPath:(NSIndexPath *)indexPath displayMode:(SPTaskDisplayMode)displayMode delegate:(id<TaskCelliPadDelegate>)delegate;
@end
