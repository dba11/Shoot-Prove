//
//  LTAnnSelectionEditDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnRectangleEditDesigner.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnSelectionEditDesigner : LTAnnRectangleEditDesigner

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnSelectionObject *)annObject;

@end

NS_ASSUME_NONNULL_END