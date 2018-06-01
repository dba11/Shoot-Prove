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

#import "SyncManager.h"

#import "StoreManager.h"
#import "RestClientManager.h"

#import "DeviceHelper.h"
#import "EnumHelper.h"
#import "ErrorHelper.h"

#import "User.h"
#import "Device.h"
#import "RemoteTask.h"
#import "RemoteService.h"
#import "Task.h"
#import "Service.h"

#import "AbstractSubTask.h"
#import "AbstractSubTaskCapture.h"
#import "SubTaskPicture.h"
#import "SubTaskScan.h"
#import "CaptureImage.h"
#import "Rendition.h"

@interface SyncManager() {
	
    UIBackgroundTaskIdentifier _backgroundTaskIdentifier;
    
	BOOL _syncTaskRequest;
	BOOL _syncServiceRequest;
	
	NSTimer *_syncTimer;
	BOOL _syncInProgress;
	BOOL _syncTasks;
	BOOL _syncServices;
	User *_user;
	
}
@end

@implementation SyncManager

#pragma - public instance

+ (instancetype)sharedManager {
	static id manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[SyncManager alloc] init];
	});
	return manager;
}

- (id)init {
	self = [super init];
	if(self) {
		_user = [StoreManager.sharedManager fetchUser];
		_syncInProgress = NO;
	}
	return self;
}

#pragma - synchronization start points. Triggered by local timer, direct calls or silent push notification

- (void)addSyncTaskRequest {
	_syncTaskRequest = YES;
	[self initTimer];
}

- (void)addSyncServiceRequest {
	_syncServiceRequest = YES;
	[self initTimer];
}

- (void)initTimer {
	//reset timer if exists
	if(_syncTimer) {
		[_syncTimer invalidate];
		_syncTimer = nil;
		NSLog(@"SyncManager.initTimer.timerReset");
	}
	_syncTimer = [NSTimer scheduledTimerWithTimeInterval:syncDelayAfterRequest
												  target:self
												selector:@selector(performTimer)
												userInfo: nil
												 repeats:NO];
	NSLog(@"SyncManager.initTimer.timerSet(%.1f sec)", syncDelayAfterRequest);
}

- (void)performTimer {
	[self syncTasks:_syncTaskRequest andServices:_syncServiceRequest];
}

- (void)syncTasks:(BOOL)syncTasks andServices:(BOOL)syncServices {
	
	if(!_syncInProgress) {
        
        _backgroundTaskIdentifier = [UIApplication.sharedApplication beginBackgroundTaskWithName:@"sp_sync" expirationHandler:^{
            NSLog(@"SyncManager.backgroundTask.expired");
            [self finalizeSync];
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"SyncManager.backgroundTask.started");
            _syncServices = syncServices;
            _syncTasks = syncTasks;
            _syncInProgress = YES;
            [NetworkManager.sharedManager setDelegate:self];
            [NetworkManager.sharedManager startNetworkPooling:5];
        });
		
	} else {
		
		if(_syncServices)
			_syncServiceRequest = NO;
		if(_syncTasks)
			_syncTaskRequest = NO;
		NSLog(@"SyncManager.addSyncRequest.syncInProgress.true");
		
	}
	
}

- (void)isInternetAvailable:(BOOL)internetAvailable andServerOnline:(BOOL)serverOnline {
	
	[NetworkManager.sharedManager setDelegate:nil];
	[NetworkManager.sharedManager stopNetworkPooling];
	
	if(serverOnline) {
		[self authenticate];
	} else {
		[self finalizeSync];
	}
	
}

- (void)authenticate {
    Device *userDevice = [DeviceHelper getCurrentDevice];
    if(userDevice) {
        [RestClientManager.sharedManager authDevice:userDevice andReturnUser:^(User *user, NSInteger statusCode, NSError *error) {
            if(statusCode == 200) {
                _user = user;
                if(_syncTasks) {
                    [self deleteLocalTasksWithoutRemoteEquivalent];
                } else if(_syncServices) {
                    [self deleteLocalServicesWithoutRemoteEquivalent];
                } else {
                    [self finalizeSync];
                }
            } else {
                [self endWithStatusCode:statusCode error:error];
            }
        }];
    } else {
        [self finalizeSync];
    }
    
}

- (void)deleteLocalTasksWithoutRemoteEquivalent {
	NSError *error;
	NSArray *tasks = [StoreManager.sharedManager fetchLocalTasksWithoutRemoteEquivalentForUser:_user error:&error];
	if(!error) {
		int numberOfTasks = (int)[tasks count];
		if(numberOfTasks > 0) {
			for(Task *task in tasks) {
				[StoreManager.sharedManager deleteTask:task];
			}
			[StoreManager.sharedManager saveContext:&error];
			if(error) {
				NSLog(@"SyncManager.deleteLocalTasksWithoutRemoteEquivalent.saveContext error: %@", [error localizedDescription]);
			}
			[self postNewLocalTasks];
		} else {
			[self postNewLocalTasks];
		}
	} else {
        NSLog(@"SyncManager.deleteLocalTasksWithoutRemoteEquivalent.fetchLocalTasksWithoutRemoteEquivalentFromUser error: %@", [error localizedDescription]);
		[self postNewLocalTasks];
	}
}

- (void)postNewLocalTasks {
	NSError *error;
	NSArray *tasks = [StoreManager.sharedManager fetchNewLocalTasksForUser:_user error:&error];
	if(!error) {
		__block int numberOfTasks = (int)[tasks count];
		__block int taskCount = 0;
		if(numberOfTasks > 0) {
			for(Task *task in tasks) {
				[RestClientManager.sharedManager postTask:task block:^(NSInteger statusCode, NSError *error) {
					if(error) {
						NSLog(@"SyncManager.postNewLocalTasks.postTask error: %@", [error localizedDescription]);
					}
					taskCount++;
					if(taskCount == numberOfTasks) {
                        NSError *saveError;
						[StoreManager.sharedManager saveContext:&saveError];
						if(saveError) {
							NSLog(@"SyncManager.postNewLocalTasks.saveContext error: %@", [saveError localizedDescription]);
						}
						[self getUpdatedRemoteTasks];
					}
				}];
			}
		} else {
			[self getUpdatedRemoteTasks];
		}
	} else {
		NSLog(@"SyncManager.postNewLocalTasks.fetchNewLocalTasks error: %@", [error localizedDescription]);
		[self getUpdatedRemoteTasks];
	}
}

- (void)getUpdatedRemoteTasks {
	NSError *error;
	NSArray *tasks = [StoreManager.sharedManager fetchUpdatedRemoteTasksForUser:_user error:&error];
	if(!error) {
		__block int numberOfTasks = (int)[tasks count];
		__block int taskCount = 0;
		if(numberOfTasks > 0) {
			for(Task *task in tasks) {
				[RestClientManager.sharedManager getUpdatedTask:task block:^(Task* updatedTask, NSInteger statusCode, NSError *error) {
					if(error) {
						NSLog(@"SyncManager.getUpdatedRemoteTasks.getTask error: %@", [error localizedDescription]);
					}
					taskCount++;
					if(taskCount == numberOfTasks) {
                        NSError *saveError;
						[StoreManager.sharedManager saveContext:&saveError];
						if(saveError) {
							NSLog(@"SyncManager.getUpdatedRemoteTasks.saveContext error: %@", [saveError localizedDescription]);
						}
						[self putUpdatedLocalTasks];
					}
				}];
			}
		} else {
			[self putUpdatedLocalTasks];
		}
	} else {
		NSLog(@"SyncManager.getUpdatedRemoteTasks.fetchUpdatedRemoteTasksFromUser error: %@", [error localizedDescription]);
		[self putUpdatedLocalTasks];
	}
}

- (void)putUpdatedLocalTasks {
	NSError *error;
	NSArray *tasks = [StoreManager.sharedManager fetchUpdatedLocalTasksForUser:_user error:&error];
	if(!error) {
		__block int numberOfTasks = (int)[tasks count];
		__block int taskCount = 0;
		if(numberOfTasks > 0) {
			for(Task *task in tasks) {
				[RestClientManager.sharedManager putTask:task block:^(NSInteger statusCode, NSError *error) {
					if(error) {
						NSLog(@"SyncManager.putUpdatedLocalTasks.putTask error: %@", [error localizedDescription]);
                    }
					taskCount++;
					if(taskCount == numberOfTasks) {
                        NSError *saveError;
						[StoreManager.sharedManager saveContext:&saveError];
						if(saveError) {
							NSLog(@"SyncManager.putUpdatedLocalTasks.saveContext error: %@", [saveError localizedDescription]);
						}
						[self deleteQueuedForDeleteLocalTasks];
					}
				}];
			}
		} else {
			[self deleteQueuedForDeleteLocalTasks];
		}
	} else {
		NSLog(@"SyncManager.putUpdatedLocalTasks.fetchUpdatedLocalTasksFromUser error: %@", [error localizedDescription]);
		[self deleteQueuedForDeleteLocalTasks];
	}
}

- (void)deleteQueuedForDeleteLocalTasks {
	NSError *error;
	NSArray *tasks = [StoreManager.sharedManager fetchQueuedForDeleteLocalTasksForUser:_user error:&error];
	if(!error) {
		__block int numberOfTasks = (int)[tasks count];
		__block int taskCount = 0;
		if(numberOfTasks > 0) {
			for(Task *task in tasks) {
				__block NSString* uuid = task.uuid;
				[RestClientManager.sharedManager deleteTask:task block:^(NSInteger statusCode, NSError *error) {
					if(error) {
						NSLog(@"SyncManager.deleteQueuedTasks.deleteTask error: %@", [error localizedDescription]);
					} else {
						//delete user remote task to prevent unwanted calls later in the sync process
						for(RemoteTask *remoteTask in _user.remoteTasks) {
							if([remoteTask.uuid isEqualToString:uuid]) {
								[StoreManager.sharedManager deleteRemoteTask:remoteTask];
								break;
							}
						}
					}
					taskCount++;
					if(taskCount == numberOfTasks) {
                        NSError *saveError;
						[StoreManager.sharedManager saveContext:&saveError];
						if(saveError) {
							NSLog(@"SyncManager.deleteQueuedTasks.saveContext error: %@", [saveError localizedDescription]);
						}
						[self getNewRemoteTasks];
					}
				}];
			}
		} else {
			[self getNewRemoteTasks];
		}
	} else {
		NSLog(@"SyncManager.deleteQueuedTasks.fetchQueuedForDeleteLocalTasksFromUser error: %@", [error localizedDescription]);
		[self getNewRemoteTasks];
	}
}

- (void)getNewRemoteTasks {
	NSError *error;
	NSArray *remoteTasks = [StoreManager.sharedManager fetchNewRemoteTasksForUser:_user error:&error];
	if(!error) {
		__block int numberOfTasks = (int)[remoteTasks count];
		__block int taskCount = 0;
		if(numberOfTasks > 0) {
			for(RemoteTask *remoteTask in remoteTasks) {
				[RestClientManager.sharedManager getNewTask:remoteTask.uuid block:^(Task *newTask, NSInteger statusCode, NSError *error) {
					if(error) {
						NSLog(@"SyncManager.getNewRemoteTasks.getNewTask error: %@", [error localizedDescription]);
					}
					taskCount++;
					if(taskCount == numberOfTasks) {
                        NSError *saveError;
						[StoreManager.sharedManager saveContext:&saveError];
						if(saveError) {
							NSLog(@"SyncManager.getNewRemoteTasks.saveContext error: %@", [saveError localizedDescription]);
						}
						[self endSyncTasks];
					}
				}];
			}
		} else {
			[self endSyncTasks];
		}
	} else {
		NSLog(@"SyncManager.getNewRemoteTasks.fetchNewRemoteTasksFromUser error: %@", [error localizedDescription]);
		[self endSyncTasks];
	}
}

- (void)endSyncTasks {
	if(_syncServices) {
		[self deleteLocalServicesWithoutRemoteEquivalent];
	} else {
		[self finalizeSync];
	}
}

- (void)deleteLocalServicesWithoutRemoteEquivalent {
    // This routine checks the difference between the services installed locally and the ones associated to the user
    // if a local service has no equivalent in the user services, it is unregistered so that next time,
    // it will not be associated to the user anymore
	NSError *error;
	NSArray *services = [StoreManager.sharedManager fetchLocalServicesWithoutRemoteEquivalentForUser:_user error:&error];
	if(!error) {
		int numberOfServices = (int) services.count;
		if(numberOfServices > 0) {
			for(Service *service in services) {
                [RestClientManager.sharedManager unregisterService:service block:^(NSInteger statusCode, NSError *error) {
                    if(statusCode == 404) {
                        NSLog(@"SyncManager.deleteLocalServicesWithoutRemoteEquivalent.serviceNotFound: %@\nLocal service has been deleted anyway", service.uuid);
                    }
                }];
			}
		}
	} else {
        NSLog(@"SyncManager.deleteLocalServicesWithoutRemoteEquivalent.fetchLocalServicesWithoutRemoteEquivalentFromUser error: %@", [error localizedDescription]);
	}
    //this routine checks if each remote service really exist on the server and, if not, delete both the remote service (in the user) and the service itself locally
    __block int numberOfServices = (int) [_user.remoteServices count];
    __block int serviceCount = 0;
    if(numberOfServices > 0) {
        for(RemoteService *remoteService in _user.remoteServices) {
            [RestClientManager.sharedManager getServiceLastUpdate:remoteService.uuid block:^(NSDate *lastUpdate, NSInteger statusCode, NSError *error) {
                if(statusCode == 404) {
                    NSLog(@"SyncManager.deleteLocalServicesWithoutRemoteEquivalent.serviceNotFound: %@\nDeleting local and remote services", remoteService.uuid);
                    NSArray *services = [StoreManager.sharedManager fetchActiveServices:nil];
                    for(Service *service in services) {
                        if([service.uuid isEqualToString:remoteService.uuid]) {
                            [ErrorHelper popToastWithMessage:[NSString stringWithFormat:NSLocalizedString(@"SYNC_SERVICE_DELETED", nil), service.title] style:ToastHelper.styleInfo];
                            [StoreManager.sharedManager deleteService:service];
                            break;
                        }
                    }
                    [StoreManager.sharedManager deleteRemoteService:remoteService];
                }
                serviceCount++;
                if(serviceCount == numberOfServices) {
                    NSError *saveError;
                    [StoreManager.sharedManager saveContext:&saveError];
                    if(saveError) {
                        NSLog(@"SyncManager.deleteLocalServicesWithoutRemoteEquivalent.saveContext error: %@", [saveError localizedDescription]);
                    }
                    [self deleteQueuedServices];
                }
            }];
        }
    } else {
        [self deleteQueuedServices];
    }
}

- (void)deleteQueuedServices {
	NSError *error;
	NSArray *localServices = [StoreManager.sharedManager fetchQueuedForDeleteLocalServicesForUser:_user error:&error];
	if(!error) {
		__block int numberOfServices = (int)[localServices count];
		__block int serviceCount = 0;
		if(numberOfServices > 0) {
			for(Service *service in localServices) {
				__block NSString *uuid = service.uuid;
				[RestClientManager.sharedManager unregisterService:service block:^(NSInteger statusCode, NSError *error) {
					if(error) {
						NSLog(@"SyncManager.deleteQueuedServices.unregisterService error: %@", [error localizedDescription]);
					} else {
						//delete user remote service to prevent unwanted calls later in the sync process
						for(RemoteService *remoteService in _user.remoteServices) {
							if([remoteService.uuid isEqualToString:uuid]) {
								[StoreManager.sharedManager deleteRemoteService:remoteService];
								break;
							}
						}
					}
					serviceCount++;
					if(serviceCount == numberOfServices) {
                        NSError *saveError;
						[StoreManager.sharedManager saveContext:&saveError];
						if(saveError) {
							NSLog(@"SyncManager.deleteQueuedServices.saveContext error: %@", [saveError localizedDescription]);
						}
						[self updateUserRemoteServicesWithLastUpdate];
					}
				}];
			}
		} else {
			[self updateUserRemoteServicesWithLastUpdate];
		}
	} else {
		NSLog(@"SyncManager.deleteQueuedServices.fetchQueuedForDeleteLocalServicesFromUser error: %@", [error localizedDescription]);
		[self updateUserRemoteServicesWithLastUpdate];
	}
}

- (void)updateUserRemoteServicesWithLastUpdate {
    __block int numberOfServices = (int) [_user.remoteServices count];
    __block int serviceCount = 0;
    if(numberOfServices > 0) {
        for(RemoteService *remoteService in _user.remoteServices) {
            [RestClientManager.sharedManager getServiceLastUpdate:remoteService.uuid block:^(NSDate *lastUpdate, NSInteger statusCode, NSError *error) {
                if(error) {
                    NSLog(@"SyncManager.updateUserRemoteServicesWithLastUpdate.getServiceLastUpdate error: %@", [error localizedDescription]);
                } else {
                    remoteService.lastUpdate = lastUpdate;
                }
                serviceCount++;
                if(serviceCount == numberOfServices) {
                    NSError *saveError;
                    [StoreManager.sharedManager saveContext:&saveError];
                    if(saveError) {
                        NSLog(@"SyncManager.updateUserRemoteServicesWithLastUpdate.saveContext error: %@", [saveError localizedDescription]);
                    }
                    [self getUpdatedRemoteServices];
                }
            }];
        }
    } else {
        [self getUpdatedRemoteServices];
    }
}

- (void)getUpdatedRemoteServices {
	NSError *error;
	NSArray *updatedServices = [StoreManager.sharedManager fetchUpdatedRemoteServicesForUser:_user error:&error];
	if(!error) {
		__block int numberOfServices = (int)[updatedServices count];
		__block int serviceCount = 0;
		if(numberOfServices > 0) {
			for(Service *service in updatedServices) {
				[RestClientManager.sharedManager getUpdatedService:service block:^(Service *service, NSInteger statusCode, NSError *error) {
					if(error) {
						NSLog(@"SyncManager.getUpdatedRemoteServices.getUpdatedService error: %@", [error localizedDescription]);
					}
					serviceCount++;
					if(serviceCount == numberOfServices) {
                        NSError *saveError;
						[StoreManager.sharedManager saveContext:&saveError];
						if(saveError) {
							NSLog(@"SyncManager.getUpdatedRemoteServices.saveContext error: %@", [saveError localizedDescription]);
						}
						[self getNewRemoteServices];
					}
				}];
			}
		} else {
			[self getNewRemoteServices];
		}
	} else {
		NSLog(@"SyncManager.getUpdatedRemoteServices.fetchQueuedForDeleteLocalServicesFromUser error: %@", [error localizedDescription]);
		[self getNewRemoteServices];
	}
}

- (void)getNewRemoteServices {
	NSError *error;
	NSArray *remoteServices = [StoreManager.sharedManager fetchNewRemoteServicesForUser:_user error:&error];
	if(!error) {
		__block int numberOfServices = (int)[remoteServices count];
		__block int serviceCount = 0;
		if(numberOfServices > 0) {
			for(RemoteService *remoteService in remoteServices) {
				[RestClientManager.sharedManager getNewService:remoteService.uuid block:^(Service *service, NSInteger statusCode, NSError *error) {
					if(error) {
						NSLog(@"SyncManager.getNewRemoteServices.getNewService error: %@", [error localizedDescription]);
					}
					serviceCount++;
					if(serviceCount == numberOfServices) {
                        NSError *saveError;
						[StoreManager.sharedManager saveContext:&saveError];
						if(saveError) {
							NSLog(@"SyncManager.getNewRemoteServices.saveContext error: %@", [saveError localizedDescription]);
						}
						[self endSynServices];
					}
				}];
			}
		} else {
			[self endSynServices];
		}
	} else {
		NSLog(@"SyncManager.getNewRemoteServices.fetchNewRemoteServicesFromUser error: %@", [error localizedDescription]);
		[self endSynServices];
	}
}

- (void)endSynServices {
	[self finalizeSync];
}

- (void)finalizeSync {
	if(_syncTasks) {
		[StoreManager.sharedManager syncSharedDirectory];
	}
	_syncInProgress = NO;
	_syncTaskRequest = NO;
	_syncServiceRequest = NO;
	_syncTasks = NO;
	_syncServices = NO;
    [UIApplication.sharedApplication endBackgroundTask:_backgroundTaskIdentifier];
    _backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    NSLog(@"SyncManager.backgroundTask.done");
}

- (void)endWithStatusCode:(NSInteger)statusCode error:(NSError *)error {
    [ErrorHelper popToastForStatusCode:statusCode error:error style:ToastHelper.styleWarning];
	[self finalizeSync];
}
@end
