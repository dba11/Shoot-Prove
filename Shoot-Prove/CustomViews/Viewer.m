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

#import "Viewer.h"

#import "ShadowButton.h"
#import "UIColor+HexString.h"
#import "ErrorHelper.h"
#import "ToastHelper.h"

@interface Viewer()
{
    UIView *_topView;
    UIView *_modalView;
	UIWebView *_webView;
    UIImageView *_imageView;
	ShadowButton *_closeButton;
}
@end

@implementation Viewer
- (id)initWithFilePath:(NSString *)path mimeType:(NSString *)mimeType {
	self = [super init];
	if(self) {
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
        _topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
        CGRect contentFrame = _topView.frame;
        self.frame = CGRectMake(0, 20, contentFrame.size.width, contentFrame.size.height-20);
		self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0f;
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _webView.backgroundColor = [UIColor colorWithHexString:colorGrey andAlpha:0.6f];
        [_webView loadData:[NSData dataWithContentsOfFile:path] MIMEType:mimeType textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
        _webView.scalesPageToFit = YES;
        _webView.userInteractionEnabled = YES;
        [self addSubview:_webView];
        [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setTopConstraintForView:_webView top:0];
        [self setLeftConstraintForView:_webView left:0];
        [self setRightConstraintForView:_webView right:0];
        [self setBottomConstraintForView:_webView bottom:0];
        CGRect buttonFrame = CGRectMake(0, contentFrame.size.width - 32, 32, 32);
        _closeButton = [[ShadowButton alloc] initWithFrame:buttonFrame];
        _closeButton.backgroundColor = [UIColor colorWithHexString:colorBlack andAlpha:1.0];
        _closeButton.layer.cornerRadius = 16;
        [_closeButton setTitle:nil forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeButton.adjustsImageWhenHighlighted = NO;
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        [_closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setTopConstraintForView:_closeButton top:0];
        [self setRightConstraintForView:_closeButton right:0];
        [self setWidthConstraintForView:_closeButton width:32];
        [self setHeightConstraintForView:_closeButton height:32];
	}
	return self;
}

#pragma - public methods
- (void)show {
    [_topView addSubview:self];
    [self setTopViewConstraints];
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {}];
}

- (void)hide {
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        [self removeFromSuperview];
        [NSNotificationCenter.defaultCenter removeObserver:self];
    }];
}

#pragma - contraints methods
- (void)setTopViewConstraints {
    [_topView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_topView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:20]];
    [_topView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_topView
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:0]];
    [_topView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_topView
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:0]];
    [_topView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_topView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0]];
}

- (void)setTopConstraintForView:(UIView *)view top:(CGFloat)top {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:top]];
}

- (void)setLeftConstraintForView:(UIView *)view left:(CGFloat)left {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:left]];
}

- (void)setRightConstraintForView:(UIView *)view right:(CGFloat)right {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:right]];
}

- (void)setBottomConstraintForView:(UIView *)view bottom:(CGFloat)bottom {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:bottom]];
}

- (void)setHeightConstraintForView:(UIView *)view height:(CGFloat)height {
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:height]];
}

- (void)setWidthConstraintForView:(UIView *)view width:(CGFloat)width {
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:width]];
}
@end
