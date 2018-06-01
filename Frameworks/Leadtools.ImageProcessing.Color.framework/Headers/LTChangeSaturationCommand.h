//
//  LTChangeSaturationCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTChangeSaturationCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger change;

- (instancetype)initWithChange:(NSInteger)change NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END