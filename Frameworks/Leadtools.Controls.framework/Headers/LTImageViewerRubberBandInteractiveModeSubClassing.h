//
//  LTImageViewerRubberBandInteractiveModeSubClassing.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTImageViewerRubberBandInteractiveMode.h"

@interface LTImageViewerRubberBandInteractiveMode(SubClassing)

- (void)onRubberBandStartedWithArgs:(LTImageViewerRubberBandEventArg *)args;
- (void)onRubberBandWorkingWithArgs:(LTImageViewerRubberBandEventArg *)args;
- (void)onRubberBandCompletedWithArgs:(LTImageViewerRubberBandEventArg *)args;

@end