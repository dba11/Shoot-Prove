//
//  LTAnnDrawDesignerSubClassing.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDrawDesigner.h"

@interface LTAnnDrawDesigner(SubClassing)

- (void)onDraw:(LTAnnDrawDesignerEventArgs *)args;

- (BOOL)startWorking;
- (BOOL)working;
- (BOOL)endWorking;

@end