//
//  LTAnnAutomationSubClassing.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnAutomation.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnAutomation(SubClassing)

- (nullable LTAnnContainer *)hitTestContainer:(LeadPointD)location;

- (void)resolveObject;

- (void)onUndoRedoChanged;
- (void)onAutomationOnPointerDown:(LTAnnPointerEventArgs *)args;
- (void)onAutomationOnPointerUp:(LTAnnPointerEventArgs *)args;

- (NSUInteger)defaultCurrentObjectId;

@end

NS_ASSUME_NONNULL_END