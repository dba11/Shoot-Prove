//
//  LTOcrPageCharacters.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrZoneCharacters.h"

@class LTOcrPage;

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrPageCharacters : NSObject <NSFastEnumeration>

@property (nonatomic, strong, readonly) LTOcrPage *page;

@property (nonatomic, assign, readonly) NSUInteger count;



- (void)addObject:(LTOcrZoneCharacters *)object;
- (void)insertObject:(LTOcrZoneCharacters *)object atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(LTOcrZoneCharacters *)object;

- (void)removeLastObject;
- (void)removeAllObjects;
- (void)removeObjectAtIndex:(NSUInteger)index;

- (LTOcrZoneCharacters *)objectAtIndex:(NSUInteger)index;

- (LTOcrZoneCharacters *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(LTOcrZoneCharacters *)object atIndexedSubscript:(NSUInteger)index;

- (void)enumerateObjectsUsingBlock:(void (^)(LTOcrZoneCharacters *characters, NSUInteger idx, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END