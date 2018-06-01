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

#import "ImageHelper.h"
#import "UIColor+HexString.h"
#import "NSData+Hash.h"
#import "NetworkManager.h"
#import "RestClientManager.h"
#import "Task.h"
#import "AbstractSubTaskCapture.h"
#import "SubTaskScan.h"
#import "SubTaskPicture.h"
#import "CaptureImage.h"

@implementation ImageHelper
+ (CGSize)formatSize:(SPFormat)format orientation:(UIInterfaceOrientation)orientation resolution:(int)resolution {
	switch (format) {
		case SPFormatA4:
			if(UIInterfaceOrientationIsPortrait(orientation)) {
				return CGSizeMake(8.25 * resolution, 11.69 * resolution);
			} else {
				return CGSizeMake(11.69 * resolution, 8.25 * resolution);
			}
			break;
		case SPFormatA5:
			if(UIInterfaceOrientationIsPortrait(orientation)) {
				return CGSizeMake(11.69 * resolution / 2, 8.25 * resolution);
			} else {
				return CGSizeMake(8.25 * resolution, 11.69 * resolution / 2);
			}
			break;
		case SPFormatID1:
			if(UIInterfaceOrientationIsPortrait(orientation)) {
				return CGSizeMake(2.125 * resolution, 3.375 * resolution);
			} else {
				return CGSizeMake(3.375 * resolution, 2.125 * resolution);
			}
			break;
		case SPFormatPicture:
			if(UIInterfaceOrientationIsPortrait(orientation)) {
				return CGSizeMake(3.9 * resolution, 5.8 * resolution);
			} else {
				return CGSizeMake(5.8 * resolution, 3.9 * resolution);
			}
			break;
		default:
			return CGSizeZero;
			break;
	}
}

+ (UIImage *)resizeImage:(UIImage *)image proportionalToSize:(CGSize)size {
	CGFloat biggestImageLength = image.size.width > image.size.height ? image.size.width : image.size.height;
	CGFloat biggestSizeLength = size.width > size.height ? size.width : size.height;
	CGFloat ratio = biggestSizeLength / biggestImageLength;
	CGSize newSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
	return [self resizeImage:image toSize:newSize];
}

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
	UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+ (UIImage *)grayishImage:(UIImage *)image {
	UIGraphicsBeginImageContextWithOptions(image.size, YES, 1.0);
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	[image drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
	UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return filteredImage;
}

+ (UIImage *)thumbnailImage:(UIImage *)image {
    return image ? [self resizeImage:image proportionalToSize:CGSizeMake(thumbnailImageSize, thumbnailImageSize)]:nil;
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

+ (UIImage *)rotateImage:(UIImage *)image degrees:(CGFloat)degrees {
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(radians(degrees));
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	// Rotate the image context
	CGContextRotateCTM(bitmap, radians(degrees));
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+ (void)createPDFWithSubTasks:(NSArray *)subTasks filePath:(NSString *)filePath {
	UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
	for (AbstractSubTask *subTask in subTasks) {
		if([subTask isKindOfClass:([SubTaskScan class])]) {
			SubTaskScan *subTaskScan = (SubTaskScan *)subTask;
			for(CaptureImage *subTaskImage in subTaskScan.images) {
				UIImage *image = subTaskImage.image;
				if(image) {
					CGSize imageSize = CGSizeMake(image.size.width * image.scale * 72 / [subTaskScan.dpi floatValue], image.size.height * image.scale * 72 / [subTaskScan.dpi floatValue]);
					CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
					UIGraphicsBeginPDFPageWithInfo(rect, nil);
					[image drawInRect:rect];
				}
			}
		} else if([subTask isKindOfClass:([SubTaskPicture class])]) {
			SubTaskPicture *subTaskPicture = (SubTaskPicture *)subTask;
			for(CaptureImage *subTaskImage in subTaskPicture.images) {
				UIImage *image = subTaskImage.image;
				if(image) {
					CGSize pictureSize;
					if(image.size.width>image.size.height) {
						pictureSize = [self formatSize:SPFormatPicture orientation:UIInterfaceOrientationLandscapeRight resolution:300];
					} else {
						pictureSize = [self formatSize:SPFormatPicture orientation:UIInterfaceOrientationPortrait resolution:300];
					}
					CGSize imageSize = CGSizeMake(pictureSize.width * image.scale * 72 / 300, pictureSize.height * image.scale * 72 / 300);
					CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
					UIGraphicsBeginPDFPageWithInfo(rect, nil);
					[image drawInRect:rect];
				}
			}
		}
	}
	UIGraphicsEndPDFContext();
}

#pragma - core image processing
+ (CIImage *)drawHighlightOverlayForRectangle:(CIImage *)image rectangle:(CIRectangleFeature *)rectangle colorMode:(SPColorMode)colorMode {
	CIImage *overlay = [image imageByCroppingToRect:rectangle.bounds];
	if (colorMode == SPColorModeGrey) {
		overlay = [self filteredImageUsingGreyFilterOnImage:overlay];
	} else if(colorMode == SPColorModeBlackAndWhite) {
		overlay = [self filteredImageUsingBlackAndWhiteFilterOnImage:overlay];
	} else {
		overlay = [self filteredImageUsingColorFilterOnImage:overlay];
	}
    return overlay;
	//return [overlay imageByCompositingOverImage:image];
}

+ (CIImage *)filteredImageUsingBlackAndWhiteFilterOnImage:(CIImage *)image {
	CIFilter *greyFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, image, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.6], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil];
	return [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, greyFilter.outputImage, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
}

+ (CIImage *)filteredImageUsingGreyFilterOnImage:(CIImage *)image {
	CIFilter *greyFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, image, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil];
	return [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, greyFilter.outputImage, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
}

+ (CIImage *)filteredImageUsingColorFilterOnImage:(CIImage *)image {
	return [CIFilter filterWithName:@"CIColorControls" withInputParameters:@{@"inputContrast":@(1.5),kCIInputImageKey:image}].outputImage;
}

+ (CIImage *)correctPerspectiveForImage:(CIImage *)image withFeatures:(CIRectangleFeature *)rectangleFeature {
	CGPoint topLeft = CGPointMake(rectangleFeature.topLeft.x, rectangleFeature.topLeft.y);
	CGPoint topRight = CGPointMake(rectangleFeature.topRight.x, rectangleFeature.topRight.y);
	CGPoint bottomLeft = CGPointMake(rectangleFeature.bottomLeft.x, rectangleFeature.bottomLeft.y);
	CGPoint bottomRight = CGPointMake(rectangleFeature.bottomRight.x, rectangleFeature.bottomRight.y);
	NSMutableDictionary *rectangleCoordinates = [NSMutableDictionary new];
	rectangleCoordinates[@"inputTopLeft"] = [CIVector vectorWithCGPoint:topLeft];
	rectangleCoordinates[@"inputTopRight"] = [CIVector vectorWithCGPoint:topRight];
	rectangleCoordinates[@"inputBottomLeft"] = [CIVector vectorWithCGPoint:bottomLeft];
	rectangleCoordinates[@"inputBottomRight"] = [CIVector vectorWithCGPoint:bottomRight];
	return [image imageByApplyingFilter:@"CIPerspectiveCorrection" withInputParameters:rectangleCoordinates];
}

+ (CIImage *)cropImage:(CIImage *)image withRect:(CGRect)rect {
	CIImage* croppedImage = [image imageByCroppingToRect:rect];
	CIFilter *transform = [CIFilter filterWithName:@"CIAffineTransform"];
	[transform setValue:croppedImage forKey:kCIInputImageKey];
	NSValue *translate = [NSValue valueWithCGAffineTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, - rect.origin.x, - rect.origin.y)];
	[transform setValue:translate forKey:@"inputTransform"];
	return [transform outputImage];
}

+ (CIDetector *)rectangleDetectorMinFeatureSize:(CGFloat)minFeatureSize AspectRatio:(CGFloat)aspectRatio {
	CIDetector *detector = nil;
    if(minFeatureSize > 0.0f && aspectRatio > 0.0f) {
        detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh, CIDetectorMinFeatureSize:[NSNumber numberWithFloat:minFeatureSize], CIDetectorAspectRatio:[NSNumber numberWithFloat:aspectRatio]}];
    } else if(minFeatureSize > 0.0f) {
        detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh, CIDetectorMinFeatureSize:[NSNumber numberWithFloat:minFeatureSize]}];
    } else if(aspectRatio > 0.0f) {
        detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh, CIDetectorAspectRatio:[NSNumber numberWithFloat:aspectRatio]}];
    } else {
        detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    }
	return detector;
}

+ (CIRectangleFeature *)biggestRectangleInRectangles:(NSArray *)rectangles {
	if (![rectangles count]) return nil;
	float halfPerimiterValue = 0;
	CIRectangleFeature *biggestRectangle = [rectangles firstObject];
	for (CIRectangleFeature *rect in rectangles) {
		CGPoint p1 = rect.topLeft;
		CGPoint p2 = rect.topRight;
		CGFloat width = hypotf(p1.x - p2.x, p1.y - p2.y);
		CGPoint p3 = rect.topLeft;
		CGPoint p4 = rect.bottomLeft;
		CGFloat height = hypotf(p3.x - p4.x, p3.y - p4.y);
		CGFloat currentHalfPerimiterValue = height + width;
		if (halfPerimiterValue < currentHalfPerimiterValue) {
			halfPerimiterValue = currentHalfPerimiterValue;
			biggestRectangle = rect;
		}
	}
	return biggestRectangle;
}

#pragma - leadtools license validation method
+ (NSError *)activateLeadToolsLicense {
	NSError *error = nil;
	[LTRasterSupport setLicenseFile:[[NSBundle mainBundle] pathForResource:leadToolsLicenseFile ofType:leadToolsLicenseFileType] developerKey:leadToolsLicense error:&error];
	return error;
}

#pragma - image processing methods for any type of image (1,8,24,... bits image)
+ (LTRasterImage *)rasterImageFromCIImage:(CIImage *)image error:(NSError **)error {
    CIContext *ctx = [CIContext contextWithOptions:@{kCIContextWorkingColorSpace:[NSNull null]}];
    CGSize bounds = image.extent.size;
    bounds = CGSizeMake(floorf(bounds.width / 4) * 4,floorf(bounds.height / 4) * 4);
    CGRect extent = CGRectMake(image.extent.origin.x, image.extent.origin.y, bounds.width, bounds.height);
    int bytesPerPixel = 8;
    uint rowBytes = bytesPerPixel * bounds.width;
    uint totalBytes = rowBytes * bounds.height;
    uint8_t *byteBuffer = malloc(totalBytes);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    [ctx render:image toBitmap:byteBuffer rowBytes:rowBytes bounds:extent format:kCIFormatRGBA8 colorSpace:colorSpace];
    CGContextRef bitmapContext = CGBitmapContextCreate(byteBuffer, bounds.width, bounds.height,bytesPerPixel,rowBytes,colorSpace,kCGImageAlphaNoneSkipLast);
    CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bitmapContext);
    free(byteBuffer);
    if (imgRef == NULL) {
     CFRelease(imgRef);
     return nil;
    }
    LTRasterImage *rasterImage = [LTRasterImageConverter convertFromCGImage:imgRef options:LTConvertFromImageOptionsNone error:error];
    CFRelease(imgRef);
    return rasterImage;
}

+ (LTRasterImage *)rasterImageFromUIImage:(UIImage *)image error:(NSError **)error {
    return [LTRasterImageConverter convertFromImage:image options:LTConvertFromImageOptionsNone error:error];
}

+ (LTRasterImage *)rasterImageFromData:(NSData *)data error:(NSError **)error {
	UIImage *image = [UIImage imageWithData:data];
	return [LTRasterImageConverter convertFromImage:image options:LTConvertFromImageOptionsNone error:error];
}

+ (LTRasterImage *)rasterImageFromPath:(NSString *)path error:(NSError **)error {
	LTRasterCodecs *codecs = [[LTRasterCodecs alloc] init];
	LTRasterImage *rasterImage = [codecs loadFile:path error:error];
	return rasterImage;
}

+ (LTRasterImage *)correctImageRotation:(LTRasterImage *)rasterImage interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation error:(NSError **)error {
    NSInteger rotateAngle = 0;
    switch(interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            rotateAngle = 9000;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = 27000;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = 18000;
            break;
        case UIInterfaceOrientationLandscapeRight:
        default:
            rotateAngle = 0;
            break;
    }
    if (rotateAngle > 0) {
        LTRotateCommand* rotateCommand = [[LTRotateCommand alloc]initWithAngle:rotateAngle flags:LTRotateCommandFlagsResize fillColor:[LTRasterColor white]];
        [rotateCommand run:rasterImage error:nil];
    }
    return rasterImage;
}

+ (void)rotateRightRasterImage:(LTRasterImage *)rasterImage error:(NSError **)error {
	LTRotateCommand *rotateCommand = [[LTRotateCommand alloc] initWithAngle:9000 flags:LTRotateCommandFlagsResize fillColor:[LTRasterColor black]];
	[rotateCommand run:rasterImage error:error];
}

+ (BOOL)resizeImage:(LTRasterImage *)rasterImage toSize:(CGSize)size allowStretch:(BOOL)allowStretch error:(NSError **)error {
    if(!(size.height > 0 && size.width > 0)) return NO;
	CGFloat imageLargestLength = rasterImage.width > rasterImage.height ? rasterImage.width:rasterImage.height;
	CGFloat imageSmallestLength = rasterImage.width < rasterImage.height ? rasterImage.width:rasterImage.height;
	CGFloat sizeLargestLength = size.width > size.height ? size.width:size.height;
	CGFloat sizeSmallestLength = size.width < size.height ? size.width:size.height;
	CGFloat smallestLengthFactor = sizeSmallestLength / imageSmallestLength;
	CGFloat largestLengthFactor = sizeLargestLength / imageLargestLength;
	CGFloat scaleFactor = 0.0;
	if (smallestLengthFactor < largestLengthFactor)
		scaleFactor = smallestLengthFactor;
	else
		scaleFactor = largestLengthFactor;
    if(scaleFactor > 1.0 && !allowStretch)
        return NO;
	CGFloat scaledWidth  = rasterImage.width * scaleFactor;
	CGFloat scaledHeight = rasterImage.height * scaleFactor;
	LTSizeCommand * sizeCommand =[[LTSizeCommand alloc] initWithWidth:scaledWidth height:scaledHeight flags:LTRasterSizeFlagsResample];
	[sizeCommand run:rasterImage error:error];
    return YES;
}

+ (LeadRect)rectangleFromGuideRect:(CGRect)guideRect inPreviewRect:(CGRect)previewRect overRasterImage:(LTRasterImage *)rasterImage {
    CGFloat ratio = MIN(rasterImage.width, rasterImage.height) / MIN(previewRect.size.width, previewRect.size.height);
    CGFloat width = guideRect.size.width * ratio;
    CGFloat height = guideRect.size.height * ratio;
    CGFloat x = (rasterImage.width - width) / 2.0;
    CGFloat y = (rasterImage.height - height) / 2.0;
    return LeadRectMake(x, y, width, height);
}

+ (LeadRect)rectangleFromImage:(LTRasterImage *)rasterImage reducedOfPixels:(NSInteger)numberOfPixels {
    return LeadRectMake(numberOfPixels, numberOfPixels, rasterImage.width - (2*numberOfPixels), rasterImage.height - (2*numberOfPixels));
}

+ (void)autoColorImage:(LTRasterImage *)rasterImage error:(NSError **)error {
	LTAutoColorLevelCommand *colorCommand = [[LTAutoColorLevelCommand alloc] initWithType:LTAutoColorLevelCommandTypeContrast flags:LTAutoColorLevelCommandFlagsNone];
	[colorCommand run:rasterImage error:error];
}

+ (void)reduceColorResolutionImage:(LTRasterImage *)rasterImage bitsPerPixel:(NSInteger)bitsPerPixel order:(LTRasterByteOrder)order error:(NSError **)error {
	if(rasterImage.bitsPerPixel > bitsPerPixel) {
		LTColorResolutionCommand *colorCommand = [[LTColorResolutionCommand alloc] initWithMode:LTColorResolutionCommandModeInPlace bitsPerPixel:bitsPerPixel order:order ditheringMethod:LTRasterDitheringMethodOrdered paletteFlags:LTColorResolutionCommandPaletteFlagsOptimized palette:nil];
		[colorCommand run:rasterImage error:error];
	}
}

+ (void)grayImage:(LTRasterImage *)rasterImage error:(NSError **)error {
	LTDesaturateCommand *desaturateCommand = [[LTDesaturateCommand alloc] init];
	[desaturateCommand run:rasterImage error:error];
}

+ (void)blackAndWhiteImage:(LTRasterImage *)rasterImage error:(NSError **)error {
	LTAutoBinarizeCommand *binarizeCommand = [[LTAutoBinarizeCommand alloc] init];
	[binarizeCommand run:rasterImage error:error];
}

+ (void)deskewImage:(LTRasterImage *)rasterImage error:(NSError **)error {
	LTRasterImage *imageCopy = [rasterImage copy];
	if(imageCopy.bitsPerPixel > 1) {
		[self blackAndWhiteImage:imageCopy error:error];
	}
	LTDeskewCommand *deskewCommand = [[LTDeskewCommand alloc] init];
	[deskewCommand setFlags:LTDeskewCommandFlagsDocumentAndPictures | LTDeskewCommandFlagsNoThreshold | LTDeskewCommandFlagsReturnAngleOnly];
	[deskewCommand run:imageCopy error:nil];
	NSInteger angle = deskewCommand.angle;
    if(angle > -20 && angle < 20) {
        LTRotateCommand* rotateCmd = [[LTRotateCommand alloc]initWithAngle:angle flags:LTRotateCommandFlagsResize fillColor:[rasterImage getPixelColorAtRow:5 column:5]];
        [rotateCmd run:rasterImage error:error];
    }
}

+ (void)despekleImage:(LTRasterImage *)rasterImage error:(NSError **)error {
	LTDespeckleCommand *despekleCommand = [[LTDespeckleCommand alloc] init];
	[despekleCommand run:rasterImage error:error];
}

+ (void)cropImage:(LTRasterImage *)rasterImage toSize:(CGSize)size error:(NSError **)error {
	NSInteger x = (rasterImage.height - size.height) / 2;
	NSInteger y = (rasterImage.width - size.width) / 2;
	LeadRect rect = LeadRectMake(x, y, size.width, size.height);
	LTCropCommand *cropCommand = [[LTCropCommand alloc] initWithRectangle:rect];
	[cropCommand run:rasterImage error:error];
}

#pragma - image processing methods for one bit image only
+ (void)dotRemoveImage:(LTRasterImage *)rasterImage error:(NSError **)error {
	if(rasterImage.bitsPerPixel > 1) return;
	LTDotRemoveCommand *dotRemoveCommand = [[LTDotRemoveCommand alloc] initWithFlags:LTDotRemoveCommandFlagsUseSize minimumDotWidth:1 minimumDotHeight:1 maximumDotWidth:10 maximumDotHeight:10];
	[dotRemoveCommand run:rasterImage error:error];
}

+ (void)smoothTextImage:(LTRasterImage *)rasterImage error:(NSError **)error {
	if(rasterImage.bitsPerPixel > 1) return;
	LTSmoothCommand *smoothCommand = [[LTSmoothCommand alloc] initWithFlags:LTSmoothCommandFlagsFavorLong length:2];
	[smoothCommand run:rasterImage error:error];
}

+ (void)removeBlackBorder:(LTRasterImage *)rasterImage error:(NSError **)error {
	if(rasterImage.bitsPerPixel > 1) return;
	LTBorderRemoveCommand *borderRemoveCommand = [[LTBorderRemoveCommand alloc] initWithFlags:LTBorderRemoveCommandFlagsUseVariance border:LTBorderRemoveBorderFlagsAll percent:20 whiteNoiseLength:5 variance:3];
	[borderRemoveCommand run:rasterImage error:error];
}

#pragma - image save methods
+ (void)saveRasterImage:(LTRasterImage *)rasterImage path:(NSString *)path error:(NSError **)error {
	LTRasterCodecs *codecs = [[LTRasterCodecs alloc] init];
	[codecs save:rasterImage file:path format:rasterImage.originalFormat bitsPerPixel:rasterImage.bitsPerPixel error:error];
}

+ (void)saveRasterImage:(LTRasterImage *)rasterImage path:(NSString *)path format:(SPFormat)format resolution:(SPResolution)resolution colorMode:(SPColorMode)colorMode error:(NSError **)error {
	if(format == SPFormatPicture) {
		[ImageHelper saveJpegImage:rasterImage quality:LTCodecsCmpQualityFactorPredefinedQualityAndSize path:path error:error];
	} else {
		int bitsPerPixels = 0;
		BOOL usePhotometricInterpretation = NO;
		LTCodecsTiffPhotometricInterpretation photometricInterpretation = LTCodecsTiffPhotometricInterpretationRgb;
		NSInteger tileValue = 0;
		LTRasterImageFormat imageFormat = LTRasterImageFormatTifLzw;
		LTRasterCodecs *codecs = [[LTRasterCodecs alloc] init];
		codecs.options.tiff.save.noPageNumber = YES;
		codecs.options.tiff.save.noSubFileType = YES;
		codecs.options.tiff.save.noLzwAutoClear = NO;
		switch (colorMode) {
			case SPColorModeBlackAndWhite:
				bitsPerPixels = 1;
				usePhotometricInterpretation = NO;
				tileValue = 0;
				imageFormat = LTRasterImageFormatCcittGroup4;
				break;
			case SPColorModeGrey:
				bitsPerPixels = 8;
				usePhotometricInterpretation = NO;
				if(format != SPFormatID1) {
					tileValue = 200;
				} else {
					tileValue = 0;
				}
				imageFormat = LTRasterImageFormatTifLzw;
				[ImageHelper reduceColorResolutionImage:rasterImage bitsPerPixel:bitsPerPixels order:LTRasterByteOrderGray error:error];
				break;
			case SPColorModeColor:
				bitsPerPixels = 24;
				usePhotometricInterpretation = NO;
				if(format != SPFormatID1) {
					tileValue = 200;
				} else {
					tileValue = 0;
				}
                imageFormat = LTRasterImageFormatTifLzw;
				[ImageHelper reduceColorResolutionImage:rasterImage bitsPerPixel:bitsPerPixels order:LTRasterByteOrderRgb error:error];
				break;
			default:
				break;
		}
		codecs.options.tiff.save.usePhotometricInterpretation = usePhotometricInterpretation;
		codecs.options.tiff.save.photometricInterpretation = photometricInterpretation;
		if(tileValue > 0) {
			codecs.options.tiff.save.useTileSize = YES;
			codecs.options.tiff.save.tileWidth = tileValue;
			codecs.options.tiff.save.tileHeight = tileValue;
		} else {
			codecs.options.tiff.save.useTileSize = NO;
		}
        int dpi = [EnumHelper valueFromResolution:resolution];
        rasterImage.xResolution = dpi;
        rasterImage.yResolution = dpi;
		[codecs save:rasterImage file:path format:imageFormat bitsPerPixel:bitsPerPixels error:error];
	}
}

+ (void)saveJpegImage:(LTRasterImage *)rasterImage quality:(LTCodecsCmpQualityFactorPredefined)quality path:(NSString*)path error:(NSError **)error {
	LTRasterCodecs *codecs = [[LTRasterCodecs alloc] init];
	codecs.options.jpeg.save.cmpQualityFactorPredefined = quality;
	int bitsPerPixels = rasterImage.bitsPerPixel > 24 ? 24:(int)rasterImage.bitsPerPixel;
	[codecs save:rasterImage file:path format:LTRasterImageFormatJpeg bitsPerPixel:bitsPerPixels error:error];
}

#pragma - svg/core graphics display and animation
+ (BOOL)isSvgImage:(NSString *)url mime:(NSString *)mime {
    if([mime isEqualToString:mimeSVG]) {
        return YES;
    } else if([mime isEqualToString:mimeJPG]) {
        return NO;
    } else if(url.length > 3) {
        NSString *extension = [[url substringFromIndex:url.length - 3] lowercaseString];
        return [extension isEqualToString:@"svg"];
    } else {
        return NO;
    }
}

+ (UIImage *)imageWithData:(NSData *)data svg:(BOOL)svg rect:(CGRect)rect {
    if(svg) {
        SVGKImage *image = [SVGKImage imageWithData:data];
        image.size = rect.size;
        return image.UIImage;
    } else {
        return [UIImage imageWithData:data];
    }
}

+ (void)displayImage:(UIImage *)image duration:(NSTimeInterval)duration inView:(UIView *)view tintColor:(UIColor *)tintColor {
    UIImageView *imageView;
    for(UIView *subView in view.subviews) {
        if(subView.tag == 99 && [subView isKindOfClass:[UIImageView class]]) {
            imageView = (UIImageView *)subView;
            break;
        }
    }
    if(!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.tag = 99;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.alpha = 0.0f;
        [view addSubview:imageView];
    }
    imageView.image = image;
    if(tintColor)
        imageView.tintColor = tintColor;
    [UIView animateWithDuration:duration animations:^{
        imageView.alpha = 1.0f;
    } completion:^(BOOL finished) {}];
}

+ (void)displayImageData:(NSData *)imageData url:(NSString *)imageUrl mime:(NSString *)imageMime name:(NSString *)imageName inView:(UIView *)view waitColor:(UIColor *)color block:(void(^)(NSData *data, NSString *mime))block {
    if(imageData) {
        BOOL isSVG = [self isSvgImage:imageUrl mime:imageMime];
        UIImage *image = [self imageWithData:imageData svg:isSVG rect:view.bounds];
        [self displayImage:image duration:0.0 inView:view tintColor:nil];
        block(imageData, imageMime);
    } else {
        if(imageUrl.length > 0 && [NetworkManager.sharedManager internetAvailable]) {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((view.frame.size.width - 37) / 2, (view.frame.size.height - 37) / 2, 37, 37)];
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            activityIndicator.tintColor = color;
            activityIndicator.hidesWhenStopped = YES;
            [view addSubview:activityIndicator];
            [activityIndicator startAnimating];
            [RestClientManager.sharedManager dataWithUrl:imageUrl block:^(NSData *data, NSString *contentType, NSInteger statusCode, NSError *error) {
                [activityIndicator stopAnimating];
                BOOL isSVG = [self isSvgImage:imageUrl mime:contentType] && data;
                UIImage *image = data ? [self imageWithData:data svg:isSVG rect:view.bounds]:[UIImage imageNamed:imageName];
                [self displayImage:image duration:0.8 inView:view tintColor:nil];
                block(data, contentType);
            }];
        } else {
            UIImage *image = [UIImage imageNamed:imageName];
            [self displayImage:image duration:0.8 inView:view tintColor:nil];
            block(nil, nil);
        }
    }
}

+ (void)animateImage:(SVGKImage *)image duration:(CFTimeInterval)duration inView:(UIView *)view {
    [self animateCALayer:image.CALayerTree duration:duration];
    [view.layer addSublayer:image.CALayerTree];
}

+ (void)animateCALayer:(CALayer *)layer duration:(CFTimeInterval)duration {
    for (CALayer *sublayer in layer.sublayers) {
        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
            CAShapeLayer* shapeLayer = (CAShapeLayer*)sublayer;
            shapeLayer.lineWidth = 2.0;
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = duration;
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        }
        if (sublayer.sublayers.count > 0) {
            [self animateCALayer:sublayer duration:duration];
        }
    }
}
@end
