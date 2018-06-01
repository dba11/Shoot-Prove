//
//  LTAnnRunDesignerSubClassing.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRunDesigner.h"

@interface LTAnnRunDesigner (SubClassing)

- (BOOL)startWorking;
- (BOOL)working;
- (BOOL)endWorking;

- (void)onRun:(LTAnnRunDesignerEventArgs *)args;

@end