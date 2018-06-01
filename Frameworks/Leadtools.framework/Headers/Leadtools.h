//
//  Leadtools.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "TargetConditionals.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#  import <UIKit/UIKit.h>
#else
#  import <AppKit/AppKit.h>
#endif

#if !defined(LEADTOOLS_FRAMEWORK)
#  define LEADTOOLS_FRAMEWORK
#endif //#ifndef LEADTOOLS_FRAMEWORK

#import "LTLeadtools.h"
#import "LTLeadtoolsDefines.h"
#import "LTPrimitives.h"
#import "LTRasterColor.h"
#import "LTRasterColor16.h"
#import "LTRasterHsvColor.h"
#import "LTRasterColorHelper.h"
#import "LTError.h"
#import "LTHandle.h"
#import "LTRasterImageFormat.h"
#import "LTRasterSupport.h"
#import "LTRasterDefaults.h"
#import "LTRasterRegionXForm.h"
#import "LTRasterRegion.h"
#import "LTRasterPalette.h"
#import "LTRasterBufferResize.h"
#import "LTRasterOverlayAttributes.h"
#import "LTRasterMetadata.h"
#import "LTRasterTagMetadata.h"
#import "LTRasterCommentMetadata.h"
#import "LTRasterMarkerMetadata.h"
#import "LTRasterImage.h"
#import "LTRasterCommand.h"
#import "LTFlipCommand.h"
#import "LTCloneCommand.h"
#import "LTCopyRectangleCommand.h"
#import "LTChangeViewPerspectiveCommand.h"
#import "LTClearCommand.h"
#import "LTClearNegativePixelsCommand.h"
#import "LTCombineFastCommand.h"
#import "LTCombineWarpCommand.h"
#import "LTGrayscaleCommand.h"
#import "LTCopyDataCommand.h"
#import "LTFillCommand.h"
#import "LTCropCommand.h"
#import "LTShearCommand.h"
#import "LTSetAlphaValuesCommand.h"
#import "LTDetectAlphaCommand.h"
#import "LTScrambleCommand.h"
#import "LTSizeCommand.h"
#import "LTResizeCommand.h"
#import "LTRotateCommand.h"
#import "LTCreateGrayScaleImageCommand.h"
#import "LTColorResolutionCommand.h"
#import "LTLeadStream.h"
#import "LTLeadFileStream.h"
#import "LTLeadDataStream.h"
#import "LTSvgDocument.h"