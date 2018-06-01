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

#import <Foundation/Foundation.h>

#import "TaskNotificationDialog.h"
#import "CaptureViewController.h"
#import "FormTaskViewController.h"
#import "CertificationClient.h"

@class Task;

@protocol TaskManagerDelegate <NSObject>
- (void)didTaskManagerRequestDisplayInbox;
- (void)didTaskManagerRequestDisplayHistory;
- (void)didTaskManagerRequestPushViewController:(UIViewController *)controller;
- (void)didTaskManagerResquestPopViewController;
- (BOOL)didTaskManagerRequestPopViewControllersFromStep:(NSInteger)step;
@end

@interface TaskManager : NSObject <CaptureViewControllerDelegate, FormTaskViewControllerDelegate, TaskNotificationDialogDelegate, CertificationClientDelegate>

#pragma - public instance
+ (instancetype)sharedManager;

#pragma - public properties
@property (nonatomic) BOOL taskIsStarted;
@property (nonatomic, weak) id<TaskManagerDelegate> delegate;

#pragma - public methods
- (void)startTask:(Task *)task popConfirmation:(BOOL)popConfirmation;
- (void)finalizeTask:(Task *)task;
@end
