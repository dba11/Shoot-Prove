//
//  LTAnnObservableCollection.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies Inc 1991-2016, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTCollectionChange) {
    LTCollectionChangeAdd,
    LTCollectionChangeRemove,
    LTCollectionChangeClear,
};

NS_ASSUME_NONNULL_BEGIN

extern NSString *const LTAnnObservableCollectionChangeNotification;
extern NSString *const LTAnnObservableCollectionKey;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnCollectionChanges : NSObject

@property (nonatomic, strong, readonly) NSArray *objects;
@property (nonatomic, strong, readonly) NSIndexSet *indices;

@property (nonatomic, assign, readonly) LTCollectionChange change;

- (instancetype)init __unavailable;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnObservableCollection : NSObject <NSCopying, NSCoding, NSFastEnumeration>

@property (nonatomic, assign, readonly) NSUInteger count;

- (void)clear;
- (void)clear:(BOOL)keepCapacity;
- (void)addObject:(id)object;
- (void)addObjects:(NSArray *)objects;
- (BOOL)contains:(id)object;
- (void)moveFrom:(NSUInteger)oldIndex to:(NSUInteger)newIndex;
- (NSUInteger)countOfCollection;
- (NSArray *)toArray;
- (id)objectAtIndex:(NSUInteger)index;

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;

- (id)objectInCollectionAtIndex:(NSUInteger)index;
- (NSArray *)objectsInCollectionAtIndexes:(NSIndexSet *)indexes;
- (void)getCollection:(id __unsafe_unretained [])objects range:(NSRange)range;
- (void)insertObject:(id)object inCollectionAtIndex:(NSUInteger)index;
- (void)insertObjects:(NSArray *)objects inCollectionAtIndexes:(NSIndexSet *)indexes;

- (void)removeObjectFromCollectionAtIndex:(NSUInteger)index;
- (void)removeCollectionAtIndexes:(NSIndexSet *)indexes;

- (void)replaceObjectInCollectionAtIndex:(NSUInteger)index withObject:(id)object;
- (void)replaceCollectionAtIndexes:(NSIndexSet *)indexes withCollection:(NSArray *)objects;

- (void)exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2;
- (void)removeObjectInCollection:(id)object;

- (NSUInteger)indexOf:(id)object;
- (void)sendToBack:(id)object last:(BOOL)last;
- (void)bringToFront:(id)object first:(BOOL)first;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnObservableCollection(Deprecated)

- (id)at:(NSUInteger)index LT_DEPRECATED_USENEW(19_0, "objectAtIndex:");

@end

NS_ASSUME_NONNULL_END

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */