//
//  Leadtools.ImageProcessing.Color.h
//  Leadtools.ImageProcessing.Color
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LEADTOOLS_FRAMEWORK) && !defined(LEADTOOLS_KERNEL_FRAMEWORK)
#error Leadtools.framework not defined before Leadtools.ImageProcessing.Color.framework. Please include Leadtools/Leadtools.h before including Leadtools.ImageProcessing.Color/Leadtools.ImageProcessing.Color.h

#else

#if !defined(LEADTOOLS_IMAGEPROCESSING_COLOR_FRAMEWORK)
#  define LEADTOOLS_IMAGEPROCESSING_COLOR_FRAMEWORK
#endif // #if !defined(LEADTOOLS_IMAGEPROCESSING_COLOR_FRAMEWORK)

#if defined(LEADTOOLS_KERNEL_FRAMEWORK)
#  include "Ltimgclr.h"
#endif // #if defined(LEADTOOLS_KERNEL_FRAMEWORK)

#if defined(LEADTOOLS_FRAMEWORK)
#  import "LTEnums.h"
#  import "LTAdaptiveContrastCommand.h"
#  import "LTAddCommand.h"
#  import "LTAddWeightedCommand.h"
#  import "LTAdjustTintCommand.h"
#  import "LTApplyMathematicalLogicCommand.h"
#  import "LTAutoBinaryCommand.h"
#  import "LTColorLevelCommand.h"
#  import "LTAutoColorLevelCommand.h"
#  import "LTBalanceColorsCommand.h"
#  import "LTChangeContrastCommand.h"
#  import "LTChangeHueCommand.h"
#  import "LTChangeHueSaturationIntensityCommand.h"
#  import "LTChangeIntensityCommand.h"
#  import "LTChangeSaturationCommand.h"
#  import "LTChannelMixerCommand.h"
#  import "LTColorCountCommand.h"
#  import "LTColorIntensityBalanceCommand.h"
#  import "LTColorMergeCommand.h"
#  import "LTColorReplaceCommand.h"
#  import "LTColorSeparateCommand.h"
#  import "LTColorThresholdCommand.h"
#  import "LTContrastBrightnessIntensityCommand.h"
#  import "LTConvertToColoredGrayCommand.h"
#  import "LTDesaturateCommand.h"
#  import "LTDynamicBinaryCommand.h"
#  import "LTGammaCorrectCommand.h"
#  import "LTGammaCorrectExtendedCommand.h"
#  import "LTGrayScaleExtendedCommand.h"
#  import "LTGrayscaleToDuotoneCommand.h"
#  import "LTGrayscaleToMultitoneCommand.h"
#  import "LTHistogramCommand.h"
#  import "LTHistogramContrastCommand.h"
#  import "LTHistogramEqualizeCommand.h"
#  import "LTIntensityDetectCommand.h"
#  import "LTInvertCommand.h"
#  import "LTLightControlCommand.h"
#  import "LTLineProfileCommand.h"
#  import "LTLocalHistogramEqualizeCommand.h"
#  import "LTMathematicalFunctionCommand.h"
#  import "LTMultiplyCommand.h"
#  import "LTPosterizeCommand.h"
#  import "LTRemapHueCommand.h"
#  import "LTRemapIntensityCommand.h"
#  import "LTSegmentCommand.h"
#  import "LTSelectiveColorCommand.h"
#  import "LTSolarizeCommand.h"
#  import "LTStretchIntensityCommand.h"
#  import "LTSwapColorsCommand.h"
#endif // #if defined(LEADTOOLS_FRAMEWORK)

#endif //#if !defined(LEADTOOLS_FRAMEWORK) && !defined(LEADTOOLS_KERNEL_FRAMEWORK)