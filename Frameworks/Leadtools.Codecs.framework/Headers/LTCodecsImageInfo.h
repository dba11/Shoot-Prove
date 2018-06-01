//
//  LTCodecsImageInfo.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTCodecsGifImageInfo.h"
#import "LTCodecsFaxImageInfo.h"
#import "LTCodecsJpegImageInfo.h"
#import "LTCodecsTiffImageInfo.h"
#import "LTCodecsDocumentImageInfo.h"

typedef NS_ENUM(NSInteger, LTCodecsColorSpaceType) {
    LTCodecsColorSpaceTypeBgr      = 0,
    LTCodecsColorSpaceTypeYuv      = 1,
    LTCodecsColorSpaceTypeCmyk     = 2,
    LTCodecsColorSpaceTypeCieLab   = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsImageInfo : NSObject <NSCopying>

@property (nonatomic, assign, readonly)           BOOL hasResolution;
@property (nonatomic, assign, readonly)           BOOL hasAlpha;
@property (nonatomic, assign, readonly)           BOOL isRotated;
@property (nonatomic, assign, readonly)           BOOL isSigned;
@property (nonatomic, assign, readonly)           BOOL isLoading;

@property (nonatomic, assign, readonly)           NSInteger width;
@property (nonatomic, assign, readonly)           NSInteger height;
@property (nonatomic, assign, readonly)           NSInteger bitsPerPixel;
@property (nonatomic, assign, readonly)           NSInteger bytesPerLine;
@property (nonatomic, assign, readonly)           NSInteger totalPages;
@property (nonatomic, assign, readonly)           NSInteger xResolution;
@property (nonatomic, assign, readonly)           NSInteger yResolution;
@property (nonatomic, assign, readonly)           NSInteger pageNumber;

@property (nonatomic, assign, readonly)           unsigned long sizeDisk;
@property (nonatomic, assign, readonly)           unsigned long sizeMemory;

@property (nonatomic, assign, readonly)           LTRasterViewPerspective viewPerspective;
@property (nonatomic, assign, readonly)           LTRasterByteOrder order;
@property (nonatomic, assign, readonly)           LTCodecsColorSpaceType colorSpace;
@property (nonatomic, assign, readonly)           LTRasterImageFormat format;

@property (nonatomic, copy, readonly, nullable)   NSString *name;
@property (nonatomic, copy, readonly, nullable)   NSString *compression;

@property (nonatomic, strong, readonly, nullable) NSArray<LTRasterColor *> *palette;

@property (nonatomic, strong, readonly)           LTCodecsGifImageInfo *gif;
@property (nonatomic, strong, readonly)           LTCodecsFaxImageInfo *fax;
@property (nonatomic, strong, readonly)           LTCodecsJpegImageInfo *jpeg;
@property (nonatomic, strong, readonly)           LTCodecsTiffImageInfo *tiff;
@property (nonatomic, strong, readonly)           LTCodecsDocumentImageInfo *document;

@end

NS_ASSUME_NONNULL_END