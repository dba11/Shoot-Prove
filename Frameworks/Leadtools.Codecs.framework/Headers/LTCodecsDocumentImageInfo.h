//
//  LTCodecsDocumentImageInfo.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTCodecsDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsDocumentImageInfo : NSObject

@property (nonatomic, assign, readonly) BOOL isDocumentFile;

@property (nonatomic, assign, readonly) double pageWidth;
@property (nonatomic, assign, readonly) double pageHeight;

@property (nonatomic, assign, readonly) LTCodecsRasterizeDocumentUnit unit;

@end

NS_ASSUME_NONNULL_END