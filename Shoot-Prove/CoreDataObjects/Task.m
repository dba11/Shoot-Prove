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

#import "Task.h"
#import <SPCertificationSDK/SPCertificationQueue.h>
#import "NetworkManager.h"
#import "StoreManager.h"
#import "CaptureImage.h"
#import "Rendition.h"
#import "Service.h"
#import "AbstractSubTask.h"
#import "AbstractSubTaskCapture.h"
#import "CaptureImage.h"
#import "SubTaskForm.h"
#import "SubTaskPicture.h"
#import "SubTaskScan.h"
#import "AbstractIndex.h"
#import "User.h"
#import "ListIndex.h"
#import "DefaultIndex.h"
#import "Item.h"
#import "UIStyle.h"
#import "DateTimeHelper.h"
#import "EnumHelper.h"
#import "ImageHelper.h"
#import "NSData+Hash.h"

@interface Task ()
{
    NSString *_completionMessage;
}
@end

@implementation Task
- (CaptureImage *)firstCaptureImage {
	for(AbstractSubTask *subTask in self.subTasks) {
		if([subTask isKindOfClass:[AbstractSubTaskCapture class]]) {
			AbstractSubTaskCapture *subTaskCapture = (AbstractSubTaskCapture *)subTask;
			for(CaptureImage *captureImage in subTaskCapture.images) {
				if(captureImage.image) {
					return captureImage;
				}
			}
		}
	}
    return nil;
}

- (BOOL)isSync {
	if(!self.uuid) {
		return NO;
	}
	for(CaptureImage *captureImage in self.images) {
		if(!captureImage.isSync) {
			return NO;
		}
	}
	if(self.renditions.count == 0) {
		return NO;
	}
	return YES;
}

- (BOOL)isCertified {
    BOOL hasSubTaskCapture = NO;
    for(AbstractSubTask *abstractSubTask in self.subTasks) {
        if([abstractSubTask isKindOfClass:[AbstractSubTaskCapture class]]) {
            hasSubTaskCapture = YES;
            break;
        }
    }
    if(!hasSubTaskCapture)
        return YES;
	if(self.images.count > 0) {
		for(CaptureImage *image in self.images) {
			if([image.certified isEqualToNumber:@0]) {
				return NO;
			}
		}
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)isComplete {
    NSMutableString *message = [[NSMutableString alloc] init];
    for(AbstractSubTask *subTask in self.subTasks) {
        if([subTask isKindOfClass:[AbstractSubTaskCapture class]]) {
            AbstractSubTaskCapture *abstractSubTaskCapture = (AbstractSubTaskCapture *)subTask;
            if(!abstractSubTaskCapture.isComplete) {
                if(message.length == 0)
                    [message appendString:NSLocalizedString(@"TASK_INFO_INCOMPLETE", nil)];
                else {
                    [message appendString:@"\n"];
                }
                [message appendFormat:NSLocalizedString(@"TASK_INFO_INCOMPLETE_CAPTURE", nil), abstractSubTaskCapture.title];
            }
        } else if([subTask isKindOfClass:[SubTaskForm class]]) {
            SubTaskForm *subTaskForm = (SubTaskForm *)subTask;
            if(!subTaskForm.isComplete) {
                if(message.length == 0)
                    [message appendString:NSLocalizedString(@"TASK_INFO_INCOMPLETE", nil)];
                else {
                    [message appendString:@"\n"];
                }
                [message appendFormat:NSLocalizedString(@"TASK_INFO_INCOMPLETE_FORM", nil), subTaskForm.title];
            }
        }
    }
    if(message.length > 0) {
        _completionMessage = message;
        return NO;
    } else {
        _completionMessage = nil;
        return YES;
    }
}

- (NSString *)completionMessage {
    return _completionMessage;
}

- (NSString *)displayTitle {
	NSString *displayTitle;
	if(!self.serviceId) {
        SubTaskForm *subTaskForm;
		for(AbstractSubTask *subTask in self.subTasks) {
			if([subTask isKindOfClass:[SubTaskForm class]]) {
				subTaskForm = (SubTaskForm *)subTask;
				break;
			}
		}
		if(subTaskForm && [subTaskForm.indexes count] > 0) {
			AbstractIndex *index = [subTaskForm.indexes firstObject];
			if([index.value length] > 0)
				displayTitle = index.value;
		}
		if(displayTitle.length == 0) {
			displayTitle = self.title;
		}
	} else {
		displayTitle = self.title;
	}
	return displayTitle;
}

- (NSDictionary *)dictionary {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	if(self.desc)
        [dictionary setObject:self.desc forKey:@"desc"];
	if(self.icon_url)
		[dictionary setObject:self.icon_url forKey:@"icon_url"];
    if(self.icon_mime)
        [dictionary setObject:self.icon_mime forKey:@"icon_mime"];
	[dictionary setObject:[DateTimeHelper jsonFromDate:self.lastUpdate] forKey:@"lastUpdate"];
	[dictionary setObject:self.permanent forKey:@"permanent"];
	if(self.provider)
		[dictionary setObject:self.provider forKey:@"provider"];
	if(self.title)
		[dictionary setObject:self.title forKey:@"title"];
	if(self.uuid)
		[dictionary setObject:self.uuid forKey:@"uuid"];
	if(self.endDate)
        [dictionary setObject:[DateTimeHelper jsonFromDate:self.endDate] forKey:@"endDate"];
	if(self.startDate)
        [dictionary setObject:[DateTimeHelper jsonFromDate:self.startDate] forKey:@"startDate"];
	[dictionary setObject:self.status forKey:@"status"];
	if(self.serviceId)
		[dictionary setObject:self.serviceId forKey:@"templateId"];
	if(self.sourceDevice)
		[dictionary setObject:self.sourceDevice forKey:@"sourceDevice"];
    if(self.uiStyle) {
        NSMutableDictionary *styleDic = [[NSMutableDictionary alloc] init];
        [styleDic setObject:self.uiStyle.toolbarBackgroundColor forKey:@"toolbarBackgroundColor"];
        [styleDic setObject:self.uiStyle.toolbarColor forKey:@"toolbarColor"];
        [styleDic setObject:self.uiStyle.headerBackgroundColor forKey:@"headerBackgroundColor"];
        [styleDic setObject:self.uiStyle.headerColor forKey:@"headerColor"];
        [styleDic setObject:self.uiStyle.thumbnailBackgroundColor forKey:@"thumbnailBackgroundColor"];
        [styleDic setObject:self.uiStyle.thumbnailColor forKey:@"thumbnailColor"];
        [styleDic setObject:self.uiStyle.promptColor forKey:@"promptColor"];
        [styleDic setObject:self.uiStyle.viewBackgroundColor forKey:@"viewBackgroundColor"];
        [dictionary setObject:styleDic forKey:@"customize"];
    }
	NSMutableArray *subTasksArray = [[NSMutableArray alloc] init];
	for(AbstractSubTask *abstractSubTask in self.subTasks) {
		NSMutableDictionary *subTaskDic = [[NSMutableDictionary alloc] init];
		if(abstractSubTask.desc) {
			[subTaskDic setObject:abstractSubTask.desc forKey:@"desc"];
		}
		if(abstractSubTask.endDate) {
			[subTaskDic setObject:[DateTimeHelper jsonFromDate:abstractSubTask.endDate] forKey:@"endDate"];
		}
		if(abstractSubTask.startDate) {
			[subTaskDic setObject:[DateTimeHelper jsonFromDate:abstractSubTask.startDate] forKey:@"startDate"];
		}
        if(abstractSubTask.title)
            [subTaskDic setObject:abstractSubTask.title forKey:@"title"];
		[subTaskDic setObject:abstractSubTask.type forKey:@"type"];
		if([abstractSubTask isKindOfClass:[SubTaskForm class]]) {
			SubTaskForm *subTask = (SubTaskForm *)abstractSubTask;
			NSMutableArray *indexArray = [[NSMutableArray alloc] init];
			for(AbstractIndex *abstractIndex in subTask.indexes) {
				NSMutableDictionary *indexDic = [[NSMutableDictionary alloc] init];
				if(abstractIndex.desc) {
					[indexDic setObject:abstractIndex.desc forKey:@"desc"];
				}
				[indexDic setObject:abstractIndex.key forKey:@"key"];
				[indexDic setObject:abstractIndex.mandatory forKey:@"mandatory"];
				[indexDic setObject:abstractIndex.type forKey:@"type"];
				if(abstractIndex.value) {
					SPIndexType indexType = [EnumHelper indexTypeFromDescription:abstractIndex.type];
					if(indexType == SPIndexTypeDate) {
						NSDateFormatter *f = [[NSDateFormatter alloc] init];
						[f setDateStyle:NSDateFormatterShortStyle];
						[f setTimeStyle:NSDateFormatterNoStyle];
						NSDate *indexDate = [f dateFromString:abstractIndex.value];
						if(indexDate) {
							[indexDic setObject:[DateTimeHelper jsonFromDate:indexDate] forKey:@"value"];
						}
					} else {
						if([abstractIndex.value length] > 0)
							[indexDic setObject:abstractIndex.value forKey:@"value"];
					}
				}
				if([abstractIndex isKindOfClass:[ListIndex class]]) {
					ListIndex *listIndex = (ListIndex *)abstractIndex;
					NSMutableArray *listArray = [[NSMutableArray alloc] init];
					for(Item *item in listIndex.list) {
						NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
						[itemDic setObject:item.key forKey:@"key"];
						if([item.value length] > 0)
							[itemDic setObject:item.value forKey:@"value"];
						[listArray addObject:itemDic];
					}
					[indexDic setObject:listArray forKey:@"list"];
				}
				[indexArray addObject:indexDic];
			}
			[subTaskDic setObject:indexArray forKey:@"indexes"];
		} else if([abstractSubTask isKindOfClass:[SubTaskPicture class]]) {
			SubTaskPicture *subTask = (SubTaskPicture *)abstractSubTask;
			if(subTask.imageSize) {
				[subTaskDic setObject:subTask.imageSize forKey:@"size"];
			} else {
				[subTaskDic setObject:[EnumHelper descriptionFromSize:SPsize1200x900] forKey:@"size"];
			}
			[subTaskDic setObject:subTask.uuid forKey:@"uuid"];
			[subTaskDic setObject:subTask.minItems forKey:@"minItems"];
			[subTaskDic setObject:subTask.maxItems forKey:@"maxItems"];
		} else if ([abstractSubTask isKindOfClass:[SubTaskScan class]]) {
			SubTaskScan *subTask = (SubTaskScan *)abstractSubTask;
			[subTaskDic setObject:subTask.dpi forKey:@"dpi"];
			[subTaskDic setObject:subTask.format forKey:@"format"];
			[subTaskDic setObject:subTask.mode forKey:@"mode"];
			[subTaskDic setObject:subTask.uuid forKey:@"uuid"];
			[subTaskDic setObject:subTask.minItems forKey:@"minItems"];
			[subTaskDic setObject:subTask.maxItems forKey:@"maxItems"];
		}
		[subTasksArray addObject:subTaskDic];
	}
	[dictionary setObject:subTasksArray forKey:@"subTasks"];
	return dictionary;
}

- (Rendition *)createRendition {
	if([self.renditions count]>0) {
		return [self.renditions objectAtIndex:0];
	}
	NSMutableArray *subTasks = [[NSMutableArray alloc] init];
	for(AbstractSubTask *subTask in self.subTasks) {
		if([subTask isKindOfClass:([AbstractSubTaskCapture class])]) {
			[subTasks addObject:subTask];
		}
	}
	if([subTasks count] > 0) {
		Rendition *rendition = [[StoreManager sharedManager] createRenditionForTask:self];
		if(!self.uuid) { //free task has no uuid and rendition name is based on it
			rendition.name = [NSString stringWithFormat:@"rendition_%@.%@", [[NSUUID UUID] UUIDString], [[StoreManager sharedManager] extentionFromMime:mimePDF]];
		}
		rendition.pageCount = [NSNumber numberWithInteger:[subTasks count]];
		[ImageHelper createPDFWithSubTasks:subTasks filePath:rendition.privatePath];
		return rendition;
	} else {
		return nil;
	}
}

- (SubTaskForm *)createFreeSubTaskForm {
	SubTaskForm *subTaskForm = [[StoreManager sharedManager] createSubTaskFormForAbstractService:self title:NSLocalizedString(@"FREE_TASK_FORM_TITLE", nil) description:NSLocalizedString(@"FREE_TASK_FORM_DESCRIPTION", nil)];
    subTaskForm.startDate = [NSDate date];
    subTaskForm.endDate = [NSDate date];
	NSMutableOrderedSet *indexes = [NSMutableOrderedSet orderedSetWithOrderedSet:subTaskForm.indexes];
	DefaultIndex *titleIndex = [[StoreManager sharedManager] createIndexWithKey:NSLocalizedString(@"FREE_TASK_INDEX_TITLE", nil) value:nil description:nil mandatory:NO type:[EnumHelper descriptionFromIndexType:SPIndexTypeSingleText]];
	DefaultIndex *descIndex = [[StoreManager sharedManager] createIndexWithKey:NSLocalizedString(@"FREE_TASK_INDEX_DESCRIPTION", nil) value:nil description:nil mandatory:NO type:[EnumHelper descriptionFromIndexType:SPIndexTypeMultiText]];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterNoStyle];
	DefaultIndex *dateIndex = [[StoreManager sharedManager] createIndexWithKey:NSLocalizedString(@"FREE_TASK_INDEX_DATE", nil) value:[df stringFromDate:[NSDate date]] description:nil mandatory:NO type:[EnumHelper descriptionFromIndexType:SPIndexTypeDate]];
	[indexes addObject:titleIndex];
	[indexes addObject:descIndex];
	[indexes addObject:dateIndex];
	subTaskForm.indexes = indexes;
	return subTaskForm;
}
@end
