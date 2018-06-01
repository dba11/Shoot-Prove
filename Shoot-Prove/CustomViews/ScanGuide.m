/*************************************************************************
 *
 * SHOOT&PROVE CONFIDENTIAL
 * __________________
 *
 *  [2016]-[2018] Shoot&Prove SA/NV
 *  www.shootandprove.com
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property
 * of Shoot&Prove SA/NV. The intellectual and technical concepts contained
 * herein are proprietary to Shoot&Prove SA/NV.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Shoot&Prove SA/NV.
 */

#import "ScanGuide.h"
#import "UIColor+HexString.h"

@implementation ScanGuide
{
	UILabel *_topLabel;
	UILabel *_bottomLabel;
}
@synthesize guideSize = _guideSize, guideColor = _guideColor, interfaceOrientation = _interfaceOrientation;
@dynamic guideFrame;

- (CGRect)guideFrame {
    CGFloat previewWidth = self.bounds.size.width;
    CGFloat previewHeight = self.bounds.size.height;
    CGFloat guideWidth = 0.0;
    CGFloat guideHeight = 0.0;
	CGFloat ratio = 0.0;
    if (UIInterfaceOrientationIsPortrait(_interfaceOrientation)) {
		ratio = _guideSize.height / _guideSize.width;
		guideWidth = previewWidth * scanGuideSizeRatio;
		guideHeight = guideWidth * ratio;
    } else {
		ratio = _guideSize.width / _guideSize.height;
        guideHeight = previewHeight * scanGuideSizeRatio;
        guideWidth = guideHeight * ratio;
    }
    return CGRectMake((previewWidth - guideWidth) / 2.0, (previewHeight - guideHeight) / 2.0, guideWidth, guideHeight);
}

#pragma - Drawing Methods
- (void)drawInContext:(CGContextRef)context {
    [super drawInContext:context];
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 5.0);
    CGContextSetShadow(context, CGSizeMake(-2, 2), 5);
    CGRect guideBounds = [self guideFrame];
    [self addDashedLineLayer:guideBounds];
    CGContextSetStrokeColorWithColor(context, _guideColor.CGColor);
    const double cornersStrokeWidth = 20.0;
    CGContextMoveToPoint(context, guideBounds.origin.x + cornersStrokeWidth, guideBounds.origin.y);
    CGContextAddLineToPoint(context, guideBounds.origin.x, guideBounds.origin.y);
    CGContextAddLineToPoint(context, guideBounds.origin.x, guideBounds.origin.y + cornersStrokeWidth);
    CGContextMoveToPoint(context, guideBounds.origin.x + guideBounds.size.width - cornersStrokeWidth, guideBounds.origin.y);
    CGContextAddLineToPoint(context, guideBounds.origin.x + guideBounds.size.width, guideBounds.origin.y);
    CGContextAddLineToPoint(context, guideBounds.origin.x + guideBounds.size.width, guideBounds.origin.y + cornersStrokeWidth);
    CGContextMoveToPoint(context, guideBounds.origin.x, guideBounds.origin.y + guideBounds.size.height - cornersStrokeWidth);
    CGContextAddLineToPoint(context, guideBounds.origin.x, guideBounds.origin.y + guideBounds.size.height);
    CGContextAddLineToPoint(context, guideBounds.origin.x + cornersStrokeWidth, guideBounds.origin.y + guideBounds.size.height);
    CGContextMoveToPoint(context, guideBounds.origin.x + guideBounds.size.width - cornersStrokeWidth, guideBounds.origin.y + guideBounds.size.height);
    CGContextAddLineToPoint(context, guideBounds.origin.x + guideBounds.size.width, guideBounds.origin.y + guideBounds.size.height);
    CGContextAddLineToPoint(context, guideBounds.origin.x + guideBounds.size.width, guideBounds.origin.y + guideBounds.size.height - cornersStrokeWidth);
	const BOOL isPhone = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
	CGRect labelFrame = CGRectMake(guideBounds.origin.x, guideBounds.origin.y + 5, guideBounds.size.width, isPhone ? 12.0 : 24.0);
	if(_topLabel == nil)
		_topLabel = [[UILabel alloc] initWithFrame:labelFrame];
	else
		_topLabel.frame = labelFrame;
	_topLabel.textAlignment       = NSTextAlignmentCenter;
	_topLabel.backgroundColor     = [UIColor clearColor];
    @try {
        [_topLabel setTextColor:_guideColor ? _guideColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
    } @catch(NSException *e) {
        [_topLabel setTextColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
    }
	_topLabel.font                = [UIFont systemFontOfSize:isPhone ? 12.0 : 24.0];
	_topLabel.text                = NSLocalizedString(@"SCANNER_LAYOUT_GUIDE_TOP", nil);
	labelFrame = CGRectMake(guideBounds.origin.x, guideBounds.origin.y + guideBounds.size.height - ((isPhone ? 12.0 : 24.0) + 5), guideBounds.size.width, isPhone ? 12.0 : 24.0);
	if(_bottomLabel == nil)
		_bottomLabel = [[UILabel alloc] initWithFrame:labelFrame];
	else
		_bottomLabel.frame = labelFrame;
	_bottomLabel.textAlignment       = NSTextAlignmentCenter;
	_bottomLabel.backgroundColor     = [UIColor clearColor];
	[_bottomLabel setTextColor:_guideColor ? _guideColor:[UIColor colorWithHexString:colorRed andAlpha:1.0f]];
	_bottomLabel.font                = [UIFont systemFontOfSize:isPhone ? 12.0 : 24.0];
	_bottomLabel.text                = NSLocalizedString(@"SCANNER_LAYOUT_GUIDE_BOTTOM", nil);;
	[self addSublayer:_topLabel.layer];
	[self addSublayer:_bottomLabel.layer];
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)addDashedLineLayer:(CGRect)guideBounds {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds = guideBounds;
    shapeLayer.position = CGPointMake(CGRectGetMidX(guideBounds), CGRectGetMidY(guideBounds));
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = _guideColor.CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineDashPattern = @[@10, @5];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, guideBounds);
    shapeLayer.path = path;
    CGPathRelease(path);
    for(NSInteger i = self.sublayers.count-1; i >= 0; i--) {
        CALayer *layer = self.sublayers[i];
        [layer removeFromSuperlayer];
    }
    [self addSublayer:shapeLayer];
}
@end
