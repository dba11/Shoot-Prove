//
//  LTCodecsJpegOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTCodecsCmpQualityFactorPredefined) {
    LTCodecsCmpQualityFactorPredefinedPerfectQuality1      = -1,
    LTCodecsCmpQualityFactorPredefinedPerfectQuality2      = -2,
    LTCodecsCmpQualityFactorPredefinedSuperQuality         = -3,
    LTCodecsCmpQualityFactorPredefinedQuality              = -4,
    LTCodecsCmpQualityFactorPredefinedQualityAndSize       = -5,
    LTCodecsCmpQualityFactorPredefinedSharp                = -6,
    LTCodecsCmpQualityFactorPredefinedLessTiling           = -7,
    LTCodecsCmpQualityFactorPredefinedMaximumQuality       = -8,
    LTCodecsCmpQualityFactorPredefinedMaximumCompression   = -9,
    LTCodecsCmpQualityFactorPredefinedCustom               = -10
};

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsJpegLoadOptions : NSObject

@property (nonatomic, assign) BOOL forceCieLab;
@property (nonatomic, assign) BOOL useBadJpegPredictor;
@property (nonatomic, assign) BOOL forceRgbFile;
@property (nonatomic, assign) BOOL useFastConversion;
@property (nonatomic, assign) BOOL ignoreAdobeColorTransform;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsJpegSaveOptions : NSObject

@property (nonatomic, assign) LTCodecsCmpQualityFactorPredefined cmpQualityFactorPredefined;

@property (nonatomic, assign) NSInteger qualityFactor;
@property (nonatomic, assign) NSInteger passes;

@property (nonatomic, assign) NSUInteger stampWidth;
@property (nonatomic, assign) NSUInteger stampHeight;
@property (nonatomic, assign) NSUInteger stampBitsPerPixel;

@property (nonatomic, assign) BOOL yccStamp;
@property (nonatomic, assign) BOOL jpegStamp;
@property (nonatomic, assign) BOOL saveWithStamp;
@property (nonatomic, assign) BOOL fixedPaletteStamp;
@property (nonatomic, assign) BOOL saveWithoutTimestamp;
@property (nonatomic, assign) BOOL saveOldJtif;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsJpegOptions : NSObject

@property (nonatomic, strong, readonly) LTCodecsJpegLoadOptions *load;
@property (nonatomic, strong, readonly) LTCodecsJpegSaveOptions *save;

@end

NS_ASSUME_NONNULL_END