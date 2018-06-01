//
//  LTImageViewerInteractiveModeSubClassing.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@interface LTImageViewerInteractiveMode(SubClassing)

@property (nonatomic, assign, readonly) BOOL restartOnImageChange;

- (BOOL)canStartWork:(UIGestureRecognizer *)gestureRecognizer;
- (void)onWorkStarted:(UIGestureRecognizer *)gestureRecognizer;
- (void)onWorkCompleted:(UIGestureRecognizer *)gestureRecognizer;

@end