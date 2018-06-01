//
//  Leadtools.Annotations.Automation.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#if !defined(LEADTOOLS_FRAMEWORK)
#error Leadtools.framework not defined before Leadtools.Annotations.Automation.framework. Please include Leadtools/Leadtools.h before including Leadtools.Annotations.Automation/Leadtools.Annotations.Automation.h

#elif !defined(LEADTOOLS_ANNOTATIONS_CORE_FRAMEWORK)
#error Leadtools.Annotations.Core.framework not defined before Leadtools.Annotations.Automation.framework. Please include Leadtools.Annotations.Core/Leadtools.Annotations.Core.h before including Leadtools.Annotations.Automation/Leadtools.Annotations.Automation.h

#elif !defined(LEADTOOLS_ANNOTATIONS_DESIGNERS_FRAMEWORK)
#error Leadtools.Annotations.Designers.framework not defined before Leadtools.Annotations.Automation.framework. Please include Leadtools.Annotations.Designers/Leadtools.Annotations.Designers.h before including Leadtools.Annotations.Automation/Leadtools.Annotations.Automation.h

#else

#if !defined(LEADTOOLS_ANNOTATIONS_AUTOMATION_FRAMEWORK)
#   define LEADTOOLS_ANNOTATIONS_AUTOMATION_FRAMEWORK
#endif //#if !defined(LEADTOOLS_ANNOTATIONS_AUTOMATION_FRAMEWORK)

#import "LTAnnAutomation.h"
#import "LTAnnAutomationCollection.h"
#import "LTAnnAutomationManager.h"
#import "LTAnnAutomationObject.h"
#import "LTAnnPropertyInfo.h"
#import "LTImageViewerAutomationControl.h"
#import "LTAnnObjectEditor.h"
#import "LTAnnAutomationUndoRedoObject.h"
#import "LTAnnAutomationEventArgs.h"
#import "LTAnnObjectChangedEventArgs.h"
#import "LTAnnDragDropEventArgs.h"
#import "LTIAnnPackage.h"

#endif //#if !defined(LEADTOOLS_FRAMEWORK)