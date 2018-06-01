//
//  LTAnnEditDesignerSubClassing.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnEditDesigner.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnEditDesigner (SubClassing)

@property (nonatomic, assign, readonly)           LeadPointD rotateGripper;
@property (nonatomic, assign, readonly)           LeadPointD rotateCenterPoint;
@property (nonatomic, assign, readonly)           LeadPointD intersectionWithReferencePoints;

@property (nonatomic, strong, readonly, nullable) LTLeadPointCollection *rotationReferencePoints;

- (BOOL)startWorking:(LTAnnEditDesignerOperation)operation thumbIndex:(NSUInteger)thumbIndex clip:(BOOL)clipCursor;
- (BOOL)working;
- (BOOL)endWorking;

- (void)onEdit:(LTAnnEditDesignerEventArgs *)args;

- (void)moveOffsetX:(double)offsetX offsetY:(double)offsetY;
- (void)moveThumbAtIndex:(NSUInteger)thumbIndex toOffset:(LeadPointD)point;

@end

NS_ASSUME_NONNULL_END