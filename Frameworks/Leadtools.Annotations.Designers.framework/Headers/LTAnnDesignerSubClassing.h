//
//  LTAnnDesignerSubClassing.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDesigner.h"

@interface LTAnnDesigner(SubClassing)

@property (nonatomic, strong, readonly) LTAnnContainer *container;

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnObject *)annObject;

@end