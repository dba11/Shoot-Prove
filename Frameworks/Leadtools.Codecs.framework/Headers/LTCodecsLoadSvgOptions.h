//
//  LTCodecsLoadSvgOptions.h
//  Leadtools.Codecs
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTCodecsLoadSvgOptions : NSObject <NSCopying>

@property (nonatomic, assign) BOOL allowPolylineText;
@property (nonatomic, assign) BOOL dropShapes;
@property (nonatomic, assign) BOOL dropImages;
@property (nonatomic, assign) BOOL dropText;
@property (nonatomic, assign) BOOL forConversion;
@property (nonatomic, assign) BOOL ignoreXmlParsingErrors;

@end

NS_ASSUME_NONNULL_END