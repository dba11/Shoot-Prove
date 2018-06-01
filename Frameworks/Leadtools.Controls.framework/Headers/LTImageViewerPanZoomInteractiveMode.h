//
//  LTImageViewerPanZoomInteractiveMode.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTImageViewerInteractiveMode.h"

@interface LTImageViewerPanZoomInteractiveMode : LTImageViewerInteractiveMode <NSCoding>

@property (nonatomic, assign) BOOL enablePinchZoom;
@property (nonatomic, assign) BOOL enableRotate;
@property (nonatomic, assign) BOOL enableZoom;
@property (nonatomic, assign) BOOL enablePan;
@property (nonatomic, assign) BOOL zoomAtImageControlCenter;

@property (nonatomic, assign) double minimumScaleFactor;

@end
