//
//  LTAnnAutomationEventArgs.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnAutomationEventArgs.h"

@class LTAnnAutomationObject;

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnAutomationEventArgs : NSObject

@property (nonatomic, strong, readonly, nullable) LTAnnAutomationObject *object;

- (instancetype)initWithObject:(nullable LTAnnAutomationObject *)object;

@end

NS_ASSUME_NONNULL_END