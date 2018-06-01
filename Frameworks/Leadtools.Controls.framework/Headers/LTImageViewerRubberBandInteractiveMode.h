//
//  LTImageViewerRubberBandInteractiveMode.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTImageViewerInteractiveMode.h"

@class LTImageViewerRubberBandEventArg;
@class LTImageViewerRubberBandInteractiveMode;

NS_ASSUME_NONNULL_BEGIN

@protocol LTImageViewerRubberBandDelegate <NSObject>
@optional
-(void)imageViewerRubberBandInteractiveMode:(LTImageViewerRubberBandInteractiveMode *)imageViewerRubberBandInteractiveMode startWithArgs:(LTImageViewerRubberBandEventArg *)args;
-(void)imageViewerRubberBandInteractiveMode:(LTImageViewerRubberBandInteractiveMode *)imageViewerRubberBandInteractiveMode workingWithArgs:(LTImageViewerRubberBandEventArg *)args;
-(void)imageViewerRubberBandInteractiveMode:(LTImageViewerRubberBandInteractiveMode *)imageViewerRubberBandInteractiveMode endWithArgs:(LTImageViewerRubberBandEventArg *)args;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewerRubberBandEventArg : NSObject

@property (nonatomic, assign) CGPoint point1;
@property (nonatomic, assign) CGPoint point2;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTImageViewerRubberBandInteractiveMode : LTImageViewerInteractiveMode <NSCoding>

@property (nonatomic, weak)   id<LTImageViewerRubberBandDelegate> delegate;

@property (nonatomic, assign) double borderThickness;
@property (nonatomic, assign) double dashPhase;

@property (nonatomic, copy)   UIColor *borderColor;
@property (nonatomic, strong) NSArray<NSNumber *> *borderDashPattern;

@property (nonatomic, assign) CGLineCap lineCap;

@end

NS_ASSUME_NONNULL_END