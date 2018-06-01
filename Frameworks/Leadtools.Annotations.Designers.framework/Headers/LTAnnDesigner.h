//
//  LTAnnDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@class LTAnnObject, LTAnnContainer, LTAnnPointerEventArgs;
@protocol LTAnnAutomationControl, LTIAnnObjectRenderer;

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnDesigner : NSObject // ABSTRACT

@property (nonatomic, strong, nullable)                     LTAnnObject *targetObject;

@property (nonatomic, assign, readonly)                     BOOL hasStarted;

@property (nonatomic, strong, readonly, nullable)           id<LTAnnAutomationControl> automationControl;
@property (nonatomic, strong, readonly, nullable)           id<LTIAnnObjectRenderer> renderer;

- (void)start;
- (void)end;
- (void)cancel;

- (BOOL)onPointerDown:(LTAnnContainer *)container args:(LTAnnPointerEventArgs *)args;
- (BOOL)onPointerMove:(LTAnnContainer *)container args:(LTAnnPointerEventArgs *)args;
- (BOOL)onPointerUp:(LTAnnContainer *)container args:(LTAnnPointerEventArgs *)args;
- (BOOL)onDoubleTap:(LTAnnContainer *)container args:(LTAnnPointerEventArgs *)args;

- (void)invalidate:(LeadRectD)rect;

@end

NS_ASSUME_NONNULL_END