//
//  LTSvgDocument.h
//  Leadtools.Svg
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTSvgOptions.h"
#import "LTSvgElementInfo.h"
#import "LTSvgNodeHandle.h"
#import "LTSvgBounds.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSvgDocument : NSObject <ISvgDocument, NSCopying, NSCoding>

@property (nonatomic, assign, getter=isFlat) BOOL flat;

@property (nonatomic, assign)                LTSvgVersion version;

@property (nonatomic, assign, readonly)      BOOL isRenderOptimized;

- (nullable instancetype)initWithFile:(NSString *)file options:(nullable LTSvgLoadOptions *)options error:(NSError **)error;
- (nullable instancetype)initWithData:(NSData *)data options:(nullable LTSvgLoadOptions *)options error:(NSError **)error;
- (nullable instancetype)initWithStream:(LTLeadStream *)stream options:(nullable LTSvgLoadOptions *)options error:(NSError **)error;
- (instancetype)init __unavailable;

- (BOOL)saveToFile:(NSString *)file options:(nullable LTSvgSaveOptions *)options error:(NSError **)error;
- (BOOL)saveToData:(NSMutableData *)data options:(nullable LTSvgSaveOptions *)options error:(NSError **)error;
- (BOOL)saveToStream:(LTLeadStream *)stream options:(nullable LTSvgSaveOptions *)options error:(NSError **)error;



- (BOOL)flattenWithOptions:(nullable LTSvgFlatOptions *)options error:(NSError **)error;
- (nullable instancetype)flatCopyWithOptions:(nullable LTSvgFlatOptions *)options error:(NSError **)error;



- (BOOL)resize:(double)scaleFactor error:(NSError **)error;

- (BOOL)addElementIDs:(NSError **)error;
- (BOOL)calculateBounds:(BOOL)trimmed error:(NSError **)error;

- (nullable LTSvgBounds *)bounds:(NSError **)error;
- (BOOL)setBounds:(LTSvgBounds *)bounds error:(NSError **)error;



- (void)beginUpdate;
- (void)endUpdate;

- (BOOL)beginRenderOptimize:(NSError **)error;
- (BOOL)endRenderOptimize:(NSError **)error;



- (BOOL)rasterizeToImage:(LTRasterImage *)image options:(nullable LTSvgRenderOptions *)options erorr:(NSError **)error;

- (BOOL)sortElementsWithOptions:(nullable LTSvgSortOptions *)options userData:(nullable id)userData callback:(BOOL (^)(LTSvgDocument *document, LTSvgElementInfo *info, id _Nullable userData))callback error:(NSError **)error;
- (BOOL)enumerateElementsWithOptions:(nullable LTSvgEnumerateOptions *)options userData:(nullable id)userData callback:(BOOL (^)(LTSvgDocument *document, LTSvgNodeHandle *node, id _Nullable userData))callback error:(NSError **)error;

- (BOOL)optimizeView:(NSError **)error;

- (BOOL)hasElement:(LTSvgElementType)elementType;

- (BOOL)mergeWithDocument:(LTSvgDocument *)document options:(nullable LTSvgMergeOptions *)options error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END