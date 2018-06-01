//
//  LTAnnUniversalRenderingEngine.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnUniversalRenderingEngine : LTAnnRenderingEngine

@property (nonatomic, assign, readonly, nullable) CGContextRef context;

- (instancetype)initWithContainer:(nullable LTAnnContainer *)container context:(nullable CGContextRef)context;

+ (void)setContext:(nullable CGContextRef)context fill:(LTAnnBrush *)brush;
+ (void)setContext:(nullable CGContextRef)context stroke:(LTAnnStroke *)stroke;
+ (void)setContext:(nullable CGContextRef)context fill:(LTAnnBrush *)brush opacity:(CGFloat)opacity;
+ (void)setContext:(nullable CGContextRef)context stroke:(LTAnnStroke *)stroke opacity:(CGFloat)opacity;

+ (UIFont *)toFont:(LTAnnFont *)aFont;
+ (LeadSizeD)getTextSize:(NSString *)text font:(LTAnnFont *)font layoutArea:(LeadSizeD)layoutArea;

- (void)drawPicture:(LTAnnPicture *)picture rect:(LeadRectD)rect annObject:(LTAnnObject *)annObject;

- (void)attachContainer:(LTAnnContainer *)container context:(CGContextRef)context;

@end

NS_ASSUME_NONNULL_END