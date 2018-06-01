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

#import "TaskHelper.h"
#import "StoreManager.h"
#import "NetworkManager.h"
#import "EnumHelper.h"
#import "DateTimeHelper.h"
#import "EnumHelper.h"
#import "ImageHelper.h"
#import "ErrorHelper.h"
#import "NSData+Hash.h"
#import "User.h"
#import "AbstractService.h"
#import "Service.h"
#import "Task.h"
#import "AbstractSubTask.h"
#import "SubTaskScan.h"
#import "SubTaskPicture.h"
#import "SubTaskForm.h"
#import "AbstractIndex.h"
#import "DefaultIndex.h"
#import "ListIndex.h"
#import "Item.h"
#import "CaptureImage.h"
#import "CertificationError.h"
#import "Rendition.h"
#import "UIStyle.h"

@implementation TaskHelper
#pragma - service helper methods
+ (NSString *)serviceIdFromDictionary:(NSDictionary *)dictionary {
	return [dictionary objectForKey:@"uuid"];
}

+ (Service *)createServiceFromDictionary:(NSDictionary *)dictionary error:(NSError **)error {
	Service *service;
	@try {
		NSString *uuid = [dictionary objectForKey:@"uuid"];
		NSString *icon_url = [dictionary objectForKey:@"icon_url"];
        NSString *icon_mime = [dictionary objectForKey:@"icon_mime"];
		NSString *title = [dictionary objectForKey:@"title"];
		NSString *description = [dictionary objectForKey:@"desc"];
		if([uuid length]>0 /*&& [title length]>0*/) {
			service = [StoreManager.sharedManager createService:uuid title:title description:description iconUrl:icon_url iconMime:icon_mime error:error];
			if(!service) {
				return nil;
			}
			service.provider = [dictionary objectForKey:@"provider"];
			NSDate *lastUpdate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"lastUpdate"]];
			service.lastUpdate = lastUpdate ? lastUpdate:[NSDate date];
			service.sourceDevice = [dictionary objectForKey:@"sourceDevice"];
			NSNumber *cost = [dictionary objectForKey:@"_cost"];
			service.cost = cost ? cost:@0;
			NSNumber *postPaid = [dictionary objectForKey:@"postPaid"];
            if(postPaid) {
                service.postPaid = postPaid;
            } else {
                postPaid = [dictionary objectForKey:@"_postPaid"];
                service.postPaid = postPaid ? postPaid:@0;
            }
            NSDictionary *styleDic = [dictionary objectForKey:@"customize"];
            [self applyStyle:styleDic toAbstractService:service];
		} else {
			return nil;
		}
		NSArray *subTasksDic = [dictionary objectForKey:@"subTasks"];
		NSMutableOrderedSet *subTasks = [[NSMutableOrderedSet alloc] init];
		for(NSDictionary *subTaskDic in subTasksDic) {
			NSString *description = [subTaskDic objectForKey:@"desc"];
			NSString *title = [subTaskDic objectForKey:@"title"];
			NSString *type = [subTaskDic objectForKey:@"type"];
			if([type isEqualToString:[EnumHelper descriptionFromSubTaskType:SPSubTaskTypePicture]]) {
				SubTaskPicture *subTaskPicture = [StoreManager.sharedManager createSubTaskPictureForAbstractService:service uuid:nil title:title description:description];
				subTaskPicture.imageSize = [subTaskDic objectForKey:@"size"];
				int minItems = [[subTaskDic objectForKey:@"minItems"] intValue];
				minItems = minItems > 0 ? minItems:1;
				subTaskPicture.minItems = [NSNumber numberWithInt:minItems];
				int maxItems = [[subTaskDic objectForKey:@"maxItems"] intValue];
				maxItems = maxItems >= minItems ? maxItems:minItems;
				subTaskPicture.maxItems = [NSNumber numberWithInt:maxItems];
				[subTasks addObject:subTaskPicture];
			} else if([type isEqualToString:[EnumHelper descriptionFromSubTaskType:SPSubTaskTypeScan]]) {
				SubTaskScan *subTaskScan = [StoreManager.sharedManager createSubTaskScanForAbstractService:service uuid:nil title:title description:description];
				subTaskScan.dpi = [subTaskDic objectForKey:@"dpi"];
				subTaskScan.format = [subTaskDic objectForKey:@"format"];
				subTaskScan.mode = [subTaskDic objectForKey:@"mode"];
				int minItems = [[subTaskDic objectForKey:@"minItems"] intValue];
				minItems = minItems > 0 ? minItems:1;
				subTaskScan.minItems = [NSNumber numberWithInt:minItems];
				int maxItems = [[subTaskDic objectForKey:@"maxItems"] intValue];
				maxItems = maxItems >= minItems ? maxItems:minItems;
				subTaskScan.maxItems = [NSNumber numberWithInt:maxItems];
				[subTasks addObject:subTaskScan];
			} else if ([type isEqualToString:[EnumHelper descriptionFromSubTaskType:SPSubTaskTypeForm]]) {
				SubTaskForm *subTaskForm = [StoreManager.sharedManager createSubTaskFormForAbstractService:service title:title description:description];
				NSArray *indexesDic = [subTaskDic objectForKey:@"indexes"];
				NSMutableOrderedSet *indexes = [[NSMutableOrderedSet alloc] init];
				for(NSDictionary *indexDic in indexesDic) {
					NSString *indexKey = [indexDic objectForKey:@"key"];
					NSString *indexValue = [indexDic objectForKey:@"value"];
					NSString *indexDescription = [indexDic objectForKey:@"desc"];
					NSString *indexType = [indexDic objectForKey:@"type"];
					BOOL indexMandatory = [[indexDic objectForKey:@"mandatory"] boolValue];
					if ([indexType isEqualToString:@"list"]) {
						NSMutableArray *list = [[NSMutableArray alloc] init];
						NSArray *itemsDic = [indexDic objectForKey:@"list"];
						for(NSDictionary *itemDic in itemsDic) {
							NSInteger itemKey = [[itemDic objectForKey:@"key"] integerValue];
							NSString *itemValue = [itemDic objectForKey:@"value"];
							Item *item = [StoreManager.sharedManager createItemWithKey:itemKey value:itemValue];
							[list addObject:item];
						}
						ListIndex *index = [StoreManager.sharedManager createIndexWithKey:indexKey value:indexValue description:indexDescription mandatory:indexMandatory list:list];
						[indexes addObject:index];
					} else {
						DefaultIndex *index = [StoreManager.sharedManager createIndexWithKey:indexKey value:indexValue description:indexDescription mandatory:indexMandatory type:indexType];
						[indexes addObject:index];
					}
				}
				subTaskForm.indexes = indexes;
				[subTasks addObject:subTaskForm];
			}
		}
		service.subTasks = subTasks;
	} @catch (NSException *exception) {
		*error = [ErrorHelper errorFromException:exception module:@"TaskHelper.createServiceFromDictionary" action:@"creating service"];
	} @finally {
		if(*error) {
			if(service)
				[StoreManager.sharedManager deleteService:service];
			return nil;
		} else {
			service.status = [NSNumber numberWithInt:SPStatusActive];
			return service;
		}
	}
}

+ (void)updateService:(Service *)service withDictionary:(NSDictionary *)dictionary error:(NSError **)error {
	@try {
		service.provider = [dictionary objectForKey:@"provider"];
        NSString *icon_url = [dictionary objectForKey:@"icon_url"];
        if(![service.icon_url isEqualToString:icon_url]) {
            service.icon_url = icon_url;
            service.icon_data = nil;
        }
        service.icon_mime = [dictionary objectForKey:@"icon_mime"];
        service.title = [dictionary objectForKey:@"title"];
		service.desc = [dictionary objectForKey:@"desc"];
		service.lastUpdate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"lastUpdate"]];
		service.sourceDevice = [dictionary objectForKey:@"sourceDevice"];
		NSNumber *cost = [dictionary objectForKey:@"_cost"];
		service.cost = cost ? cost:@0;
        NSNumber *postPaid = [dictionary objectForKey:@"postPaid"];
        if(postPaid) {
            service.postPaid = postPaid;
        } else {
            postPaid = [dictionary objectForKey:@"_postPaid"];
            service.postPaid = postPaid ? postPaid:@0;
        }
        NSDictionary *styleDic = [dictionary objectForKey:@"customize"];
        [self applyStyle:styleDic toAbstractService:service];
		for(AbstractSubTask *abstractSubTask in service.subTasks) {
			[StoreManager.sharedManager deleteSubTask:abstractSubTask];
		}
		NSArray *subTasksDic = [dictionary objectForKey:@"subTasks"];
		NSMutableOrderedSet *subTasks = [[NSMutableOrderedSet alloc] init];
		for(NSDictionary *subTaskDic in subTasksDic) {
			NSString *description = [subTaskDic objectForKey:@"desc"];
			NSString *title = [subTaskDic objectForKey:@"title"];
			NSString *type = [subTaskDic objectForKey:@"type"];
			if([type isEqualToString:[EnumHelper descriptionFromSubTaskType:SPSubTaskTypePicture]]) {
				SubTaskPicture *subTaskPicture = [StoreManager.sharedManager createSubTaskPictureForAbstractService:service uuid:nil title:title description:description];
				subTaskPicture.imageSize = [subTaskDic objectForKey:@"size"];
				int minItems = [[subTaskDic objectForKey:@"minItems"] intValue];
				minItems = minItems > 0 ? minItems:1;
				subTaskPicture.minItems = [NSNumber numberWithInt:minItems];
				int maxItems = [[subTaskDic objectForKey:@"maxItems"] intValue];
				maxItems = maxItems >= minItems ? maxItems:minItems;
				subTaskPicture.maxItems = [NSNumber numberWithInt:maxItems];
				[subTasks addObject:subTaskPicture];
			} else if([type isEqualToString:[EnumHelper descriptionFromSubTaskType:SPSubTaskTypeScan]]) {
				SubTaskScan *subTaskScan = [StoreManager.sharedManager createSubTaskScanForAbstractService:service uuid:nil title:title description:description];
				subTaskScan.dpi = [subTaskDic objectForKey:@"dpi"];
				subTaskScan.format = [subTaskDic objectForKey:@"format"];
				subTaskScan.mode = [subTaskDic objectForKey:@"mode"];
				int minItems = [[subTaskDic objectForKey:@"minItems"] intValue];
				minItems = minItems > 0 ? minItems:1;
				subTaskScan.minItems = [NSNumber numberWithInt:minItems];
				int maxItems = [[subTaskDic objectForKey:@"maxItems"] intValue];
				maxItems = maxItems >= minItems ? maxItems:minItems;
				subTaskScan.maxItems = [NSNumber numberWithInt:maxItems];
				[subTasks addObject:subTaskScan];
			} else if ([type isEqualToString:[EnumHelper descriptionFromSubTaskType:SPSubTaskTypeForm]]) {
				SubTaskForm *subTaskForm = [StoreManager.sharedManager createSubTaskFormForAbstractService:service title:title description:description];
				NSArray *indexesDic = [subTaskDic objectForKey:@"indexes"];
				NSMutableOrderedSet *indexes = [[NSMutableOrderedSet alloc] init];
				for(NSDictionary *indexDic in indexesDic) {
					NSString *indexKey = [indexDic objectForKey:@"key"];
					NSString *indexValue = [indexDic objectForKey:@"value"];
					NSString *indexDescription = [indexDic objectForKey:@"desc"];
					NSString *indexType = [indexDic objectForKey:@"type"];
					BOOL indexMandatory = [[indexDic objectForKey:@"mandatory"] boolValue];
					if ([indexType isEqualToString:@"list"]) {
						NSMutableArray *list = [[NSMutableArray alloc] init];
						NSArray *itemsDic = [indexDic objectForKey:@"list"];
						for(NSDictionary *itemDic in itemsDic) {
							NSInteger itemKey = [[itemDic objectForKey:@"key"] integerValue];
							NSString *itemValue = [itemDic objectForKey:@"value"];
							Item *item = [StoreManager.sharedManager createItemWithKey:itemKey value:itemValue];
							[list addObject:item];
						}
						ListIndex *index = [StoreManager.sharedManager createIndexWithKey:indexKey value:indexValue description:indexDescription mandatory:indexMandatory list:list];
						[indexes addObject:index];
					} else {
						DefaultIndex *index = [StoreManager.sharedManager createIndexWithKey:indexKey value:indexValue description:indexDescription mandatory:indexMandatory type:indexType];
						[indexes addObject:index];
					}
				}
				subTaskForm.indexes = indexes;
				[subTasks addObject:subTaskForm];
			}
		}
		service.subTasks = subTasks;
	} @catch (NSException *exception) {
		*error = [ErrorHelper errorFromException:exception module:@"TaskHelper.updateServiceWithDictionary" action:@"updating service"];
	}
}

#pragma - task helper methods
+ (Task *)createTaskFromDictionary:(NSDictionary *)dictionary visible:(BOOL)visible error:(NSError **)error {
	Task *task;
	*error = nil;
	@try {
        task = [StoreManager.sharedManager createFreeTask:error];
        if(!*error) {
            task.desc = [dictionary objectForKey:@"desc"];
            task.icon_url = [dictionary objectForKey:@"icon_url"];
            task.icon_mime = [dictionary objectForKey:@"icon_mime"];
            NSDate *lastUpdate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"lastUpdate"]];
            task.lastUpdate = lastUpdate ? lastUpdate:[NSDate date];
            task.permanent = @0;
            task.provider = [dictionary objectForKey:@"provider"];
            task.title = [dictionary objectForKey:@"title"];
            task.uuid = [dictionary objectForKey:@"uuid"];
            task.endDate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"endDate"]];
            task.startDate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"startDate"]];
            task.serviceId = [dictionary objectForKey:@"templateId"];
            task.sourceDevice = [dictionary objectForKey:@"sourceDevice"];
            NSNumber *cost = [dictionary objectForKey:@"_cost"];
            task.cost = cost ? cost:@0;
            NSNumber *postPaid = [dictionary objectForKey:@"postPaid"];
            if(postPaid) {
                task.postPaid = postPaid;
            } else {
                postPaid = [dictionary objectForKey:@"_postPaid"];
                task.postPaid = postPaid ? postPaid:@0;
            }
            task.noCredit = @0;
            NSDictionary *styleDic = [dictionary objectForKey:@"customize"];
            [self applyStyle:styleDic toAbstractService:task];
            NSArray *subTasksDic = [dictionary objectForKey:@"subTasks"];
            for(NSDictionary *subTaskDic in subTasksDic) {
                NSString *description = [subTaskDic objectForKey:@"desc"];
                NSString *title = [subTaskDic objectForKey:@"title"];
                NSString *type = [subTaskDic objectForKey:@"type"];
                NSDate *startDate = [DateTimeHelper dateFromJson:[subTaskDic objectForKey:@"startDate"]];
                NSDate *endDate = [DateTimeHelper dateFromJson:[subTaskDic objectForKey:@"endDate"]];
                if([type isEqualToString:[EnumHelper descriptionFromSubTaskType:SPSubTaskTypePicture]]) {
                    SubTaskPicture *subTaskPicture = [StoreManager.sharedManager createSubTaskPictureForAbstractService:task uuid:[subTaskDic objectForKey:@"uuid"] title:title description:description];
                    subTaskPicture.imageSize = [subTaskDic objectForKey:@"size"];
                    subTaskPicture.startDate = startDate;
                    subTaskPicture.endDate = endDate;
                    int minItems = [[subTaskDic objectForKey:@"minItems"] intValue];
                    minItems = minItems > 0 ? minItems:1;
                    subTaskPicture.minItems = [NSNumber numberWithInt:minItems];
                    int maxItems = [[subTaskDic objectForKey:@"maxItems"] intValue];
                    maxItems = maxItems >= minItems ? maxItems:minItems;
                    subTaskPicture.maxItems = [NSNumber numberWithInt:maxItems];
                } else if([type isEqualToString:[EnumHelper descriptionFromSubTaskType:SPSubTaskTypeScan]]) {
                    SubTaskScan *subTaskScan = [StoreManager.sharedManager createSubTaskScanForAbstractService:task uuid:[subTaskDic valueForKey:@"uuid"] title:title description:description];
                    subTaskScan.dpi = [subTaskDic objectForKey:@"dpi"];
                    subTaskScan.format = [subTaskDic objectForKey:@"format"];
                    subTaskScan.mode = [subTaskDic objectForKey:@"mode"];
                    subTaskScan.startDate = startDate;
                    subTaskScan.endDate = endDate;
                    int minItems = [[subTaskDic objectForKey:@"minItems"] intValue];
                    minItems = minItems > 0 ? minItems:1;
                    subTaskScan.minItems = [NSNumber numberWithInt:minItems];
                    int maxItems = [[subTaskDic objectForKey:@"maxItems"] intValue];
                    maxItems = maxItems >= minItems ? maxItems:minItems;
                    subTaskScan.maxItems = [NSNumber numberWithInt:maxItems];
                } else if ([type isEqualToString:[EnumHelper descriptionFromSubTaskType:SPSubTaskTypeForm]]) {
                    SubTaskForm *subTaskForm = [StoreManager.sharedManager createSubTaskFormForAbstractService:task title:title description:description];
                    subTaskForm.startDate = startDate;
                    subTaskForm.endDate = endDate;
                    NSArray *indexesDic = [subTaskDic objectForKey:@"indexes"];
                    NSMutableOrderedSet *indexes = [[NSMutableOrderedSet alloc] init];
                    for(NSDictionary *indexDic in indexesDic) {
                        NSString *indexKey = [indexDic objectForKey:@"key"];
                        NSString *indexValue = [indexDic objectForKey:@"value"];
                        NSString *indexDescription = [indexDic objectForKey:@"desc"];
                        NSString *indexType = [indexDic objectForKey:@"type"];
                        BOOL indexMandatory = [[indexDic objectForKey:@"mandatory"] boolValue];
                        if ([indexType isEqualToString:@"list"]) {
                            NSMutableArray *list = [[NSMutableArray alloc] init];
                            NSArray *itemsDic = [indexDic objectForKey:@"list"];
                            for(NSDictionary *itemDic in itemsDic) {
                                NSInteger itemKey = [[itemDic objectForKey:@"key"] integerValue];
                                NSString *itemValue = [itemDic objectForKey:@"value"];
                                Item *item = [StoreManager.sharedManager createItemWithKey:itemKey value:itemValue];
                                [list addObject:item];
                            }
                            ListIndex *index = [StoreManager.sharedManager createIndexWithKey:indexKey value:indexValue description:indexDescription mandatory:indexMandatory list:list];
                            [indexes addObject:index];
                        } else {
                            DefaultIndex *index = [StoreManager.sharedManager createIndexWithKey:indexKey value:indexValue description:indexDescription mandatory:indexMandatory type:indexType];
                            [indexes addObject:index];
                        }
                    }
                    subTaskForm.indexes = indexes;
                }
            }
            NSArray *imagesDic = [dictionary objectForKey:@"images"];
            for(NSDictionary *imageDic in imagesDic) {
                NSDictionary *metadatas = [imageDic objectForKey:@"metadatas"];
                NSString *uuid = [metadatas objectForKey:@"uuid"];
                NSInteger order = [[metadatas objectForKey:@"order"] integerValue];
                CaptureImage *image = [StoreManager.sharedManager createImageForTask:task uuid:uuid order:order mime:[imageDic objectForKey:@"mimetype"]];
                image.md5 = [imageDic objectForKey:@"hash"];
                image.mimetype = [imageDic objectForKey:@"mimetype"];
                image.accuracy = [NSNumber numberWithFloat:[[metadatas objectForKey:@"accuracy"] floatValue]];
                image.certified = [NSNumber numberWithInt:[[metadatas objectForKey:@"certified"] intValue]];
                image.creationDate = [DateTimeHelper dateFromJson:[metadatas objectForKey:@"creationDate"]];
                image.errorLevel = [NSNumber numberWithInt:[[metadatas objectForKey:@"errorLevel"] intValue]];
                image.latitude =  [NSNumber numberWithDouble:[[metadatas objectForKey:@"latitude"] doubleValue]];
                image.longitude = [NSNumber numberWithDouble:[[metadatas objectForKey:@"longitude"] doubleValue]];
                image.sha1 = [metadatas objectForKey:@"sha1"];
                image.timestamp = [DateTimeHelper dateFromJson:[metadatas objectForKey:@"timestamp"]];
                NSArray *errorsDic = [metadatas objectForKey:@"errors"];
                for(NSDictionary *errorDic in errorsDic) {
                    NSInteger code = [[errorDic objectForKey:@"code"] integerValue];
                    NSString *desc = [errorDic objectForKey:@"description"];
                    NSString *domain = [errorDic objectForKey:@"domain"];
                    [StoreManager.sharedManager createCertificationErrorForImage:image code:code description:desc domain:domain];
                }
            }
            NSArray *renditionsDic = [dictionary objectForKey:@"renditions"];
            if([renditionsDic count]>0) {
                NSDictionary *renditionDic = [renditionsDic objectAtIndex:0];
                NSDictionary *metadatas = [renditionDic objectForKey:@"metadatas"];
                Rendition *rendition;
                if([task.renditions count]>0) {
                    rendition = [task.renditions objectAtIndex:0];
                } else {
                    rendition = [StoreManager.sharedManager createRenditionForTask:task];
                }
                rendition.name = [renditionDic objectForKey:@"name"];;
                rendition.creationDate = [DateTimeHelper dateFromJson:[metadatas objectForKey:@"creationDate"]];
                rendition.md5 = [renditionDic objectForKey:@"hash"];
                rendition.mimetype = [renditionDic objectForKey:@"mimetype"];
                rendition.pageCount = [NSNumber numberWithInt:[[metadatas objectForKey:@"pageCount"] intValue]];
                rendition.size = [NSNumber numberWithInt:[[metadatas objectForKey:@"size"] intValue]];
            }
        }
	} @catch (NSException *exception) {
		*error = [ErrorHelper errorFromException:exception module:@"TaskHelper.createTaskFromDictionary" action:@"creating task"];
	} @finally {
		if(*error) {
			if(task) {
				NSError *deleteTaskError = [StoreManager.sharedManager deleteTask:task];
				if(!deleteTaskError) {
					NSLog(@"Invalid task has been removed");
				} else {
					NSLog(@"Error removing invalid task: %@", [deleteTaskError localizedDescription]);
				}
			}
			return nil;
		} else {
			@try {
                if(visible && task) {
					task.status = [dictionary objectForKey:@"status"];
                }
                if([task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusCompleted]] && [task.renditions count] > 0){
                    task.finished = @1;
                } else {
                    task.finished = @0;
                }
			} @catch (NSException *exception) {
				*error = [ErrorHelper errorFromException:exception module:@"TaskHelper.createTaskFromDictionary" action:@"updating task status"];
			} @finally {
				return task;
			}
		}
	}
}

+ (void)updateTask:(Task *)task withDictionary:(NSDictionary *)dictionary error:(NSError **)error {
	@try {
		task.lastUpdate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"lastUpdate"]];
		task.endDate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"endDate"]];
		task.startDate = [DateTimeHelper dateFromJson:[dictionary objectForKey:@"startDate"]];
		task.status = [dictionary objectForKey:@"status"];
        task.noCredit = @0;
        NSDictionary *styleDic = [dictionary objectForKey:@"customize"];
        [self applyStyle:styleDic toAbstractService:task];
		NSArray *subTasksDic = [dictionary objectForKey:@"subTasks"];
		for(NSDictionary *subTaskDic in subTasksDic) {
			NSDate *startDate = [DateTimeHelper dateFromJson:[subTaskDic objectForKey:@"startDate"]];
			NSDate *endDate = [DateTimeHelper dateFromJson:[subTaskDic objectForKey:@"endDate"]];
			NSString *uuid = [subTaskDic objectForKey:@"uuid"];
			NSString *title = [subTaskDic objectForKey:@"title"];
			NSString *desc = [subTaskDic objectForKey:@"desc"];
			for(AbstractSubTask *subTask in task.subTasks) {
				if([subTask isKindOfClass:[AbstractSubTaskCapture class]] && uuid) {
					AbstractSubTaskCapture *subTaskCapture = (AbstractSubTaskCapture *)subTask;
					if([subTaskCapture.uuid isEqualToString:uuid]) {
						subTaskCapture.startDate = startDate;
						subTaskCapture.endDate = endDate;
						break;
					}
				} else if([subTask isKindOfClass:[SubTaskForm class]] &&
						  [subTask.title isEqualToString:title] &&
						  [subTask.desc isEqualToString:desc]) {
					SubTaskForm *subTaskForm = (SubTaskForm *)subTask;
					subTaskForm.startDate = startDate;
					subTaskForm.endDate = endDate;
					NSArray *indexesDic = [subTaskDic objectForKey:@"indexes"];
					for(NSDictionary *indexDic in indexesDic) {
						for(AbstractIndex *index in subTaskForm.indexes) {
							if([index.key isEqualToString:[indexDic objectForKey:@"key"]]) {
								index.value = [indexDic objectForKey:@"value"];
								break;
							}
						}
					}
					break;
				}
			}
		}
		NSArray *imagesDic = [dictionary objectForKey:@"images"];
		for(NSDictionary *imageDic in imagesDic) {
			NSDictionary *metadatas = [imageDic objectForKey:@"metadatas"];
			NSString *uuid = [metadatas objectForKey:@"uuid"];
			NSInteger order = [[metadatas objectForKey:@"order"] integerValue];
			[StoreManager.sharedManager fetchImage:uuid order:order withBlock:^(CaptureImage *image, NSError *error) {
				NSString *md5 = [imageDic objectForKey:@"hash"];
				if(!image) {
					image = [StoreManager.sharedManager createImageForTask:task uuid:uuid order:order mime:[imageDic objectForKey:@"mimetype"]];
				} else if(![[[image data] md5] isEqualToString:md5]) {
					[StoreManager.sharedManager removeImageFiles:image];
				}
				image.md5 = md5;
				image.mimetype = [imageDic objectForKey:@"mimetype"];
				image.accuracy = [NSNumber numberWithFloat:[[metadatas objectForKey:@"accuracy"] floatValue]];
				image.certified = [NSNumber numberWithInt:[[metadatas objectForKey:@"certified"] intValue]];
				image.creationDate = [DateTimeHelper dateFromJson:[metadatas objectForKey:@"creationDate"]];
				image.errorLevel = [NSNumber numberWithInt:[[metadatas objectForKey:@"errorLevel"] intValue]];
				image.latitude =  [NSNumber numberWithDouble:[[metadatas objectForKey:@"latitude"] doubleValue]];
				image.longitude = [NSNumber numberWithDouble:[[metadatas objectForKey:@"longitude"] doubleValue]];
				image.sha1 = [metadatas objectForKey:@"sha1"];
				image.timestamp = [DateTimeHelper dateFromJson:[metadatas objectForKey:@"timestamp"]];
				NSArray *errorsDic = [metadatas objectForKey:@"errors"];
				for(NSDictionary *errorDic in errorsDic) {
					NSInteger code = [[errorDic objectForKey:@"code"] integerValue];
					NSString *desc = [errorDic objectForKey:@"description"];
					NSString *domain = [errorDic objectForKey:@"domain"];
					[StoreManager.sharedManager createCertificationErrorForImage:image code:code description:desc domain:domain];
				}
			}];
		}
		for(CaptureImage *image in task.images) {
			BOOL imageFound = NO;
			for(NSDictionary *imageDic in imagesDic) {
				NSDictionary *metadatas = [imageDic objectForKey:@"metadatas"];
				NSString *uuid = [metadatas objectForKey:@"uuid"];
				NSNumber *order = [metadatas objectForKey:@"order"];
				if([image.uuid isEqualToString:uuid] && [image.order isEqualToNumber:order]) {
					imageFound = YES;
					break;
				}
			}
			if(!imageFound) {
				image.md5 = nil; //set to nil so that is will not be added as a ref to delete in delete method below
				[StoreManager.sharedManager deleteImage:image];
			}
		}
		NSArray *renditionsDic = [dictionary objectForKey:@"renditions"];
		if([renditionsDic count]>0) {
			NSDictionary *renditionDic = [renditionsDic objectAtIndex:0];
			NSDictionary *metadatas = [renditionDic objectForKey:@"metadatas"];
			Rendition *rendition;
			if([task.renditions count]>0) {
				rendition = [task.renditions objectAtIndex:0];
			} else {
				rendition = [StoreManager.sharedManager createRenditionForTask:task];
			}
			rendition.name = [renditionDic objectForKey:@"name"];;
			rendition.creationDate = [DateTimeHelper dateFromJson:[metadatas objectForKey:@"creationDate"]];
			rendition.md5 = [renditionDic objectForKey:@"hash"];
			rendition.mimetype = [renditionDic objectForKey:@"mimetype"];
			rendition.pageCount = [NSNumber numberWithInt:[[metadatas objectForKey:@"pageCount"] intValue]];
			rendition.size = [NSNumber numberWithInt:[[metadatas objectForKey:@"size"] intValue]];
            if([task.status isEqualToNumber:[NSNumber numberWithInt:SPStatusCompleted]]){
                task.finished = @1;
            }
        } else {
            task.finished = @0;
        }
	} @catch (NSException *exception) {
		*error = [ErrorHelper errorFromException:exception module:@"TaskHelper.updateTask" action:@"updating task"];
	}
}

+ (void)applyStyle:(NSDictionary *)styleDic toAbstractService:(AbstractService *)abstractService {
    if(styleDic && abstractService.uiStyle) {
        NSString *toolBarColor = [styleDic objectForKey:@"toolbarColor"];
        NSString *toolBarBackgroundColor = [styleDic objectForKey:@"toolbarBackgroundColor"];
        NSString *headerColor = [styleDic objectForKey:@"headerColor"];
        NSString *headerBackgroundColor = [styleDic objectForKey:@"headerBackgroundColor"];
        NSString *thumbnailColor = [styleDic objectForKey:@"thumbnailColor"];
        NSString *thumbnailBackgroundColor = [styleDic objectForKey:@"thumbnailBackgroundColor"];
        NSString *promptColor = [styleDic objectForKey:@"promptColor"];
        NSString *viewBackgroundColor = [styleDic objectForKey:@"viewBackgroundColor"];
        if(toolBarColor)
            abstractService.uiStyle.toolbarColor = toolBarColor;
        if(toolBarBackgroundColor)
            abstractService.uiStyle.toolbarBackgroundColor = toolBarBackgroundColor;
        if(headerColor)
            abstractService.uiStyle.headerColor = headerColor;
        if(headerBackgroundColor)
            abstractService.uiStyle.headerBackgroundColor = headerBackgroundColor;
        if(thumbnailColor)
            abstractService.uiStyle.thumbnailColor = thumbnailColor;
        if(thumbnailBackgroundColor)
            abstractService.uiStyle.thumbnailBackgroundColor = thumbnailBackgroundColor;
        if(promptColor)
            abstractService.uiStyle.promptColor = promptColor;
        if(viewBackgroundColor)
            abstractService.uiStyle.viewBackgroundColor = viewBackgroundColor;
    }
}
@end
