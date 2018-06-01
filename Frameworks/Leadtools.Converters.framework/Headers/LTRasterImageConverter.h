//
//  LTRasterImageConverter.h
//  Leadtools.Converters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTConvertersDefines.h"
#import "LTConvertToImageData.h"
#import "LTConvertFromImageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTRasterImageConverter : NSObject

+ (dispatch_queue_t)asyncQueue; // Default is Concurrent
+ (dispatch_group_t)asyncGroup;

+ (void)setAsyncQueue:(dispatch_queue_t)asyncQueue;
+ (void)setAsyncGroup:(dispatch_group_t)asyncGroup;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

+ (nullable UIImage *)convertToImage:(LTRasterImage *)image options:(LTConvertToImageOptions)options error:(NSError **)error;
+ (nullable CGImageRef)convertToCGImage:(LTRasterImage *)image options:(LTConvertToImageOptions)options error:(NSError **)error;

+ (void)convertToImageAsync:(LTRasterImage *)image options:(LTConvertToImageOptions)options completion:(void (^)(UIImage * __nullable image, NSError * __nullable error))completion;
+ (void)convertToCGImageAsync:(LTRasterImage *)image options:(LTConvertToImageOptions)options completion:(void (^)(CGImageRef __nullable image, NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

+ (nullable UIImage *)convertToImage:(LTRasterImage *)image data:(nullable LTConvertToImageData *)data error:(NSError **)error;
+ (nullable CGImageRef)convertToCGImage:(LTRasterImage *)image data:(nullable LTConvertToImageData *)data error:(NSError **)error;

+ (void)convertToImageAsync:(LTRasterImage *)image data:(nullable LTConvertToImageData *)data completion:(void (^)(UIImage * __nullable image, NSError * __nullable error))completion;
+ (void)convertToCGImageAsync:(LTRasterImage *)image data:(nullable LTConvertToImageData *)data completion:(void (^)(CGImageRef __nullable image, NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

+ (nullable LTRasterImage *)convertFromImage:(UIImage *)image options:(LTConvertFromImageOptions)options error:(NSError **)error;
+ (nullable LTRasterImage *)convertFromCGImage:(CGImageRef)image options:(LTConvertFromImageOptions)options error:(NSError **)error;

+ (void)convertFromImageAsync:(UIImage *)image options:(LTConvertFromImageOptions)options completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
+ (void)convertFromCGImageAsync:(CGImageRef)image options:(LTConvertFromImageOptions)options completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

+ (nullable LTRasterImage *)convertFromImage:(UIImage *)image data:(nullable LTConvertFromImageData *)data error:(NSError **)error;
+ (nullable LTRasterImage *)convertFromCGImage:(CGImageRef)image data:(nullable LTConvertFromImageData *)data error:(NSError **)error;

+ (void)convertFromImageAsync:(UIImage *)image data:(nullable LTConvertFromImageData *)data completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;
+ (void)convertFromCGImageAsync:(CGImageRef)image data:(nullable LTConvertFromImageData *)data completion:(void (^)(LTRasterImage * __nullable image, NSError * __nullable error))completion;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

+ (nullable UIImage *)getLinkedImage:(LTRasterImage *)image;
+ (nullable CGImageRef)getLinkedCGImage:(LTRasterImage *)image CF_RETURNS_NOT_RETAINED;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
