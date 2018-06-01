//
//  LTIAnnThumb.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnBrush.h"
#import "LTAnnStroke.h"

@protocol LTIAnnObjectRenderer;
@class LTAnnContainerMapper;

NS_ASSUME_NONNULL_BEGIN

@protocol LTIAnnThumbStyle<NSObject>

@property (nonatomic, strong, nullable) LTAnnBrush *fill;
@property (nonatomic, strong, nullable) LTAnnStroke *stroke;

@property (nonatomic, assign)           LeadSizeD size;

@property (nonatomic, assign)           BOOL isVisible;

@property (nonatomic, strong, nullable) id<LTIAnnObjectRenderer> renderer;

- (BOOL)hitTestPoint:(LeadPointD)location testPoint:(LeadPointD)testPoint buffer:(double)buffer;
- (BOOL)rendererHitTestPoint:(LeadPointD)location testPoint:(LeadPointD)testPoint buffer:(double)buffer mapper:(LTAnnContainerMapper *)mapper;
- (void)renderer:(id<LTIAnnObjectRenderer>)renderer mapper:(LTAnnContainerMapper *)mapper location:(LeadPointD)location operation:(LTAnnFixedStateOperations)operation;

@end

NS_ASSUME_NONNULL_END