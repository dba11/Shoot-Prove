//
//  LTAnnDrawDesigner.h
//  Leadtools.Annotations.Designers
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnDesigner.h"

@class LTAnnDrawDesignerEventArgs, LTAnnDrawDesigner;

NS_ASSUME_NONNULL_BEGIN

@protocol LTAnnDrawDesignerDelegate<NSObject>
@optional

- (void)drawDesigner:(LTAnnDrawDesigner *)designer drawWithargs:(LTAnnDrawDesignerEventArgs *)args;

@end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

@interface LTAnnDrawDesigner : LTAnnDesigner

@property (nonatomic, weak, nullable)   id<LTAnnDrawDesignerDelegate> delegate;

@property (nonatomic, assign, readonly) LTAnnDesignerOperationStatus operationStatus;

@end

NS_ASSUME_NONNULL_END