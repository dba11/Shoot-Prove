//
//  LTOcrZoneCollection.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrZoneCell.h"
#import "LTOcrZone.h"

@class LTOcrPage;

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrZoneCollection : NSObject <NSFastEnumeration>

@property (nonatomic, assign, readonly) NSUInteger count;

- (instancetype)init __unavailable;

- (void)addObject:(LTOcrZone *)object;
- (void)insertObject:(LTOcrZone *)object atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(LTOcrZone *)object;

- (void)removeLastObject;
- (void)removeAllObjects;
- (void)removeObjectAtIndex:(NSUInteger)index;

- (LTOcrZone *)objectAtIndex:(NSUInteger)index;

- (LTOcrZone *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(LTOcrZone *)object atIndexedSubscript:(NSUInteger)index;

- (void)enumerateObjectsUsingBlock:(void (^)(LTOcrZone *zone, NSUInteger idx, BOOL *stop))block;

- (nullable NSArray<LTOcrZoneCell *> *)zoneCellsAtIndex:(NSUInteger)index error:(NSError **)error;
- (BOOL)setZoneCells:(NSArray<LTOcrZoneCell *> *)zoneCells atIndex:(NSUInteger)index error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END