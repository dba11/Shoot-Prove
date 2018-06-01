//
//  LTAnnTransformer.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTLeadPointCollection.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnTransformer : NSObject

+ (LeadPointD)rotatePoint:(LeadPointD)point angle:(double)angle;
+ (LeadPointD)rotatePoint:(LeadPointD)point angle:(double)angle centerX:(double)centerX centerY:(double)centerY;

+ (LeadPointD)scalePoint:(LeadPointD)point xScale:(double)xScale yScale:(double)yScale;
+ (LeadPointD)scalePoint:(LeadPointD)point xScale:(double)xScale yScale:(double)yScale centerX:(double)centerX centerY:(double)centerY;

+ (LeadPointD)translatePoint:(LeadPointD)point offsetX:(double)offsetX offsetY:(double)offsetY;

+ (LTLeadPointCollection *)rotatePoints:(LTLeadPointCollection *)points angle:(double)angle;
+ (LTLeadPointCollection *)rotatePoints:(LTLeadPointCollection *)points angle:(double)angle centerX:(double)centerX centerY:(double)centerY;

+ (LTLeadPointCollection *)scalePoints:(LTLeadPointCollection *)points xScale:(double)xScale yScale:(double)yScale centerX:(double)centerX centerY:(double)centerY;

+ (LTLeadPointCollection *)translatePoints:(LTLeadPointCollection *)points offsetX:(double)offsetX offsetY:(double)offsetY;

+ (LeadRectD)rotateRect:(LeadRectD)rect angle:(double)angle;
+ (LeadRectD)rotateRect:(LeadRectD)rect angle:(double)angle centerX:(double)centerX centerY:(double)centerY;

@end

NS_ASSUME_NONNULL_END