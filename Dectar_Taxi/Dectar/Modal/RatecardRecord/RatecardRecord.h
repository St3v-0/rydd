//
//  RatecardRecord.h
//  Dectar
//
//  Created by Suresh J on 24/08/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RatecardRecord : NSObject
@property (strong,nonatomic)NSString *cityID;
@property (strong,nonatomic)NSString *cityName;
@property (strong,nonatomic)NSString *categoryID;
@property (strong,nonatomic)NSString *categoryName;
@property (strong,nonatomic)NSString *status;
@property (strong,nonatomic)NSString *currency;
@property (strong,nonatomic)NSString *title;
@property (strong,nonatomic)NSString *fare;
@property (strong,nonatomic)NSString *sub_title;

@end
