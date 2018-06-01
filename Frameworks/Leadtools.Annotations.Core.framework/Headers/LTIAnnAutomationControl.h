//
//  LTIAnnAutomationControl.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@class LTRasterImage,LTAnnContainer,LTAnnPointerEventArgs,LTAnnRenderingEngine;

@protocol LTIAnnAutomationControl;

NS_ASSUME_NONNULL_BEGIN

@protocol LTIAnnAutomationControlGetContainersCallback <NSObject>

- (LTAnnContainer *)annAutomationControlGetContainersCallback;

@end

@protocol LTAnnAutomationControlDelegate <NSObject>

- (void)automationControl:(id<LTIAnnAutomationControl>)control pointerDown:(LTAnnPointerEventArgs *)args;
- (void)automationControl:(id<LTIAnnAutomationControl>)control pointerMove:(LTAnnPointerEventArgs *)args;
- (void)automationControl:(id<LTIAnnAutomationControl>)control pointerUp:(LTAnnPointerEventArgs *)args;
- (void)automationControl:(id<LTIAnnAutomationControl>)control doubleTap:(nullable LTAnnPointerEventArgs *)args;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@protocol LTIAnnAutomationControl <NSObject>

@property (nonatomic, weak, nullable)             id<LTAnnAutomationControlDelegate> automationDelegate;
@property (nonatomic, strong, nullable)           LTAnnRenderingEngine *renderingEngine;
@property (nonatomic, strong, readonly, nullable) LTAnnContainer *automationContainer;

@property (nonatomic, assign)                     BOOL focus;
@property (nonatomic, assign, readonly)           BOOL automationUseDpi;
@property (nonatomic, assign, readonly)           BOOL automationEnabled;

@property (nonatomic, assign, readonly)           double automationDpiX;
@property (nonatomic, assign, readonly)           double automationDpiY;
@property (nonatomic, assign, readonly)           double automationXResolution;
@property (nonatomic, assign, readonly)           double automationYResolution;

@property (nonatomic, assign, readonly)           LeadPointD automationOffset;
@property (nonatomic, assign, readonly)           LeadSizeD automationSize;
@property (nonatomic, assign, readonly)           LeadMatrix automationTransform;

@property (nonatomic, strong, readonly, nullable) LTRasterImage *image;

- (void)automationAttach:(LTAnnContainer *)container;
- (void)automationDetach;
- (void)automationInvalidate:(LeadRectD)rect;

@end

NS_ASSUME_NONNULL_END