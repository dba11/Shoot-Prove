//
//  LTAnnObjectRenderer.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnLabelRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@class LTAnnObject;
@class LTAnnCrossProductObject;
@class LTAnnCurveObject;
@class LTAnnEllipseObject;
@class LTAnnGroupObject;
@class LTAnnFreehandHotspotObject;
@class LTAnnHotspotObject;
@class LTAnnHiliteObject;
@class LTAnnImageObject;
@class LTAnnNoteObject;
@class LTAnnPointerObject;
@class LTAnnPointObject;
@class LTAnnPolylineObject;
@class LTAnnProtractorObject;
@class LTAnnRectangleObject;
@class LTAnnRedactionObject;
@class LTAnnRubberStampObject;
@class LTAnnSelectionObject;
@class LTAnnTextObject;
@class LTAnnTextPointerObject;
@class LTAnnTextRollupObject;
@class LTAnnContainerMapper;
@class LTAnnLabel;
@class LTAnnRenderingEngine;

@interface LTAnnObjectRenderer : NSObject <LTIAnnObjectRenderer>
@end

NS_ASSUME_NONNULL_END