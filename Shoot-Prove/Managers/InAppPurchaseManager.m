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

#import "InAppPurchaseManager.h"
#import "StoreManager.h"
#import "RestClientManager.h"
#import "SyncManager.h"
#import "SettingsManager.h"

#import "CleanAndRepairHelper.h"
#import "ErrorHelper.h"
#import "UnCheckedTransaction.h"

#import "User.h"

@interface InAppPurchaseManager()
{
    
	NSMutableArray *_validProducts;
    SKProduct *_product;
    NSFetchedResultsController *_uncheckedTransactionsController;
    NSTimer *_timer;

}

@end

@implementation InAppPurchaseManager
@synthesize delegate;

#pragma - manager life cycle
+ (instancetype)sharedManager {
	static id manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[InAppPurchaseManager alloc] init];
	});
	return manager;
}

- (id)init {
	
	self = [super init];
	
	if(self) {
		
		[self fetchAvailableProducts];
        _uncheckedTransactionsController = [[StoreManager sharedManager] fetchedUncheckedTransactionsController];
        [_uncheckedTransactionsController setDelegate:self];
        NSError *error;
        if(![_uncheckedTransactionsController performFetch:&error]) {
            NSLog(@"InAppPurchaseManager.init.error: %@", [error localizedDescription]);
        } else {
            [self performTimer];
        }
		
	}
	
	return self;
	
}

#pragma - public methods
- (BOOL)canMakePurchases {
	return [SKPaymentQueue canMakePayments];
}

- (void)refreshAvailableProducts {
	[self fetchAvailableProducts];
}

- (NSArray *)availableProducts {
	return _validProducts;
}

- (BOOL)purchaseProduct:(SKProduct *)product {
	
    if(_timer) {
        
        [_timer invalidate];
        _timer = nil;
        
    }
    
	if([self canMakePurchases]) {
		
        _product = product;
		SKPayment *payment = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
		return YES;
		
	} else {
		
        _product = nil;
		return NO;
		
	}
	
}

#pragma - determine which products are available for purchase
- (void)fetchAvailableProducts {
	
	NSSet *productIdentifiers = [NSSet setWithObjects:premiumAccountProductId, serviceCredit20ProductId, serviceCredit50ProductId, serviceCredit100ProductId, nil];
	
	SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
	productsRequest.delegate = self;
	[productsRequest start];
	
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	
    _validProducts = [[NSMutableArray alloc] init];
    
    for(SKProduct *product in response.products) {
        if([product.productIdentifier isEqualToString:premiumAccountProductId]) {
            [_validProducts addObject:product];
            break;
        }
    }
    
    for(SKProduct *product in response.products) {
        if([product.productIdentifier isEqualToString:serviceCredit20ProductId]) {
            [_validProducts addObject:product];
            break;
        }
    }
    
    for(SKProduct *product in response.products) {
        if([product.productIdentifier isEqualToString:serviceCredit50ProductId]) {
            [_validProducts addObject:product];
            break;
        }
    }
    
    for(SKProduct *product in response.products) {
        if([product.productIdentifier isEqualToString:serviceCredit100ProductId]) {
            [_validProducts addObject:product];
            break;
        }
    }
	
	NSLog(@"InAppPurchaseManager.products: %ld", (unsigned long)_validProducts.count);
	if([self.delegate respondsToSelector:@selector(didInAppPurchaseFinishRefreshAvailableProducts)]) {
		[self.delegate didInAppPurchaseFinishRefreshAvailableProducts];
	}
	
}

#pragma - handle purchase response
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	
	for (SKPaymentTransaction *transaction in transactions) {
		
        if([_product.productIdentifier isEqualToString:transaction.payment.productIdentifier]) {
        
            switch (transaction.transactionState) {
                    
                case SKPaymentTransactionStatePurchasing:
                    
                    //NSLog(@"SKPaymentTransactionStatePurchasing");
                    if([self.delegate respondsToSelector:@selector(didInAppPurchaseManagerReturnTransactionInProgressWithProductIdentifier:)]) {
                        [self.delegate didInAppPurchaseManagerReturnTransactionInProgressWithProductIdentifier:_product.productIdentifier];
                    }
                    break;
                    
                case SKPaymentTransactionStatePurchased:
                    
                    //NSLog(@"SKPaymentTransactionStatePurchased");
                    [self addUncheckedTransaction:transaction product:_product];
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    
                    break;
                    
                case SKPaymentTransactionStateRestored:
                    
                    //NSLog(@"SKPaymentTransactionStateRestored");
                    [self addUncheckedTransaction:transaction product:_product];
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    
                    break;
                    
                case SKPaymentTransactionStateFailed:
                    
                    //NSLog(@"SKPaymentTransactionStateFailed");
                    if([self.delegate respondsToSelector:@selector(didInAppPurchaseManagerReturnTransactionFailedWithProductIdentifier:error:)]) {
                        
                        [self.delegate didInAppPurchaseManagerReturnTransactionFailedWithProductIdentifier:_product.productIdentifier error:nil];
                        
                    }
                    
                    break;
                    
                default:
                    break;
                    
            }
            
        }
		
	}
}

- (UIImage *)productImage:(SKProduct *)product {
	
	if([product.productIdentifier isEqualToString:premiumAccountProductId]) {
		
		return [UIImage imageNamed:@"premium"];
		
	} else if([product.productIdentifier isEqualToString:serviceCredit20ProductId]) {
		
		return [UIImage imageNamed:@"credit_20"];
		
	} else if([product.productIdentifier isEqualToString:serviceCredit50ProductId]) {
		
		return [UIImage imageNamed:@"credit_50"];
		
	} else if([product.productIdentifier isEqualToString:serviceCredit100ProductId]) {
		
		return [UIImage imageNamed:@"credit_100"];
		
	} else {
		
		return nil;
		
	}
	
}

- (void)addUncheckedTransaction:(SKPaymentTransaction *)transaction product:(SKProduct *)product {
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[_uncheckedTransactionsController sections] objectAtIndex:0];
    NSUInteger count = [sectionInfo numberOfObjects];
    BOOL found = NO;
    
    for(int i=0;i<count;i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UnCheckedTransaction *uncheckedTransaction = (UnCheckedTransaction *)[_uncheckedTransactionsController objectAtIndexPath:indexPath];
        if([uncheckedTransaction.identifier isEqualToString:transaction.transactionIdentifier]) {
            found = YES;
            break;
        }
        
    }
    
    if(!found) {
        
        //NSLog(@"createUncheckedTransaction");
        UnCheckedTransaction *uncheckedTransaction = [[StoreManager sharedManager] createUncheckedTransaction:transaction product:product];
        if(uncheckedTransaction) {
            //NSLog(@"saveContext");
            [[StoreManager sharedManager] saveContext:nil];
            _product = nil;
        } else {
            //NSLog(@"InAppPurchase.addUncheckedTransaction.error: product identifier does not match transaction product identifier !");
            if([self.delegate respondsToSelector:@selector(didInAppPurchaseManagerReturnTransactionFailedWithProductIdentifier:error:)]) {
                [self.delegate didInAppPurchaseManagerReturnTransactionFailedWithProductIdentifier:transaction.payment.productIdentifier error:nil];
            }
        }
        
    }
    
}

# pragma - fetchedUncheckedTransactionController delegate methods
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    if(type == NSFetchedResultsChangeInsert) {
        
        //NSLog(@"new transaction: verifying");
        UnCheckedTransaction *transaction = (UnCheckedTransaction *)[_uncheckedTransactionsController objectAtIndexPath:newIndexPath];
        [self verifyTransaction:transaction];
        
    } else if(type == NSFetchedResultsChangeDelete) {
        
        id<NSFetchedResultsSectionInfo> sectionInfo = [[_uncheckedTransactionsController sections] objectAtIndex:0];
        NSUInteger count = [sectionInfo numberOfObjects];
        if(count == 0) {
            [_timer invalidate];
            _timer = nil;
        }
        
    }
}

- (void)verifyTransaction:(UnCheckedTransaction *)transaction {
    
    NSString *appleStoreName = [[SettingsManager sharedManager] betaMode] || [[SettingsManager sharedManager] devMode] ? KiTunesStoreNameBeta:KiTunesStoreName;
    
    [[RestClientManager sharedManager] postTransaction:transaction onStore:appleStoreName block:^(User *user, NSInteger statusCode, NSError *error) {
        
        if(!error && user) {
            
            if([transaction.product_id isEqualToString:premiumAccountProductId]) {
                
                [CleanAndRepairHelper migrateFreeToSubscriptionUser:user];
                [SyncManager.sharedManager addSyncTaskRequest];
                
            }
            
            [StoreManager.sharedManager deleteUncheckedTransaction:transaction];
            [StoreManager.sharedManager saveContext:nil];
            
            if([self.delegate respondsToSelector:@selector(didInAppPurchaseManagerReturnTransactionDoneWithProductIdentifier:)]) {
                
                [self.delegate didInAppPurchaseManagerReturnTransactionDoneWithProductIdentifier:transaction.product_id];
                
            }
            
        } else {
            
            if([transaction.errorDisplayed isEqualToNumber:@0]) {
                
                [ErrorHelper popDialogWithTitle:NSLocalizedString(@"TITLE_ERROR", nil) message:[NSString stringWithFormat:NSLocalizedString(@"ACCOUNT_TRANSACTION_CONTROL_ERROR", nil), transaction.product_name, error.localizedDescription] type:DialogTypeError];

                transaction.errorDisplayed = @1;
                [[StoreManager sharedManager] saveContext:nil];
                
            }
            
            [self initTimer];
            
            if([self.delegate respondsToSelector:@selector(didInAppPurchaseManagerReturnTransactionFailedWithProductIdentifier:error:)]) {
                [self.delegate didInAppPurchaseManagerReturnTransactionFailedWithProductIdentifier:transaction.product_id error:error];
            }
            
        }
        
    }];
    
}

- (void)initTimer {
    
    if(_timer) {
        
        [_timer invalidate];
        _timer = nil;
        //NSLog(@"InAppPurchaseManager.initTimer.timerReset");
        
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:transactionCheckInterval
                                                  target:self
                                                selector:@selector(performTimer)
                                                userInfo: nil
                                                 repeats:YES];
    
    //NSLog(@"InAppPurchaseManager.initTimer.timerSet(%.1f sec)", transactionCheckInterval);
    
}

- (void)performTimer {
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[_uncheckedTransactionsController sections] objectAtIndex:0];
    NSUInteger count = [sectionInfo numberOfObjects];
    
    for(int i=0;i<count;i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UnCheckedTransaction *transaction = (UnCheckedTransaction *)[_uncheckedTransactionsController objectAtIndexPath:indexPath];
        [self verifyTransaction:transaction];
        
    }
    
}

@end
