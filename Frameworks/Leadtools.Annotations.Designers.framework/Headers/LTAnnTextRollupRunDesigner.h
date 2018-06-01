//
//  LTAnnTextRollupRunDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRunDesigner.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnTextRollupRunDesigner : LTAnnRunDesigner

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnTextRollupObject *)annObject;

@end

NS_ASSUME_NONNULL_END