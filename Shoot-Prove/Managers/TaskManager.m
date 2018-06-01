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

#import "TaskManager.h"

#import "StoreManager.h"
#import "RestClientManager.h"
#import "SyncManager.h"

#import "TaskHelper.h"
#import "ErrorHelper.h"

#import "User.h"
#import "Task.h"
#import "AbstractSubTask.h"
#import "AbstractSubTaskCapture.h"
#import "SubTaskForm.h"
#import "CaptureImage.h"

@interface TaskManager()
{
    User *_user;
    int _taskStepCount;
}

@end

@implementation TaskManager
@synthesize delegate, taskIsStarted = _taskIsStarted;

#pragma - public instance

+ (instancetype)sharedManager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TaskManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if(self) {
        _user = [StoreManager.sharedManager fetchUser];
    }
    return self;
}

#pragma - public methods
- (void)startTask:(Task *)task popConfirmation:(BOOL)popConfirmation {
    
    if(_taskIsStarted) {
        NSLog(@"TaskManager.taskIsStarted");
        return;
    } else if(popConfirmation) {
        [[[TaskNotificationDialog alloc] initWithTask:task delegate:self] show];
    } else {
        _taskStepCount = 0;
        [self nextTaskStep:task];
    }
    
}

#pragma - task manager methods
- (void)nextTaskStep:(Task *)task {
    
    _taskIsStarted = YES;
    UIViewController *controller = nil;
    
    if(_taskStepCount < [task.subTasks count]) {
        
        AbstractSubTask *subTask = [task.subTasks objectAtIndex:_taskStepCount];
        
        if([subTask isKindOfClass:[AbstractSubTaskCapture class]]) {
            
            controller = [[CaptureViewController alloc] initWithSubTaskCapture:(AbstractSubTaskCapture *)subTask stepCount:(_taskStepCount+1) delegate:self];
            
        } else if([subTask isKindOfClass:[SubTaskForm class]]) {
            
            controller = [[FormTaskViewController alloc] initWithSubTaskForm:(SubTaskForm *)subTask stepCount:(_taskStepCount+1) delegate:self];
            
        }
        
    }
    
    if(controller) {
        
        if(_taskStepCount == 0 && !task.startDate)
            task.startDate = [NSDate date];
        task.lastUpdate = [NSDate date];
        _taskStepCount++;
        if([self.delegate respondsToSelector:@selector(didTaskManagerRequestPushViewController:)]){
            [self.delegate didTaskManagerRequestPushViewController:controller];
        }
        
    } else {
        
        UIView * topView = UIApplication.sharedApplication.keyWindow.subviews.lastObject;
        
        if(_taskStepCount == 0 && task.subTasks.count == 0) {
            
            [self markAsDeleteTask:task];
            [StoreManager.sharedManager saveContext:nil];
            _taskIsStarted = NO;
            
            [ErrorHelper popToastWithMessage:[NSString stringWithFormat:NSLocalizedString(@"TASK_ERROR_NO_SUBTASK", nil), task.provider] style:ToastHelper.styleError];
            
        } else {
            
            if(task.isComplete) {
                
                if([self popToFrontController]) {
                
                    [topView makeToast:NSLocalizedString(@"TASK_INFO_FINALIZED", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper.imageInfo style:ToastHelper.styleInfo completion:^(BOOL didTap) {
                        
                        if(didTap && !_taskIsStarted && [self.delegate respondsToSelector:@selector(didTaskManagerRequestDisplayHistory)]) {
                            [self.delegate didTaskManagerRequestDisplayHistory];
                        }
                        
                    }];
                    
                    if(task.isCertified) {
                        NSLog(@"TaskManager.nextTaskStep: task is certified and will be finalized.");
                        [self finalizeTask:task];
                        [StoreManager.sharedManager saveContext:nil];
                        [SyncManager.sharedManager syncTasks:YES andServices:NO];
                    } else {
                        NSLog(@"TaskManager.nextTaskStep: task is not certified. Waiting for certification client to finish the certification of its images.");
                        [CertificationClient.sharedManager setDelegate:self];
                    }
                
                    _taskIsStarted = NO;
                    
                }
                
            } else {
                
                [ErrorHelper popToastWithMessage:task.completionMessage style:ToastHelper.styleWarning];
                
            }
            
        }
        
    }
    
}

- (void)cancelTaskStep:(Task *)task {
    
    if([self popToFrontController]) {
        
        _taskStepCount = 0;
        [self cancelTask:task];
        _taskIsStarted = NO;
        [SyncManager.sharedManager addSyncTaskRequest];
        
        UIView * topView = UIApplication.sharedApplication.keyWindow.subviews.lastObject;
        [topView makeToast:NSLocalizedString(@"TASK_INFO_CANCELLED", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper. imageInfo style:ToastHelper.styleInfo completion:^(BOOL didTap) {
            
            if(didTap && !_taskIsStarted && [self.delegate respondsToSelector:@selector(didTaskManagerRequestDisplayInbox)]) {
                [self.delegate didTaskManagerRequestDisplayInbox];
            }
            
        }];
        
    }
    
}

- (void)backTaskStep:(Task *)task {
    
    _taskStepCount--;
    if([self.delegate respondsToSelector:@selector(didTaskManagerResquestPopViewController)]) {
        [self.delegate didTaskManagerResquestPopViewController];
    }
    
    if(_taskStepCount == 0) {
        
        [self cancelTask:task];
        _taskIsStarted = NO;
        [SyncManager.sharedManager addSyncTaskRequest];
        
        UIView * topView = UIApplication.sharedApplication.keyWindow.subviews.lastObject;
        [topView makeToast:NSLocalizedString(@"TASK_INFO_CANCELLED", nil) duration:toastDuration position:CSToastPositionBottom title:nil image:ToastHelper. imageInfo style:ToastHelper.styleInfo completion:^(BOOL didTap) {
            
            if(didTap && !_taskIsStarted && [self.delegate respondsToSelector:@selector(didTaskManagerRequestDisplayInbox)]) {
                [self.delegate didTaskManagerRequestDisplayInbox];
            }
            
        }];
        
    }
    
}

- (void)cancelTask:(Task *)task {
    task.icon_data = nil;
    task.endDate = nil;
    task.lastUpdate = [NSDate date];
    task.status = [NSNumber numberWithInt:SPStatusInProgress];
}

- (void)markAsDeleteTask:(Task *)task {
    task.icon_data = nil;
    task.endDate = nil;
    task.lastUpdate = [NSDate date];
    task.status = [NSNumber numberWithInt:SPStatusQueuedForDelete];
}

- (void)finalizeTask:(Task *)task {
    task.icon_data = nil;
    task.endDate = [NSDate date];
    task.lastUpdate = [NSDate date];
    task.status = [NSNumber numberWithInt:SPStatusCompleted];
}

#pragma - navigation controller helper
- (BOOL)popToFrontController {
    
    if([self.delegate respondsToSelector:@selector(didTaskManagerRequestPopViewControllersFromStep:)]) {
        return [self.delegate didTaskManagerRequestPopViewControllersFromStep:_taskStepCount];
    } else {
        return NO;
    }
    
}

#pragma - capture tasks view controller delegate methods
- (void)didCaptureViewControllerCancelSubTask:(AbstractSubTaskCapture *)subTaskCapture {
    if(subTaskCapture.isComplete)
        subTaskCapture.endDate = [NSDate date];
    else
        subTaskCapture.endDate = nil;
    Task *task = (Task *) subTaskCapture.abstractService;
    [self cancelTaskStep:task];
}

- (void)didCaptureViewControllerRequestBackOnSubTask:(AbstractSubTaskCapture *)subTaskCapture {
    if(subTaskCapture.isComplete)
        subTaskCapture.endDate = [NSDate date];
    else
        subTaskCapture.endDate = nil;
    Task *task = (Task *) subTaskCapture.abstractService;
    [self backTaskStep:task];
}

- (void)didCaptureViewControllerCompleteSubTask:(AbstractSubTaskCapture *)subTaskCapture {
    if(subTaskCapture.isComplete)
        subTaskCapture.endDate = [NSDate date];
    else
        subTaskCapture.endDate = nil;
    Task *task = (Task *) subTaskCapture.abstractService;
    [self nextTaskStep:task];
}

#pragma - form task view controller delegate methods
- (void)didFormTaskViewControllerRequestBackOnSubTask:(SubTaskForm *)subTaskForm {
    if(subTaskForm.isComplete)
        subTaskForm.endDate = [NSDate date];
    else
        subTaskForm.endDate = nil;
    
    Task *task = (Task *) subTaskForm.abstractService;
    [self backTaskStep:task];
}

- (void)didFormTaskViewControllerCancelSubTask:(SubTaskForm *)subTaskForm {
    if(subTaskForm.isComplete)
        subTaskForm.endDate = [NSDate date];
    else
        subTaskForm.endDate = nil;
    
    Task *task = (Task *) subTaskForm.abstractService;
    [self cancelTaskStep:task];
}

- (void)didFormTaskViewControllerCompleteSubTask:(SubTaskForm *)subTaskForm {
    if(subTaskForm.isComplete)
        subTaskForm.endDate = [NSDate date];
    else
        subTaskForm.endDate = nil;
    
    Task *task = (Task *) subTaskForm.abstractService;
    [self nextTaskStep:task];
}

#pragma - task notification dialog delegate
- (void)didTaskNotificationDialogRequestStartTask:(Task *)task {
    [self startTask:task popConfirmation:NO];
}

#pragma - certification client delegate
- (void)didCertificationClientFinishWithCaptureImageObject:(id)imageObject indexPath:(NSIndexPath *)indexPath {
    
    if([imageObject isKindOfClass:[CaptureImage class]]) {
        CaptureImage *captureImage = (CaptureImage *)imageObject;
        Task *task = captureImage.task;
        if(task.isComplete && task.isCertified) {
            NSLog(@"TaskManager.didCertificationClientFinishWithCaptureImageObject: task is complete and certified, finalizing task...");
            [self finalizeTask:task];
            [StoreManager.sharedManager saveContext:nil];
            [SyncManager.sharedManager syncTasks:YES andServices:NO];
        }
    }
    
}

@end
