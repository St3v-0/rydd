//
//  PayPalVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 10/12/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface PayPalVC : UIViewController<PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>

@property (strong, nonatomic)  NSString *Amount_String;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong) NSString * details;
@property(strong,nonatomic) NSString * Currency;
@property(assign ,nonatomic) BOOL isRecharge;
@property(assign ,nonatomic) BOOL isSuccess;


@end
