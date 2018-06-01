//
//  LTPosterizeCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTPosterizeCommand : LTRasterCommand

@property (nonatomic, assign) NSUInteger levels;

- (instancetype)initWithLevels:(NSUInteger)levels NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END