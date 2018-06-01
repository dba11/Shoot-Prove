//
//  Leadtools.Annotations.Core.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LEADTOOLS_FRAMEWORK)
#error Leadtools.framework not defined before Leadtools.Annotations.Core.framework. Please include Leadtools/Leadtools.h before including Leadtools.Annotations.Core/Leadtools.Annotations.Core.h

#else

#if !defined(LEADTOOLS_ANNOTATIONS_CORE_FRAMEWORK)
#   define LEADTOOLS_ANNOTATIONS_CORE_FRAMEWORK
#endif //#if !defined(LEADTOOLS_ANNOTATIONS_CORE_FRAMEWORK)

//Annotations Objects
#import "LTAnnObject.h"
#import "LTAnnCrossProductObject.h"
#import "LTAnnCurveObject.h"
#import "LTAnnEllipseObject.h"
#import "LTAnnGroupObject.h"
#import "LTAnnFreehandHotspotObject.h"
#import "LTAnnHotspotObject.h"
#import "LTAnnHiliteObject.h"
#import "LTAnnImageObject.h"
#import "LTAnnNoteObject.h"
#import "LTAnnPointerObject.h"
#import "LTAnnPointObject.h"
#import "LTAnnPolylineObject.h"
#import "LTAnnProtractorObject.h"
#import "LTAnnRectangleObject.h"
#import "LTAnnRedactionObject.h"
#import "LTAnnRubberStampObject.h"
#import "LTAnnSelectionObject.h"
#import "LTAnnStampObject.h"
#import "LTAnnTextObject.h"
#import "LTAnnTextPointerObject.h"
#import "LTAnnTextRollupObject.h"
#import "LTAnnAudioObject.h"
#import "LTAnnMediaObject.h"
#import "LTAnnEncryptObject.h"

//Codecs
#import "LTAnnCodecs.h"

//Container
#import "LTAnnContainer.h"
#import "LTAnnContainerMapper.h"


//Event Args

#import "LTAnnDrawDesignerEventArgs.h"
#import "LTAnnEditDesignerEventArgs.h"
#import "LTAnnPointerEventArgs.h"
#import "LTAnnRunDesignerEventArgs.h"
#import "LTAnnEditTextEventArgs.h"
#import "LTAnnLockObjectEventArgs.h"
#import "LTAnnToolTipEventArgs.h"

//others
#import "LTAnnRenderingEngine.h"
#import "LTAnnResources.h"
#import "LTAnnObservableCollection.h"
#import "LTAnnContainerCollection.h"
#import "LTAnnObjectCollection.h"
#import "LTLeadPointCollection.h"
#import "LTAnnFont.h"
#import "LTAnnLabel.h"
#import "LTAnnPicture.h"
#import "LTAnnStroke.h"
#import "LTAnnMedia.h"
#import "LTAnnBrush.h"
#import "LTAnnThickness.h"
#import "DDXML.h"
#import "LTAnnTransformer.h"
#import "LTAnnUnitConverter.h"
#import "LTAnnLayer.h"
#import "LTAnnGroupsRoles.h"
#import "LTAnnCheckModifierCallback.h"


//Protocols
#import "LTIAnnThumb.h"
#import "LTIAnnAutomationControl.h"
#import "LTIAnnLabelRenderer.h"
#import "LTIAnnObjectRenderer.h"

#endif //#if !defined(LEADTOOLS_FRAMEWORK)