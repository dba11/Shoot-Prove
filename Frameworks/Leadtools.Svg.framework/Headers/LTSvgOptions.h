//
//  LTSvgOptions.h
//  Leadtools.Svg
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSvgLoadOptions : NSObject

@property (nonatomic, assign) LTSvgLoadFlags loadFlags;

@property (nonatomic, assign) NSUInteger maximumElements;

@end



@interface LTSvgSaveOptions : NSObject

@property (nonatomic, assign) BOOL formatted;

@property (nonatomic, assign) LTSvgEncoding encoding;
@property (nonatomic, assign) LTSvgFormat format;

@property (nonatomic, copy)   NSString *indent;

@end



@interface LTSvgFlatOptions : NSObject

@property (nonatomic, assign) LeadSizeD size;

@property (nonatomic, assign) BOOL textOnly;

@end



@interface LTSvgRenderOptions : NSObject

@property (nonatomic, assign) BOOL useBackgroundColor;

@property (nonatomic, copy)   LTRasterColor *backgroundColor;

@property (nonatomic, assign) LeadRectD bounds;
@property (nonatomic, assign) LeadRectD clipBounds;
@property (nonatomic, assign) LeadMatrix transform;

@end



@class LTSvgDocument;
@interface LTSvgSortOptions : NSObject

@property (nonatomic, assign)           LTSvgSortFlags sortFlags;
@property (nonatomic, assign)           LTSvgExtractText extractText;

@property (nonatomic, strong, nullable) BOOL (^filterElements)(LTSvgDocument *document, LTSvgElementType elementType);

@end



@interface LTSvgMergeOptions : NSObject

@property (nonatomic, assign) LTSvgDropFlags destinationDropFlags;
@property (nonatomic, assign) LTSvgDropFlags sourceDropFlags;

@end



@interface LTSvgEnumerateOptions : NSObject

@property (nonatomic, assign) LTSvgEnumerateDirection enumerateDirection;

@end

NS_ASSUME_NONNULL_END