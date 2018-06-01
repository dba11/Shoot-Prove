//
//  Leadtools.ImageProcessing.Core.h
//  Leadtools.ImageProcessing.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LEADTOOLS_FRAMEWORK) && !defined(LEADTOOLS_KERNEL_FRAMEWORK)
#error Leadtools.framework not defined before Leadtools.ImageProcessing.Core.framework. Please include Leadtools/Leadtools.h before including Leadtools.ImageProcessing.Core/Leadtools.ImageProcessing.Core.h

#else

#if !defined(LEADTOOLS_IMAGEPROCESSING_CORE_FRAMEWORK)
#  define LEADTOOLS_IMAGEPROCESSING_CORE_FRAMEWORK
#endif // #if !defined(LEADTOOLS_IMAGEPROCESSING_CORE_FRAMEWORK)

#if defined(LEADTOOLS_KERNEL_FRAMEWORK)
#  include "Ltimgcor.h"
#endif // #if defined(LEADTOOLS_KERNEL_FRAMEWORK)

#if defined(LEADTOOLS_FRAMEWORK)
#  import "LTMedianCommand.h"
#  import "LTMinimumCommand.h"
#  import "LTDotRemoveCommand.h"
#  import "LTApplyLinearModalityLookupTableCommand.h"
#  import "LTApplyLinearVoiLookupTableCommand.h"
#  import "LTApplyTransformationParametersCommand.h"
#  import "LTDicomLookupTableDescriptor.h"
#  import "LTApplyModalityLookupTableCommand.h"
#  import "LTApplyVoiLookupTableCommand.h"
#  import "LTAutoBinarizeCommand.h"
#  import "LTAutoCropCommand.h"
#  import "LTAutoCropRectangleCommand.h"
#  import "LTBarCodeReadPreprocessCommand.h"
#  import "LTBlankPageDetectorCommand.h"
#  import "LTBorderRemoveCommand.h"
#  import "LTColorizeGrayCommand.h"
#  import "LTConvertSignedToUnsignedCommand.h"
#  import "LTConvertUnsignedToSignedCommand.h"
#  import "LTCorrelationCommand.h"
#  import "LTCorrelationListCommand.h"
#  import "LTDeskewCommand.h"
#  import "LTDespeckleCommand.h"
#  import "LTDigitalSubtractCommand.h"
#  import "LTDiscreteFourierTransformCommand.h"
#  import "LTFastFourierTransformCommand.h"
#  import "LTFourierTransformInformation.h"
#  import "LTFourierTransformDisplayCommand.h"
#  import "LTGetLinearVoiLookupTableCommand.h"
#  import "LTInvertedPageCommand.h"
#  import "LTInvertedTextCommand.h"
#  import "LTHalftoneCommand.h"
#  import "LTHighQualityRotateCommand.h"
#  import "LTMaximumCommand.h"
#  import "LTLineRemoveCommand.h"
#  import "LTMinimumToZeroCommand.h"
#  import "LTMinMaxBitsCommand.h"
#  import "LTMinMaxValuesCommand.h"
#  import "LTMultiscaleEnhancementCommand.h"
#  import "LTResizeInterpolateCommand.h"
#  import "LTShiftDataCommand.h"
#  import "LTSmoothCommand.h"
#  import "LTSubtractBackgroundCommand.h"
#  import "LTTissueEqualizeCommand.h"
#  import "LTWindowLevelCommand.h"
#  import "LTWindowLevelExtCommand.h"
#  import "LTZeroToNegativeCommand.h"
#  import "LTGetBackgroundColorCommand.h"
#  import "LTOmrCommand.h"
#  import "LTAutoZoningCommand.h"
#  import "LTCoreUtilities.h"
#  import "LTSearchRegistrationMarksCommand.h"
#  import "LTMICRCodeDetectionCommand.h"
#  import "LTEnums.h"
#  import "LTManualPerspectiveDeskewCommand.h"
#  import "LTPerspectiveDeskewCommand.h"
#  import "LTCLAHECommand.h"
#  import "LTKMeansCommand.h"
#  import "LTWatershedCommand.h"
#  import "LTOtsuThresholdCommand.h"
#  import "LTLambdaConnectednessCommand.h"
#  import "LTLevelsetCommand.h"
#  import "LTShrinkWrapCommand.h"
#  import "LTKeyStoneCommand.h"
#  import "LTBlurDetectionCommand.h"
#  import "LTAlignImagesCommand.h"
#  import "LTAnisotropicDiffusionCommand.h"
#  import "LTTextBlurDetectionCommand.h"
#  import "LTIDCardAlignmentCommand.h"
#  import "LTUnWarpCommand.h"
#endif // #if defined(LEADTOOLS_FRAMEWORK)

#endif //#if !defined(LEADTOOLS_FRAMEWORK) && !defined(LEADTOOLS_KERNEL_FRAMEWORK)