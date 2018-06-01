//
//  LTColorMergeCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTColorMergeCommandType) {
    LTColorMergeCommandTypeRgb   = 0x0000,
    LTColorMergeCommandTypeCmyk  = 0x0001,
    LTColorMergeCommandTypeHsv   = 0x0002,
    LTColorMergeCommandTypeHls   = 0x0003,
    LTColorMergeCommandTypeCmy   = 0x0004,
    LTColorMergeCommandTypeYuv   = 0x0005,
    LTColorMergeCommandTypeXyz   = 0x0006,
    LTColorMergeCommandTypeLab   = 0x0007,
    LTColorMergeCommandTypeYcrCb = 0x0008,
    LTColorMergeCommandTypeSct   = 0x0009,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTColorMergeCommand : LTRasterCommand

@property (nonatomic, assign)                     LTColorMergeCommandType type;
@property (nonatomic, strong, readonly, nullable) LTRasterImage *destinationImage;

- (instancetype)initWithType:(LTColorMergeCommandType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END