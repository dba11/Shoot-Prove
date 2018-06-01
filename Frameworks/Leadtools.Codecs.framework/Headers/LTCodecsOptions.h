//
//  LTCodecsOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTCodecsGifOptions.h"
#import "LTCodecsJbigOptions.h"
#import "LTCodecsJbig2Options.h"
#import "LTCodecsJpegOptions.h"
#import "LTCodecsJpeg2000Options.h"
#import "LTCodecsPdfOptions.h"
#import "LTCodecsPngOptions.h"
#import "LTCodecsRawOptions.h"
#import "LTCodecsTiffOptions.h"
#import "LTCodecsRasterizeDocumentOptions.h"

@class LTCodecsOptions;

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsLoadOptions : NSObject

@property (nonatomic, assign) BOOL markers;
@property (nonatomic, assign) BOOL tags;
@property (nonatomic, assign) BOOL geoKeys;
@property (nonatomic, assign) BOOL comments;
@property (nonatomic, assign) BOOL allocateImage;
@property (nonatomic, assign) BOOL storeDataInImage;
@property (nonatomic, assign) BOOL allPages;
@property (nonatomic, assign) BOOL rotated;
@property (nonatomic, assign) BOOL isSigned;
@property (nonatomic, assign) BOOL initAlpha;
@property (nonatomic, assign) BOOL premultiplyAlpha;
@property (nonatomic, assign) BOOL fixedPalette;
@property (nonatomic, assign) BOOL noInterlace;
@property (nonatomic, assign) BOOL compressed;
@property (nonatomic, assign) BOOL superCompressed;
@property (nonatomic, assign) BOOL tiledMemory;
@property (nonatomic, assign) BOOL noTiledMemory;
@property (nonatomic, assign) BOOL diskMemory;
@property (nonatomic, assign) BOOL noDiskMemory;
@property (nonatomic, assign) BOOL loadCorrupted;

@property (nonatomic, assign) LTRasterImageFormat format;

@property (nonatomic, assign) uint64_t maximumConventionalMemorySize;

@property (nonatomic, copy, nullable) NSString *name;

@property (nonatomic, assign) NSInteger xResolution;
@property (nonatomic, assign) NSInteger yResolution;
@property (nonatomic, assign) NSInteger passes;

- (void)reset;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsSaveOptions : NSObject

@property (nonatomic, assign)                     BOOL markers;
@property (nonatomic, assign)                     BOOL tags;
@property (nonatomic, assign)                     BOOL geoKeys;
@property (nonatomic, assign)                     BOOL comments;
@property (nonatomic, assign)                     BOOL retrieveDataFromImage;
@property (nonatomic, assign)                     BOOL motorolaOrder;
@property (nonatomic, assign)                     BOOL fixedPalette;
@property (nonatomic, assign)                     BOOL optimizePalette;
@property (nonatomic, assign)                     BOOL grayOutput;
@property (nonatomic, assign)                     BOOL useImageDitheringMethod;
@property (nonatomic, assign)                     BOOL initAlpha;

@property (nonatomic, copy, nullable)             NSString *password;

@property (nonatomic, strong, readonly, nullable) NSArray<NSValue *> *resolutions; //CGSize
- (BOOL)setResolutions:(NSArray<NSValue *> *)resolutions; //CGSize

- (void)reset;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsOptions : NSObject <NSCopying>

@property (nonatomic, strong, readonly) LTCodecsLoadOptions *load;
@property (nonatomic, strong, readonly) LTCodecsSaveOptions *save;

@property (nonatomic, strong, readonly) LTCodecsGifOptions *gif;
@property (nonatomic, strong, readonly) LTCodecsJbigOptions *jbig;
@property (nonatomic, strong, readonly) LTCodecsJbig2Options *jbig2;
@property (nonatomic, strong, readonly) LTCodecsJpegOptions *jpeg;
@property (nonatomic, strong, readonly) LTCodecsJpeg2000Options *jpeg2000;
@property (nonatomic, strong, readonly) LTCodecsPdfOptions *pdf;
@property (nonatomic, strong, readonly) LTCodecsPngOptions *png;
@property (nonatomic, strong, readonly) LTCodecsRawOptions *raw;
@property (nonatomic, strong, readonly) LTCodecsTiffOptions *tiff;
@property (nonatomic, strong, readonly) LTCodecsRasterizeDocumentOptions *rasterizeDocument;

@end

NS_ASSUME_NONNULL_END