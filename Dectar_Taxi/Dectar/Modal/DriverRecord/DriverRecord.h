//
//  DriverRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/31/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DriverRecord : NSObject

@property (strong ,nonatomic) NSString * Driver_Name;
@property (strong ,nonatomic) NSString * Car_Name;
@property (strong ,nonatomic) NSString * Car_Number;
@property double latitude_driver;
@property double longitude_driver;
@property (strong,nonatomic) NSString * Driver_moblNumber;
@property (strong ,nonatomic) NSString * Ride_ID;
@property (assign ,nonatomic) BOOL isCancel;
@property (strong,nonatomic) NSString * DriverImage;

@property double latitude_User;
@property double longitude_User;

@property (strong,nonatomic) NSString * reason;
@property (strong,nonatomic) NSString *ID_Reason;
@property (strong,nonatomic) NSString * message;
@property (strong,nonatomic) NSString * ETA;
@property (strong,nonatomic) NSString * rating;
@property (strong,nonatomic) NSString * Status;

@property double Drop_latitude_User;
@property double Drop_longitude_User;
@end
