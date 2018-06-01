//
//  LTCreditCardScanner.h
//  Leadtools.CreditCard
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "LTScannerAnalytics.h"
#import "LTCreditCard.h"
#import "LTScannerOptions.h"
#import "LTDetectionInfo.h"
#import "LTFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCreditCardScanner : NSObject

@property (nonatomic, strong, readonly, nullable) LTScannerAnalytics *analytics;

- (instancetype)init __unavailable;
- (nullable instancetype)init:(NSError **)error;
- (nullable instancetype)initWithOptions:(LTScannerOptions *)options error:(NSError **)error;

+ (LeadRect)guideFrameWithOrientation:(LTFrameOrientation)orientation width:(NSUInteger)width height:(NSUInteger)height;

+ (LTCardType)cardTypeForCardNumber:(NSString *)cardNumber;

- (void)reset;

- (nullable LTDetectionInfo *)scanFrame:(LTFrame *)frame error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END