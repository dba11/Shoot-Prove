//
//  Leadtools.Converters.h
//  Leadtools.Converters
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LEADTOOLS_FRAMEWORK) && !defined(LEADTOOLS_KERNEL_FRAMEWORK)
#error Leadtools.framework not defined before Leadtools.Converters.framework. Please include Leadtools/Leadtools.h before including Leadtools.Converters/Leadtools.Converters.h

#else

#if !defined(LEADTOOLS_CONVERTERS_FRAMEWORK)
#   define LEADTOOLS_CONVERTERS_FRAMEWORK
#endif //#ifndef LEADTOOLS_CONVERTERS_FRAMEWORK

#import <ImageIO/ImageIO.h>

#if defined(__OBJC__)
#  if defined(LEADTOOLS_FRAMEWORK)
#     import "LTConvertersDefines.h"
#     import "LTConvertToImageData.h"
#     import "LTConvertFromImageData.h"
#     import "LTRasterImageConverter.h"
#  endif
#endif

#if defined(LEADTOOLS_KERNEL_FRAMEWORK)
#  include "LTConvertersDefines.h"
#  include "LTBitmapHandleConverter.h"
#endif

#endif //#if !defined(LEADTOOLS_FRAMEWORK) && !defined(LEADTOOLS_KERNEL_FRAMEWORK)