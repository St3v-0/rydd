//
//  ReferralRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/27/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReferralRecord : NSObject

@property (strong,nonatomic)NSString * friendsamount;
@property (strong,nonatomic)NSString * referral_code;
@property (strong,nonatomic)NSString * your_earn;
@property (strong,nonatomic)NSString * your_earn_amount;
@property (strong,nonatomic) NSString * Currecny;
@property (strong,nonatomic) NSString * earnCondition;
@property (strong,nonatomic) NSString * urlString;
@property (strong,nonatomic) NSString * message;

@end
