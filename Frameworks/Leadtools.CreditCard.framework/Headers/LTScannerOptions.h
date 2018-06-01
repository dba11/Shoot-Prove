//
//  LTScannerOptions.h
//  Leadtools.CreditCard
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface LTScannerOptions : NSObject <NSCopying, NSCoding>

@property (nonatomic, assign) BOOL detectOnly;
@property (nonatomic, assign) BOOL detectExpiryDate;

@property (nonatomic, assign) float minimumFocusScore;

@end

NS_ASSUME_NONNULL_END