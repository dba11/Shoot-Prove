//
//  LTAnnProtractorDrawDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDrawDesigner.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnProtractorDrawDesigner : LTAnnDrawDesigner

- (instancetype)initWithControl:(id<LTIAnnAutomationControl>)control container:(LTAnnContainer *)container object:(LTAnnProtractorObject *)annObject;

@end

NS_ASSUME_NONNULL_END