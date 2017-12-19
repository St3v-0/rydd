//
//  MyRideRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/26/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRideRecord : NSObject
@property(strong,nonatomic) NSString * pickup;
@property(strong,nonatomic) NSString * ride_date;
@property(strong,nonatomic) NSString * ride_id;
@property(strong,nonatomic) NSString * ride_time;
@property(strong,nonatomic) NSString * Total_Count;
@property(strong,nonatomic) NSString * drop_date;
@property(strong,nonatomic) NSString * myride_status;
@property(strong,nonatomic) NSString * myride_display_status;
@property(strong,nonatomic) NSString * dateTime;
@property(strong,nonatomic) NSString * drivername;
@property(strong,nonatomic) NSString * mileage;
@property(strong,nonatomic) NSString * RideAmount;
@property(strong,nonatomic) NSString * driverImage;
@property(strong,nonatomic) NSString * CancellationFee;
@property(strong,nonatomic) NSString * CancellationStatus;



@property(strong,nonatomic) NSString * cab_type;
@property(strong,nonatomic) NSString * ride_id_detls;
@property(strong,nonatomic) NSString * ride_status;
@property(strong,nonatomic) NSString * location;
@property(strong,nonatomic) NSString * lon;
@property(strong,nonatomic) NSString * lat;
@property(strong,nonatomic) NSString * pickup_date;
@property(strong,nonatomic) NSString * ride_distance;
@property(strong,nonatomic) NSString * ride_duration;
@property(strong,nonatomic) NSString * waiting_duration;
@property(strong,nonatomic) NSString * total_bill;
@property(strong,nonatomic) NSString * total_paid;
@property(strong,nonatomic) NSString * payStatus;
@property (strong,nonatomic) NSString * CancelStatus;
@property (strong,nonatomic) NSString * Currency;
@property (strong,nonatomic) NSString * grand_Bill;
@property (strong,nonatomic) NSString * DisPlay_status;
@property(strong,nonatomic) NSString * Coupon_Discount;
@property(strong,nonatomic) NSString * Wallet_usage;

@property(strong,nonatomic) NSString * Track_Status;
@property(strong,nonatomic) NSString * Favourite_Status;

@property(strong,nonatomic) NSString * Tip_Amount;

@property (strong,nonatomic) NSString * paymentname;
@property (strong,nonatomic) NSString * paymentCode;
@property (strong,nonatomic) NSString * group;
@property (strong,nonatomic) NSString * distance_unit;

@property(strong,nonatomic) NSString * Drop_lon;
@property(strong,nonatomic) NSString * Drop_lat;
@property(strong,nonatomic) NSString * DropLocation;
@end
