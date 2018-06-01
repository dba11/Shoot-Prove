//
//  LTAlphaBlendCommand.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTAlphaBlendCommand : LTRasterCommand

@property (nonatomic, strong, nullable) LTRasterImage *sourceImage;
@property (nonatomic, assign)           LeadRect destinationRectangle;
@property (nonatomic, assign)           LeadPoint sourcePoint;
@property (nonatomic, assign)           NSInteger opacity;

- (instancetype)initWithSourceImage:(LTRasterImage *)sourceImage sourcePoint:(LeadPoint)sourcePoint destinationRect:(LeadRect)destinationRect opacity:(NSInteger)opacity NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END