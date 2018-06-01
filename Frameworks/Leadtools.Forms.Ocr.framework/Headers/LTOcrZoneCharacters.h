//
//  LTOcrZoneCharacters.h
//  Leadtools.Forms.Ocr
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTOcrMicrData.h"
#import "LTOcrCharacter.h"
#import "LTOcrWord.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTOcrZoneCharacters : NSObject <NSFastEnumeration>

@property (nonatomic, assign, readonly)         NSUInteger count;
@property (nonatomic, assign, readonly)         NSUInteger zoneIndex;
@property (nonatomic, copy, readonly, nullable) NSArray<LTOcrWord *> *words;


- (nullable LTOcrMicrData *)extractMicrData;

- (void)addObject:(LTOcrCharacter *)object;
- (void)insertObject:(LTOcrCharacter *)object atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(LTOcrCharacter *)object;

- (void)removeLastObject;
- (void)removeAllObjects;
- (void)removeObjectAtIndex:(NSUInteger)index;

- (LTOcrCharacter *)objectAtIndex:(NSUInteger)index;

- (LTOcrCharacter *)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(LTOcrCharacter *)object atIndexedSubscript:(NSUInteger)index;

- (void)enumerateObjectsUsingBlock:(void (^)(LTOcrCharacter *character, NSUInteger idx, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END