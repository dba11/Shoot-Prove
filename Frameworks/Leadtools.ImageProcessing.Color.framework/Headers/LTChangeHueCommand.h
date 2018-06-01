//
//  LTChangeHueCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTChangeHueCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger angle;

- (instancetype)initWithAngle:(NSInteger)angle NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END