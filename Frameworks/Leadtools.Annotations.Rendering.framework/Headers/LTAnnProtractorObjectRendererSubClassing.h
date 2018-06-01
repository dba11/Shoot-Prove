//
//  LTAnnProtractorObjectRendererSubClassing.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnProtractorObjectRenderer.h"

@interface LTAnnProtractorObjectRenderer (SubClassing)

- (void)drawArcMapper:(LTAnnContainerMapper *)mapper center:(LeadPointD)center startAngle:(double)startAngle sweepAngle:(double)sweepAngle arcRadius:(LeadLengthD)arcRadius stroke:(LTAnnStroke *)stroke operations:(LTAnnFixedStateOperations)operations;

@end