//
//  LTLeadPointCollection.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTLeadPointCollection : NSObject <NSCoding, NSCopying, NSFastEnumeration>

@property (nonatomic, assign, readonly) NSUInteger count;

+ (instancetype)collection;
+ (instancetype)collectionWithCapacity:(NSUInteger)capacity;
+ (instancetype)collectionWithPoints:(LeadPointD *)array length:(NSUInteger)length;
+ (instancetype)collectionWithNSArray:(NSArray<NSValue *> *)array;
+ (instancetype)collectionWithPoints:(NSUInteger)amount, ...;

- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (instancetype)initWithPoints:(LeadPointD *)array length:(NSUInteger)length;
- (instancetype)initWithNSArray:(NSArray<NSValue *> *)array;
- (instancetype)initWithPoints:(NSUInteger)amount, ...;

- (void)clear;
- (void)clear:(BOOL)keepCapacity;
- (void)addPoint:(LeadPointD)point;
- (void)addCollectionPoints:(LTLeadPointCollection*)annCollection;
- (BOOL)containsPoint:(LeadPointD)point;
- (void)moveFrom:(NSUInteger)oldIndex to:(NSUInteger)newIndex;
- (void)setPoint:(LeadPointD)point atIndex:(NSUInteger)index;
- (void)insertPoint:(LeadPointD)point atIndex:(NSUInteger)index;
- (LeadPointD)pointAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfPoint:(LeadPointD)point;
- (void)removePointAtIndex:(NSUInteger)index;

- (NSUInteger)countOfCollection;
- (NSValue *)objectInCollectionAtIndex:(NSUInteger)index;
- (NSArray<NSValue *> *)objectsInCollectionAtIndexes:(NSIndexSet *)indexes;
- (void)getCollection:(NSValue *__unsafe_unretained [])objects range:(NSRange)range;
  
- (void)insertObject:(NSValue *)object inCollectionAtIndex:(NSUInteger)index;
- (void)insertObjects:(NSArray<NSValue *> *)objects inCollectionAtIndexes:(NSIndexSet *)indexes;

- (void)removeObjectFromCollectionAtIndex:(NSUInteger)index;
- (void)removeCollectionAtIndexes:(NSIndexSet *)indexes;

- (void)replaceObjectInCollectionAtIndex:(NSUInteger)index withObject:(NSValue *)object;
- (void)replaceCollectionAtIndexes:(NSIndexSet *)indexes withCollection:(NSArray<NSValue *> *)objects;

- (void)removeObjectInCollection:(id)object;


@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTLeadPointCollection (Deprecated)

- (LeadPointD)at:(NSUInteger)index LT_DEPRECATED_USENEW(19_0, "pointAtIndex:");
- (void)removeAt:(NSUInteger)index LT_DEPRECATED_USENEW(19_0, "removePointAtIndex:");

@end

NS_ASSUME_NONNULL_END