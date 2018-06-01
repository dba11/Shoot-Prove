//
//  LTImageViewerAutomationControl.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@class LTImageViewerInteractiveMode, LTImageViewer;
@protocol LTIAnnAutomationControl, LTAnnRenderingEngineDelegate, LTIAnnAutomationControlGetContainersCallback;

NS_ASSUME_NONNULL_BEGIN

@interface LTImageViewerAutomationControl : LTImageViewerInteractiveMode <LTIAnnAutomationControl, LTAnnRenderingEngineDelegate>

- (instancetype)initWithViewer:(LTImageViewer *)viewer;

@end

NS_ASSUME_NONNULL_END