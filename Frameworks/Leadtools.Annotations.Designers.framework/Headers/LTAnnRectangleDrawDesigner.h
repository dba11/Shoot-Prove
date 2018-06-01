//
//  LTAnnRectangleDrawDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDrawDesigner.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnRectangleDrawDesigner : LTAnnDrawDesigner 

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnRectangleObject *)annObject;

@end

NS_ASSUME_NONNULL_END