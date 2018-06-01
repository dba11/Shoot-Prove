//
//  LTAlignImagesCommand.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LTRegistrationOptions) {
    LTRegistrationOptionsUnknown      = 0x00000000,
    LTRegistrationOptionsXY           = 0x00000001,
    LTRegistrationOptionsRSXY         = 0x00000002,
    LTRegistrationOptionsAffine6      = 0x00000003,
    LTRegistrationOptionsPerspective  = 0x00000004,
};

NS_ASSUME_NONNULL_BEGIN

@interface LTAlignImagesCommand : LTRasterCommand

@property (nonatomic, strong, readonly, nullable) LTRasterImage *registeredImage;
@property (nonatomic, strong, nullable)           LTRasterImage *templateImage;
@property (nonatomic, strong, nullable)           NSArray<NSValue *> *referenceImagePoints; //LeadPoint
@property (nonatomic, strong, nullable)           NSArray<NSValue *> *templateImagePoints; //LeadPoint
@property (nonatomic, assign)                     LTRegistrationOptions registrationMethod;

@end

NS_ASSUME_NONNULL_END