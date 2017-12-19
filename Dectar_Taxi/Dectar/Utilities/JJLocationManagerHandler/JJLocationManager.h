//
//  JJLocationManager.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 12/05/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "UrlHandler.h"
#import "Themes.h"
#import "Constant.h"
#import <GoogleMaps/GMSGeometryUtils.h>
#import "OpinionzAlertView.h"

static NSString *const kJJLocationManagerNotificationLocationUpdatedName = @"JJLocationManagerNotificationLocationUpdated";
static NSString *const kJJLocationManagerNotificationLocationUpdatedInitially = @"JJLocationManagerNotificationLocationUpdatedInitially";
static NSString *const kJJLocationManagerNotificationFailedName = @"JJLocationManagerNotificationFailed";
static NSString *const kJJLocationManagerNotificationAuthorizationChangedName = @"JJLocationManagerNotificationAuthorizationChangedName";

typedef enum {
    kJJLocationManagerModeStandard,
    kJJLocationManagerModeStandardWhenInUse, // this is new in iOS 8 - app can request for permission for only when app is in use
    kJJLocationManagerModeSignificantLocationUpdates
} JJLocationManagerMonitorMode;

@interface JJLocationManager : NSObject


+(JJLocationManager *)sharedManager;

-(void)refreshDriverCurrentLocation;

+(float)kilometresBetweenPlace1:(CLLocation*)place1 andPlace2:(CLLocation*) place2;

+(float)kilometresFromLocation:(CLLocation*)location;

-(void)updateLocationToServerManually;

-(void)startLocationUpdates;


-(void)startLocationUpdates:(JJLocationManagerMonitorMode)mode
             distanceFilter:(CLLocationDistance)filter
                   accuracy:(CLLocationAccuracy)accuracy;

- (void)stopLocationUpdates;

@property (readonly) CLLocation *currentLocation;
@property (readonly) CLLocation *previousLocation;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property(assign,nonatomic)BOOL isLocationUpdated;
@property(assign,nonatomic)BOOL isDriverLocationUpdatedInitially;
@property(assign,nonatomic)BOOL gotAppInfo;
@property(assign,nonatomic)BOOL canMoveToApp;
@property(strong,nonatomic)NSString * categString;
@property(strong,nonatomic)NSString * CurrencyString;
@property(assign,nonatomic)NSInteger updateErrorCount;
@property (assign , nonatomic) BOOL isStopMoveToLogin;


@end
