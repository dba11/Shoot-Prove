//
//  LTWindowLevelExtCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@interface LTWindowLevelExtCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger lowBit;
@property (nonatomic, assign) NSInteger highBit;
@property (nonatomic, assign) LTRasterByteOrder order;
@property (nonatomic, strong) NSMutableArray<LTRasterColor16 *> *lookupTable;

- (instancetype)initWithLookupTable:(NSArray<LTRasterColor16 *> *)lookupTable lowBit:(NSInteger)lowBit highBit:(NSInteger)highBit order:(LTRasterByteOrder)order NS_DESIGNATED_INITIALIZER;

@end
