//
//  LTAnnObjectRendererSubClassing.h
//  Leadtools.Annotations.Rendering
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObjectRenderer.h"

@interface LTAnnObjectRenderer (SubClassing)

@property (nonatomic, assign) BOOL clipPath;

- (void)beginClipPath;
- (void)endClipPath;

@end