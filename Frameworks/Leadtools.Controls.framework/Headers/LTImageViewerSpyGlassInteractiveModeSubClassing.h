//
//  LTImageViewerSpyGlassInteractiveModeSubClassing.h
//  Leadtools.Controls
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTImageViewerSpyGlassInteractiveMode.h"

@interface LTImageViewerSpyGlassInteractiveMode(SubClassing)

-(void)onPreDraw:(CGContextRef)context touchLocation:(CGPoint)point;
-(void)onDraw:(CGContextRef)context touchLocation:(CGPoint)point;
-(void)onPostDraw:(CGContextRef)context touchLocation:(CGPoint)point;

@end