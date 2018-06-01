/*************************************************************************
 *
 * SHOOT&PROVE CONFIDENTIAL
 * __________________
 *
 *  [2016]-[2018] Shoot&Prove SA/NV
 *  www.shootandprove.com
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property
 * of Shoot&Prove SA/NV. The intellectual and technical concepts contained
 * herein are proprietary to Shoot&Prove SA/NV.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Shoot&Prove SA/NV.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Leadtools/Leadtools.h>
#import <Leadtools.Converters/Leadtools.Converters.h>
#import <Leadtools.ImageProcessing.Core/Leadtools.ImageProcessing.Core.h>
#import <Leadtools.ImageProcessing.Color/Leadtools.ImageProcessing.Color.h>
#import <Leadtools.Codecs/Leadtools.Codecs.h>
#import "EnumHelper.h"

@class CaptureImage;
@interface ImageHelper : NSObject
+ (CGSize)formatSize:(SPFormat)format orientation:(UIInterfaceOrientation)orientation resolution:(int)resolution;
+ (UIImage *)resizeImage:(UIImage *)image proportionalToSize:(CGSize)size;
+ (UIImage *)rotateImage:(UIImage *)image degrees:(CGFloat)degrees;
+ (UIImage *)grayishImage:(UIImage *)image;
+ (UIImage *)thumbnailImage:(UIImage *)image;
+ (void)createPDFWithSubTasks:(NSArray *)subTasks filePath:(NSString *)filePath;
#pragma - core image processing
+ (CIImage *)drawHighlightOverlayForRectangle:(CIImage *)image rectangle:(CIRectangleFeature *)rectangle colorMode:(SPColorMode)colorMode;
+ (CIImage *)filteredImageUsingBlackAndWhiteFilterOnImage:(CIImage *)image;
+ (CIImage *)filteredImageUsingGreyFilterOnImage:(CIImage *)image;
+ (CIImage *)filteredImageUsingColorFilterOnImage:(CIImage *)image;
+ (CIDetector *)rectangleDetectorMinFeatureSize:(CGFloat)minFeatureSize AspectRatio:(CGFloat)aspectRatio;
+ (CIRectangleFeature *)biggestRectangleInRectangles:(NSArray *)rectangles;
+ (CIImage *)correctPerspectiveForImage:(CIImage *)image withFeatures:(CIRectangleFeature *)rectangleFeature;
#pragma - leadtools license validation method
+ (NSError *)activateLeadToolsLicense;
#pragma - leadtools functions
+ (LTRasterImage *)rasterImageFromUIImage:(UIImage *)image error:(NSError **)error;
+ (LTRasterImage *)rasterImageFromCIImage:(CIImage *)image error:(NSError **)error;
+ (LTRasterImage *)rasterImageFromData:(NSData *)data error:(NSError **)error;
+ (LTRasterImage *)rasterImageFromPath:(NSString *)path error:(NSError **)error;
+ (LTRasterImage *)correctImageRotation:(LTRasterImage *)rasterImage interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation error:(NSError **)error;
+ (void)rotateRightRasterImage:(LTRasterImage *)rasterImage error:(NSError **)error;
+ (BOOL)resizeImage:(LTRasterImage *)rasterImage toSize:(CGSize)size allowStretch:(BOOL)allowStretch error:(NSError **)error;
+ (LeadRect)rectangleFromGuideRect:(CGRect)guideRect inPreviewRect:(CGRect)previewRect overRasterImage:(LTRasterImage *)rasterImage;
+ (LeadRect)rectangleFromImage:(LTRasterImage *)rasterImage reducedOfPixels:(NSInteger)numberOfPixels;
+ (void)autoColorImage:(LTRasterImage *)rasterImage error:(NSError **)error;
+ (void)reduceColorResolutionImage:(LTRasterImage *)rasterImage bitsPerPixel:(NSInteger)bitsPerPixel order:(LTRasterByteOrder)order error:(NSError **)error;
+ (void)grayImage:(LTRasterImage *)rasterImage error:(NSError **)error;
+ (void)blackAndWhiteImage:(LTRasterImage *)rasterImage error:(NSError **)error;
+ (void)deskewImage:(LTRasterImage *)rasterImage error:(NSError **)error;
+ (void)despekleImage:(LTRasterImage *)rasterImage error:(NSError **)error;
+ (void)cropImage:(LTRasterImage *)rasterImage toSize:(CGSize)size error:(NSError **)error;
+ (void)dotRemoveImage:(LTRasterImage *)rasterImage error:(NSError **)error;
+ (void)smoothTextImage:(LTRasterImage *)rasterImage error:(NSError **)error;
+ (void)removeBlackBorder:(LTRasterImage *)rasterImage error:(NSError **)error;
+ (void)saveRasterImage:(LTRasterImage *)rasterImage path:(NSString *)path error:(NSError **)error;
+ (void)saveRasterImage:(LTRasterImage *)rasterImage path:(NSString *)path format:(SPFormat)format resolution:(SPResolution)resolution colorMode:(SPColorMode)colorMode error:(NSError **)error;
+ (void)saveJpegImage:(LTRasterImage *)rasterImage quality:(LTCodecsCmpQualityFactorPredefined)quality path:(NSString *)path error:(NSError **)error;
#pragma - SVG graphics animation
+ (void)displayImage:(UIImage *)image duration:(NSTimeInterval)duration inView:(UIView *)view tintColor:(UIColor *)tintColor;
+ (void)displayImageData:(NSData *)imageData url:(NSString *)imageUrl mime:(NSString *)imageMime name:(NSString *)imageName inView:(UIView *)view waitColor:(UIColor *)color block:(void(^)(NSData *data, NSString *mime))block;
@end
