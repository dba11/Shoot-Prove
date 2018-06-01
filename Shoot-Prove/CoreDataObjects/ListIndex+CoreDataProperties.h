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

#import "ListIndex.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListIndex (CoreDataProperties)

@property (nullable, nonatomic, retain) NSOrderedSet<Item *> *list;

@end

@interface ListIndex (CoreDataGeneratedAccessors)

- (void)insertObject:(Item *)value inListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromListAtIndex:(NSUInteger)idx;
- (void)insertList:(NSArray<Item *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInListAtIndex:(NSUInteger)idx withObject:(Item *)value;
- (void)replaceListAtIndexes:(NSIndexSet *)indexes withList:(NSArray<Item *> *)values;
- (void)addListObject:(Item *)value;
- (void)removeListObject:(Item *)value;
- (void)addList:(NSOrderedSet<Item *> *)values;
- (void)removeList:(NSOrderedSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
