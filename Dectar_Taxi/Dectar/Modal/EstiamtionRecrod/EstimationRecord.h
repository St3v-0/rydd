//
//  EstimationRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/20/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstimationRecord : NSObject

@property(strong ,nonatomic) NSString * attString;
@property(strong ,nonatomic) NSString * dropStr,* dropStr2;
@property(strong ,nonatomic) NSString * PickupStr;
@property(strong ,nonatomic) NSString * max_amount;
@property(strong ,nonatomic) NSString * min_amount;
@property(strong ,nonatomic) NSString * night_charge;
@property(strong ,nonatomic) NSString * note;
@property(strong ,nonatomic) NSString * peak_time;


@end
