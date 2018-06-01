//
//  UIView+FirstResponder.h
//  soHunt
//
//  Created by Wallerand Réquillart on 30/06/2014.
//  Copyright (c) 2014 Wallerand Réquillart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FirstResponder)
- (UIView *)findFirstResponder;
@end

@implementation UIView (FirstResponder)

- (UIView *)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}
@end
