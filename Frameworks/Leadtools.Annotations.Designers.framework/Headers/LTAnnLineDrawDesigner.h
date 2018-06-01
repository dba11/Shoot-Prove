//
//  LTAnnLineDrawDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnPolylineDrawDesigner.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnLineDrawDesigner : LTAnnPolylineDrawDesigner

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnPolylineObject *)annObject;

@end

NS_ASSUME_NONNULL_END