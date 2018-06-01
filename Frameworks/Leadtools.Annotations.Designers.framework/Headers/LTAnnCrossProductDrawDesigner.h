//
//  LTAnnCrossProductDrawDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDrawDesigner.h"

@class LTAnnCrossProductObject;

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnCrossProductDrawDesigner : LTAnnDrawDesigner

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnCrossProductObject *)annObject;

@end

NS_ASSUME_NONNULL_END