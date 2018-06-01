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

#import "AbstractService.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractService (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cost;
@property (nullable, nonatomic, retain) NSNumber *postPaid;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *icon_url;
@property (nullable, nonatomic, retain) NSString *icon_mime;
@property (nullable, nonatomic, retain) NSData *icon_data;
@property (nullable, nonatomic, retain) NSDate *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *permanent;
@property (nullable, nonatomic, retain) NSString *provider;
@property (nullable, nonatomic, retain) NSString *sourceDevice;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSOrderedSet<AbstractSubTask *> *subTasks;
@property (nullable, nonatomic, retain) UIStyle *uiStyle;

@end

@interface AbstractService (CoreDataGeneratedAccessors)

- (void)insertObject:(AbstractSubTask *)value inSubTasksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubTasksAtIndex:(NSUInteger)idx;
- (void)insertSubTasks:(NSArray<AbstractSubTask *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubTasksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubTasksAtIndex:(NSUInteger)idx withObject:(AbstractSubTask *)value;
- (void)replaceSubTasksAtIndexes:(NSIndexSet *)indexes withSubTasks:(NSArray<AbstractSubTask *> *)values;
- (void)addSubTasksObject:(AbstractSubTask *)value;
- (void)removeSubTasksObject:(AbstractSubTask *)value;
- (void)addSubTasks:(NSOrderedSet<AbstractSubTask *> *)values;
- (void)removeSubTasks:(NSOrderedSet<AbstractSubTask *> *)values;

@end

NS_ASSUME_NONNULL_END
