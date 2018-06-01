//
//  Leadtools.ImageProcessing.Effects.h
//  Leadtools.ImageProcessing.Effects
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LEADTOOLS_FRAMEWORK) && !defined(LEADTOOLS_KERNEL_FRAMEWORK)
#error Leadtools.framework not defined before Leadtools.ImageProcessing.Effects.framework. Please include Leadtools/Leadtools.h before including Leadtools.ImageProcessing.Effects/Leadtools.ImageProcessing.Effects.h

#else

#if !defined(LEADTOOLS_IMAGEPROCESSING_EFFECTS_FRAMEWORK)
#  define LEADTOOLS_IMAGEPROCESSING_EFFECTS_FRAMEWORK
#endif // #if !defined(LEADTOOLS_IMAGEPROCESSING_EFFECTS_FRAMEWORK)

#if defined(LEADTOOLS_KERNEL_FRAMEWORK)
#  include "Ltimgefx.h"
#endif // #if defined(LEADTOOLS_KERNEL_FRAMEWORK)

#if defined(LEADTOOLS_FRAMEWORK)
#  import "LTAddNoiseCommand.h"
#  import "LTAlphaBlendCommand.h"
#  import "LTAntiAliasingCommand.h"
#  import "LTAverageCommand.h"
#  import "LTBinaryFilterCommand.h"
#  import "LTColorHalftoneCommand.h"
#  import "LTCombineCommand.h"
#  import "LTDeinterlaceCommand.h"
#  import "LTDirectionEdgeStatisticalCommand.h"
#  import "LTDisplacementCommand.h"
#  import "LTEdgeDetectEffectCommand.h"
#  import "LTEdgeDetectorCommand.h"
#  import "LTEdgeDetectStatisticalCommand.h"
#  import "LTEmbossCommand.h"
#  import "LTFeatherAlphaBlendCommand.h"
#  import "LTGaussianCommand.h"
#  import "LTHighPassCommand.h"
#  import "LTMaskConvolutionCommand.h"
#  import "LTObjectInformationCommand.h"
#  import "LTOffsetCommand.h"
#  import "LTSharpenCommand.h"
#  import "LTSmoothEdgesCommand.h"
#  import "LTSpatialFilterCommand.h"
#  import "LTStatisticsInformationCommand.h"
#  import "LTUnsharpMaskCommand.h"
#  import "LTUserFilterCommand.h"
#  import "LTEffectsUtilities.h"
#endif // #if defined(LEADTOOLS_FRAMEWORK)

#endif //#if !defined(LEADTOOLS_FRAMEWORK) && !defined(LEADTOOLS_KERNEL_FRAMEWORK)