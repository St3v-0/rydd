//
//  JJLocationManager.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 12/05/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import "JJLocationManager.h"

@interface JJLocationManager () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) CLLocation *previousLocation;
@property (nonatomic) JJLocationManagerMonitorMode mode;

@end;
@implementation JJLocationManager
@synthesize isDriverLocationUpdatedInitially,categString,CurrencyString,gotAppInfo,canMoveToApp;

#pragma mark - Static

static JJLocationManager *sharedManager;

#pragma mark - Initialization

- (id)init
{
    return [self initWithLocationManager:[[CLLocationManager alloc] init]];
}

- (id)initWithLocationManager:(CLLocationManager *)locationManager
{
    self = [super init];
    if (self) {
        NSParameterAssert(locationManager);
        _locationManager = locationManager;
        _locationManager.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveAppInfoNotification:)
                                                     name:@"NotifForAppInfo"
                                                   object:nil];
       
    }
    return self;
}

- (void)receiveAppInfoNotification:(NSNotification *) notification
{
    gotAppInfo=YES;
    [self updateUserLocation];
   
    
    
}

#pragma mark - Public static methods

+ (JJLocationManager *)sharedManager {
    if (sharedManager == nil) {
        sharedManager = [[JJLocationManager alloc] init];
    };
    return sharedManager;
}

+ (float)kilometresBetweenPlace1:(CLLocation*)place1 andPlace2:(CLLocation*) place2
{
    CLLocationDistance dist = [place1 distanceFromLocation:place2]/1000;
    NSString *strDistance = [NSString stringWithFormat:@"%.2f", dist];
    return [strDistance floatValue];
}

+ (float)kilometresFromLocation:(CLLocation*)location
{
    return [self kilometresBetweenPlace1:location andPlace2:[self sharedManager].currentLocation];
}

#pragma mark - Public methods

- (void)startLocationUpdates
{
    if (self.mode == kJJLocationManagerModeStandard) {
        [self requestAlwaysAuthorization]; // for significant location changes this auth is required (>= ios8)
        [self.locationManager startUpdatingLocation];
    }
    else if (self.mode == kJJLocationManagerModeStandardWhenInUse) {
        [self requestWhenInUseAuthorization]; // for significant location changes this auth is required (>= ios8)
        [self.locationManager startUpdatingLocation];
    }
    else {
        [self requestAlwaysAuthorization]; // for significant location changes this auth is required (>= ios8)
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    
    // based on docs, locationmanager's location property is populated with latest
    // known location even before we started monitoring, so let's simulate a change
    if (self.locationManager.location) {
        [self locationManager:self.locationManager didUpdateLocations:@[self.locationManager.location]];
    }
}

- (void)startLocationUpdates:(JJLocationManagerMonitorMode)mode
              distanceFilter:(CLLocationDistance)filter
                    accuracy:(CLLocationAccuracy)accuracy
{
    self.mode = mode;
    self.locationManager.distanceFilter = filter;
    self.locationManager.desiredAccuracy = accuracy;
    
    [self startLocationUpdates];
}

- (void)stopLocationUpdates
{
    if (self.mode == kJJLocationManagerModeStandard) {
        [self.locationManager stopUpdatingLocation];
    }
    else {
        [self.locationManager stopMonitoringSignificantLocationChanges];
    }
    
}

#pragma mark - Private

/**
 iOS 8 requires you to request authorisation prior to starting location updates
 */
- (void)requestAlwaysAuthorization
{
    if (![self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        return;
    }
    
    [self.locationManager requestAlwaysAuthorization];
}

- (void)requestWhenInUseAuthorization
{
    if (![self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        return;
    }
    
    [self.locationManager requestWhenInUseAuthorization];
}

+ (void)setSharedManager:(JJLocationManager *)manager
{
    sharedManager = manager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (![locations count]) {
        return;
    }
    
    // location didn't change
    if (nil != self.currentLocation && [[locations lastObject] isEqual:self.currentLocation]) {
        return;
    }
    self.currentLocation = [locations lastObject];
    if(self.isLocationUpdated==NO){
        if(self.currentLocation.coordinate.latitude!=0){
            self.isLocationUpdated=YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kJJLocationManagerNotificationLocationUpdatedInitially
                                                                object:self];
            if ([Themes getUserID] !=nil){
                isDriverLocationUpdatedInitially=YES;
                [self updateLocationOnBackgroundThread];
            }
           
            
        }
    }
    
    
    [self locationManagerUpdate:self.locationManager didUpdateToLocation:self.currentLocation fromLocation:self.previousLocation];
    
    // notify about the change
    [[NSNotificationCenter defaultCenter] postNotificationName:kJJLocationManagerNotificationLocationUpdatedName
                                                        object:self];
}

-(void)updateLocationOnBackgroundThread{
    @try {
        [self updateUserLocation];
     
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in Location Update thread..");
    }
}


- (void)locationManagerUpdate:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if(oldLocation.coordinate.latitude!=0){
        _previousLocation=oldLocation;
    }else{
        _previousLocation=newLocation;
    }
//    if(isDriverLocationUpdatedInitially==NO){
//        isDriverLocationUpdatedInitially=YES;
//        if ([Themes getUserID] !=nil){
//            [self updateLocationOnBackgroundThread];
//        }
//
//    }
//    float totalDistTowardsDest= GMSGeometryDistance(oldLocation.coordinate, newLocation.coordinate);
//    if(totalDistTowardsDest>=100){
//         if ([Themes getUserID] !=nil){
//             [self updateLocationOnBackgroundThread];
//        }
//    }
}

-(void)updateLocationToServerManually{
    [self updateUserLocation];
}


-(void)refreshDriverCurrentLocation{
    [_locationManager startUpdatingLocation];
}
-(void)dealloc{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJJLocationManagerNotificationFailedName
                                                        object:self
                                                      userInfo:@{@"error": error}];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [[NSNotificationCenter defaultCenter] postNotificationName:kJJLocationManagerNotificationAuthorizationChangedName
                                                        object:self userInfo:@{@"status": @(status)}];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            //   NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            // NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
             [self startLocationUpdates];; //Will update location immediately
        } break;
        default:
            break;
    }
}




-(void)updateUserLocation
{
    if(gotAppInfo==YES){
        NSString*latitudeStr=[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
        NSString*longitudeStr=[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
        
        NSDictionary * parameters=@{@"user_id":[Themes checkNullValue:[Themes getUserID]],
                                    @"latitude":latitudeStr,
                                    @"longitude":longitudeStr};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [web GetGoeUpate:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             
             if ([responseDictionary count]>0)
             {
                 
                
                 
                 NSString * comfiramtion=[Themes checkNullValue:[responseDictionary valueForKey:@"status"]];
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     
                     
                     
                     [Themes SaveWallet:[Themes checkNullValue:[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"wallet_amount"]]]];
                     categString=[Themes checkNullValue:[Themes writableValue:[responseDictionary valueForKey:@"category_id"]]];
                     
                     CurrencyString=[Themes checkNullValue:[responseDictionary valueForKey:@"currency"]];
                     CurrencyString=[Themes findCurrencySymbolByCode:CurrencyString];
                     [Themes SaveCurrency:CurrencyString];
                     [Themes SaveCategoryString:categString];
                     if(canMoveToApp==NO){
                         canMoveToApp=YES;
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:@"moveToApp"
                          object:self userInfo:nil];
                     }else if ([Themes getUserID].length==0){
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:@"moveToApp"
                          object:self userInfo:nil];
                     }
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName: kLocationUpdate object:nil];
                     _updateErrorCount=0;
                 }
                 else
                 {
                 if ([Themes getUserID].length!=0){
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"whenLocAppIsWrong"
                      object:self userInfo:responseDictionary];
                 }
                 else{
                     if(self.isStopMoveToLogin==NO){
                         self.isStopMoveToLogin=YES;
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:@"whenLocAppIsWrong"
                          object:self userInfo:responseDictionary];
                         
                     }
                     
                 }
                 }
                 
             }else{
                 
             }
             
             
         }
                 failure:^(NSError *error)
         {
             if(_updateErrorCount<=2){
                 [self updateUserLocation];
                 _updateErrorCount++;
             }else{
                     [self showAlertForAppInfo:JJLocalizedString(@"Seems_your_network_is", nil)];
                 
             }
         }];
    }
  
}


-(void)showAlertForAppInfo:(NSString *)msg{
    OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Oops", nil)
                                                                message:msg
                                                      cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                      otherButtonTitles:nil];
    alert.iconType = OpinionzAlertIconWarning;
    [alert show];
}


@end
