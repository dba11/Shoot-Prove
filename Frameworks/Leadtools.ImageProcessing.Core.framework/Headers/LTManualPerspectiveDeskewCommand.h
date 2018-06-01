//
//  LTManualPerspectiveDeskewCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTManualPerspectiveDeskewCommand : LTRasterCommand

@property (nonatomic, assign, nullable)           NSArray<NSValue *> *inputPoints; //LeadPoint
@property (nonatomic, assign, nullable)           NSArray<NSValue *> *mappingPoints; //LeadPoint

@property (nonatomic, strong, readonly, nullable) LTRasterImage *outputImage;

- (instancetype)initWithInPoints:(nullable NSArray<NSValue *> *)inputPoints mappingPoints:(nullable NSArray<NSValue *> *)mappingPoints NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END