//
//  LTWindowLevelCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTWindowLevelCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger lowBit;
@property (nonatomic, assign) NSInteger highBit;
@property (nonatomic, assign) LTRasterByteOrder order;
@property (nonatomic, strong) NSMutableArray<LTRasterColor *> *lookupTable;

- (instancetype)initWithLookupTable:(NSArray<LTRasterColor *> *)lookupTable lowBit:(NSInteger)lowBit highBit:(NSInteger)highBit order:(LTRasterByteOrder)order NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END