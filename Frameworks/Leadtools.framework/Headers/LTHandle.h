//
//  LTHandle.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

@interface LTHandle : NSObject

- (nullable const void *)lock;
- (void)unlock;

@end
