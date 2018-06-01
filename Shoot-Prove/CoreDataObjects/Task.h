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
#import "AbstractService.h"

@class CaptureImage, Rendition, User, SubTaskForm, DeleteImageReference;

NS_ASSUME_NONNULL_BEGIN

@interface Task : AbstractService
- (CaptureImage *)firstCaptureImage;
- (BOOL)isSync;
- (BOOL)isCertified;
- (BOOL)isComplete;
- (NSString *)completionMessage;
- (NSString *)displayTitle;
- (NSDictionary *)dictionary;
- (Rendition *)createRendition;
- (SubTaskForm *)createFreeSubTaskForm;
@end

NS_ASSUME_NONNULL_END

#import "Task+CoreDataProperties.h"
