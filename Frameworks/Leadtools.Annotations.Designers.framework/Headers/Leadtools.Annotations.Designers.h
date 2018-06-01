//
//  Leadtools.Annotations.Designers.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LEADTOOLS_FRAMEWORK)
#error Leadtools.framework not defined before Leadtools.Annotations.Designers.framework. Please include Leadtools/Leadtools.h before including Leadtools.Annotations.Designers/Leadtools.Annotations.Designers.h

#elif !defined(LEADTOOLS_ANNOTATIONS_CORE_FRAMEWORK)
#error Leadtools.Annotations.Core.framework not defined before Leadtools.Annotations.Designers.framework. Please include Leadtools.Annotations.Core/Leadtools.Annotations.Core.h before including Leadtools.Annotations.Designers/Leadtools.Annotations.Designers.h

#else

#if !defined(LEADTOOLS_ANNOTATIONS_DESIGNERS_FRAMEWORK)
#   define LEADTOOLS_ANNOTATIONS_DESIGNERS_FRAMEWORK
#endif //#if !defined(LEADTOOLS_ANNOTATIONS_DESIGNERS_FRAMEWORK)

//Designers
#import "LTAnnDesigner.h"
#import "LTAnnDrawDesigner.h"
#import "LTAnnEditDesigner.h"
#import "LTAnnRunDesigner.h"

//Draw Designers
#import "LTAnnCrossProductDrawDesigner.h"
#import "LTAnnFreehandDrawDesigner.h"
#import "LTAnnLineDrawDesigner.h"
#import "LTAnnPointDrawDesigner.h"
#import "LTAnnPolylineDrawDesigner.h"
#import "LTAnnProtractorDrawDesigner.h"
#import "LTAnnRectangleDrawDesigner.h"
#import "LTAnnTextPointerDrawDesigner.h"

//Edit Designers
#import "LTAnnCrossProductEditDesigner.h"
#import "LTAnnPointEditDesigner.h"
#import "LTAnnPolylineEditDesigner.h"
#import "LTAnnRectangleEditDesigner.h"
#import "LTAnnSelectionEditDesigner.h"
#import "LTAnnTextEditDesigner.h"
#import "LTAnnTextPointerEditDesigner.h"

//Run Designers
#import "LTAnnRunDesigner.h"
#import "LTAnnTextRollupRunDesigner.h"

#endif //#if !defined(LEADTOOLS_FRAMEWORK)