//
//  LTAnnFreehandDrawDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDrawDesigner.h"

@class LTAnnPolylineObject, LTAnnPointerEventArgs;

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnFreehandDrawDesigner : LTAnnDrawDesigner

@property (nonatomic, assign) NSUInteger spacing;

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnPolylineObject *)annObject;

@end

NS_ASSUME_NONNULL_END