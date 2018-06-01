//
//  LTAnnEditDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDesigner.h"
#import "LTAnnDesignerSubClassing.h"

NS_ASSUME_NONNULL_BEGIN

@class LTAnnEditDesigner, LTAnnEditDesignerEventArgs, LTLeadPointCollection;

@protocol LTAnnEditDesignerDelegate<NSObject>

@optional
- (void)editDesigner:(LTAnnEditDesigner *)designer editWithArgs:(LTAnnEditDesignerEventArgs *)args;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnEditDesigner : LTAnnDesigner

@property (nonatomic, weak, nullable)             id<LTAnnEditDesignerDelegate> delegate;

@property (nonatomic, assign)                     BOOL maintainAspectRatio;
@property (nonatomic, assign)                     BOOL useRotateThumbs;
@property (nonatomic, assign)                     BOOL showThumbs;
@property (nonatomic, assign)                     BOOL restrictRotateGripper;

@property (nonatomic, assign)                     NSUInteger thumbsHitTestBuffer;
@property (nonatomic, assign, readonly)           NSUInteger moveThumbIndex;

@property (nonatomic, assign)                     LTAnnEditDesignerOperation operation;

@property (nonatomic, strong, readonly, nullable) LTLeadPointCollection *thumbLocations;

- (BOOL)hitTestThumbs:(LeadPointD)point;
- (void)resetRotateThumbs;

@end

NS_ASSUME_NONNULL_END