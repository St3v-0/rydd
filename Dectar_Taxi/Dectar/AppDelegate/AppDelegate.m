
//
//  AppDelegate.m
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
#import <GoogleMaps/GoogleMaps.h>

#import "LoginMainVC.h"
#import "Themes.h"
#import "FareRecord.h"
#import <CoreLocation/CoreLocation.h>
#import "SMBInternetConnectionIndicator.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "Constant.h"
#import "FareVC.h"
#import "AdvertsRecord.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "XMLReader.h"
#import "UrlHandler.h"
#import "Driver_Record.h"
#import "NewTrackVC.h"
#import "DEMORootViewController.h"
#import <HockeySDK/HockeySDK.h>


@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    Reachability*internetReachableHandler;
    FareRecord * ObjRec;
    SMBInternetConnectionIndicator * banner;
    AVAudioPlayer * audioplayer;
    UIAlertView *NOInetrnet,*haveInternet;
    AdvertsRecord * Ads_objRec;
    NSDictionary *dictCodes ;
    Driver_Record * ObjDriverRecord;
    UIAlertView    *CancelAlert;
    BOOL isXMPPDisConnected;

}
@property (strong ,nonatomic)CLLocationManager * currentLocation;

@end

@implementation AppDelegate
@synthesize currentLocation,IsShowing;
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize wifiReachability,wwanReachability,isNetworkAvailable,currentView,connectionTimer,appInfoIteration,xmppJabberIdStr,isGetAppLoad;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   /* CTTelephonyNetworkInfo *network_Info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = network_Info.subscriberCellularProvider;
    
    NSLog(@"country code is: %@", carrier.mobileCountryCode);
    
    //will return the actual country code
    NSLog(@"ISO country code is: %@", carrier.isoCountryCode);*/
    if([Themes hasAppDetails]){
        [Themes ClearAppDetails];
          [Themes SaveCategoryString:nil];
    }
        
    isGetAppLoad=NO;
  
    dictCodes= [Themes getCountryList];
    
    [GMSServices provideAPIKey:GoogleClientKey];
    
    currentLocation = [[CLLocationManager alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [currentLocation requestWhenInUseAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//        currentLocation.allowsBackgroundLocationUpdates = YES;
        [currentLocation requestWhenInUseAuthorization];

    }
    [currentLocation startUpdatingLocation];
    [currentLocation requestWhenInUseAuthorization];
    [currentLocation setDelegate:self];

    //*************************************************************************//
    //     Monitoring network reachability
    //*************************************************************************//
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    if(!wifiReachability)
        wifiReachability = [Reachability reachabilityForLocalWiFi];
    
    if(!wwanReachability)
        wwanReachability = [Reachability reachabilityForInternetConnection];
    
    
    [wifiReachability startNotifier]; // It will inform changes in wifi network
    
    [wwanReachability startNotifier]; // It will inform changes in cellular network
    
    wifiStatus = [wifiReachability currentReachabilityStatus];
    wwanStatus = [wwanReachability currentReachabilityStatus];
    
    isNetworkAvailable = (wifiStatus == ReachableViaWiFi) || (wwanStatus == ReachableViaWWAN);
    
    if(wifiStatus == ReachableViaWiFi)
    {
        NSLog(@"Net work reachable through wifi");
    }
    else if(wwanStatus == ReachableViaWWAN)
    {
        NSLog(@"Net work reachable through wwan");
    }
    else
    {
        NSLog(@"No wan found...");
    }
    
    internetReachableHandler = [Reachability reachabilityForInternetConnection];
    [internetReachableHandler startNotifier];
    
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
         [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
  
    if ([AppbaseUrl rangeOfString:isCabilyProduct].location == NSNotFound) {
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyCustomizationAppIdentifier];
    } else {
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyAppIdentifier];
    }

    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
   /*if ([Themes getUserID]==nil)
    {
        [self Logoutroot];
    }*/
    if ([Themes getUserID] !=nil)
    {
        if ([url.description containsString:@"cabilydectar"])
        {
            NSDictionary *userDict = [self urlPathToDictionary:url.absoluteString];
            NSString * rideIdStr=[Themes checkNullValue:[userDict valueForKey:@"ride_id"]];
            if(rideIdStr.length>0){
                ObjRec=[[FareRecord alloc]init];
                ObjRec.ride_id=rideIdStr;
                [self performSelector:@selector(ShareEta) withObject:nil afterDelay:1.0];
                UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                NewTrackVC*rootNewTrackVC = [storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                [rootNewTrackVC setRide_ID:rideIdStr];
                self.window.rootViewController = rootNewTrackVC;
            }
        }
        else
        {
            [self setInitialViewController];

        }
        
    }
    else if ([url.description containsString:@"cabilydectar"])
    {
        if ([Themes getUserID].length >0)
        {
            NSDictionary *userDict = [self urlPathToDictionary:url.absoluteString];
            NSString * rideIdStr=[Themes checkNullValue:[userDict valueForKey:@"ride_id"]];
            if(rideIdStr.length>0){
                ObjRec=[[FareRecord alloc]init];
                ObjRec.ride_id=rideIdStr;
                [self performSelector:@selector(ShareEta) withObject:nil afterDelay:1.0];
                UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                NewTrackVC*rootNewTrackVC = [storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                   [rootNewTrackVC setRide_ID:rideIdStr];
                self.window.rootViewController = rootNewTrackVC;
            }
        }
        else
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            UINavigationController *rootView = (UINavigationController*)[sb instantiateViewControllerWithIdentifier:@"LoginNavigation"];
            [appDel.window setRootViewController:rootView];
            [self performSelector:@selector(ShareEta) withObject:nil afterDelay:1.0];
            
        }
       
    }
    else
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        UINavigationController *rootView = (UINavigationController*)[sb instantiateViewControllerWithIdentifier:@"LoginNavigation"];
        [appDel.window setRootViewController:rootView];
      //  [self performSelector:@selector(ShareEta) withObject:nil afterDelay:1.0];
        
      
        
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      //   NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
          [Themes saveLanguage:@"en"];
        [Themes SetLanguageToApp];
      
    }
    
    [Stripe setDefaultPublishableKey:kStripeKey];
    [[JJLocationManager sharedManager] startLocationUpdates:kJJLocationManagerModeStandardWhenInUse
                                             distanceFilter:kCLDistanceFilterNone
                                                   accuracy:kCLLocationAccuracyBestForNavigation];
      [UIApplication sharedApplication].idleTimerDisabled = YES;
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(remoteNotif)
    {
        [self performSelector:@selector(setPush:) withObject:remoteNotif afterDelay:1];
        
       // [self pushNotificationHandler:remoteNotif];
    }
   
    [self performSelector:@selector(GetAppInfo) withObject:nil afterDelay:.5];

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
    
    return YES;
}

-(void)setPush:(NSDictionary*)dic
{
    
    [self pushNotificationHandler:dic];
}

- (void) receiveLanguageChangedNotification22:(NSNotification *) notification
{
    
}
-(void)setInitialViewController{
    
    if([Themes getUserID] !=nil){
        if(([Themes getUserID] !=nil)){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            DEMORootViewController * objLoginVc=[mainStoryboard instantiateViewControllerWithIdentifier:@"rootController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
            self.window.rootViewController = navigationController;
            self.window.backgroundColor = [UIColor whiteColor];
            [navigationController setNavigationBarHidden:YES animated:YES];
            [self.window makeKeyAndVisible];
        }
    }
}
-(void)ShareEta
{
    if ([Themes getUserID].length >0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"ShareETA" object:ObjRec];

    }
    else
    {
        UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:[Themes getAppName]
                                                           message:JJLocalizedString(@"Kindly_login_to", nil)
                                                          delegate:nil
                                                 cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                 otherButtonTitles:nil];
        [alert show];

    }

}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    if ([[url scheme] containsString:@"cabilydectar"])
    {
        
        if ([Themes getUserID].length >0)
        {
            NSDictionary *userDict = [self urlPathToDictionary:url.absoluteString];
            ObjRec=[[FareRecord alloc]init];
            ObjRec.ride_id=[Themes checkNullValue:[userDict valueForKey:@"ride_id"]];
            if(ObjRec.ride_id.length>0){
                [[NSNotificationCenter defaultCenter] postNotificationName: @"ShareETA" object:ObjRec];
                UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                NewTrackVC*rootNewTrackVC = [storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                   [rootNewTrackVC setRide_ID:ObjRec.ride_id];
                self.window.rootViewController = rootNewTrackVC;
            }
        }
        else
        {
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:[Themes getAppName]
                                                               message:JJLocalizedString(@"Kindly_login_to", nil)
                                                              delegate:nil
                                                     cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                     otherButtonTitles:nil];
            [alert show];
        }

    }
    else
    {
        [[FBSDKApplicationDelegate sharedInstance] application:application
                                                       openURL:url
                                             sourceApplication:sourceApplication
                                                    annotation:annotation];

    }
    
    

    return YES;
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{       CLGeocoder*geocoder = [[CLGeocoder alloc] init];
    
    if (locations == nil)
        return;
    
    CLLocation *current = [locations objectAtIndex:0];
    if(current.coordinate.latitude!=0){
        [geocoder reverseGeocodeLocation:current completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (placemarks == nil)
                 return;
             
             CLPlacemark *currentLocPlacemark = [placemarks objectAtIndex:0];
             NSString *code= [currentLocPlacemark ISOcountryCode];
             code=[[dictCodes valueForKey:code]objectAtIndex:1];
             NSLog(@"%@",code);
             currentLocation = nil;
             [Themes SaveCountryCode:[NSString stringWithFormat:@"+%@",code]];
             [currentLocation stopUpdatingLocation];
             
         }];
    }
    
}

-(void)handleNetworkChange:(NSNotification *)notification
{
    @try{
        
        NSLog(@"||||||||||||----Network changed: %@----|||||||||||",[notification object]);
        
        NetworkStatus remoteHostStatus = [[notification object] currentReachabilityStatus];
        
        if(!wwanReachability)
            wwanReachability = [Reachability reachabilityForInternetConnection];
        
        [wwanReachability startNotifier];
        
        wwanStatus=[wwanReachability currentReachabilityStatus];
        
        
        if(remoteHostStatus == NotReachable)
        {
            isNetworkAvailable = NO;
            
            isNetworkAvailable = ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi) || ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NoNetworkMsgPush" object:self];
            
            NSLog(@"Network Reachable....%@",isNetworkAvailable?@"available":@"unavailable.");
        }
        else
        {
            if (remoteHostStatus == ReachableViaWiFi)
            {
                NSLog(@"ReachableViaWiFi....");
                
                isNetworkAvailable=YES;
                
            }
            if (remoteHostStatus == ReachableViaWWAN)
            {
                NSLog(@"ReachableViaWWAN....");
                
                BOOL isConnectedWith3G = [wwanReachability connectionRequired];
                
                if (isConnectedWith3G) {
                    
                    isNetworkAvailable=NO;
                    
                }
                else
                {
                    isNetworkAvailable=YES;
                    
                    
                }
                NSLog(@"Connecting through 3G Network........ ");
            }
            
            if ([xmppStream isDisconnected]) {
                
                [self disconnect];
                if([Themes hasAppDetails]){
                    [self connect];
                }
                
                
            }
            if(![Themes hasAppDetails]){
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"internetConnectedAndChangeStatus"
                 object:self userInfo:nil];
                  [self performSelector:@selector(GetAppInfo) withObject:nil afterDelay:.5];
            }
            
        }

        
    }
    @catch (NSException *e) {
        
        NSLog(@"Exception in Reachability Notification..%@",e);
    }
}
-(void)dismiss:(UIAlertView*)alert
{
   
    if (alert==NOInetrnet)
    {
        [NOInetrnet dismissWithClickedButtonIndex:0 animated:YES];

    }
    else if (alert ==haveInternet)
    {
        [haveInternet dismissWithClickedButtonIndex:0 animated:YES];

    }
}
-(void)playAudio{
    if(audioplayer==nil){
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/NoInternet.wav", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioplayer.numberOfLoops = -1;
        [audioplayer play];
    }
}
- (void) stopAudio
{
    [audioplayer stop];
    [audioplayer setCurrentTime:0];
    audioplayer=nil;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if([CLLocationManager locationServicesEnabled]){
        
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"App_Permission_Denied", nil)
                                                               message:JJLocalizedString(@"To_reenable_please", nil)
                                                              delegate:nil
                                                     cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}
-(void)LogIn
{
    [self setInitialViewController];

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [Themes SaveDeviceToken:devToken];
    
}
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self pushNotificationHandler:userInfo];

    
}
-(void)pushNotificationHandler:(NSDictionary *)userInfo
{
    
    
    NSMutableDictionary * MessageDict=[userInfo[@"message"] mutableCopy];
    [MessageDict setValue:@"fromPush" forKey:@"PushKey"];   //dhiravida
    
    if([MessageDict count]>0){
         [self didReceiveNotificationAndHandling:MessageDict];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==CancelAlert)
    {
        if (buttonIndex==0)
        {
            [self LogIn];
 
        }
    }
}
-(void)AdVerts
{
    [self coreManagementWithPosition:EMNotificationPopupPositionCenter andType:EMNotificationPopupBigButton];

}
- (void) coreManagementWithPosition: (EMNotificationPopupPosition) position andType:(EMNotificationPopupType) notificationPopupType {
    if (_notificationPopup.isVisible) {
        [_notificationPopup dismissWithAnimation:YES];
        _notificationPopup = NULL;
    } else {
        _notificationPopup = [[EMNotificationPopup alloc] initWithType:notificationPopupType enterDirection:EMNotificationPopupToDown exitDirection:EMNotificationPopupToLeft popupPosition:position];
        _notificationPopup.delegate = self;
        
        _notificationPopup.title = JJLocalizedString(@"Sorry_for_this_Alert", nil);
        _notificationPopup.subtitle = JJLocalizedString(@"Awesome_message", nil);
        _notificationPopup.image = [UIImage imageNamed:@"carimage"];
        
        if (notificationPopupType == EMNotificationPopupBigButton)
            _notificationPopup.actionTitle = JJLocalizedString(@"ok", nil);
        
        [_notificationPopup show];
    }
}
- (void) emNotificationPopupActionClicked {
    [_notificationPopup dismissWithAnimation:YES];
}

- (void) dismissCustomView {
    [_notificationPopup dismissWithAnimation:YES];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
-(void)Logoutroot
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController *rootView = (UINavigationController*)[sb instantiateViewControllerWithIdentifier:@"LoginNavigation"];
    [appDel.window setRootViewController:rootView];

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
    [connectionTimer invalidate];
    [self disconnect];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[JJLocationManager sharedManager] stopLocationUpdates];
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
     [[JJLocationManager sharedManager] startLocationUpdates];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    [self performSelector:@selector(dismiss:) withObject:errorView afterDelay:0.10];*/
//    if (IsShowing==YES)
//    {
//        [self networkChanged];
//
//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    /*[self performSelector:@selector(dismiss:) withObject:errorView afterDelay:0.10];*/
    
    NSLog(@"applicationDidBecomeActive");
    [FBSDKAppEvents activateApp];
    
    if (connectionTimer)
    {
        [connectionTimer invalidate];
    }
    connectionTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkConnectionTimer) userInfo:nil repeats:YES];
    
    if ([Themes getUserID]!=nil)
    {
        if (![xmppStream isDisconnected]) {
            
            [self disconnect];
        }
        if([Themes hasAppDetails]){
            [self connect];
        }
    }
    
    
    if ([Themes getUserID]!=nil)
    {
        [self disconnect];
        if([Themes hasAppDetails]){
            [self connect];
        }
    }

}
- (void)applicationWillTerminate:(UIApplication *)application {
    [Themes SaveCategoryString:@""];
    [Themes ClearAppDetails];
    [[JJLocationManager sharedManager] stopLocationUpdates];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark Check Connection Timer
-(void)checkConnectionTimer
{
    @try {
        [NSThread detachNewThreadSelector:@selector(checkConnectionAvailability) toTarget:self withObject:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in checkConnectionTimer..");
    }
    
}
#pragma mark Check Connection Availability
-(void)checkConnectionAvailability
{
    @try {
        
        if (isNetworkAvailable)
        {
            if([Themes getUserID]!=nil)
            {
                [self xmppState];
                
                if (isXMPPDisConnected)
                {
                    if([Themes hasAppDetails]){
                        [self connect];
                    }
                }
                else
                {
                    NSLog(@"XMPP not disconnected");
                }
                
            }
            else
            {
                NSLog(@"User not logged in");
            }
        }
        else
        {
            NSLog(@"Network/Server Unavailable");
            
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception...checkConnectionAvailability");
    }
}


#pragma XMPP

-(void)connectToXmpp{
    
    if ([Themes getUserID]!=nil)
    {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        if([Themes hasAppDetails]){
            [self connect];
        }
    }
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSDictionary *userInfo = [error userInfo];
    NSString *errorString = [userInfo objectForKey:NSLocalizedDescriptionKey];
    
    
    NSLog(@"Error..........%@",errorString);
    NSLog(@"Error IP.......%@",xmppStream.hostName);
    
    if (errorString && ![errorString isEqualToString:@"Network is unreachable"] && [Themes getUserID]!=nil)
    {
        if(isNetworkAvailable){
            if([Themes hasAppDetails]){
                [self connect];
            }
        }
        
    }
}
- (void)setupStream {
    
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSDictionary * appInfoDict=[Themes AppAllInfoDatas];
    NSString * xmppHostStr=[Themes checkNullValue:[appInfoDict objectForKey:@"xmpp_host_name"]];
    if(xmppHostStr.length>0){
        xmppStream.hostName=xmppHostStr;
    }else{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"xmppNotConectNotif"
         object:self userInfo:nil];
    }
    
    
}
- (void)goOnline {
    
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}


- (void)disconnect {
    isXMPPDisConnected = YES;
    [self XMPP_Unplug];
    [self goOffline];
    [xmppStream disconnect];
}


- (BOOL)connect {

    [self setupStream];
    NSDictionary * appInfoDict=[Themes AppAllInfoDatas];
    xmppJabberIdStr=[Themes checkNullValue:[appInfoDict objectForKey:@"xmpp_host_url"]];
    if(xmppJabberIdStr.length>0){
        
    }else{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"xmppNotConectNotif"
         object:self userInfo:nil];
    }
    NSString *jabberID = [NSString stringWithFormat:@"%@@%@",[Themes getUserID],xmppJabberIdStr]; // @messaging.dectar.com
    NSString *myPassword = [Themes getXmppUserCredentials];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    
    if (jabberID == nil || myPassword == nil) {
        
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    //    password = myPassword;
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        
        NSString *str= JJLocalizedString(@"Cant_connect_to_server", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Error", nil)
                                                            message:[NSString stringWithFormat:@"%@ %@", str,[error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
        return NO;
    }
    else
    {
        NSLog(@"Connection success");
        return YES;
        
        
    }
    
    
    return YES;
}

#pragma mark -
#pragma mark XMPP delegates

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    isXMPPDisConnected = NO;
    NSError *error = nil;
    [[self xmppStream] authenticateWithPassword:[Themes getXmppUserCredentials] error:&error];
    if (error==nil)
    {
        [self XMPP_Plug];
    }
    else
    {
        isXMPPDisConnected = YES;
    }
    
}

-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    UIAlertView *timeOutView = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Time_Out", nil) message:JJLocalizedString(@"Connection_timeout", nil) delegate:self cancelButtonTitle:JJLocalizedString(@"Cancel", nil) otherButtonTitles:JJLocalizedString(@"ok", nil), nil];
    [timeOutView show];
    
    NSLog(@"Handle timeout issues");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    [self goOnline];
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)element
{
    // This method is executed on our moduleQueue.
    
    // <stream:error>
    //   <conflict xmlns="urn:ietf:params:xml:ns:xmpp-streams"/>
    //   <text xmlns="urn:ietf:params:xml:ns:xmpp-streams" xml:lang="">Replaced by new connection</text>
    // </stream:error>
    //
    // If our connection ever gets replaced, we shouldn't attempt a reconnect,
    // because the user has logged in on another device.
    // If we still applied the reconnect logic,
    // the two devices may get into an infinite loop of kicking each other off the system.
    
    NSString *elementName = [element name];
    NSString *myJid = (NSString *)[sender myJID];
    
    
    NSString *resultString = [[[NSString stringWithFormat:@"%@",myJid] componentsSeparatedByString:@"@"] objectAtIndex:0];
    
    NSString *userName = [[Themes getUserID] lowercaseString];
    
    if ([elementName isEqualToString:@"stream:error"] || [elementName isEqualToString:@"error"])
    {
        NSXMLElement *r_conflict = [element elementForName:@"conflict" xmlns:@"urn:ietf:params:xml:ns:xmpp-streams"];
        
        if (r_conflict)
        {
            [self disconnect];
            
            if ([resultString isEqualToString:userName])
            {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Conflict", nil) message:JJLocalizedString(@"Same_User_has_been_logged", nil) delegate:self cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles: nil];
                [errorAlert show];
            }
            else
            {
                
            }
        }
        
    }
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    return NO;
    
}
-(void)playAudioDriverArrived{
  
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Dingdong.wav", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioplayer.numberOfLoops =1;
        [audioplayer play];
   
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    @try {
        NSLog(@"Receive success %@",message);
        NSString *testXMLString =[NSString stringWithFormat:@"%@",message];
        // Parse the XML into a dictionary
        NSError *parseError = nil;
        NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:testXMLString error:&parseError];
        
        NSLog(@"%@", xmlDictionary);
        
        NSString * TextContent=[[[xmlDictionary valueForKey:@"message"] valueForKey:@"body"] valueForKey:@"text"];
        
        NSString *xmppRecMsg = [[TextContent
                                 stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                                stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSData *data = [xmppRecMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary * recMsgDict = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
        
        if(recMsgDict!=nil&&[recMsgDict count]>0)
        {
            NSLog(@"%@",recMsgDict);
            
            [recMsgDict setValue:@"fromxmpp" forKey:@"PushKey"]; //dhiravida
            [self didReceiveNotificationAndHandling:recMsgDict];
   
        }
    }
    @catch (NSException *exception)
    {
        
    }
    
}

-(void)didReceiveNotificationAndHandling:(NSDictionary *)recMsgDict{
    
    if([recMsgDict count]>0){
        
        NSString * ActionMsg=[recMsgDict valueForKey:@"action"];
        
        if ([ActionMsg isEqualToString:@"ride_confirmed"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: @"pushnotification" object:recMsgDict];
            
            
        }
        else if ([ActionMsg isEqualToString:@"cab_arrived"])
        {
            [self playAudioDriverArrived];
            ObjRec=[[FareRecord alloc]init];
            ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
            ObjRec.Message=[Themes checkNullValue:[recMsgDict valueForKey:@"message"]];
            ObjRec.driverLat=[Themes checkNullValue:[recMsgDict valueForKey:@"key3"]];
            ObjRec.driverLong=[Themes checkNullValue:[recMsgDict valueForKey:@"key4"]];
            
            ObjRec.fromNotification=[Themes checkNullValue:[recMsgDict valueForKey:@"PushKey"]];//dhiravida
            
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cab_arrived" object:ObjRec];
            //[self LogIn];
            
        }
        else if ([ActionMsg isEqualToString:@"ride_completed"])
        {
            ObjRec=[[FareRecord alloc]init];
            ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
            ObjRec.Message=[Themes checkNullValue:[recMsgDict valueForKey:@"message"]];
            UIAlertView * CompleteAlert= [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"success", nil)
                                                    message:[Themes checkNullValue:[recMsgDict valueForKey:@"message"]]
                                                   delegate:self
                                          cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                          otherButtonTitles:nil];
            [CompleteAlert show];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"ride_completed" object:ObjRec];
            
             ObjRec.fromNotification=[Themes checkNullValue:[recMsgDict valueForKey:@"PushKey"]];//dhiravida
            
            
        }
        else if ([ActionMsg isEqualToString:@"payment_paid"])
        {
            ObjRec=[[FareRecord alloc]init];
            ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
            
             ObjRec.fromNotification=[Themes checkNullValue:[recMsgDict valueForKey:@"PushKey"]];//dhiravida
            
            [[NSNotificationCenter defaultCenter] postNotificationName: @"payment_paid" object:ObjRec];
            
        }
        else if ([ActionMsg isEqualToString:@"requesting_payment"])
        {
            ObjRec=[[FareRecord alloc]init];
            ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key6"]];
            
             ObjRec.fromNotification=[Themes checkNullValue:[recMsgDict valueForKey:@"PushKey"]];//dhiravida
            
            [[NSNotificationCenter defaultCenter] postNotificationName: @"waitingfor_payment" object:ObjRec];
        }
        
        else if ([ActionMsg isEqualToString:@"ride_cancelled"])
        {
            CancelAlert= [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Sorry", nil)
                                                    message:[Themes checkNullValue:[recMsgDict valueForKey:@"message"]]
                                                   delegate:self
                                          cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                          otherButtonTitles:nil];
            [CancelAlert show];
            
        }
        else if ([ActionMsg isEqualToString:@"ads"])
        {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kDriverAdvtInfo
             object:self userInfo:recMsgDict];
            
         
            
        }
        else if ([ActionMsg isEqualToString:@"trip_begin"])
        {
            ObjRec=[[FareRecord alloc]init];
            ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
            ObjRec.Message=[Themes checkNullValue:[recMsgDict valueForKey:@"message"]];
            ObjRec.DropLatitude=[Themes checkNullValue:[recMsgDict valueForKey:@"key3"]];
            ObjRec.DropLongitude=[Themes checkNullValue:[recMsgDict valueForKey:@"key4"]];
            
            ObjRec.driverLat=[Themes checkNullValue:[recMsgDict valueForKey:@"key5"]];
            ObjRec.driverLong=[Themes checkNullValue:[recMsgDict valueForKey:@"key6"]];
            
             ObjRec.fromNotification=[Themes checkNullValue:[recMsgDict valueForKey:@"PushKey"]];//dhiravida
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Ride_start" object:ObjRec];
            
        }
        else if ([ActionMsg isEqualToString:@"make_payment"])
        {
            ObjRec=[[FareRecord alloc]init];
            ObjRec.ride_id=[Themes checkNullValue:[recMsgDict valueForKey:@"key1"]];
            ObjRec.Message=[Themes checkNullValue:[recMsgDict valueForKey:@"message"]];
            
             ObjRec.fromNotification=[Themes checkNullValue:[recMsgDict valueForKey:@"PushKey"]];//dhiravida
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ride_completed" object:ObjRec];
            
        }
        else if ([ActionMsg isEqualToString:@"driver_loc"])
        {
            
            if ([currentView isEqualToString:@"NewTrackVC"]) {
                
                ObjDriverRecord=[[Driver_Record alloc]init];
                ObjDriverRecord.Driver_latitude=[Themes checkNullValue:[recMsgDict valueForKey:@"latitude"]];
                ObjDriverRecord.Driver_longitude=[Themes checkNullValue:[recMsgDict valueForKey:@"longitude"]];
                ObjDriverRecord.RideID=[Themes checkNullValue:[recMsgDict valueForKey:@"ride_id"]];
                ObjDriverRecord.bearingValue=[Themes checkNullValue:[recMsgDict valueForKey:@"bearing"]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Updatedriver_loc" object:ObjDriverRecord];
                
            }
        }
        
    }
    
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    NSLog(@"Send success %@",message);
    // [[NSNotificationCenter defaultCenter] postNotificationName: @"SendMessage" object:message];
}


- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSString *jidUserTypeStr = [presence type];
    
    NSString *jidUserStr = [[presence from] user];
    
    if ([jidUserTypeStr isEqualToString:@"available"]) {
        
        isXMPPDisConnected = NO;
    }
    else
    {
        isXMPPDisConnected = YES;
        [self disconnect];
    }
    
    NSLog(@"presnece......User->%@..UserPresence->%@",jidUserStr,jidUserTypeStr);
    
    
    
}
#pragma mark - XMPP State
/**
 * Called to whether XMPP is connected/disconnected for Reconnection process
 */
-(void)xmppState
{
    if (xmppStream == nil)
    {
        // xmppStream = [[XMPPStream alloc] init];
        isXMPPDisConnected = YES;
    }
    else
    {
        isXMPPDisConnected = [xmppStream isDisconnected];
    }
    
    
}

- (void)xmppRoster:(XMPPStream *)sender didReceiveRosterItem:(DDXMLElement *)item {
    
    NSLog(@"Did receive Roster item");
    
    
}
-(void)XMPP_Plug
{
    NSDictionary* parameter=@{@"user_type":@"user",
                              @"id":[Themes writableValue:[Themes getUserID]],
                              @"mode":@"available"};
    UrlHandler * webhandler=[UrlHandler UrlsharedHandler];
    [webhandler CheckXMPP:parameter success:^(NSMutableDictionary *responseDictionary) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void)XMPP_Unplug
{
    NSDictionary* parameter=@{@"user_type":@"user",
                              @"id":[Themes writableValue:[Themes getUserID]],
                              @"mode":@"unavailable"};
    UrlHandler * webhandler=[UrlHandler UrlsharedHandler];
    [webhandler CheckXMPP:parameter success:^(NSMutableDictionary *responseDictionary) {
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma URL SCHEME

-(NSDictionary *)urlPathToDictionary:(NSString *)path
{
    //Get the string everything after the :// of the URL.
    NSString *stringNoPrefix = [[path componentsSeparatedByString:@"://"] lastObject];
    //Get all the parts of the url
    NSMutableArray *parts = [[stringNoPrefix componentsSeparatedByString:@"/"] mutableCopy];
    //Make sure the last object isn't empty
    if([[parts lastObject] isEqualToString:@""])[parts removeLastObject];
    
    if([parts count] % 2 != 0)//Make sure that the array has an even number
        return nil;
    
    //We already know how many values there are, so don't make a mutable dictionary larger than it needs to be.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:([parts count] / 2)];
    
    //Add all our parts to the dictionary
    for (int i=0; i<[parts count]; i+=2) {
        [dict setObject:[parts objectAtIndex:i+1] forKey:[parts objectAtIndex:i]];
    }
    
    //Return an NSDictionary, not an NSMutableDictionary
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(void)GetAppInfo{
    NSDictionary* parameter=@{@"id":[Themes checkNullValue:[Themes getUserID]]
                              ,@"user_type":@"user"};
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web AppInfoUrl:parameter
            success:^(NSMutableDictionary *responseDictionary)
     {
         if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
              self.isAlertCleared=NO;
             appInfoIteration=0;
             NSDictionary * dict=responseDictionary[@"response"][@"info"];
             NSDictionary * rideDict=responseDictionary[@"response"];
             if(dict.count>0){
               AppInfoRecords * objAppInfoRecs=[[AppInfoRecords alloc]init];
                 objAppInfoRecs.serviceContactEmail=[Themes checkNullValue:[dict objectForKey:@"site_contact_mail"]];
                 objAppInfoRecs.serviceNumber=[Themes checkNullValue:[dict objectForKey:@"customer_service_number"]];
                 objAppInfoRecs.serviceSiteUrl=[Themes checkNullValue:[dict objectForKey:@"site_url"]];
                 objAppInfoRecs.serviceXmppHost=[Themes checkNullValue:[dict objectForKey:@"xmpp_host_name"]];
                 objAppInfoRecs.serviceXmppPort=[Themes checkNullValue:[dict objectForKey:@"xmpp_host_url"]];
                 objAppInfoRecs.serviceFacebookAppId=[Themes checkNullValue:[dict objectForKey:@"facebook_id"]];
                 objAppInfoRecs.serviceGooglePlusId=[Themes checkNullValue:[dict objectForKey:@"google_plus_app_id"]];
                 objAppInfoRecs.servicePhoneMaskingStatus=[Themes checkNullValue:[dict objectForKey:@"phone_masking_status"]];
                 
                 objAppInfoRecs.hasPendingRide=[Themes checkNullValue:[rideDict objectForKey:@"ongoing_ride"]];
                 objAppInfoRecs.pendingRideID=[Themes checkNullValue:[rideDict objectForKey:@"ongoing_ride_id"]];
                 objAppInfoRecs.hasPendingRating=[Themes checkNullValue:[rideDict objectForKey:@"rating_pending"]];
                 objAppInfoRecs.pendingRateId=[Themes checkNullValue:[rideDict objectForKey:@"rating_pending_ride_id"]];
                 objAppInfoRecs.appUserAgentName=[Themes checkNullValue:[dict objectForKey:@"app_identity_name"]];
                   objAppInfoRecs.aboutusTxt=[Themes checkNullValue:[dict objectForKey:@"about_content"]];
                 objAppInfoRecs.userEmergencyPage=[Themes checkNullValue:[dict objectForKey:@"user_emergency_page"]];
                 objAppInfoRecs.ryddwalletRecharge=[Themes checkNullValue:[dict objectForKey:@"rydd_wallet_recharge"]];
                 objAppInfoRecs.operatingsHours=[Themes checkNullValue:[dict objectForKey:@"operating_hours"]];
                 
                 [Themes saveAppDetails:objAppInfoRecs];
                    NSString *userImg=[Themes checkNullValue:[dict objectForKey:@"user_image"]];
                 [Themes SaveUserImage:userImg];
                 NSString *siteUrlStr=[Themes checkNullValue:[dict objectForKey:@"site_url"]];
                 NSString *siteModeStr=[Themes checkNullValue:[dict objectForKey:@"site_mode"]];
                 NSString *serverModeStr=[Themes checkNullValue:[dict objectForKey:@"server_mode"]];
                NSString *inputLang=[Themes checkNullValue:[dict objectForKey:@"lang_code"]];
              
                NSArray * langArr=@[@"es",@"ta",@"en"];
                  //   NSArray * langArr=@[@"es",@"en"];
                 if([langArr containsObject:inputLang]){
                        [Themes saveLanguage:inputLang];
                 }else{
                        [Themes saveLanguage:@"en"];
                 }
                     [Themes SetLanguageToApp];
                 
                 if([siteModeStr isEqualToString:@"development"]){
                    
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:kShutTheApp
                      object:self userInfo:dict];
                     
                 }else{
                     if(objAppInfoRecs.serviceXmppHost.length>0 && objAppInfoRecs.serviceXmppPort.length>0){
                         
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:@"NotifForAppInfo"
                          object:self userInfo:nil];
                     }else{
                     }
                 }
                 if([serverModeStr isEqualToString:@"1"]){
                     if(isGetAppLoad==NO){
                         isGetAppLoad=YES;
                         UIViewController* mainController = (UIViewController*)  self.window.rootViewController;
                         [mainController.view makeToast:[Themes checkNullValue:siteUrlStr]];
                     }
                 }else{
                 
                 }
             }
         }else{
              self.isAlertCleared=NO;
             [self showAlertForAppInfo:[Themes checkNullValue:responseDictionary[@"response"]]];
         }
         
     }
            failure:^(NSError *error)
     {
         
         if(appInfoIteration<=3){
             appInfoIteration++;
             [self GetAppInfo];
         }else{
             if(isGetAppLoad==NO){
                 isGetAppLoad=YES;
                 UIViewController* mainController = (UIViewController*)  self.window.rootViewController;
                 [mainController.view makeToast:[Themes checkNullValue:AppbaseUrl]];
             }
           
             [self showAlertForAppInfo:JJLocalizedString(@"Having_some_problem_in", nil)];
         }
         //[self.view makeToast:kErrorMessage];
     }];
}

-(void)showAlertForAppInfo:(NSString *)msg{
    if(self.isAlertCleared==NO){
        self.isAlertCleared=YES;
        OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Oops", nil)
                                                                    message:msg
                                                          cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                          otherButtonTitles:nil];
        alert.iconType = OpinionzAlertIconWarning;
        [alert show];
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    
    if(self.restrictRotation)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
    
}


@end
