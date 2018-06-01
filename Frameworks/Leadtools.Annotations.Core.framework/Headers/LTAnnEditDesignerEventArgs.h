//
//  LTAnnEditDesignerEventArgs.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnEditDesignerEventArgs : NSObject

@property (nonatomic, strong, readonly) LTAnnObject *object;

@property (nonatomic, assign, readonly) LTAnnEditDesignerOperation operation;
@property (nonatomic, assign, readonly) LTAnnDesignerOperationStatus operationStatus;

@property (nonatomic, assign, readonly) NSUInteger moveControlPointIndex;

@property (nonatomic, assign)           BOOL cancel;

- (instancetype)initWithObject:(LTAnnObject *)annObject operation:(LTAnnEditDesignerOperation)operation thumbIndex:(NSUInteger)index operationStatus:(LTAnnDesignerOperationStatus)operationStatus NS_DESIGNATED_INITIALIZER;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END