//
//  BookingRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/18/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookingRecord : NSObject
@property (strong,nonatomic)NSString *categoryID;
@property (strong,nonatomic)NSString *categoryName;
@property (strong,nonatomic)NSString *categoryETA;
@property (strong,nonatomic)NSString *currency;
@property (strong,nonatomic)NSString *note;
@property (strong ,nonatomic)NSString *vehicletypes;
@property (strong,nonatomic)NSString *categorySubName;
@property (strong,nonatomic)NSString * amountafter_fare;
@property (strong,nonatomic)NSString *amountmin_fare;
@property (strong,nonatomic)NSString *amountother_fare;
@property (strong,nonatomic)NSString *after_fare_text;
@property(strong,nonatomic)NSString *min_fare_text;
@property(strong ,nonatomic)NSString *other_fare_text;
@property(assign,nonatomic)BOOL isSelected;
@property(strong,nonatomic) NSString * CouponCode;
@property(strong ,  nonatomic)NSString * Normal_image;
@property (strong , nonatomic) NSString * Active_Image;
@property (strong,nonatomic) NSString * Booking_ID;
@property (strong ,nonatomic) NSString * timinrloading;
@property (strong ,nonatomic) NSString * icon_car_image;
@property (strong ,nonatomic) NSString * etaTimeDigit;
@property (strong ,nonatomic) NSString * popup_content;
@property (strong ,nonatomic) NSString * show_popup;
@property (strong ,nonatomic) NSString * RequestTimeCount;
@property (strong ,nonatomic) NSString * retryTime;

@end
