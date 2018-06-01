//
//  LTCreditCard.h
//  Leadtools.CreditCard
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTEnums.h"
#import "LTDetectionInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCreditCard : NSObject

@property (nonatomic, copy, nullable) NSString *cardNumber;
@property (nonatomic, copy, nullable) NSString *postalCode;
@property (nonatomic, copy, nullable) NSString *CVV;

@property (nonatomic, assign)         NSUInteger expiryMonth;
@property (nonatomic, assign)         NSUInteger expiryYear;

@property (nonatomic, assign)         LTCardType cardType;

- (nullable instancetype)initWithDetectionInfo:(LTDetectionInfo *)detectionInfo error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END