//
//  LTIAnnObjectRenderer.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@class LTAnnRenderingEngine;
@class LTLeadPointCollection;
@class LTAnnContainerMapper;
@class LTAnnObject;

@protocol LTIAnnThumbStyle, LTIAnnLabelRenderer;

NS_ASSUME_NONNULL_BEGIN

@protocol LTIAnnObjectRenderer <NSObject>

@property (nonatomic, strong, nullable) id<LTIAnnThumbStyle> locationsThumbStyle;
@property (nonatomic, strong, nullable) id<LTIAnnThumbStyle> rotateCenterThumbStyle;
@property (nonatomic, strong, nullable) id<LTIAnnThumbStyle> rotateGripperThumbStyle;
@property (nonatomic, strong, readonly) LTAnnRenderingEngine *renderingEngine;
@property (nonatomic, strong, nullable) id<LTIAnnLabelRenderer> labelRenderer;

- (void)initialize:(LTAnnRenderingEngine *)renderingEngine;

- (LTLeadPointCollection *)getRenderPointsMapper:(LTAnnContainerMapper *)mapper object:(LTAnnObject *)annObject;

- (void)renderMapper:(LTAnnContainerMapper *)mapper object:(LTAnnObject *)annObject;
- (void)renderThumbsMapper:(LTAnnContainerMapper *)mapper thumbsLocations:(LTLeadPointCollection *)thumbLocations operations:(LTAnnFixedStateOperations)operations;
- (void)renderRotatePointThumbsMapper:(LTAnnContainerMapper *)mapper rotateCenterLocation:(LeadPointD)rotateCenterLocation rotateGripperLocation:(LeadPointD)rotateGripperLocation operations:(LTAnnFixedStateOperations)operations;
- (void)renderLockedMapper:(LTAnnContainerMapper *)mapper object:(LTAnnObject *)annObject operations:(LTAnnFixedStateOperations)operations;

- (void)addObject:(LTAnnObject *)annObject;
- (void)removeObject:(LTAnnObject *)annObject;

@end

NS_ASSUME_NONNULL_END