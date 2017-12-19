//
//  AppInfoRecords.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 26/04/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfoRecords : NSObject
@property(strong,nonatomic)NSString * serviceContactEmail;
@property(strong,nonatomic)NSString * serviceNumber;
@property(strong,nonatomic)NSString * serviceSiteUrl;
@property(strong,nonatomic)NSString * serviceXmppHost;

@property(strong,nonatomic)NSString * serviceXmppPort;
@property(strong,nonatomic)NSString * serviceFacebookAppId;
@property(strong,nonatomic)NSString * serviceGooglePlusId;
@property(strong,nonatomic)NSString * servicePhoneMaskingStatus;

@property(strong,nonatomic)NSString * hasPendingRide;
@property(strong,nonatomic)NSString * pendingRideID;
@property(strong,nonatomic)NSString * hasPendingRating;
@property(strong,nonatomic)NSString * pendingRateId;

@property(strong,nonatomic)NSString * appUserAgentName;
@property(strong,nonatomic)NSString * aboutusTxt;
@property(strong,nonatomic)NSString * userEmergencyPage;
@property(strong,nonatomic)NSString * ryddwalletRecharge;
@property(strong,nonatomic)NSString * operatingsHours;

@end
