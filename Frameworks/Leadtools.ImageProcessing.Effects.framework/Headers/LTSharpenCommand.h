//
//  LTSharpenCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTSharpenCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger sharpness;

- (instancetype)initWithSharpness:(NSInteger)sharpness NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END