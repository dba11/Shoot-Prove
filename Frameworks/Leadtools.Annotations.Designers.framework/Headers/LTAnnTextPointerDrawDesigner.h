//
//  LTAnnTextPointerDrawDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDrawDesigner.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnTextPointerDrawDesigner : LTAnnDrawDesigner

@property (nonatomic, copy, nullable) NSString *defaultText;

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnTextPointerObject *)annObject;

@end

NS_ASSUME_NONNULL_END