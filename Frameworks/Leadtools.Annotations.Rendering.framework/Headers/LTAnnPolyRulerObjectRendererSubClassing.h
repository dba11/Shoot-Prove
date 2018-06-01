//
//  LTAnnPolyRulerObjectRendererSubClassing.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolyRulerObjectRenderer.h"

@interface LTAnnPolyRulerObjectRenderer (SubClassing)

- (void)drawTickMarksMapper:(LTAnnContainerMapper *)mapper start:(LeadPointD)startPoint end:(LeadPointD)endPoint tickMarklength:(LeadLengthD)length unit:(LTAnnUnit)unit stroke:(LTAnnStroke *)stroke operations:(LTAnnFixedStateOperations)operations;

- (void)drawGaugeMapper:(LTAnnContainerMapper *)mapper start:(LeadPointD)startPoint end:(LeadPointD)endPoint gaugeLength:(double)gaugeLength stroke:(LTAnnStroke *)stroke operations:(LTAnnFixedStateOperations)operations;

- (void)drawLengthTextMapper:(LTAnnContainerMapper *)mapper label:(LTAnnLabel *)label operations:(LTAnnFixedStateOperations)operations;

@end