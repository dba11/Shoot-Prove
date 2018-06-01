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


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, copy) NSNumber *finished;
@property (nullable, nonatomic, copy) NSNumber *noCredit;
@property (nullable, nonatomic, copy) NSString *serviceId;
@property (nullable, nonatomic, retain) NSData *serviceIconData;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSNumber *status;
@property (nullable, nonatomic, retain) NSOrderedSet<DeleteImageReference *> *deleteImageReferences;
@property (nullable, nonatomic, retain) NSOrderedSet<CaptureImage *> *images;
@property (nullable, nonatomic, retain) NSOrderedSet<Rendition *> *renditions;

@end

@interface Task (CoreDataGeneratedAccessors)

- (void)insertObject:(DeleteImageReference *)value inDeleteImageReferencesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDeleteImageReferencesAtIndex:(NSUInteger)idx;
- (void)insertDeleteImageReferences:(NSArray<DeleteImageReference *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDeleteImageReferencesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDeleteImageReferencesAtIndex:(NSUInteger)idx withObject:(DeleteImageReference *)value;
- (void)replaceDeleteImageReferencesAtIndexes:(NSIndexSet *)indexes withDeleteImageReferences:(NSArray<DeleteImageReference *> *)values;
- (void)addDeleteImageReferencesObject:(DeleteImageReference *)value;
- (void)removeDeleteImageReferencesObject:(DeleteImageReference *)value;
- (void)addDeleteImageReferences:(NSOrderedSet<DeleteImageReference *> *)values;
- (void)removeDeleteImageReferences:(NSOrderedSet<DeleteImageReference *> *)values;

- (void)insertObject:(CaptureImage *)value inImagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)idx;
- (void)insertImages:(NSArray<CaptureImage *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImagesAtIndex:(NSUInteger)idx withObject:(CaptureImage *)value;
- (void)replaceImagesAtIndexes:(NSIndexSet *)indexes withImages:(NSArray<CaptureImage *> *)values;
- (void)addImagesObject:(CaptureImage *)value;
- (void)removeImagesObject:(CaptureImage *)value;
- (void)addImages:(NSOrderedSet<CaptureImage *> *)values;
- (void)removeImages:(NSOrderedSet<CaptureImage *> *)values;

- (void)insertObject:(Rendition *)value inRenditionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRenditionsAtIndex:(NSUInteger)idx;
- (void)insertRenditions:(NSArray<Rendition *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRenditionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRenditionsAtIndex:(NSUInteger)idx withObject:(Rendition *)value;
- (void)replaceRenditionsAtIndexes:(NSIndexSet *)indexes withRenditions:(NSArray<Rendition *> *)values;
- (void)addRenditionsObject:(Rendition *)value;
- (void)removeRenditionsObject:(Rendition *)value;
- (void)addRenditions:(NSOrderedSet<Rendition *> *)values;
- (void)removeRenditions:(NSOrderedSet<Rendition *> *)values;

@end

NS_ASSUME_NONNULL_END
