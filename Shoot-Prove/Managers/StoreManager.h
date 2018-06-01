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
#import <StoreKit/StoreKit.h>
#import "DeviceHelper.h"
#import "EnumHelper.h"

@class User;
@class Device;
@class Ident;
@class Rendition;
@class AbstractIndex;
@class DefaultIndex;
@class ListIndex;
@class Item;
@class Service;
@class Task;
@class CaptureImage;
@class AbstractService;
@class AbstractSubTask;
@class AbstractSubTaskCapture;
@class SubTaskForm;
@class SubTaskPicture;
@class SubTaskScan;
@class CertificationError;
@class DeleteImageReference;
@class RemoteTask;
@class RemoteService;
@class UnCheckedTransaction;
@class Subscription;
@class UIStyle;

@interface StoreManager : NSObject

#pragma - public instance
+ (instancetype)sharedManager;

#pragma - store paths
- (NSString *)publicPath;
- (NSString *)privatePath;

#pragma - public getters
- (RKManagedObjectStore *)objectStore;
- (BOOL)storeHasChanges;

#pragma - public save method
- (void)saveContext:(NSError **)error;

#pragma - user management methods
- (User *)fetchUser;
- (void)deleteUser:(User *)user;
- (void)applyTaskCost:(Task *)task;

#pragma - ident management methods
- (NSFetchedResultsController *)fetchedIdentsController;
- (void)deleteIdent:(Ident *)ident;

#pragma - device management method
- (NSArray *)fetchDevices;
- (NSFetchedResultsController *)fetchedDevicesController;
- (Device *)createDeviceForUser:(User *)user withProperties:(DeviceProperties *)properties;
- (void)deleteDevice:(Device *)device;

#pragma - user remote tasks management method
- (void)deleteRemoteTask:(RemoteTask *)remoteTask;

#pragma - user remote services management method
- (void)deleteRemoteService:(RemoteService *)remoteService;

#pragma - service management methods
- (NSFetchedResultsController *)fetchedActiveServicesController;

- (NSArray *)fetchActiveServices:(NSError **)error;
- (NSArray *)fetchLocalServicesWithoutRemoteEquivalentForUser:(User *)user error:(NSError **)error;
- (NSArray *)fetchNewRemoteServicesForUser:(User *)user error:(NSError **)error;
- (NSArray *)fetchQueuedForDeleteLocalServicesForUser:(User *)user error:(NSError **)error;
- (NSArray *)fetchUpdatedRemoteServicesForUser:(User *)user error:(NSError **)error;
- (NSArray *)fetchInactiveTasks:(NSError **)error;

- (Service *)fetchServiceWithId:(NSString *)uuid error:(NSError **)error;
- (Service *)createService:(NSString *)uuid title:(NSString *)title description:(NSString *)description iconUrl:(NSString *)url iconMime:(NSString *)mime error:(NSError **)error;
- (void)deleteService:(Service *)service;

#pragma - task management methods
- (NSFetchedResultsController *)fetchedPendingTasksController;
- (NSFetchedResultsController *)fetchedHistoryTasksController;
- (NSFetchedResultsController *)fetchedTrashedTasksController;

- (NSArray *)fetchAllTasks:(NSError **)error;
- (NSArray *)fetchLocalTasksWithoutRemoteEquivalentForUser:(User *)user error:(NSError **)error;
- (NSArray *)fetchNewLocalTasksForUser:(User *)user error:(NSError **)error;
- (NSArray *)fetchQueuedForDeleteLocalTasksForUser:(User *)user error:(NSError **)error;
- (NSArray *)fetchUpdatedLocalTasksForUser:(User *)user error:(NSError **)error;
- (NSArray *)fetchNewRemoteTasksForUser:(User *)user error:(NSError **)error;
- (NSArray *)fetchUpdatedRemoteTasksForUser:(User *)user error:(NSError **)error;

- (Task *)createFreeTask:(NSError **)error;
- (Task *)createTaskWithService:(Service *)service error:(NSError **)error;
- (NSError *)deleteTask:(Task *)task;

#pragma - style management method
- (UIStyle *)createNewStyle;

#pragma - sub task management methods
- (SubTaskForm *)createSubTaskFormForAbstractService:(AbstractService *)abstractService title:(NSString *)title description:(NSString *)description;
- (SubTaskPicture *)createSubTaskPictureForAbstractService:(AbstractService *)abstractService uuid:(NSString *)uuid title:(NSString *)title description:(NSString *)description;
- (SubTaskScan *)createSubTaskScanForAbstractService:(AbstractService *)abstractService uuid:(NSString *)uuid title:(NSString *)title description:(NSString *)description;
- (void)deleteSubTask:(AbstractSubTask *)subTask;

#pragma - index management methods
- (Item *)createItemWithKey:(NSInteger)key value:(NSString *)value;
- (DefaultIndex *)createIndexWithKey:(NSString *)key value:(NSString *)value description:(NSString *)description mandatory:(BOOL)mandatory type:(NSString *)type;
- (ListIndex *)createIndexWithKey:(NSString *)key value:(NSString *)value description:(NSString *)description mandatory:(BOOL)mandatory list:(NSArray *)list;
- (NSOrderedSet *)indexesFromSubTaskForm:(SubTaskForm *)subTaskForm;

#pragma - image management
- (void)fetchImage:(NSString *)uuid order:(NSInteger)order withBlock:(void(^)(CaptureImage *image, NSError *error)) block;
- (CaptureImage *)createImageForTask:(Task *)task uuid:(NSString *)uuid order:(NSInteger)order mime:(NSString *)mime;
- (void)deleteImageReference:(DeleteImageReference *)reference;
- (NSError *)deleteImage:(CaptureImage *)image;
- (NSError *)removeImageFiles:(CaptureImage *)image;

#pragma - rendition management methods
- (Rendition *)createRenditionForTask:(Task *)task;
- (NSError *)deleteRendition:(Rendition *)rendition;

#pragma - certification error management methods
- (void)createCertificationErrorForImage:(CaptureImage * )image code:(NSInteger)code description:(NSString *)desc domain:(NSString *)domain;

#pragma - transaction management methods
- (UnCheckedTransaction *)createUncheckedTransaction:(SKPaymentTransaction *)transaction product:(SKProduct *)product;
- (NSFetchedResultsController *)fetchedUncheckedTransactionsController;
- (void)deleteUncheckedTransaction:(UnCheckedTransaction *)uncheckedTransaction;

#pragma - other methods
- (NSString *)extentionFromMime:(NSString *)mime;
- (void)cleanSharedDirectoy;
- (void)syncSharedDirectory;
- (void)removeTempImages;

@end
