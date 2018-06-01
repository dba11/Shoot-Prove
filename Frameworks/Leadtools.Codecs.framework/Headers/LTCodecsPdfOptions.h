//
//  LTCodecsPdfOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTCodecsDefines.h"

typedef NS_ENUM(NSInteger, LTCodecsPdfTextEncoding) {
    LTCodecsPdfTextEncodingNone,
    LTCodecsPdfTextEncodingBase85,
    LTCodecsPdfTextEncodingHex
};

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsPdfLoadOptions : NSObject

@property (nonatomic, assign)         BOOL useLibFonts;
@property (nonatomic, assign)         BOOL disableCropping;
@property (nonatomic, assign)         BOOL disableCieColors;
@property (nonatomic, assign)         BOOL enableInterpolate;

@property (nonatomic, assign)         NSInteger displayDepth;
@property (nonatomic, assign)         NSInteger textAlpha;
@property (nonatomic, assign)         NSInteger graphicsAlpha;

@property (nonatomic, copy, nullable) NSString *password;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsPdfSaveOptions : NSObject

@property (nonatomic, assign)         BOOL use128BitEncryption;
@property (nonatomic, assign)         BOOL printDocument;
@property (nonatomic, assign)         BOOL printFaithful;
@property (nonatomic, assign)         BOOL modifyDocument;
@property (nonatomic, assign)         BOOL extractText;
@property (nonatomic, assign)         BOOL extractTextGraphics;
@property (nonatomic, assign)         BOOL modifyAnnotation;
@property (nonatomic, assign)         BOOL fillForm;
@property (nonatomic, assign)         BOOL assembleDocument;
@property (nonatomic, assign)         BOOL lowMemoryUsage;
@property (nonatomic, assign)         BOOL useImageResolution;

@property (nonatomic, copy, nullable) NSString *userPassword;
@property (nonatomic, copy, nullable) NSString *ownerPassword;

@property (nonatomic, assign)         LTCodecsPdfTextEncoding textEncoding;
@property (nonatomic, assign)         LTCodecsRasterPdfVersion version;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsPdfOptions : NSObject

@property (nonatomic, strong, readonly) LTCodecsPdfLoadOptions *load;
@property (nonatomic, strong, readonly) LTCodecsPdfSaveOptions *save;

@end

NS_ASSUME_NONNULL_END