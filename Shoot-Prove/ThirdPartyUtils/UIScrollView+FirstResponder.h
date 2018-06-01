//
//  UIScrollView+FirstResponder.h
//  soHunt
//
//  Created by Wallerand Réquillart on 07/07/2014.
//  Copyright (c) 2014 Wallerand Réquillart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (FirstResponder)
- (UIScrollView *)findFirstResponder;
@end

@implementation UIScrollView (FirstResponder)
- (UIScrollView *)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIScrollView *subView in self.subviews) {
        UIScrollView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}
@end