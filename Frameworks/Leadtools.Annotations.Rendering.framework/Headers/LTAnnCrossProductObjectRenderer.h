//
//  LTAnnCrossProductObjectRenderer.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolyRulerObjectRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnCrossProductObjectRenderer : LTAnnPolyRulerObjectRenderer

- (void)renderMapper:(LTAnnContainerMapper *)mapper object:(LTAnnObject *)annObject;

@end

NS_ASSUME_NONNULL_END