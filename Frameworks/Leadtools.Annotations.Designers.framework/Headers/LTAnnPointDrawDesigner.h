//
//  LTAnnPointDrawDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDrawDesigner.h"

@class LTAnnPointObject;

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnPointDrawDesigner : LTAnnDrawDesigner

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnPointObject *)annObject;

@end

NS_ASSUME_NONNULL_END