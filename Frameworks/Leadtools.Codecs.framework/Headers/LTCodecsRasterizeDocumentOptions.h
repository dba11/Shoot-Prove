//
//  LTCodecsRasterizeDocumentOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTCodecsDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsRasterizeDocumentLoadOptions : NSObject

@property (nonatomic, assign) NSUInteger xResolution;
@property (nonatomic, assign) NSUInteger yResolution;

@property (nonatomic, assign) double pageWidth;
@property (nonatomic, assign) double pageHeight;
@property (nonatomic, assign) double leftMargin;
@property (nonatomic, assign) double topMargin;
@property (nonatomic, assign) double rightMargin;
@property (nonatomic, assign) double bottomMargin;

@property (nonatomic, assign) LTCodecsRasterizeDocumentUnit unit;
@property (nonatomic, assign) LTCodecsRasterizeDocumentSizeMode sizeMode;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTCodecsRasterizeDocumentOptions : NSObject

@property (nonatomic, strong, readonly) LTCodecsRasterizeDocumentLoadOptions *load;

@end

NS_ASSUME_NONNULL_END