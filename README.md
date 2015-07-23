# LxIAPManager
*	Apple IAP capsulation.

### Installation
    You only need drag LxIAPManager.h and LxIAPManager.m to your project.

### Support
    Minimum support iOS version: iOS 7.0

### Usage

	//	First, implement LxIAPManager protocol in your class.

	BOOL iapEnable = [LxIAPManager iapEnable];
    NSData * transactionReceipt = [LxIAPManager transactionReceipt];
    
    [LxIAPManager defaultManager].delegate = self;
    
    [[LxIAPManager defaultManager]fetchProductsByIdentifiers:@[PRODUCT_IDENTIFIER_1, PRODUCT_IDENTIFIER_2]];
    [[LxIAPManager defaultManager]purchaseProductWithIdentifier:PRODUCT_IDENTIFIER_2];
    
    #pragma mark - protocol method
    
    - (void)iapManager:(LxIAPManager *)iapManager didFetchedProductArray:(NSArray *)productArray
	{
		//	fetched valid product info.
	}
	
	- (void)iapManager:(LxIAPManager *)iapManager fetchProductsFailedForInvalidProductIdentifiers:(NSArray *)invalidProductIdentifiers
	{
		//	fetched product info failed.
	}
	
	- (void)iapManager:(LxIAPManager *)iapManager didBeginTransaction:(SKPaymentTransaction *)transaction
	{
		//	a transaction did begin.
	}
	
	- (void)iapManager:(LxIAPManager *)iapManager purchaseSuccessForTransaction:(SKPaymentTransaction *)transaction
	{
		//	a transaction paid successful.
		//	next, verify it by apple server.
	}
	
	- (void)iapManager:(LxIAPManager *)iapManager purchaseFailedForTransaction:(SKPaymentTransaction *)transaction
	{
		//	a transaction paid failed.
	}
	
	- (void)iapManager:(LxIAPManager *)iapManager hasBeenPurchasedForTransaction:(SKPaymentTransaction *)transaction
	{
		//	the product has purchased, recover it.
	}
	
### License
    LxIAPManager is available under the Apache License 2.0. See the LICENSE file for more info.