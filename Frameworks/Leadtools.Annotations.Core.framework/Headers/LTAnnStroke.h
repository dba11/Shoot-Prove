//
//  LTAnnStroke.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTAnnBrush.h"
#import "LTEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnStroke : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign)           double strokeMiterLimit;
@property (nonatomic, assign)           double strokeDashOffset;

@property (nonatomic, strong)           LTAnnBrush *stroke;
@property (nonatomic, assign)           LeadLengthD strokeThickness;
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *strokeDashArray;

@property (nonatomic, assign)           LTAnnStrokeLineCap strokeDashCap;
@property (nonatomic, assign)           LTAnnStrokeLineCap strokeStartLineCap;
@property (nonatomic, assign)           LTAnnStrokeLineCap strokeEndLineCap;
@property (nonatomic, assign)           LTAnnStrokeLineJoin strokeLineJoin;

- (instancetype)initWithBrush:(LTAnnBrush *)brush withThickness:(LeadLengthD)thickness NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END