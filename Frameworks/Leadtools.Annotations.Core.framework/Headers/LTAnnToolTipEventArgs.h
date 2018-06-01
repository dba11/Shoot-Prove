//
//  LTAnnToolTipEventArgs.h
//  Leadtools.Annotations.Core
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTAnnToolTipEventArgs.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAnnToolTipEventArgs : NSObject

@property (nonatomic, strong, readonly, nullable) LTAnnObject *annObject;

@property (nonatomic, assign, readonly)           LeadRectD bounds;

@property (nonatomic, assign)                     BOOL cancel;

- (instancetype)initWithObject:(nullable LTAnnObject *)annObject bounds:(LeadRectD)bounds NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END