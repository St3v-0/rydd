//
//  LoginRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/19/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginRecord : NSObject

@property(strong ,nonatomic) NSString * UserID;
@property(strong ,nonatomic) NSString * UserImage;
@property(strong ,nonatomic) NSString * CategoryStr;
@property(strong ,nonatomic) NSString * UserEmail;
@property(strong ,nonatomic) NSString * UserName;
@property(strong ,nonatomic) NSString * MobileNumber;
@property(strong ,nonatomic) NSString * AmountWallet;
@property(strong ,nonatomic) NSString * currency;
@property(strong ,nonatomic) NSString * countryCode;
@property(strong ,nonatomic) NSString * XmppKey;

@end
