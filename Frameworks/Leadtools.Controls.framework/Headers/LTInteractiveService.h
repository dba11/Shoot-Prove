//
//  LTInteractiveService.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

@class LTBasicGestureRecognizer;
@class LTInteractiveService;

NS_ASSUME_NONNULL_BEGIN

@protocol LTBasicGestureRecognizerDelegate <NSObject>
@optional
- (void)basicGestureRecognizerPointerDown:(LTBasicGestureRecognizer *)recognizer;
- (void)basicGestureRecognizerPointerDrag:(LTBasicGestureRecognizer *)recognizer;
- (void)basicGestureRecognizerPointerUp:(LTBasicGestureRecognizer *)recognizer;
- (void)basicGestureRecognizerPointerDoubleTap:(LTBasicGestureRecognizer *)recognizer;
- (void)basicGestureRecognizerPointerCancel:(LTBasicGestureRecognizer *)recognizer;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTBasicGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) id<LTBasicGestureRecognizerDelegate> basicDelegate;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

typedef NS_ENUM(NSInteger, LTBasicGesturePhase) {
    LTBasicGesturePhaseDown,
    LTBasicGesturePhaseMove,
    LTBasicGesturePhaseUp,
    LTBasicGesturePhaseDoubleTab,
    LTBasicGesturePhaseCancel,
};

@interface LTBasicGestureEvent : NSObject

@property (nonatomic, strong, readonly) LTBasicGestureRecognizer *gestureRecognizer;
@property (nonatomic, assign, readonly) LTBasicGesturePhase gesturePhase;

- (instancetype)init __unavailable;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@protocol LTInteractiveServiceDelegate <NSObject>
@optional
- (void)interactiveService:(LTInteractiveService *)service pinchWithArgs:(UIPinchGestureRecognizer *)recognizer;
- (void)interactiveService:(LTInteractiveService *)service tapWithArgs:(UITapGestureRecognizer *)recognizer;
- (void)interactiveService:(LTInteractiveService *)service doubleTapWithArgs:(UITapGestureRecognizer *)recognizer;
- (void)interactiveService:(LTInteractiveService *)service holdWithArgs:(UILongPressGestureRecognizer *)recognizer;
- (void)interactiveService:(LTInteractiveService *)service panWithArgs:(UIPanGestureRecognizer *)recognizer;
- (void)interactiveService:(LTInteractiveService *)service rotateWithArgs:(UIRotationGestureRecognizer *)recognizer;
- (void)interactiveService:(LTInteractiveService *)service basicWithArgs:(LTBasicGestureRecognizer *)recognizer;

@end

@protocol LTInteractiveServiceBasicDelegate <NSObject>
@optional
- (void)interactiveService:(LTInteractiveService *)service basicGestureEvent:(LTBasicGestureEvent *)basicGesture;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTInteractiveService : NSObject <LTBasicGestureRecognizerDelegate>

@property (nonatomic, strong)           UIView *target;
@property (nonatomic, assign, readonly) BOOL isListening;
@property (nonatomic, weak, nullable)   id<LTInteractiveServiceDelegate, LTInteractiveServiceBasicDelegate> delegate;
@property (nonatomic, strong, readonly) NSMutableArray<UIView *> *userViews;
@property (nonatomic, strong, readonly) NSMutableArray<UIView *> *execludedSubView;

@property (nonatomic, strong, readonly) UIRotationGestureRecognizer *rotateGesture;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong, readonly) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *holdGesture;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong, readonly) LTBasicGestureRecognizer *basicGesture;

- (instancetype)initWithTarget:(UIView *)target NS_DESIGNATED_INITIALIZER;
- (instancetype)init __unavailable;

- (void)startListening;
- (void)stopListening;

- (void)setAllGestureRecognizerDelegates:(id<UIGestureRecognizerDelegate>)delegate;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTBasicGestureRecognizer(BasicGestureDeleage)

@property (nonatomic, weak, nullable) id<LTBasicGestureRecognizerDelegate> basicDelegate;
@property (nonatomic, assign)         NSTimeInterval doubleTouchBasicIntervalTime;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

extern NSString *const LTInteractiveServiceRotateNotification;
extern NSString *const LTInteractiveServiceTapNotification;
extern NSString *const LTInteractiveServiceDoubleTapNotification;
extern NSString *const LTInteractiveServicePinchNotification;
extern NSString *const LTInteractiveServiceHoldNotification;
extern NSString *const LTInteractiveServicePanNotification;
extern NSString *const LTInteractiveServiceBasicNotification;

extern NSString *const LTInteractiveServicePointerDownNotification;
extern NSString *const LTInteractiveServicePointerUpNotification;
extern NSString *const LTInteractiveServicePointerDragNotification;
extern NSString *const LTInteractiveServicePointerDoubleTapNotification;
extern NSString *const LTInteractiveServicePointerCancelNotification;

extern NSString *const LTInteractiveServiceGestureRecognizerKey;

NS_ASSUME_NONNULL_END