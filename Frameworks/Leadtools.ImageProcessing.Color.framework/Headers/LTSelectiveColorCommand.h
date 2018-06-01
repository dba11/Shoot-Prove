//
//  LTSelectiveColorCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTSelectiveCommandColorTypes) {
    LTSelectiveCommandColorTypesRed     = 0x00000000,
    LTSelectiveCommandColorTypesYellow  = 0x00000001,
    LTSelectiveCommandColorTypesGreen   = 0x00000002,
    LTSelectiveCommandColorTypesCyan    = 0x00000003,
    LTSelectiveCommandColorTypesBlue    = 0x00000004,
    LTSelectiveCommandColorTypesMagenta = 0x00000005,
    LTSelectiveCommandColorTypesWhite   = 0x00000006,
    LTSelectiveCommandColorTypesNeutral = 0x00000007,
    LTSelectiveCommandColorTypesBlack   = 0x00000008,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTSelectiveColorCommandData : NSObject

@property (nonatomic, assign) char cyan;
@property (nonatomic, assign) char magenta;
@property (nonatomic, assign) char yellow;
@property (nonatomic, assign) char black;

- (instancetype)initWithCyan:(char)cyan magenta:(char)magenta yellow:(char)yellow black:(char)black NS_DESIGNATED_INITIALIZER;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTSelectiveColorCommand : LTRasterCommand

@property (nonatomic, strong) NSMutableArray<LTSelectiveColorCommandData *> *colorsData;

- (instancetype)initWithColorsData:(NSArray<LTSelectiveColorCommandData *> *)colorsData NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END