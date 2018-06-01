/*************************************************************************
 *
 * SHOOT&PROVE CONFIDENTIAL
 * __________________
 *
 *  [2016]-[2018] Shoot&Prove SA/NV
 *  www.shootandprove.com
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property
 * of Shoot&Prove SA/NV. The intellectual and technical concepts contained
 * herein are proprietary to Shoot&Prove SA/NV.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Shoot&Prove SA/NV.
 */

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol InAppPurchaseManagerDelegate <NSObject>
- (void)didInAppPurchaseManagerReturnTransactionInProgressWithProductIdentifier:(NSString *)productIdentifier;
- (void)didInAppPurchaseManagerReturnTransactionDoneWithProductIdentifier:(NSString *)productIdentifier;
- (void)didInAppPurchaseManagerReturnTransactionFailedWithProductIdentifier:(NSString *)productIdentifier error:(NSError *)error;
@optional
- (void)didInAppPurchaseFinishRefreshAvailableProducts;
@end

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) id<InAppPurchaseManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (BOOL)canMakePurchases;
- (void)refreshAvailableProducts;
- (NSArray *)availableProducts;
- (BOOL)purchaseProduct:(SKProduct *)product;
- (UIImage *)productImage:(SKProduct *)product;
@end
