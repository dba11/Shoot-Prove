//
//  LTCodecsTiffOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTCodecsDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsTiffLoadOptions : NSObject

@property (nonatomic, assign) BOOL ignoreViewPerspective;
@property (nonatomic, assign) BOOL ignorePhotometricInterpretation;
@property (nonatomic, assign) BOOL ignoreAdobeColorTransform;

@property (nonatomic, assign, getter=usesFastConversion) BOOL useFastConversion;
@property (nonatomic, assign, getter=usesImageFileDirectoryOffset) BOOL useImageFileDirectoryOffset;

@property (nonatomic, assign) unsigned long imageFileDirectoryOffset;

@property (nonatomic, assign) LeadSize j2kResolution;

@end


@interface LTCodecsTiffSaveOptions : NSObject

@property (nonatomic, assign) BOOL noSubFileType;
@property (nonatomic, assign) BOOL noPageNumber;
@property (nonatomic, assign) BOOL noPalette;
@property (nonatomic, assign) BOOL noLzwAutoClear;

@property (nonatomic, assign, getter=usesTileSize) BOOL useTileSize;
@property (nonatomic, assign, getter=usesPredictor) BOOL usePredictor;
@property (nonatomic, assign, getter=usesImageFileDirectoryOffset) BOOL useImageFileDirectoryOffset;
@property (nonatomic, assign, getter=usesPhotometricInterpretation) BOOL usePhotometricInterpretation;

@property (nonatomic, assign) BOOL preservePalette;
@property (nonatomic, assign) BOOL savePlanar;
@property (nonatomic, assign) BOOL bigTiff;

@property (nonatomic, assign) unsigned long imageFileDirectoryOffset;
@property (nonatomic, assign) NSUInteger tileWidth;
@property (nonatomic, assign) NSUInteger tileHeight;

@property (nonatomic, assign) LTCodecsTiffPhotometricInterpretation photometricInterpretation;

@end


@interface LTCodecsTiffOptions : NSObject

@property (nonatomic, strong, readonly) LTCodecsTiffLoadOptions *load;
@property (nonatomic, strong, readonly) LTCodecsTiffSaveOptions *save;

@end

NS_ASSUME_NONNULL_END