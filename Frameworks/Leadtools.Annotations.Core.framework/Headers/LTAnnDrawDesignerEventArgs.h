//
//  LTAnnDrawDesignerEventArgs.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnDrawDesignerEventArgs : NSObject

@property (nonatomic, strong, readonly) LTAnnObject *object;
@property (nonatomic, assign, readonly) LTAnnDesignerOperationStatus operationStatus;

@property (nonatomic, assign)           BOOL cancel;

- (instancetype)initWithObject:(LTAnnObject *)annObject operation:(LTAnnDesignerOperationStatus)status NS_DESIGNATED_INITIALIZER;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END