//
//  LTImageViewerSubClassing.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTImageViewer.h"

@interface LTImageViewer (SubClassing)

- (void)onPreRender:(CGContextRef)context;
- (void)onPostRender:(CGContextRef)context;

@end