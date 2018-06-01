//
//  LTColorizeGrayCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTColorizeGrayCommandData : NSObject

@property (nonatomic, strong) const LTRasterColor *color;
@property (nonatomic, assign) NSUInteger threshold;

- (instancetype)initWithColor:(const LTRasterColor *)color threshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTColorizeGrayCommand : LTRasterCommand

@property (nonatomic, strong, readonly, nullable) LTRasterImage *destinationImage;
@property (nonatomic, strong)                     NSMutableArray<LTColorizeGrayCommandData *> *grayColors;

- (instancetype)initWithGrayColors:(NSArray<LTColorizeGrayCommandData *> *)grayColors NS_DESIGNATED_INITIALIZER;

@end


NS_ASSUME_NONNULL_END