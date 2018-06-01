//
//  LTAnnPolylineEditDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.thumbsGap
//

#import "LTAnnEditDesigner.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnPolylineEditDesigner : LTAnnEditDesigner

@property (nonatomic, assign) NSInteger thumbsGap;

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnPolylineObject *)annObject;

@end

NS_ASSUME_NONNULL_END