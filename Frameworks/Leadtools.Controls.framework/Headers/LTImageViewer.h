//
//  LTImageViewer.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@class LTImageViewer;
@class LTImageViewerInteractiveMode;
@class LTInteractiveService;
@class LTRasterImage;

typedef NS_ENUM(NSInteger, LTImageViewerSizeMode) {
    LTImageViewerSizeModeNone       = 0,
    LTImageViewerSizeModeActualSize = 1,
    LTImageViewerSizeModeFit        = 2,
    LTImageViewerSizeModeFitAlways  = 3,
    LTImageViewerSizeModeFitWidth   = 4,
    LTImageViewerSizeModeFitHeight  = 5,
    LTImageViewerSizeModeStretch    = 6,
};

typedef NS_OPTIONS(NSUInteger, LTImageViewerNewImageResetOptions) {
    LTImageViewerNewImageResetOptionsNone                  = 0x0000,
    LTImageViewerNewImageResetOptionsScrollOffset          = 0x0001,
    LTImageViewerNewImageResetOptionsScaleFactor           = 0x0002,
    LTImageViewerNewImageResetOptionsAspectRatioCorrection = 0x0004,
    LTImageViewerNewImageResetOptionsSizeMode              = 0x0008,
    LTImageViewerNewImageResetOptionsReverse               = 0x0010,
    LTImageViewerNewImageResetOptionsFlip                  = 0x0020,
    LTImageViewerNewImageResetOptionsRotateAngle           = 0x0040,
    LTImageViewerNewImageResetOptionsInvert                = 0x0080,
    LTImageViewerNewImageResetOptionsAll                   = 0x00FF
};

typedef NS_ENUM(NSInteger, LTCoordinateType) {
    LTCoordinateTypeControl,
    LTCoordinateTypeImage,
};

typedef NS_ENUM(NSInteger, LTImageViewerScrollMode) {
    LTImageViewerScrollModeAuto,
    LTImageViewerScrollModeHidden,
    LTImageViewerScrollModeDisable,
};

typedef NS_ENUM(NSInteger, LTControlAlignment) {
    LTControlAlignmentNear   = 0,
    LTControlAlignmentCenter = 1,
    LTControlAlignmentFar    = 2,
};

NS_ASSUME_NONNULL_BEGIN

@protocol LTImageViewerDelegate<NSObject>
@optional

- (void)imageViewer:(LTImageViewer *)imageViewer postRenderWithContext:(CGContextRef)context;
- (void)imageViewer:(LTImageViewer *)imageViewer preRenderWithContext:(CGContextRef)context;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer : UIView <NSCoding>

@property (nonatomic, weak, nullable) id<LTImageViewerDelegate> delegate;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (Constants)

+ (float)maximumScaleFactor;
+ (float)minimumScaleFactor;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (ImageOptions)

@property (nonatomic, assign)           BOOL ownerDraw;
@property (nonatomic, assign)           BOOL useDpi;
@property (nonatomic, assign)           BOOL enableDpiCorrection;
@property (nonatomic, assign, readonly) BOOL hasImage;

@property (nonatomic, assign)           NSUInteger imageDpiX;
@property (nonatomic, assign)           NSUInteger imageDpiY;
@property (nonatomic, assign)           NSUInteger screenDpiX;
@property (nonatomic, assign)           NSUInteger screenDpiY;

@property (nonatomic, assign)           CGSize imageSize;
@property (nonatomic, assign, readonly) CGSize realImageSize;

@property (nonatomic, strong, nullable) UIImage *image;

@property (nonatomic, assign)           LTImageViewerNewImageResetOptions newImageResetOptions;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (ViewOptions)

@property (nonatomic, assign)           BOOL flip;
@property (nonatomic, assign)           BOOL reverse;
@property (nonatomic, assign)           BOOL invert;
@property (nonatomic, assign)           BOOL resizeOnRotate;

@property (nonatomic, assign)           double scaleFactor;
@property (nonatomic, assign)           double aspectRatioCorrection;
@property (nonatomic, assign)           double rotateAngle;
@property (nonatomic, assign, readonly) double currentXScaleFactor;
@property (nonatomic, assign, readonly) double currentYScaleFactor;
@property (nonatomic, assign, readonly) double currentScaleFactor;

@property (nonatomic, assign, readonly) CGPoint imageControlCenter;

@property (nonatomic, assign)           LTImageViewerSizeMode sizeMode;

- (CGRect)imageControlRectangle:(BOOL)clipped;

- (void)centerAtPoint:(CGPoint)point;
- (void)zoomToRect:(CGRect)rect;

- (void)zoomWithSizeMode:(LTImageViewerSizeMode)sizeMode scaleFactor:(double)scaleFactor origin:(CGPoint)origin;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (ApperanceOptions)

@property (nonatomic, assign)         BOOL dropShadow;

@property (nonatomic, assign)         double imageBorderThickness;

@property (nonatomic, copy, nullable) UIColor *imageBorderColor;
@property (nonatomic, copy, nullable) UIColor *imageBackColor;

@property (nonatomic, assign)         LTControlAlignment imageHorizontalAlignment;
@property (nonatomic, assign)         LTControlAlignment imageVerticalAlignment;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (ConversionOptions)

@property (nonatomic,readonly) CGPoint defaultZoomOrigin;

- (CGPoint)convertPoint:(CGPoint) point sourceType:(LTCoordinateType)src destType:(LTCoordinateType)dst;
- (CGRect)convertRect:(CGRect)rect sourceType:(LTCoordinateType)src destType:(LTCoordinateType)dst;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (LayoutOptions)

@property (nonatomic, assign, readonly) BOOL canUpdate;

- (void)beginUpdate;
- (void)endUpdate;
- (void)invalidate;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (TransformOptions)

@property (nonatomic, assign, readonly) CGAffineTransform internalTransform;

- (CGAffineTransform)getTransform:(BOOL)useDpi;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (ScrollOptions)

@property (nonatomic, assign)           BOOL restrictHiddenScrollMode;

@property (nonatomic, assign)           CGPoint scrollOffset;
@property (nonatomic, assign, readonly) CGSize scrollRange;

@property (nonatomic, assign)           LTImageViewerScrollMode scrollMode;

- (void)scrollBy:(CGPoint)point;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (InteractiveModeOptions)

@property (nonatomic, strong)                     LTInteractiveService *interactiveService;

@property (nonatomic, strong, nullable)           LTImageViewerInteractiveMode *defaultInteractiveMode;
@property (nonatomic, strong, readonly, nullable) LTImageViewerInteractiveMode *workingInteractiveMode;
@property (nonatomic, strong, nullable)           LTImageViewerInteractiveMode *pinchInteractiveMode;
@property (nonatomic, strong, nullable)           LTImageViewerInteractiveMode *touchInteractiveMode;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewer (RasterImage)

@property (nonatomic, strong, nullable) LTRasterImage *rasterImage;

@property (nonatomic, assign)           LTConvertToImageOptions convertToImageOptions;
@property (nonatomic, assign)           LTConvertFromImageOptions convertFromImageOptions;

- (void)freeRasterImage;

@end

NS_ASSUME_NONNULL_END

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */