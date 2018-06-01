//
//  LTIAnnPackage.h
//  Leadtools.Annotations.Automation
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnAutomationObject.h"

@protocol LTIAnnPackage <NSObject>

@property (nonatomic, strong, readonly) NSString *author;
@property (nonatomic, strong, readonly) NSString *frindlyName;

@property (nonatomic, strong, readonly) NSArray <LTAnnAutomationObject *> *automationObjects;

@end