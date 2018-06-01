//
//  LTImageViewerSpyGlassInteractiveMode.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTImageViewerInteractiveMode.h"

typedef NS_ENUM(NSInteger, LTSpyGlassShape) {
    LTSpyGlassShapeNone           = 0,
    LTSpyGlassShapeRectangle      = 1,
    LTSpyGlassShapeRoundRectangle = 2,
    LTSpyGlassShapeEllipse        = 3,
};

typedef NS_ENUM(NSInteger, LTSpyGlassCrosshair) {
    LTSpyGlassCrosshairNone = 0,
    LTSpyGlassCrosshairFine = 1,
};

@class LTImageViewerSpyGlassInteractiveMode;

NS_ASSUME_NONNULL_BEGIN

@protocol LTImageViewerSpyGlassDelegate <NSObject>
@optional
- (void)imageViewerSpyGlassInteractiveMode:(LTImageViewerSpyGlassInteractiveMode *)imageViewerSpyGlassInteractiveMode preDrawWithContext:(CGContextRef)context;
- (void)imageViewerSpyGlassInteractiveMode:(LTImageViewerSpyGlassInteractiveMode *)imageViewerSpyGlassInteractiveMode postDrawWithContext:(CGContextRef)context;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewerSpyGlassInteractiveMode : LTImageViewerInteractiveMode

@property (nonatomic, weak)   id<LTImageViewerSpyGlassDelegate> delegate;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint offset;

@property (nonatomic, assign) LTSpyGlassShape shape;
@property (nonatomic, assign) LTSpyGlassCrosshair crosshair;

@property (nonatomic, copy)   UIColor *borderColor;
@property (nonatomic, copy)   UIColor *backgroundColor;
@property (nonatomic, copy)   UIColor *crosshairColor;

@property (nonatomic, assign) double borderThickness;
@property (nonatomic, assign) double crosshairThickness;
@property (nonatomic, assign) double roundRectangleRadius;

@property (nonatomic, assign) BOOL autoCorrectOffset;

@end

NS_ASSUME_NONNULL_END