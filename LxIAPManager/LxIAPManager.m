//
//  LxIAPManager.m
//  LxIAPManagerDemo
//

#import "LxIAPManager.h"


@interface LxIAPManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation LxIAPManager

+ (instancetype)defaultManager
{
    static LxIAPManager * defaultManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        
        defaultManager = [[self alloc]init];
    });
    return defaultManager;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

+ (BOOL)iapEnable
{
    return [SKPaymentQueue canMakePayments];
}

+ (NSData *)transactionReceipt
{
    NSURL * appStoreReceiptURL = [[NSBundle mainBundle]appStoreReceiptURL];
    return [NSData dataWithContentsOfURL:appStoreReceiptURL];
}

#pragma mark - fetch products

- (void)fetchProductsByIdentifiers:(NSArray *)productIdentifiers
{
    if (productIdentifiers.count == 0) {
        if ([self.delegate respondsToSelector:@selector(iapManager:fetchProductsFailedForInvalidProductIdentifiers:)]) {
            [self.delegate iapManager:self fetchProductsFailedForInvalidProductIdentifiers:@[]];
        }
    }
    
    for (id productIdentifier in productIdentifiers) {
        NSCAssert([productIdentifier isKindOfClass:[NSString class]], @"LxIAPManager: productIdentifier type error!");
    }
    
    SKProductsRequest * productsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (response.products.count == 0) {
        if ([self.delegate respondsToSelector:@selector(iapManager:fetchProductsFailedForInvalidProductIdentifiers:)]) {
            [self.delegate iapManager:self fetchProductsFailedForInvalidProductIdentifiers:@[]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(iapManager:didFetchedProductArray:)]) {
        [self.delegate iapManager:self didFetchedProductArray:response.products];
    }
}

#pragma mark - purchase product

- (void)purchaseProductWithIdentifier:(NSString *)productIdentifier
{
    BOOL hasUnfinishedTransactions = NO;
    
    for (SKPaymentTransaction * paymentTransaction in [SKPaymentQueue defaultQueue].transactions) {
        switch (paymentTransaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
            {
            
            }
                break;
            case SKPaymentTransactionStatePurchased:
            {
                hasUnfinishedTransactions = YES;
                [[SKPaymentQueue defaultQueue]finishTransaction:paymentTransaction];
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                hasUnfinishedTransactions = YES;
                [[SKPaymentQueue defaultQueue]finishTransaction:paymentTransaction];
            }
                break;
            case SKPaymentTransactionStateRestored:
            {
                hasUnfinishedTransactions = YES;
                [[SKPaymentQueue defaultQueue]finishTransaction:paymentTransaction];
            }
                break;
            case SKPaymentTransactionStateDeferred:
            {
                
            }
                break;
            default:
                break;
        }
    }
    
    if (hasUnfinishedTransactions == YES) {
        
        if ([self.delegate respondsToSelector:@selector(iapManager:purchaseFailedForTransaction:)]) {
            [self.delegate iapManager:self purchaseFailedForTransaction:nil];
        }
        return;
    }
    
    SKMutablePayment * payment = [[SKMutablePayment alloc]init];
    payment.productIdentifier = productIdentifier;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * paymentTransaction in transactions) {
    
        switch (paymentTransaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {
                NSLog(@"LxIAPManager: Transaction is being added to the server queue.");
                if ([self.delegate respondsToSelector:@selector(iapManager:didBeginTransaction:)]) {
                    [self.delegate iapManager:self didBeginTransaction:paymentTransaction];
                }
                break;
            }
            case SKPaymentTransactionStatePurchased: {
                NSLog(@"LxIAPManager: Transaction is in queue, user has been charged.  Client should complete the transaction.");
                if ([self.delegate respondsToSelector:@selector(iapManager:purchaseSuccessForTransaction:)]) {
                    [self.delegate iapManager:self purchaseSuccessForTransaction:paymentTransaction];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
                break;
            }
            case SKPaymentTransactionStateFailed: {
                NSLog(@"LxIAPManager: Transaction was cancelled or failed before being added to the server queue.");
                if ([self.delegate respondsToSelector:@selector(iapManager:purchaseFailedForTransaction:)]) {
                    [self.delegate iapManager:self purchaseFailedForTransaction:paymentTransaction];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
                break;
            }
            case SKPaymentTransactionStateRestored: {
                NSLog(@"LxIAPManager: Transaction was restored from user's purchase history.  Client should complete the transaction.");
                if ([self.delegate respondsToSelector:@selector(iapManager:hasBeenPurchasedForTransaction:)]) {
                    [self.delegate iapManager:self hasBeenPurchasedForTransaction:paymentTransaction];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
                break;
            }
            case SKPaymentTransactionStateDeferred: {
                NSLog(@"LxIAPManager: The transaction is in the queue, but its final status is pending external action.");
                break;
            }
            default: {
                break;
            }
        }
    }
}

@end
