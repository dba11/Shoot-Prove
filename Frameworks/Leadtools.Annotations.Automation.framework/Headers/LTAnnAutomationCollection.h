//
//  LTAnnAutomationCollection.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnAutomationObject.h"
#import "LTAnnAutomation.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnAutomationObjects : LTAnnObservableCollection

- (void)addAutomationObject:(LTAnnAutomationObject *)automationObject;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnAutomations : LTAnnObservableCollection

- (void)addAutomationObject:(LTAnnAutomation *)automationObject;

@end

NS_ASSUME_NONNULL_END