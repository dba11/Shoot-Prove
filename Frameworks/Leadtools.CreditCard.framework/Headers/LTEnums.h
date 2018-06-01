//
//  LTEnums.h
//  Leadtools.CreditCard
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, LTCardType) {
    LTCardTypeUnknown,
    LTCardTypeInsufficientDigits,
    LTCardTypeAmericanExpress,
    LTCardTypeDinersClub,
    LTCardTypeDiscover,
    LTCardTypeJCB,
    LTCardTypeMasterCard,
    LTCardTypeVisa,
    LTCardTypeMaestro,
};

typedef NS_ENUM(NSInteger, LTFrameOrientation) {
    LTFrameOrientationPortrait,
    LTFrameOrientationPortraitUpsideDown,
    LTFrameOrientationLandscapeLeft,
    LTFrameOrientationLandscapeRight,
};

typedef NS_ENUM(NSInteger, LTScanFrameStatus) {
    LTScanFrameStatusMoreFramesNeeded,
    LTScanFrameStatusNumbersFound,
    LTScanFrameStatusLowFocusScore,
    LTScanFrameStatusError,
};

typedef NS_ENUM(NSInteger, LTImageFormat) {
    LTImageFormatYUV420,
    LTImageFormatYCbCr420,
    LTImageFormatYCrCb420,
    LTImageFormatRGB8888,
    LTImageFormatBGR8888,
    LTImageFormatRGB888,
    LTImageFormatBGR888,
};