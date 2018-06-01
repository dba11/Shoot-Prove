//
//  LTAdjustTintCommand.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTAdjustTintCommand : LTRasterCommand

@property (nonatomic, assign) NSInteger angleA;
@property (nonatomic, assign) NSInteger angleB;

- (instancetype)initWithAngleA:(NSInteger)angleA angleB:(NSInteger)angleB NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END