//
//  LTFeatherAlphaBlendCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTFeatherAlphaBlendCommand : LTRasterCommand

@property (nonatomic, strong, nullable) LTRasterImage *sourceImage;
@property (nonatomic, strong, nullable) LTRasterImage *maskImage;
@property (nonatomic, assign)           LeadRect destinationRectangle;
@property (nonatomic, assign)           LeadPoint sourcePoint;
@property (nonatomic, assign)           LeadPoint maskSourcePoint;

- (instancetype)initWithSourceImage:(LTRasterImage *)sourceImage sourcePoint:(LeadPoint)sourcePoint destinationRectangle:(LeadRect)destinationRectangle maskImage:(LTRasterImage *)maskImage maskSourcePoint:(LeadPoint)maskSourcePoint NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSourceImage:(LTRasterImage *)sourceImage sourcePoint:(LeadPoint)sourcePoint destinationRectangle:(LeadRect)destinationRectangle maskImage:(LTRasterImage *)maskImage;

@end

NS_ASSUME_NONNULL_END