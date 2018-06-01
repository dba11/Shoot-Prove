//
//  LTCodecsRasterPdfInfo.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTCodecsDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsRasterPdfInfo : NSObject

@property (nonatomic, assign) BOOL isLeadPdf;

@property (nonatomic, assign) NSInteger bitsPerPixel;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger xResolution;
@property (nonatomic, assign) NSInteger yResolution;

@property (nonatomic, assign) LTRasterImageFormat format;
@property (nonatomic, assign) LTCodecsRasterPdfVersion version;

@end

NS_ASSUME_NONNULL_END