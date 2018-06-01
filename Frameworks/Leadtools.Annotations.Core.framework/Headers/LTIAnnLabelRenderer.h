//
//  LTIAnnLabelRenderer.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@protocol LTIAnnLabelRenderer <NSObject>

@property (nonatomic, strong, readonly) LTAnnRenderingEngine *renderingEngine;
@property (nonatomic, assign)           BOOL offsetHeight;

- (void)initialize:(LTAnnRenderingEngine *)renderingEngine;

- (void)renderLabelMapper:(LTAnnContainerMapper *)mapper label:(LTAnnLabel *)label operations:(LTAnnFixedStateOperations)operations;
- (LeadRectD)getBoundsMapper:(LTAnnContainerMapper *)mapper label:(LTAnnLabel *)label operation:(LTAnnFixedStateOperations)operation;

@end

NS_ASSUME_NONNULL_END