//
//  LxIAPManager.h
//  LxIAPManagerDemo
//

#import <StoreKit/StoreKit.h>

@class LxIAPManager;

@protocol LxIAPManagerDelegate <NSObject>

- (void)iapManager:(LxIAPManager *)iapManager didFetchedProductArray:(NSArray *)productArray; //  SKProduct object array
- (void)iapManager:(LxIAPManager *)iapManager fetchProductsFailedForInvalidProductIdentifiers:(NSArray *)invalidProductIdentifiers;
- (void)iapManager:(LxIAPManager *)iapManager didBeginTransaction:(SKPaymentTransaction *)transaction;
- (void)iapManager:(LxIAPManager *)iapManager purchaseSuccessForTransaction:(SKPaymentTransaction *)transaction;
- (void)iapManager:(LxIAPManager *)iapManager purchaseFailedForTransaction:(SKPaymentTransaction *)transaction;
- (void)iapManager:(LxIAPManager *)iapManager hasBeenPurchasedForTransaction:(SKPaymentTransaction *)transaction;

@end

@interface LxIAPManager : NSObject

+ (instancetype)defaultManager;

+ (BOOL)iapEnable;
+ (NSData *)transactionReceipt;

@property (nonatomic,assign) id<LxIAPManagerDelegate> delegate;

- (void)fetchProductsByIdentifiers:(NSArray *)productIdentifiers;
- (void)purchaseProductWithIdentifier:(NSString *)productIdentifier;

@end
