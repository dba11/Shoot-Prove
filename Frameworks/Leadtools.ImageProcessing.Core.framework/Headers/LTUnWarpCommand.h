//
//  LTUnWarpCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTUnWarpCommand : LTRasterCommand

@property (nonatomic, assign, nullable)           NSArray<NSValue *> *inPoints; //LeadPoint
@property (nonatomic, strong, readonly, nullable) LTRasterImage *outputImage;

- (instancetype)initWithInPoints:(nullable NSArray<NSValue *> *)inputPoints NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END