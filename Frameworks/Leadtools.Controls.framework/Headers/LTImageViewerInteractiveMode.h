//
//  LTImageViewerInteractiveMode.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTImageViewer.h"
#import "LTInteractiveService.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTImageViewerInteractiveMode : NSObject <LTInteractiveServiceDelegate, LTInteractiveServiceBasicDelegate, UIGestureRecognizerDelegate, NSCoding> //ABSTRACT

@property (nonatomic, assign, readonly)           BOOL isWorking;
@property (nonatomic, assign, readonly)           BOOL isStarted;
@property (nonatomic, assign)                     BOOL workOnImageRectangle;

@property (nonatomic, strong, readonly, nullable) NSString *name;
@property (nonatomic, strong, readonly, nullable) LTImageViewer *imageViewer;
@property (nonatomic, strong, readonly, nullable) LTInteractiveService *interactiveService;

- (void)start:(LTImageViewer *)viewer;
- (void)stop:(LTImageViewer *)viewer;

@end

extern NSString *const LTImageViewerInteractiveModeWorkStartedNotification;
extern NSString *const LTImageViewerInteractiveModeWorkCompletedNotification;

extern NSString *const LTImageViewerInteractiveModeKey;
extern NSString *const LTImageViewerInteractiveModeGestureRecognizerKey;

NS_ASSUME_NONNULL_END