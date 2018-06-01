//
//  LTAnnLockObjectEventArgs.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnLockObjectEventArgs : NSObject

@property (nonatomic, strong, readonly) LTAnnObject *object;

@property (nonatomic, copy, nullable)   NSString *password;

@property (nonatomic, assign)           BOOL cancel;

- (instancetype)initWithObject:(LTAnnObject *)annObject password:(nullable NSString *)password NS_DESIGNATED_INITIALIZER;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END