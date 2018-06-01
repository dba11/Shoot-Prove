//
//  LTAnnProtractorObjectRenderer.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolyRulerObjectRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnProtractorObjectRenderer : LTAnnPolyRulerObjectRenderer

- (NSString *)getAngleText:(double)angle precision:(double)precision unit:(LTAnnAngularUnit)unit unitsAbbreviation:(NSDictionary *)unitsAbbreviation;

- (void)drawAngleTextMapper:(LTAnnContainerMapper *)mapper label:(LTAnnLabel *)label operations:(LTAnnFixedStateOperations)operations;

- (void)renderMapper:(LTAnnContainerMapper *)mapper object:(LTAnnObject* )annObject;

@end

NS_ASSUME_NONNULL_END