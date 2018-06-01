//
//  LTAnnEditTextEventArgs.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnTextObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnEditTextEventArgs : NSObject

@property (nonatomic, strong)           LTAnnTextObject *textObject;

@property (nonatomic, assign, readonly) LeadRectD bounds;

@property (nonatomic, assign)           BOOL cancel;

- (instancetype)initWithObject:(LTAnnTextObject *)textObject bounds:(LeadRectD)bounds NS_DESIGNATED_INITIALIZER;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END