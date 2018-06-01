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

#import "StoreManager.h"

#import "SettingsManager.h"
#import "SyncManager.h"

#import "DeviceHelper.h"
#import "ErrorHelper.h"

#import "User.h"
#import "Ident.h"
#import "Device.h"
#import "Service.h"
#import "Task.h"
#import "UIStyle.h"
#import "CaptureImage.h"
#import "AbstractSubTaskCapture.h"
#import "SubTaskForm.h"
#import "SubTaskPicture.h"
#import "SubTaskScan.h"
#import "Rendition.h"
#import "AbstractIndex.h"
#import "DefaultIndex.h"
#import "ListIndex.h"
#import "Item.h"
#import "CertificationError.h"
#import "DeleteImageReference.h"
#import "RemoteTask.h"
#import "RemoteService.h"
#import "Subscription.h"
#import "UnCheckedTransaction.h"

#define KstorePath @"com.shootprove"	//Private store path
#define KstoreName @"com.shootprove"	//SQLlite store file name
#define KmodelName @"shootprove"		//object model name

@interface StoreManager () {
	NSManagedObjectModel *_managedObjectModel;
	RKManagedObjectStore *_managedObjectStore;
}
@end

@implementation StoreManager

#pragma - public instance

+ (instancetype)sharedManager {
	static id manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[StoreManager alloc] init];
	});
	return manager;
}

#pragma - public getters

- (RKManagedObjectStore *)objectStore {
	return _managedObjectStore;
}

- (BOOL)storeHasChanges {
	return [_managedObjectStore.mainQueueManagedObjectContext hasChanges];
}

#pragma - store paths

- (NSString *)publicPath {
	static NSString *_publicPath = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		_publicPath = [paths objectAtIndex:0];
	});
	return _publicPath;
}

- (NSString *)privatePath {
	static NSString *_privatePath = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString *libraryDirectory = [paths objectAtIndex:0];
		_privatePath = [libraryDirectory stringByAppendingPathComponent:KstorePath];
		if(![[NSFileManager defaultManager] fileExistsAtPath:_privatePath])
			[[NSFileManager defaultManager] createDirectoryAtPath:_privatePath withIntermediateDirectories:YES attributes:nil error:nil];
	});
	return _privatePath;
}

- (NSString *)storePath {
	static NSString *_storePath = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_storePath = [[self privatePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", KstoreName]];
	});
	return _storePath;
}

#pragma - initialization

- (id)init {
	
	self = [super init];
	
	if(self) {
		
		_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:KmodelName ofType:@"momd"]]];
		
		NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
		
		NSError *error = nil;
		NSURL *storeURL = [NSURL fileURLWithPath:[self storePath]];
		NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
								 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
		
		if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
			[NSException raise:@"Persistent store error" format:@"Reason : %@", [error localizedDescription]];
		}
		
		_managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:psc];
		[_managedObjectStore createManagedObjectContexts];
		_managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:_managedObjectStore.persistentStoreManagedObjectContext];
        
        [_managedObjectStore.mainQueueManagedObjectContext setStalenessInterval:0];
        
	}
	
	return self;
	
}

#pragma - public save
- (void)saveContext:(NSError **)error {
	if([_managedObjectStore.mainQueueManagedObjectContext hasChanges]) {
		[_managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:error];
    }
}

#pragma - user management
- (User *)fetchUser {
	
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([User class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSError *error = nil;
	NSArray *result = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:&error];
	
    return result.count > 0 ? (User *)[result firstObject]:nil;
    
}

- (void)deleteUser:(User *)user {
	
    NSArray *tasks = [self fetchAllTasks:nil];
    
	for(Task *task in tasks) {
		[self deleteTask:task];
	}
	
	[[_managedObjectStore mainQueueManagedObjectContext] deleteObject:user];
	
}

- (void)applyTaskCost:(Task *)task {
    
    User *user = [self fetchUser];
    
    if([task.postPaid isEqualToNumber:[NSNumber numberWithBool:NO]] && !user.activeSubscription.postPaid) {
        
        int taskCost = [task.cost intValue];
        int userCredit = [user.credits intValue];
        int newCredit = userCredit - taskCost;
        user.credits = [NSNumber numberWithInt:newCredit];
        
        NSLog(@"StoreManager.applyTaskCost: %d - %d => %d", userCredit, taskCost, newCredit);
        
    } else {
        
        NSLog(@"StoreManager.applyTaskCost: not applied");
        
    }
    
}

#pragma - ident management methods
- (NSFetchedResultsController *)fetchedIdentsController {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *e = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Ident class])];
	[request setEntity:e];
	
    NSPredicate *p = [NSPredicate predicateWithFormat:@"type != %@", @"api"];
    [request setPredicate:p];
    
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
	[request setSortDescriptors:@[sort]];
	
	NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_managedObjectStore.mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
	
	return resultController;
	
}

- (void)deleteIdent:(Ident *)ident {
	
	[[_managedObjectStore mainQueueManagedObjectContext] deleteObject:ident];
	
}

#pragma - device management

- (NSArray *)fetchDevices {
	
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Device class])];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	NSError *error = nil;
	NSArray *result = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:&error];
	
	if(error) {
		
		NSLog(@"FetchDevices error: %@", [error localizedDescription]);
		return nil;
		
	} else {
		
		return result;

	}
	
}

- (NSFetchedResultsController *)fetchedDevicesController {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *e = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Device class])];
	[request setEntity:e];
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[request setSortDescriptors:@[sort]];
	
	NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_managedObjectStore.mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
	
	return resultController;
	
}

- (Device *)createDeviceForUser:(User *)user withProperties:(DeviceProperties *)properties {
	
	Device *device = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Device class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	device.buildNumber = properties.buildNumber;
	device.type = properties.type;
	device.name = properties.name;
	device.token = properties.token;
	device.uid = properties.uid;
	device.nsToken = nil;
	
	[user addDevicesObject:device];
	return device;
}

- (void)deleteDevice:(Device *)device {
	[[_managedObjectStore mainQueueManagedObjectContext] deleteObject:device];
}

#pragma - user remote tasks management method
- (void)deleteRemoteTask:(RemoteTask *)remoteTask {
	[[_managedObjectStore mainQueueManagedObjectContext] deleteObject:remoteTask];
}

#pragma - user remote services management method
- (void)deleteRemoteService:(RemoteService *)remoteService {
	[[_managedObjectStore mainQueueManagedObjectContext] deleteObject:remoteService];
}

#pragma - template management methods
- (NSFetchedResultsController *)fetchedActiveServicesController {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *e = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Service class])];
	[request setEntity:e];
	
	NSPredicate *p = [NSPredicate predicateWithFormat:@"status == %d", SPStatusActive];
	[request setPredicate:p];
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"provider" ascending:YES];
	[request setSortDescriptors:@[sort]];
	
	NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_managedObjectStore.mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
	
	return resultController;
	
}

- (NSArray *)fetchActiveServices:(NSError **)error {
    
    //fetch local tasks with an uuid
    NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Service class])];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"status == %d", SPStatusActive];
    [request setPredicate:p];
    
    return [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
    
}

- (NSArray *)fetchLocalServicesWithoutRemoteEquivalentForUser:(User *)user error:(NSError **)error {
	
	//prepare output array
	NSMutableArray *localServicesToDelete = [[NSMutableArray alloc] init];
	
	//fetch local tasks with an uuid
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Service class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSArray *localServices = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
	if(!*error) {
		
		//get remote tasks uuids from user
		NSArray *remoteServices = [user.remoteServices allObjects];
		
		//for local task, check if remote task exists (same uuid)
		for(Service *service in localServices) {
			
			BOOL exists = NO;
			
			for(RemoteService *remoteService in remoteServices) {
				
				//check if uuids match
				if([remoteService.uuid isEqualToString:service.uuid]) {
					exists = YES;
					break;
					
				}
				
			}
			
			//if local task does not exist, add remoteTask to newRemoteTasks
			if(!exists) {
				[localServicesToDelete addObject:service];
			}
			
		}
		
	}
	
	return localServicesToDelete;
	
}

- (NSArray *)fetchNewRemoteServicesForUser:(User *)user error:(NSError **)error {
	
	NSMutableArray *newRemoteServices = [[NSMutableArray alloc] init];
	
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Service class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSArray *localServices = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
	if(!*error) {
		
		NSArray *remoteServices = [user.remoteServices allObjects];
		
		for(RemoteService *remoteService in remoteServices) {
			
			BOOL exists = NO;
			
			for(Service *service in localServices) {
				
				if([service.uuid isEqualToString:remoteService.uuid]) {
                    service.status = [NSNumber numberWithInt:SPStatusActive];
					exists = YES;
					break;
				}
				
			}
			
			if(!exists) {
				[newRemoteServices addObject:remoteService];
			}
			
			
		}
		
	}
	
	return newRemoteServices;
	
}

- (NSArray *)fetchQueuedForDeleteLocalServicesForUser:(User *)user error:(NSError **)error {
	
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Service class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *p = [NSPredicate predicateWithFormat:@"status == %d", SPStatusQueuedForDelete];
	[request setPredicate:p];
	
	//NSLog(@"StoreManager.fetchQueuedForDeleteLocalServicesFromUser.predicate: %@", [p description]);
	
	NSArray *localServices = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
    return localServices;
	
}

- (NSArray *)fetchUpdatedRemoteServicesForUser:(User *)user error:(NSError **)error {
	
	NSMutableArray *updatedRemoteServices = [[NSMutableArray alloc] init];
	
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Service class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *p = [NSPredicate predicateWithFormat:@"status == %d", SPStatusActive];
	[request setPredicate:p];
	
	//NSLog(@"StoreManager.fetchUpdatedRemoteServicesFromUser.predicate: %@", [p description]);
	
	NSArray *localServices = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
	if(!*error) {
		
		//get remote services uuids from user
		NSArray *remoteServices = [user.remoteServices allObjects];
		
		//for each remote service, check if local service exists (same uuid)
		for(RemoteService *remoteService in remoteServices) {
		
			for(Service *service in localServices) {
			
				//check if uuids match
				if([service.uuid isEqualToString:remoteService.uuid]) {
					
					if(remoteService.lastUpdate) {
					
						//check if local service last update is more recent than remote service
						NSCalendar *calendar = [NSCalendar currentCalendar];
						NSDateComponents *comps = [calendar components:NSCalendarUnitSecond fromDate:service.lastUpdate toDate:remoteService.lastUpdate options:0];
						
                        //NSLog(@"service %@:\nremote service last update: %@\nlocal service last update: %@", remoteService.uuid, remoteService.lastUpdate, service.lastUpdate);
                        
						if(comps.second > 0) {
							[updatedRemoteServices addObject:service];
						}
						
					} else {
						
						[updatedRemoteServices addObject:service];
						
					}
					
					break;
					
				}
				
			}
			
		}
		
	}
	
	return updatedRemoteServices;
	
	return nil;
}

- (Service *)fetchServiceWithId:(NSString *)uuid error:(NSError **)error {
	
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Service class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *p = [NSPredicate predicateWithFormat:@"uuid == %@", uuid];
	[request setPredicate:p];
	
	NSArray *result = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
	if(error) {
		return nil;
	} else {
		if([result count]>0) {
			return (Service *)[result firstObject];
		} else {
			return nil;
		}
	}
	
}

- (Service *)createService:(NSString *)uuid title:(NSString *)title description:(NSString *)description iconUrl:(NSString *)url iconMime:(NSString *)mime error:(NSError **)error {
	
	Service *service = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Service class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	service.uuid = uuid;
	service.title = title;
	service.desc = description;
	service.icon_url = url;
    service.icon_mime = mime;
	service.icon_data = nil;
	service.status = [NSNumber numberWithInt:SPStatusNone];
	service.permanent = @1;
	service.provider = @"S&P";
	service.lastUpdate = [NSDate date];
    service.uiStyle = [self createNewStyle];
	
	return service;
	
}

- (void)deleteService:(Service *)service {
	[[_managedObjectStore mainQueueManagedObjectContext] deleteObject:service];
}

#pragma - task management methods
- (NSFetchedResultsController *)fetchedPendingTasksController {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *e = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	[request setEntity:e];
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
	[request setSortDescriptors:@[sort]];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:[NSPredicate predicateWithFormat:@"status == %d", SPStatusInProgress]];
	[predicates addObject:[NSPredicate predicateWithFormat:@"serviceId != nil"]];
	
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	[request setPredicate:p];
	
	NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_managedObjectStore.mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
	
	return resultController;
	
}

- (NSFetchedResultsController *)fetchedHistoryTasksController {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *e = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	[request setEntity:e];
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:NO];
	[request setSortDescriptors:@[sort]];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:[NSPredicate predicateWithFormat:@"status == %d", SPStatusCompleted]];
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	
	[request setPredicate:p];
	
	NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_managedObjectStore.mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
	
	return resultController;
	
}

- (NSFetchedResultsController *)fetchedTrashedTasksController {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *e = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	[request setEntity:e];
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
	[request setSortDescriptors:@[sort]];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:[NSPredicate predicateWithFormat:@"status == %d", SPStatusTrash]];
	
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	
	[request setPredicate:p];
	
	NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_managedObjectStore.mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
	
	return resultController;
	
}

- (NSArray *)fetchAllTasks:(NSError **)error {
	
	//fetch local tasks and free tasks
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	return [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
}

- (NSArray *)fetchLocalTasksWithoutRemoteEquivalentForUser:(User *)user error:(NSError **)error {
	
	//prepare output array
	NSMutableArray *localTasksToDelete = [[NSMutableArray alloc] init];
	
	//fetch local tasks with an uuid
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSMutableArray *statusPredicates = [[NSMutableArray alloc] init];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusCompleted]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusInProgress]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusTrash]]];
	NSPredicate *statusPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:statusPredicates];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:statusPredicate];
	if(!user.activeSubscription) {
		[predicates addObject:[NSPredicate predicateWithFormat:@"serviceId != nil"]];
	}
	[predicates addObject:[NSPredicate predicateWithFormat:@"uuid != nil"]];
	
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	[request setPredicate:p];
	
	//NSLog(@"StoreManager.fetchLocalTasksWithoutRemoteEquivalentFromUser.predicate: %@", [p description]);
	
	NSArray *localTasks = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
    //NSLog(@"StoreManager.fetchLocalTasksWithoutRemoteEquivalentFromUser.localTasks.count: %ld", localTasks.count);
    
	if(!*error) {
		
		//get remote tasks uuids from user
		NSArray *remoteTasks = [user.remoteTasks allObjects];
		
		//for local task, check if remote task exists (same uuid)
		for(Task *task in localTasks) {
			
			BOOL exists = NO;
			
			for(RemoteTask *remoteTask in remoteTasks) {
				
				//check if uuids match
				if([remoteTask.uuid isEqualToString:task.uuid]) {
					exists = YES;
					break;
					
				}
				
			}
			
			//if local task does not exist, add remoteTask to newRemoteTasks
			if(!exists) {
				[localTasksToDelete addObject:task];
			}
			
		}
		
	}
	if(localTasksToDelete.count>0)
        NSLog(@"StoreManager.fetchLocalTasksWithoutRemoteEquivalentFromUser.localTasksToDelete.count: %ld", (unsigned long)localTasksToDelete.count);
    
	return localTasksToDelete;
	
}

- (NSArray *)fetchNewLocalTasksForUser:(User *)user error:(NSError **)error {
	
	//fetch local tasks without an uuid
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSMutableArray *statusPredicates = [[NSMutableArray alloc] init];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusCompleted]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusInProgress]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusTrash]]];
	NSPredicate *statusPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:statusPredicates];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:statusPredicate];
	if(!user.activeSubscription) {
		[predicates addObject:[NSPredicate predicateWithFormat:@"serviceId != nil"]];
	}
	[predicates addObject:[NSPredicate predicateWithFormat:@"uuid == nil"]];
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	
	[request setPredicate:p];
	
	NSArray *localTasks = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
    
    if(localTasks.count>0)
        NSLog(@"StoreManager.fetchNewLocalTasksFromUser.newLocalTasks.count: %ld", (unsigned long)localTasks.count);
    
    return localTasks;
	
}

- (NSArray *)fetchQueuedForDeleteLocalTasksForUser:(User *)user error:(NSError **)error {
	
	//prepare output array
	NSMutableArray *queuedForDeleteLocalTasks = [[NSMutableArray alloc] init];
	
	//fetch local tasks with an uuid
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusQueuedForDelete]]];
	
	[predicates addObject:[NSPredicate predicateWithFormat:@"uuid != nil"]];
	
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	[request setPredicate:p];
	
	//NSLog(@"StoreManager.fetchQueuedForDeleteLocalTasksFromUser.predicate: %@", [p description]);
	
	NSArray *localTasks = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
    //NSLog(@"StoreManager.fetchQueuedForDeleteLocalTasksFromUser.localTasks.count: %ld", localTasks.count);
    
	if(!*error) {
		
		//get remote tasks uuids from user
		NSArray *remoteTasks = [user.remoteTasks allObjects];
		
		//for each local task, check if remote task exists (same uuid)
		for(Task *task in localTasks) {
			
			for(RemoteTask *remoteTask in remoteTasks) {
				
				//check if uuids match
				if([remoteTask.uuid isEqualToString:task.uuid]) {
					
					//check if local task last update is more recent than remote task
					NSCalendar *calendar = [NSCalendar currentCalendar];
					NSDateComponents *comps = [calendar components:NSCalendarUnitSecond fromDate:remoteTask.lastUpdate toDate:task.lastUpdate options:0];
					
					if(comps.second > 0) {
						[queuedForDeleteLocalTasks addObject:task];
					}
					
					break;
					
				}
				
			}
			
		}
		
	}
	
    if(queuedForDeleteLocalTasks.count>0)
        NSLog(@"StoreManager.fetchQueuedForDeleteLocalTasksFromUser.queuedForDeleteLocalTasks.count: %ld", (unsigned long)queuedForDeleteLocalTasks.count);
    
	return queuedForDeleteLocalTasks;
	
}

- (NSArray *)fetchUpdatedLocalTasksForUser:(User *)user error:(NSError **)error {
	
	//prepare output array
	NSMutableArray *updatedLocalTasks = [[NSMutableArray alloc] init];
	
	//fetch local tasks with an uuid
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSMutableArray *statusPredicates = [[NSMutableArray alloc] init];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusCompleted]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusInProgress]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusTrash]]];
	NSPredicate *statusPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:statusPredicates];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:statusPredicate];
	[predicates addObject:[NSPredicate predicateWithFormat:@"uuid != nil"]];
	
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	[request setPredicate:p];
	
	//NSLog(@"StoreManager.fetchUpdatedLocalTasksFromUser.predicate: %@", [p description]);
	
	NSArray *localTasks = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
    //NSLog(@"StoreManager.fetchUpdatedLocalTasksFromUser.localTasks.count: %ld", localTasks.count);
    
	if(!*error) {
		
		//get remote tasks uuids from user
		NSArray *remoteTasks = [user.remoteTasks allObjects];
		
		//for each local task, check if remote task exists (same uuid)
		for(Task *task in localTasks) {
            
            for(RemoteTask *remoteTask in remoteTasks) {
                    
                //check if uuids match
                if([remoteTask.uuid isEqualToString:task.uuid]) {
                    
                    //check if local task last update is more recent than remote task
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDateComponents *comps = [calendar components:NSCalendarUnitSecond fromDate:remoteTask.lastUpdate toDate:task.lastUpdate options:0];
                    
                    //NSLog(@"task %@:\nremote task last update: %@\nlocal task last update: %@", task.uuid, remoteTask.lastUpdate, task.lastUpdate);
                    
                    if(comps.second > 0) {
                        [updatedLocalTasks addObject:task];
                    }
                    
                    break;
                    
                }
                
            }
            
		}
		
	}
	
    if(updatedLocalTasks.count>0)
        NSLog(@"StoreManager.fetchUpdatedLocalTasksFromUser.updatedLocalTasks.count: %ld", (unsigned long)updatedLocalTasks.count);
    
	return updatedLocalTasks;
	
}

- (NSArray *)fetchNewRemoteTasksForUser:(User *)user error:(NSError **)error {
	
	//prepare output array
	NSMutableArray *newRemoteTasks = [[NSMutableArray alloc] init];
	
	//fetch local tasks with an uuid
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSMutableArray *statusPredicates = [[NSMutableArray alloc] init];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusCompleted]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusInProgress]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusTrash]]];
	NSPredicate *statusPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:statusPredicates];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:statusPredicate];
	
	[predicates addObject:[NSPredicate predicateWithFormat:@"uuid != nil"]];
	
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	[request setPredicate:p];
	
	//NSLog(@"StoreManager.fetchNewRemoteTasksFromUser.predicate: %@", [p description]);
	
	NSArray *localTasks = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
    //NSLog(@"StoreManager.fetchNewRemoteTasksFromUser.localTasks.count: %ld", localTasks.count);
    
	if(!*error) {
		
		//get remote tasks uuids from user
		NSArray *remoteTasks = [user.remoteTasks allObjects];
		
        //NSLog(@"StoreManager.fetchNewRemoteTasksFromUser.remoteTasks.count: %ld", remoteTasks.count);
        
		//for each remote task, check if local task exists (same uuid)
		for(RemoteTask *remoteTask in remoteTasks) {
			
			BOOL exists = NO;
			
			for(Task *task in localTasks) {
				
				//check if uuids match
				if([task.uuid isEqualToString:remoteTask.uuid]) {
                    //NSLog(@"StoreManager.fetchNewRemoteTasksFromUser.remoteTasks.existsLocally: %@", remoteTask.uuid);
					exists = YES;
					break;
					
				}
				
			}
			
			//if local task does not exist, add remoteTask to newRemoteTasks
			if(!exists) {
                //NSLog(@"remote task %@ does not exist locally. added to newRemoteTasks for download.", remoteTask.uuid);
				[newRemoteTasks addObject:remoteTask];
			}
			
		}
		
	}
	
    if(newRemoteTasks.count>0)
        NSLog(@"StoreManager.fetchNewRemoteTasksFromUser.newRemoteTasks.count: %ld", (unsigned long)newRemoteTasks.count);
    
	return newRemoteTasks;
	
}

- (NSArray *)fetchUpdatedRemoteTasksForUser:(User *)user error:(NSError **)error {
	
	//prepare output array
	NSMutableArray *updatedRemoteTasks = [[NSMutableArray alloc] init];
	
	//fetch local tasks with an uuid
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSMutableArray *statusPredicates = [[NSMutableArray alloc] init];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusCompleted]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusInProgress]]];
	[statusPredicates addObject:[NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:SPStatusTrash]]];
	NSPredicate *statusPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:statusPredicates];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:statusPredicate];
	
	[predicates addObject:[NSPredicate predicateWithFormat:@"uuid != nil"]];
	
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	[request setPredicate:p];
	
	//NSLog(@"StoreManager.fetchUpdatedRemoteTasksFromUser.predicate: %@", [p description]);
	
	NSArray *localTasks = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
	
    //NSLog(@"StoreManager.fetchUpdatedRemoteTasksFromUser.localTasks.count: %ld", localTasks.count);
    
	if(!*error) {
		
		//get remote tasks uuids from user
		NSArray *remoteTasks = [user.remoteTasks allObjects];
		
		//for each remote task, check if local task exists (same uuid)
		for(RemoteTask *remoteTask in remoteTasks) {
			
			for(Task *task in localTasks) {
				
				//check if uuids match
				if([task.uuid isEqualToString:remoteTask.uuid]) {
					
					//check if remote task last update is more recent than local task
					NSCalendar *calendar = [NSCalendar currentCalendar];
					NSDateComponents *comps = [calendar components:NSCalendarUnitSecond fromDate:task.lastUpdate toDate:remoteTask.lastUpdate options:0];
					
					if(comps.second > 0) {
						[updatedRemoteTasks addObject:task];
					}
					
					break;
					
				}
				
			}
			
		}
		
	}
	
    if(updatedRemoteTasks.count>0)
        NSLog(@"StoreManager.fetchUpdatedRemoteTasksFromUser.updatedRemoteTasks.count: %ld", (unsigned long)updatedRemoteTasks.count);
    
	return updatedRemoteTasks;
	
}

- (NSArray *)fetchInactiveTasks:(NSError **)error {
	
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([Task class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSPredicate *p = [NSPredicate predicateWithFormat:@"status == %d", SPStatusNone];
	[request setPredicate:p];
	
	NSArray *inactiveTasks = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:error];
    
    if(inactiveTasks.count>0)
        NSLog(@"StoreManager.fetchInactiveTasks.inactiveTasks.count: %ld", (unsigned long)inactiveTasks.count);
    
    return inactiveTasks;
	
}

- (Task *)createFreeTask:(NSError **)error {
	
	Task *task = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Task class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	task.desc = NSLocalizedString(@"FREE_TASK_DESCRIPTION", nil);
	task.icon_url = nil;
    task.icon_mime = nil;
	task.icon_data = nil;
	task.permanent = @0;
	task.provider = NSLocalizedString(@"APPLICATION_TITLE", nil);
	task.title = NSLocalizedString(@"FREE_TASK_EMPTY_TITLE", nil);
	task.postPaid = @0;
	task.cost = @0;
	task.uuid = nil;
	
	task.startDate = [NSDate date];
	task.endDate = nil;
	task.lastUpdate = [NSDate date];
	task.status = [NSNumber numberWithInt:SPStatusNone];
    task.finished = @0;
    task.noCredit = @0;
	
	task.serviceId = nil;
    task.serviceIconData = nil;
	task.sourceDevice = [[DeviceHelper getCurrentDevice] uid];
    task.uiStyle = [self createNewStyle];
    
	[self saveContext:error];
	
	return task;
	
}

- (Task *)createTaskWithService:(Service *)service error:(NSError **)error {
	
	Task *task;
	*error = nil;
	
	@try {
		
		task = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Task class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
		
		task.desc = service.desc;
		task.icon_url = service.icon_url;
        task.icon_mime = service.icon_mime;
		task.icon_data = service.icon_data;
		task.permanent = @0;
		task.provider = service.provider;
		task.title = service.title;
		task.uuid = nil;
		task.status = [NSNumber numberWithInt:SPStatusNone];
        task.finished = @0;
        task.noCredit = @0;
		task.startDate = nil;
		task.endDate = nil;
		task.lastUpdate = [NSDate date];
		task.cost = service.cost;
		task.postPaid = service.postPaid;
        task.uiStyle = [self copyStyle:service.uiStyle];
		task.serviceId = service.uuid;
        task.serviceIconData = service.icon_data;
		task.sourceDevice = [[DeviceHelper getCurrentDevice] uid];
		
		for(AbstractSubTask *abstractSubTask in service.subTasks) {
			
			if([abstractSubTask isKindOfClass:[SubTaskForm class]]) {
				
				SubTaskForm *subTaskForm = [self createSubTaskFormForAbstractService:task title:abstractSubTask.title description:abstractSubTask.desc];
				subTaskForm.indexes = [self indexesFromSubTaskForm:(SubTaskForm *)abstractSubTask];
				
			} else if([abstractSubTask isKindOfClass:[SubTaskPicture class]]) {
				
				SubTaskPicture *subTaskPicture = [self createSubTaskPictureForAbstractService:task uuid:nil title:abstractSubTask.title description:abstractSubTask.desc];
				subTaskPicture.imageSize = [abstractSubTask valueForKey:@"imageSize"];
				subTaskPicture.minItems = [abstractSubTask valueForKey:@"minItems"];
				subTaskPicture.maxItems = [abstractSubTask valueForKey:@"maxItems"];
				
			} else if([abstractSubTask isKindOfClass:[SubTaskScan class]]) {
				
				SubTaskScan *subTaskScan = [self createSubTaskScanForAbstractService:task uuid:nil title:abstractSubTask.title description:abstractSubTask.desc];
				subTaskScan.dpi = [abstractSubTask valueForKey:@"dpi"];
				subTaskScan.format = [abstractSubTask valueForKey:@"format"];
				subTaskScan.mode = [abstractSubTask valueForKey:@"mode"];
				subTaskScan.minItems = [abstractSubTask valueForKey:@"minItems"];
				subTaskScan.maxItems = [abstractSubTask valueForKey:@"maxItems"];
				
			}
			
		}
		
        [self saveContext:error];
        
	} @catch (NSException *exception) {
		*error = [ErrorHelper errorFromException:exception module:@"createTaskWithService" action:@"creating task"];
	} @finally {
		if(*error) {
			if(task)
				[self deleteTask:task];
			return nil;
		} else {
			return task;
		}
	}
	
}

- (NSError *)deleteTask:(Task *)task {
	
	if(!task)
		return nil;
	NSError *error;
	for(AbstractSubTask *subTask in task.subTasks) {
		[self deleteSubTask:subTask];
	}
	for(Rendition *rendition in task.renditions) {
		error = [self deleteRendition:rendition];
		if(error)
			return error;
	}
	[_managedObjectStore.mainQueueManagedObjectContext deleteObject:task];
	return error;
	
}

#pragma - style management method
- (UIStyle *)createNewStyle {
    
    UIStyle *style = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([UIStyle class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
    
    /* S&P default style */
    style.toolbarColor = colorWhite;
    style.toolbarBackgroundColor = colorGreen;
    style.headerColor = colorDarkGrey;
    style.headerBackgroundColor = colorLightGrey;
    style.thumbnailColor = colorWhite;
    style.thumbnailBackgroundColor = colorLightGrey;
    style.promptColor = colorDarkGrey;
    style.viewBackgroundColor = colorWhite;
    
    /* OtherExample */
    /*********************************************
    style.toolbarColor = @"FCD879";
    style.toolbarBackgroundColor = @"4E2709";
    style.headerColor = @"4E2709";
    style.headerBackgroundColor = @"FCD879";
    style.thumbnailColor = @"FCD879";
    style.thumbnailBackgroundColor = @"4E2709";
    style.promptColor = @"4E2709";
    style.viewBackgroundColor = colorLightGrey;
    *********************************************/
    return style;
}

- (UIStyle *)copyStyle:(UIStyle *)style {
    
    UIStyle *newStyle = [self createNewStyle];
    
    if(style) {
        
        if(style.toolbarBackgroundColor)
            newStyle.toolbarBackgroundColor = style.toolbarBackgroundColor;
        if(style.toolbarColor)
            newStyle.toolbarColor = style.toolbarColor;
        if(style.headerBackgroundColor)
            newStyle.headerBackgroundColor = style.headerBackgroundColor;
        if(style.headerColor)
            newStyle.headerColor = style.headerColor;
        if(style.thumbnailBackgroundColor)
            newStyle.thumbnailBackgroundColor = style.thumbnailBackgroundColor;
        if(style.thumbnailColor)
            newStyle.thumbnailColor = style.thumbnailColor;
        if(style.viewBackgroundColor)
            newStyle.viewBackgroundColor = style.viewBackgroundColor;
        if(style.promptColor)
            newStyle.promptColor = style.promptColor;
        
    }
    
    return newStyle;
    
}

#pragma - sub tasks management method
- (SubTaskForm *)createSubTaskFormForAbstractService:(AbstractService *)abstractService title:(NSString *)title description:(NSString *)description {
	
	SubTaskForm *subTask = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SubTaskForm class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	subTask.title = title;
	subTask.desc = description;
	subTask.type = [EnumHelper descriptionFromSubTaskType:SPSubTaskTypeForm];
	subTask.startDate = nil;
	subTask.endDate = nil;
	
	NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithOrderedSet:abstractService.subTasks];
	[set addObject:subTask];
	abstractService.subTasks = set;

	return subTask;
	
}

- (SubTaskPicture *)createSubTaskPictureForAbstractService:(AbstractService *)abstractService uuid:(NSString *)uuid title:(NSString *)title description:(NSString *)description {
	
	SubTaskPicture *subTask = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SubTaskPicture class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	subTask.title = title;
	subTask.desc = description;
	subTask.type = [EnumHelper descriptionFromSubTaskType:SPSubTaskTypePicture];
	subTask.startDate = nil;
	subTask.endDate = nil;
	subTask.uuid = uuid ? uuid : [[NSUUID UUID] UUIDString];
	
	subTask.minItems = @1;
	subTask.maxItems = @1;
	
	NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithOrderedSet:abstractService.subTasks];
	[set addObject:subTask];
	abstractService.subTasks = set;

	return subTask;
	
}

- (SubTaskScan *)createSubTaskScanForAbstractService:(AbstractService *)abstractService uuid:(NSString *)uuid title:(NSString *)title description:(NSString *)description {
	
	SubTaskScan *subTask = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SubTaskScan class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	subTask.title = title;
	subTask.desc = description;
	subTask.type = [EnumHelper descriptionFromSubTaskType:SPSubTaskTypeScan];
	subTask.startDate = nil;
	subTask.endDate = nil;
	subTask.uuid = uuid ? uuid : [[NSUUID UUID] UUIDString];
	
	subTask.minItems = @1;
	subTask.maxItems = @1;
	
	NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithOrderedSet:abstractService.subTasks];
	[set addObject:subTask];
	abstractService.subTasks = set;
	
	return subTask;
	
}

- (void)deleteSubTask:(AbstractSubTask *)subTask {
	
	if([subTask isKindOfClass:[AbstractSubTaskCapture class]]) {
		
		AbstractService *abstractTask = subTask.abstractService;
		
		if([abstractTask isKindOfClass:[Task class]]) {
			
			Task *task = (Task *)abstractTask;
			AbstractSubTaskCapture *captureTask = (AbstractSubTaskCapture *)subTask;
			
			for(CaptureImage *image in task.images) {
				
				if([image.uuid isEqualToString:captureTask.uuid]) {
					[self deleteImage:image];
				}
			}
			
		}
		
	}
	
	[[_managedObjectStore mainQueueManagedObjectContext] deleteObject:subTask];
	
}

#pragma - index management

- (Item *)createItemWithKey:(NSInteger)key value:(NSString *)value {
	
	Item *item = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Item class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	item.key = [NSNumber numberWithInteger:key];
	item.value = value;
	
	return item;
	
}

- (DefaultIndex *)createIndexWithKey:(NSString *)key value:(NSString *)value description:(NSString *)description mandatory:(BOOL)mandatory type:(NSString *)type {
	
	DefaultIndex *index = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DefaultIndex class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	index.key = key;
	index.value = value;
	index.desc = description;
	index.mandatory = [NSNumber numberWithBool:mandatory];
	index.type = type;
	
	return index;
	
}

- (ListIndex *)createIndexWithKey:(NSString *)key value:(NSString *)value description:(NSString *)description mandatory:(BOOL)mandatory list:(NSArray *)list {
	
	ListIndex *index = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ListIndex class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	index.key = key;
	index.value = value;
	index.desc = description;
	index.mandatory = [NSNumber numberWithBool:mandatory];
	index.type = [EnumHelper descriptionFromIndexType:SPIndexTypeList];
	index.list = [NSMutableOrderedSet orderedSetWithArray:list];
	
	return index;
	
}

- (NSOrderedSet *)indexesFromSubTaskForm:(SubTaskForm *)subTaskForm {
	
	NSMutableOrderedSet *indexes = [[NSMutableOrderedSet alloc] init];
	
	for(AbstractIndex *abstractIndex in subTaskForm.indexes) {
		
		if([abstractIndex isKindOfClass:[DefaultIndex class]]) {
			
			DefaultIndex *defaultIndex = [self createIndexWithKey:abstractIndex.key value:abstractIndex.value description:abstractIndex.desc mandatory:[abstractIndex.mandatory boolValue] type:abstractIndex.type];
			
			[indexes addObject:defaultIndex];
			
		} else if([abstractIndex isKindOfClass:[ListIndex class]]) {
			
			NSMutableArray *list = [[NSMutableArray alloc] init];
			ListIndex *abstractListIndex = (ListIndex *)abstractIndex;
			
			for(Item *item in abstractListIndex.list) {
				
				Item *listItem = [self createItemWithKey:[item.key integerValue] value:item.value];
				[list addObject:listItem];
				
			}
			
			ListIndex *listIndex = [self createIndexWithKey:abstractIndex.key value:abstractIndex.value description:abstractIndex.desc mandatory:[abstractIndex.mandatory boolValue] list:list];
			
			[indexes addObject:listIndex];
			
		}
		
	}
	
	return indexes;
	
}

- (void)deleteDocumentIndex:(AbstractIndex *)index {
	[_managedObjectStore.mainQueueManagedObjectContext deleteObject:index];
}

#pragma - image management
- (void)fetchImage:(NSString *)uuid order:(NSInteger)order withBlock:(void(^)(CaptureImage *image, NSError *error)) block {
	
	NSEntityDescription *entity = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([CaptureImage class])];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:[NSPredicate predicateWithFormat:@"uuid == %@", uuid]];
	[predicates addObject:[NSPredicate predicateWithFormat:@"order == %d", order]];
	NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	[request setPredicate:p];
	
	NSError *error = nil;
	NSArray *result = [_managedObjectStore.mainQueueManagedObjectContext executeFetchRequest:request error:&error];
	
	if([result count] > 0) {
		block((CaptureImage *) [result firstObject], error);
	} else {
		block(nil, error);
	}
	
}

- (CaptureImage *)createImageForTask:(Task *)task uuid:(NSString *)uuid order:(NSInteger)order mime:(NSString *)mime {
	
	CaptureImage *image = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CaptureImage class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	image.accuracy = @0;
	image.certified = @0;
	image.creationDate = [NSDate date];
	image.errorLevel = @0;
	image.latitude = @0;
	image.longitude = @0;
	image.mimetype = mime;
	image.sha1 = nil;
	image.md5 = nil;
	image.timestamp = nil;
	image.uuid = uuid;
	image.order = [NSNumber numberWithInteger:order];
	
	NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithOrderedSet:task.images];
	[set addObject:image];
	task.images = set;

	return image;
	
}

- (void)deleteImageReference:(DeleteImageReference *)reference {
	
	[_managedObjectStore.mainQueueManagedObjectContext deleteObject:reference];
	
}

- (NSError *)deleteImage:(CaptureImage *)image {
	
	if(!image)
		return nil;
	
	//check if image is sync remotely
	//if so, memorize image info to request delete on next sync and then delete if
	//if not, delete it locally
	if(image.md5) {
		
		DeleteImageReference *ref = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DeleteImageReference class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
		
		int index = 0;
		Task *task = image.task;
		for(CaptureImage *captureImage in task.images) {
			if([captureImage.uuid isEqualToString:image.uuid] && [captureImage.order isEqualToNumber:image.order]) {
				break;
			}
			index++;
		}
		
		ref.index = [NSNumber numberWithInt:index];
		ref.md5 = image.md5;
		
		NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithOrderedSet:task.deleteImageReferences];
		[set addObject:ref];
		task.deleteImageReferences = set;

	}
	
	[self removeImageFiles:image];
	[_managedObjectStore.mainQueueManagedObjectContext deleteObject:image];
	return nil;
	
}

- (NSError *)removeImageFiles:(CaptureImage *)image {
	
	if([[NSFileManager defaultManager] fileExistsAtPath:image.privatePath]) {
		NSError *error;
		if(![[NSFileManager defaultManager] removeItemAtPath:image.privatePath error:&error]) {
			return error;
		}
	}
	
	if([[NSFileManager defaultManager] fileExistsAtPath:image.publicPath]) {
		NSError *error;
		if(![[NSFileManager defaultManager] removeItemAtPath:image.publicPath error:&error]) {
			return error;
		}
	}
	
	return nil;
	
}

#pragma - rendition management
- (Rendition *)createRenditionForTask:(Task *)task {
	
	Rendition *rendition = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Rendition class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	rendition.creationDate = [NSDate date];
	rendition.md5 = nil;
	rendition.mimetype = mimePDF;
	rendition.name = [NSString stringWithFormat:@"rendition_%@.%@", task.uuid, [[StoreManager sharedManager] extentionFromMime:mimePDF]];
	rendition.pageCount = @0;
	rendition.size = @0;
	
	NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithOrderedSet:task.renditions];
	[set addObject:rendition];
	task.renditions = set;

	return rendition;
	
}

- (NSError *)deleteRendition:(Rendition *)rendition {
	
	NSError *error;
	
	if([[NSFileManager defaultManager] fileExistsAtPath:rendition.privatePath]) {
		if(![[NSFileManager defaultManager] removeItemAtPath:rendition.privatePath error:&error]) {
			return error;
		}
	}
	
	if([[NSFileManager defaultManager] fileExistsAtPath:rendition.publicPath]) {
		if(![[NSFileManager defaultManager] removeItemAtPath:rendition.publicPath error:&error]) {
			return error;
		}
	}
	
	[[_managedObjectStore mainQueueManagedObjectContext] deleteObject:rendition];
	
	return nil;
}

#pragma - certification error management methods
- (void)createCertificationErrorForImage:(CaptureImage * )image code:(NSInteger)code description:(NSString *)desc domain:(NSString *)domain {
	
	CertificationError *error = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CertificationError class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
	
	error.code = [NSNumber numberWithInteger:code];
	error.desc = desc;
	error.domain = domain;
	
	NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithOrderedSet:image.errors];
	[set addObject:error];
	image.errors = set;

}

#pragma - unchecked transaction methods
- (UnCheckedTransaction *)createUncheckedTransaction:(SKPaymentTransaction *)transaction product:(SKProduct *)product {
	
    if([product.productIdentifier isEqualToString:transaction.payment.productIdentifier]) {
    
        UnCheckedTransaction *uncheckedTransaction = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([UnCheckedTransaction class]) inManagedObjectContext:_managedObjectStore.mainQueueManagedObjectContext];
        
        uncheckedTransaction.identifier = transaction.transactionIdentifier;
        uncheckedTransaction.date = transaction.transactionDate;
        uncheckedTransaction.product_id = transaction.payment.productIdentifier;
        uncheckedTransaction.product_name = product.localizedTitle;
        uncheckedTransaction.quantity = [NSNumber numberWithInteger:transaction.payment.quantity];
        uncheckedTransaction.errorDisplayed = @0;
        
        return uncheckedTransaction;
        
    } else {
        
        return nil;
        
    }
	
}

- (NSFetchedResultsController *)fetchedUncheckedTransactionsController {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [[_managedObjectModel entitiesByName] objectForKey:NSStringFromClass([UnCheckedTransaction class])];
    [request setEntity:e];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sort]];
    
    NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_managedObjectStore.mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return resultController;
    
}

- (void)deleteUncheckedTransaction:(UnCheckedTransaction *)uncheckedTransaction {
    [[_managedObjectStore mainQueueManagedObjectContext] deleteObject:uncheckedTransaction];
}



#pragma - common methods

- (NSString *)extentionFromMime:(NSString *)mime {
	NSArray *mimeParts = [mime componentsSeparatedByString:@"/"];
	return [mimeParts lastObject];
}

- (void)cleanSharedDirectoy {
	
	//remove all files from shared directory
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error = nil;
	
	for (NSString *file in [fm contentsOfDirectoryAtPath:self.publicPath error:&error]) {
		
		NSString *filePath = [self.publicPath stringByAppendingPathComponent:file];
		[fm removeItemAtPath:filePath error:&error];
		
		if(error) {
			
			NSLog(@"StoreManager.cleanSharedDirectory.removeItemAtPath.%@: %@", file, [error localizedDescription]);
			
		} else {
			
			NSLog(@"StoreManager.cleanSharedDirectory.removeItemAtPath.%@: Done", file);
			
		}
		
	}
	
}

- (void)syncSharedDirectory {
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSError *error;
		NSArray *tasks = [self fetchAllTasks:&error];
		
		if(!error) {
			
			for(Task *task in tasks) {
				
				for(Rendition *rendition in task.renditions) {
					
					if([[SettingsManager sharedManager] shareRenditions] && [task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusCompleted]]) {
						
						if(![[NSFileManager defaultManager] fileExistsAtPath:rendition.publicPath] && [[NSFileManager defaultManager] fileExistsAtPath:rendition.privatePath]) {

							[[NSFileManager defaultManager] copyItemAtPath:rendition.privatePath toPath:rendition.publicPath error:nil];

						}
						
					} else {
						
						if([[NSFileManager defaultManager] fileExistsAtPath:rendition.publicPath]) {

							[[NSFileManager defaultManager] removeItemAtPath:rendition.publicPath error:nil];
							
						}
						
					}
				
				}
				
				for(AbstractSubTask *subTask in task.subTasks) {
					
					if([subTask isKindOfClass:[AbstractSubTaskCapture class]]) {
						
						AbstractSubTaskCapture *subTaskCapture = (AbstractSubTaskCapture *)subTask;
						
						if([[SettingsManager sharedManager] shareFiles] && [task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusCompleted]]) {
							
							for(CaptureImage *captureImage in subTaskCapture.images) {
							
								if(![[NSFileManager defaultManager] fileExistsAtPath:captureImage.publicPath] && [[NSFileManager defaultManager] fileExistsAtPath:captureImage.privatePath]) {
									
									[[NSFileManager defaultManager] copyItemAtPath:captureImage.privatePath toPath:captureImage.publicPath error:nil];
									
								}
								
							}
					
						} else {
							
							for(CaptureImage *captureImage in subTaskCapture.images) {
							
								if([[NSFileManager defaultManager] fileExistsAtPath:captureImage.publicPath]) {
									
									[[NSFileManager defaultManager] removeItemAtPath:captureImage.publicPath error:nil];
									
								}
								
							}
							
						}
						
					}
					
				}
				
			}
			
		}
		
	});
		
}

- (void)removeTempImages {
    
    //remove all temp_image* files from private directory
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSArray *privateFiles = [fm contentsOfDirectoryAtPath:self.privatePath error:&error];
    
    if(!error) {
        
        NSString *match = @"temp_image*.*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like %@", match];
        NSArray *tempImages = [privateFiles filteredArrayUsingPredicate:predicate];
        
        for (NSString *file in tempImages) {
            
            NSString *filePath = [self.privatePath stringByAppendingPathComponent:file];
            [fm removeItemAtPath:filePath error:&error];
            
            if(error) {
                
                NSLog(@"StoreManager.removeTempImages.removeItemAtPath.%@: %@", file, [error localizedDescription]);
                
            } else {
                
                NSLog(@"StoreManager.removeTempImages.removeItemAtPath.%@: Done", file);
                
            }
            
        }
        
    } else {
        
        NSLog(@"StoreManager.removeTempImages.contentsOfDirectoryAtPath error: %@", [error localizedDescription]);
        
    }
    
    
    
}

@end
