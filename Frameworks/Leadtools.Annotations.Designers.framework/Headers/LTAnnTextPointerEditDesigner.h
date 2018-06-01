//
//  LTAnnTextPointerEditDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnTextEditDesigner.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnTextPointerEditDesigner : LTAnnTextEditDesigner

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnTextPointerObject *)annObject;

@end

NS_ASSUME_NONNULL_END