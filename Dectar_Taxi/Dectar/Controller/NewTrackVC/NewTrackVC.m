//
//  NewTrackVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 12/30/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.

#import "NewTrackVC.h"
#import <CoreLocation/CoreLocation.h>
#import "Blurview.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "Constant.h"
#import "ASIHTTPRequest.h"
#import "MarkerView.h"
#import "CancelRideVC.h"
#import "UIImageView+Network.h"
#import "RatingVC.h"
#import "NewViewController.h"
#import "Driver_Record.h"
#import "HelpVC.h"
#import "LanguageHandler.h"
#import "UIImageView+Network.h"
#import "UIImageView+WebCache.h"



@interface NewTrackVC ()<UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    BOOL isSelected;
    Blurview* view;
    NSTimer *SerivceHitting;
    GMSMarker*PickUpmarker;
    GMSMarker*Dropmarker;
    GMSMarker*Drivermarker;
    GMSMarker*userMarker;
    Driver_Record*objDriver;
    NSString * PickUpTime_Str;
    UILabel *label ;
    AppDelegate *appDel;
    BOOL CheckStatus_Notify;
    UIImageView *DrivImage_view;

    
    
}
@end

@implementation NewTrackVC
@synthesize TrackObj,DriverName,CarModel,CarNumber,Driver_MobileNumber,GoogleMap,Camera,MapBG,Ride_ID,Reason_ID,Reason_Str,rating,Cancel_Ride,Driver_image,Cap_image,beforeRideStartView,afterRideStartView,contBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    _parallax_Scroll.hidden=YES;
    CarNumber.numberOfLines = 1;
    CarNumber.minimumScaleFactor = 0.5;
    CarNumber.adjustsFontSizeToFitWidth = YES;

    if (!appDel) {
        appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    appDel.currentView = @"NewTrackVC";
    
  
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"ride_completed" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewVc:) name:@"payment_paid" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cabCame:) name:@"cab_arrived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CompleteRide:) name:@"ride_completed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RideStared:) name:@"Ride_start" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateDriverPlace:) name:@"Updatedriver_loc" object:nil];
    
    _PanicBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _PanicBtn.layer.shadowOpacity = 0.5;
    _PanicBtn.layer.shadowRadius = 2;
    _PanicBtn.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    Driver_image.layer.cornerRadius=Driver_image.frame.size.width/2;
    Driver_image.layer.masksToBounds=YES;
    Cap_image.layer.cornerRadius=Cap_image.frame.size.width/2;
    Cap_image.layer.masksToBounds=YES;
    
  }

-(void)viewWillAppear:(BOOL)animated
{
     [self UpdateDriverLocation];
    [super viewWillAppear:animated];
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_Title_lbl setText:JJLocalizedString(@"Track_Driver", nil)];
    [_done_btn setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [_headerDoneBtn setTitle:JJLocalizedString(@"Exit", nil) forState:UIControlStateNormal];
    [Cancel_Ride setTitle:JJLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [_contact setTitle:JJLocalizedString(@"Contact", nil) forState:UIControlStateNormal];
    [contBtn setTitle:JJLocalizedString(@"Contact", nil) forState:UIControlStateNormal];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)setObjrecFar:(FareRecord *)objrecFar
{
    Ride_ID=objrecFar.ride_id;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)UpdateDriverLocation
{
    [Themes StartView:self.view];
    NSDictionary * parameters=@{@"ride_id":[Themes checkNullValue:Ride_ID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web Track_Driver:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
             NSLog(@"%@",responseDictionary);
             
             if ([responseDictionary count]>0)
             {
                 responseDictionary=[Themes writableValue:responseDictionary];
                 NSString * comfiramtion=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"status"]];
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     NSDictionary * drivDict=[[responseDictionary objectForKey:@"response"]objectForKey:@"driver_profile"];
                     
                     DriverName.text=[Themes checkNullValue:[drivDict objectForKey:@"driver_name"]];
                     CarNumber.text=[Themes checkNullValue:[drivDict valueForKey:@"vehicle_model"]];
                     CarModel.text=[Themes checkNullValue:[drivDict valueForKey:@"vehicle_number"]];
                     Driver_MobileNumber=[Themes checkNullValue:[drivDict valueForKey:@"phone_number"]];
                     
                   
                    
                     PickUpTime_Str=[Themes checkNullValue:[drivDict valueForKey:@"min_pickup_duration"]];
                     rating.text=[NSString stringWithFormat:@"%@",[Themes checkNullValue:[drivDict valueForKey:@"driver_review"]]];
                     Ride_ID=[Themes checkNullValue:[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"]];
                     if(drivDict.count>0){
                           [self loadMapwith:drivDict];
                     }
                     NSString * Imageurl=[Themes checkNullValue:[drivDict valueForKey:@"driver_image"]];
                        [Driver_image sd_setImageWithURL:[NSURL URLWithString:Imageurl] placeholderImage:[UIImage imageNamed:@"driverSample.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         
                     }];
                 }
                    _parallax_Scroll.hidden=NO;
             }else{
                 [self.view makeToast:[Themes checkNullValue:[responseDictionary objectForKey:@"response"]]];
             }
         
         
     }
     
              failure:^(NSError *error)
     {
        
         [Themes StopView:self.view];
         if(self.errorCount<2){
               [self UpdateDriverLocation];
             self.errorCount++;
         }else{
              [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
         }
       
     }];
}
-(void)loadMapwith:(NSDictionary *)drivDict{
      NSString * Status=[Themes checkNullValue:[drivDict valueForKey:@"ride_status"]];
    float   User_longitude=[[drivDict valueForKey:@"rider_lon"] doubleValue];
    float  User_latitude=[[drivDict valueForKey:@"rider_lat"]doubleValue];
    if(Camera==nil){
        Camera = [GMSCameraPosition cameraWithLatitude: User_latitude
                                             longitude: User_longitude
                                                  zoom:17];
        
        
        GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, MapBG.frame.size.width , MapBG.frame.size.height) camera:Camera];
        
        if (MapNightMode==1) {
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSURL *styleUrl = [mainBundle URLForResource:@"Style" withExtension:@"json"];
            NSError *error;
            GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
            if (!style) {
                NSLog(@"The style definition could not be loaded: %@", error);
            }
            else{
                GoogleMap.mapStyle = style;
            }
        }

        [GoogleMap setMyLocationEnabled:NO];
        [GoogleMap animateToCameraPosition:Camera];
        [MapBG addSubview:GoogleMap];
      
        PickUpmarker=[[GMSMarker alloc]init];
        Dropmarker=[[GMSMarker alloc]init];
        Drivermarker=[[GMSMarker alloc]init];
        userMarker=[[GMSMarker alloc]init];
        GoogleMap.settings.allowScrollGesturesDuringRotateOrZoom = NO;
        GoogleMap.settings.rotateGestures=NO;
    }
    
    [self loadmarkersAccordingToStatus:Status withDictionary:drivDict];
    
}
-(void)statusUpToArrivedwithPickUpCoordinate:(CLLocationCoordinate2D)pickCoordinate withDriverCoordinate:(CLLocationCoordinate2D )drivCoOrdinate withImage:(NSString *)drivImgStr withLoadDirection:(BOOL)isLoad{
  
    [GoogleMap clear];
    
    Drivermarker.position = CLLocationCoordinate2DMake(drivCoOrdinate.latitude, drivCoOrdinate.longitude);
    Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
    DrivImage_view=[[UIImageView alloc] init];
    
    [DrivImage_view sd_setImageWithURL:[NSURL URLWithString:drivImgStr] placeholderImage:[UIImage imageNamed:@"pointer"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        Drivermarker.icon = DrivImage_view.image;
    }];
   // Drivermarker.icon = DrivImage_view.image;
    Drivermarker.map = GoogleMap;
    
    
    userMarker.position=CLLocationCoordinate2DMake(pickCoordinate.latitude, pickCoordinate.longitude);
    userMarker.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *markerIcon2 = [UIImage imageNamed:@"StartingPin"];
    userMarker.icon = markerIcon2;
    userMarker.map = GoogleMap;
    
    Camera = [GMSCameraPosition cameraWithLatitude: drivCoOrdinate.latitude
                                         longitude:drivCoOrdinate.longitude
                                              zoom:17];
    [GoogleMap animateToCameraPosition:Camera];
    if(isLoad==YES){
         [self DrawDirectionPath:drivCoOrdinate.latitude userlng:drivCoOrdinate.longitude drop:pickCoordinate.latitude  droplng:pickCoordinate.longitude];
    }
   
}
-(void)statusOnridePickUpCoordinate:(CLLocationCoordinate2D)pickCoordinate withDropCoordinate:(CLLocationCoordinate2D )dropCoOrdinate withDriverCoordinate:(CLLocationCoordinate2D )drivCoOrdinate withImage:(NSString *)drivImgStr{
    
    [GoogleMap clear];
    
    Drivermarker.position = CLLocationCoordinate2DMake(drivCoOrdinate.latitude, drivCoOrdinate.longitude);
    Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
    DrivImage_view=[[UIImageView alloc] init];
    
    [DrivImage_view sd_setImageWithURL:[NSURL URLWithString:drivImgStr] placeholderImage:[UIImage imageNamed:@"pointer"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        Drivermarker.icon = DrivImage_view.image;
    }];
    //Drivermarker.icon = DrivImage_view.image;
    Drivermarker.map = GoogleMap;
    
    
    userMarker.position=CLLocationCoordinate2DMake(pickCoordinate.latitude, pickCoordinate.longitude);
    userMarker.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *userMarkerImg = [UIImage imageNamed:@"StartingPin"];
    userMarker.icon = userMarkerImg;
    userMarker.map = GoogleMap;
    
    Dropmarker.position=CLLocationCoordinate2DMake(dropCoOrdinate.latitude, dropCoOrdinate.longitude);
    Dropmarker.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *dropMarkerImg = [UIImage imageNamed:@"DestinationPin"];
    Dropmarker.icon = dropMarkerImg;
    Dropmarker.map = GoogleMap;
    
    Camera = [GMSCameraPosition cameraWithLatitude: drivCoOrdinate.latitude
                                         longitude:drivCoOrdinate.longitude
                                              zoom:17];
    [GoogleMap animateToCameraPosition:Camera];
    [self DrawDirectionPath:pickCoordinate.latitude userlng:pickCoordinate.longitude drop:dropCoOrdinate.latitude  droplng:dropCoOrdinate.longitude];
}

-(void)loadmarkersAccordingToStatus:(NSString *)statusStr withDictionary:(NSDictionary *)drivDict{
    
    float   User_longitude=[[drivDict valueForKey:@"rider_lon"] doubleValue];
    float  User_latitude=[[drivDict valueForKey:@"rider_lat"]doubleValue];
    float  Driver_longitude=[[drivDict valueForKey:@"driver_lon"] doubleValue];
    float   Driver_latitude=[[drivDict valueForKey:@"driver_lat"] doubleValue];
    CLLocationCoordinate2D pickupCoOrdinate= CLLocationCoordinate2DMake(User_latitude, User_longitude);
    CLLocationCoordinate2D driverCoOrdinate= CLLocationCoordinate2DMake(Driver_latitude, Driver_longitude);
    CLLocationCoordinate2D dropCoOrdinate=CLLocationCoordinate2DMake(0, 0);
    
    NSArray *dropStatus=[drivDict valueForKey:@"drop"] ;
    
    NSString * catgImg=[Themes checkNullValue:[drivDict objectForKey:@"category_icon"]];
    [Themes SaveCarCatimage:catgImg];
    
    
    
    if(dropStatus.count>0)
    {
        NSString * dropLat=[NSString stringWithFormat:@"%@",[[dropStatus valueForKey:@"latlong"] objectForKey:@"lat"] ];
        NSString * dropLong=[NSString stringWithFormat:@"%@",[[dropStatus valueForKey:@"latlong"] valueForKey:@"lon"]];
        dropCoOrdinate= CLLocationCoordinate2DMake([dropLat doubleValue], [dropLong doubleValue]);
        
    }
     [_PanicBtn setHidden:YES];
    if ([statusStr isEqualToString:@"Booked"]||[statusStr isEqualToString:@"Confirmed"]) {
        beforeRideStartView.hidden=NO;
        afterRideStartView.hidden=YES;
          [_Title_lbl setText:JJLocalizedString(@"Track_Driver", nil)];
        [self statusUpToArrivedwithPickUpCoordinate:pickupCoOrdinate withDriverCoordinate:driverCoOrdinate withImage:[Themes GetCarCatimage] withLoadDirection:YES];
    }
    else if([statusStr isEqualToString:@"Arrived"]) {
        beforeRideStartView.hidden=NO;
        afterRideStartView.hidden=YES;
          [_Title_lbl setText:JJLocalizedString(@"Cab_Arrived", nil)];
           [self statusUpToArrivedwithPickUpCoordinate:pickupCoOrdinate withDriverCoordinate:driverCoOrdinate withImage:[Themes GetCarCatimage] withLoadDirection:NO];
        
    }else if([statusStr isEqualToString:@"Onride"]) {
          [_PanicBtn setHidden:NO];
        beforeRideStartView.hidden=YES;
        afterRideStartView.hidden=NO;
           [_Title_lbl setText:JJLocalizedString(@"Enjoy_Your_Ride", nil) ];
        [self statusOnridePickUpCoordinate:pickupCoOrdinate withDropCoordinate:dropCoOrdinate withDriverCoordinate:driverCoOrdinate withImage:[Themes GetCarCatimage]];
    }else if([statusStr isEqualToString:@"Finished"]) {
        beforeRideStartView.hidden=YES;
        afterRideStartView.hidden=NO;
         [_Title_lbl setText:JJLocalizedString(@"Ride_Completed", nil)];
          [self statusUpToArrivedwithPickUpCoordinate:driverCoOrdinate withDriverCoordinate:driverCoOrdinate withImage:[Themes GetCarCatimage]withLoadDirection:NO];
        OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Ride_Completed", nil)
                                                                    message:JJLocalizedString(@"Your Rydd has been completed ", nil)
                                                          cancelButtonTitle:JJLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil];
        alert.iconType = OpinionzAlertIconSuccess;
        [alert show];

        
    }else if([statusStr isEqualToString:@"Completed"]) {
        beforeRideStartView.hidden=YES;
        afterRideStartView.hidden=NO;
           [_Title_lbl setText:JJLocalizedString(@"Ride_Completed", nil)];
         [self statusUpToArrivedwithPickUpCoordinate:driverCoOrdinate withDriverCoordinate:driverCoOrdinate withImage:[Themes GetCarCatimage]withLoadDirection:NO];
        OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Ride_Completed", nil)
                                                                    message:JJLocalizedString(@"Your Rydd has been completed ", nil)
                                                          cancelButtonTitle:JJLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil];
        alert.iconType = OpinionzAlertIconSuccess;
        [alert show];
  
    }
  }


-(void)UpdateDriverPlace:(NSNotification*)notification
{
    if (self.view.window)
    {
        @try {
            objDriver=[notification object];
            if ([objDriver.RideID isEqualToString:Ride_ID])
            {
                Drivermarker.position=CLLocationCoordinate2DMake([objDriver.Driver_latitude doubleValue], [objDriver.Driver_longitude doubleValue]);
                Drivermarker.rotation=[objDriver.bearingValue integerValue];
                Drivermarker.appearAnimation=kGMSMarkerAnimationPop;
                if(DrivImage_view==nil){
                    DrivImage_view.image=[UIImage imageNamed:@"pointer"];
                }
                NSString * carImgStr=[Themes checkNullValue:[Themes GetCarCatimage]];
                [DrivImage_view sd_setImageWithURL:[NSURL URLWithString:carImgStr] placeholderImage:[UIImage imageNamed:@"pointer"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    Drivermarker.icon = DrivImage_view.image;
                }];
                
                
                
              
                Drivermarker.map = GoogleMap;
            }
        } @catch (NSException *exception) {
            
        }
    }
}

-(void)cabCame:(NSNotification *)notification
{
    _objrecFar=[notification object];
    if ([_objrecFar.ride_id isEqualToString:Ride_ID])
    {
        beforeRideStartView.hidden=NO;
        afterRideStartView.hidden=YES;
        [_Title_lbl setText:JJLocalizedString(@"Cab_Arrived", nil)];
        
            [self statusUpToArrivedwithPickUpCoordinate:CLLocationCoordinate2DMake([_objrecFar.driverLat floatValue], [_objrecFar.driverLong floatValue]) withDriverCoordinate:CLLocationCoordinate2DMake([_objrecFar.driverLat floatValue], [_objrecFar.driverLong floatValue]) withImage:@""withLoadDirection:NO];
        
    }
}

-(void)RideStared:(NSNotification *)notification
{
    _objrecFar=[notification object];
    if ([_objrecFar.ride_id isEqualToString:Ride_ID])
    {
          [_PanicBtn setHidden:NO];
        beforeRideStartView.hidden=YES;
        afterRideStartView.hidden=NO;
        [_Title_lbl setText:JJLocalizedString(@"Enjoy_Your_Ride", nil)];
        [self statusOnridePickUpCoordinate: CLLocationCoordinate2DMake([_objrecFar.driverLat doubleValue], [_objrecFar.driverLong doubleValue]) withDropCoordinate:CLLocationCoordinate2DMake([_objrecFar.DropLatitude doubleValue], [_objrecFar.DropLongitude doubleValue]) withDriverCoordinate: CLLocationCoordinate2DMake([_objrecFar.driverLat doubleValue], [_objrecFar.driverLong doubleValue]) withImage:@""];
       
    }
}

-(void)CompleteRide:(NSNotification*)notification
{
      [_PanicBtn setHidden:YES];
    _objrecFar=[notification object];
    if ([_objrecFar.ride_id isEqualToString:Ride_ID]) {
        beforeRideStartView.hidden=YES;
        afterRideStartView.hidden=NO;
        [_Title_lbl setText:JJLocalizedString(@"Ride_Completed", nil)];
        OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Ride_Completed", nil)
                                                                    message:JJLocalizedString(@"Your Rydd has been completed ", nil)
                                                          cancelButtonTitle:JJLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil];
        alert.iconType = OpinionzAlertIconSuccess;
        [alert show];

    }
}
-(IBAction)Panic_action:(id)sender
{
//    HelpVC * ObjHelpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpVCID"];
//    [self.navigationController pushViewController:ObjHelpVC animated:YES];
    
    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Emergency number", nil)  message:@"112" delegate:self cancelButtonTitle:JJLocalizedString(@"Cancel", nil) otherButtonTitles:JJLocalizedString(@"ok", nil), nil];
    Alert.delegate=self;
    [Alert show];
  
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:JJLocalizedString(@"Select Emergency number", nil) delegate:self cancelButtonTitle:JJLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:
//                                  @"POLICE - 10111",
//                                 @"CALL CENTRE - 112",
//                                  @"AMBULANCE - 10177",
//                                  nil];
//    
//    actionSheet.tag = 300;
//    [actionSheet showInView:self.view];
    
   
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1)
    {
        NSString *contactno=@"112";
        NSString* actionStr = [NSString stringWithFormat:@"tel://%@",[Themes checkNullValue:contactno]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionStr]];
        
    }
    
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    if (buttonIndex==0) {
//        NSString* actionStr = [NSString stringWithFormat:@"tel://%@",[Themes checkNullValue:PanicContactNumber]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionStr]];
//
//    }
//    NSString* contactNo=@"";
//    NSArray * arr=[NSArray arrayWithObjects:@"10111",@"112",@"10177"	, nil];
//    if(buttonIndex<3){
//         contactNo=[arr objectAtIndex:buttonIndex];
//    }
//    
//    if(contactNo.length>0){
//        NSString*   actionStr = [NSString stringWithFormat:@"tel://%@",[Themes checkNullValue:contactNo]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionStr]];
//    }

    
    
//}


-(NSDictionary *)setParametersDrawLocation:(CGFloat )loclat withLocLong:(CGFloat)locLong withDestLoc:(CGFloat)destLoc withDestLonf:(CGFloat)destLong{
    
    NSDictionary *dictForuser = @{
                                  @"origin":[NSString stringWithFormat:@"%f,%f",loclat,locLong],
                                  @"destination":[NSString stringWithFormat:@"%f,%f",destLoc,destLong],
                                  @"sensor":@"true",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}



- (IBAction)cancel_action:(id)sender {
    CancelRideVC * ObjCancelRideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CancelRideVCID"];
    [ObjCancelRideVC setRide_ID:Ride_ID];
    [self.navigationController pushViewController:ObjCancelRideVC animated:YES];

}
- (IBAction)call_Action:(id)sender {
    
    NSString* actionStr = [NSString stringWithFormat:@"tel://%@",Driver_MobileNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionStr]];
    
}
- (IBAction)Done_Action:(id)sender {
    if( [self.delegate respondsToSelector:@selector(moveToHome)]){
         [self.delegate moveToHome];
    }
   
    [self.navigationController popViewControllerAnimated:YES];
  
}
-(void)DrawDirectionPath: (CGFloat )userlat userlng:(CGFloat )userlng drop:(CGFloat )droplat droplng:(CGFloat )droplng
{
    //Testing
    

    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleRoute:[self setParametersDrawLocation:userlat withLocLong:userlng withDestLoc:droplat withDestLonf:droplng]
                success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             NSArray * arr=[responseDictionary objectForKey:@"routes"];
             GMSPath *    pathDrawn;
             if([arr count]>0){
                 pathDrawn =[GMSPath pathFromEncodedPath:responseDictionary[@"routes"][0][@"overview_polyline"][@"points"]];
                 GMSPolyline * singleLine = [GMSPolyline polylineWithPath:pathDrawn];
                 singleLine.strokeWidth = MapLineWidth;
                 singleLine.strokeColor = [UIColor colorWithRed:47/255.0f green:163/255.0f blue:225/255.0f alpha:1];
                 singleLine.map = self.GoogleMap;
                 
                 GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:pathDrawn];
                 GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
                 [GoogleMap animateWithCameraUpdate:update];
                 
             }else{
                 
                 [self Toast:@"cant_find_route"];
             }
             
             
             
         }
         @catch (NSException *exception) {
             
         }
         
         
     }
                failure:^(NSError *error)
     {
         [self Toast:@"can't find route"];
     }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    appDel.currentView = @"";
    [super viewWillDisappear:animated];
}






@end
