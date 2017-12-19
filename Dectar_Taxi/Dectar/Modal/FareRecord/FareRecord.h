//
//  FareRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/2/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FareRecord : NSObject

@property (strong ,nonatomic) NSString * TotalBill;
@property (strong,nonatomic) NSString * waiting;
@property (strong ,nonatomic) NSString * distance;
@property (strong,nonatomic) NSString * duration;
@property (strong,nonatomic) NSString * ride_id;
@property (strong, nonatomic) NSString * CurrencySymbol;

@property (strong, nonatomic) NSString * Message;
@property (strong, nonatomic) NSString * DropLatitude;
@property (strong, nonatomic) NSString * DropLongitude;
@property (strong, nonatomic) NSString * stripe_connected;
 @property (strong, nonatomic) NSString * payment_timeout;

@property (strong, nonatomic) NSString * driverLat;
@property (strong, nonatomic) NSString * driverLong;

@property (strong, nonatomic) NSString * fromNotification;


@end
