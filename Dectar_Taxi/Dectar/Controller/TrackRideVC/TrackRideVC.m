//
//  TrackRideVC.m
//  Dectar
//
//  Created by Suresh J on 20/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "TrackRideVC.h"
#import <CoreLocation/CoreLocation.h>
#import "SWRevealViewController.h"
#import "Blurview.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "Constant.h"
#import "ASIHTTPRequest.h"
#import "MarkerView.h"

@interface TrackRideVC ()<UITableViewDelegate,UITableViewDataSource,BlurViewDeletgate>
{
    CLLocationManager * currentLocation;
    BOOL isSelected;
    Blurview* view;
    NSTimer *SerivceHitting;
    GMSMarker*marker;
    NSString * PickUpTime_Str;

}
@property (strong,nonatomic)IBOutlet UIButton *btnDriver;
@end

@implementation TrackRideVC
@synthesize btnDriver,TrackObj,DriverName,CarModel,CarNumber,Driver_latitude,Driver_longitude,Driver_MobileNumber,GoogleMap,Camera,MapBG,CancelView,ResonTableView,Reason_Array,SubmitBtn,Ride_ID,Reason_ID,Reason_Str,rating,User_latitude,User_longitude,Cancel_Ride;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnDriver.layer.cornerRadius=20;
    [self setTrackObj:TrackObj];
    marker=[[GMSMarker alloc]init];
   

    ResonTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    CancelView.layer.cornerRadius = 5;
    CancelView.layer.masksToBounds = YES;
    
    SubmitBtn.backgroundColor=[UIColor grayColor];
    SubmitBtn.userInteractionEnabled=NO;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cabCame:) name:@"cab_arrived" object:nil];

    [self getCancelReason];

}
/*-(void)cabCame:(NSNotification *)notification
{
    [SerivceHitting invalidate];
}*/
-(void)UpdateDriverLocation:(NSTimer*)timer
{
    NSDictionary * parameters=@{@"rideId":Ride_ID};
    
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
                 PickUpTime_Str=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"min_pickup_duration"];
                 NSMutableArray *aray =[[[responseDictionary valueForKey:@"response"] valueForKey:@"tracking_details"] valueForKey:@"location"];
                 NSString * result = [aray componentsJoinedByString:@""];
                 NSLog(@"%@",result);
                //[GoogleMap clear];
                if ([result isEqualToString:@""])
                 {
                     
                 }
                 for(int i=0;i<[aray count];i++)
                 {
                     NSDictionary *dict=(NSDictionary *)[aray objectAtIndex:i];
                     double la=[[dict objectForKey:@"lat"] doubleValue];
                     double lo=[[dict objectForKey:@"lon"] doubleValue];
                     CLLocation * loca=[[CLLocation alloc]initWithLatitude:la longitude:lo];
                     CLLocationCoordinate2D coordi=loca.coordinate;
                     marker=[GMSMarker markerWithPosition:coordi];
                     marker.map = GoogleMap;
                     marker.appearAnimation=kGMSMarkerAnimationPop;
                     UIImage *mapicon=[UIImage imageNamed:@"pin"];
                     marker.icon = mapicon;
                     // [GoogleMap animateToZoom:12];
                 
                }
             }
         }
     }
     
              failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [GoogleMap setMyLocationEnabled:NO];

    Camera = [GMSCameraPosition cameraWithLatitude: User_latitude
                                         longitude: User_longitude
                                              zoom:17];
    [GoogleMap animateToCameraPosition:Camera];
    Reason_Array=[NSMutableArray array];
    GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, MapBG.frame.size.width , MapBG.frame.size.height) camera:Camera];
    [MapBG addSubview:GoogleMap];
    [self foo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)UpdateLocation:(id)sender {
    [GoogleMap setMyLocationEnabled:YES];
    CLLocation *location = GoogleMap.myLocation;
    if (location) {
        [GoogleMap animateToLocation:location.coordinate];
    }

}

-(void)setTrackObj:(DriverRecord *)_addressObj
{
    TrackObj=_addressObj;
    DriverName.text=_addressObj.Driver_Name;
    CarNumber.text=_addressObj.Car_Number;
    CarModel.text=_addressObj.Car_Name;
    Driver_MobileNumber=_addressObj.Driver_moblNumber;
    Ride_ID=_addressObj.Ride_ID;
    Driver_longitude=_addressObj.longitude_driver;
    Driver_latitude=_addressObj.latitude_driver;
    rating.text=[NSString stringWithFormat:@"%@/5",_addressObj.rating];
    rating.textColor=[UIColor redColor];
    User_longitude=_addressObj.longitude_User;
    User_latitude=_addressObj.latitude_User;
    PickUpTime_Str=_addressObj.ETA;
    if (_addressObj.isCancel==YES)
    {
        [Cancel_Ride setHidden:NO];
        /*NSString *coordinates = [NSString stringWithFormat:@"%@ Driver Will Arrive with in , %@ to your address", TrackObj.message, TrackObj.ETA];
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:coordinates delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];*/

    }
    else
    {
        [Cancel_Ride setHidden:YES];

    }
   
}
- (void)foo
{
    UIImageView *pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maping"]];
    UIView *viewMarker = [[UIView alloc] initWithFrame:CGRectMake(0,0,pinImageView.frame.size.width,pinImageView.frame.size.height)];
    UILabel *label = [UILabel new];
    label.frame=CGRectMake(pinImageView.center.x-20,pinImageView.center.y-30,pinImageView.frame.size.width,pinImageView.frame.size.height);
    //label.center=pinImageView.center;
    label.text = PickUpTime_Str;
    label.textColor=[UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:13.0f];
    [label sizeToFit];
    [viewMarker addSubview:pinImageView];
    [viewMarker addSubview:label];
    //i.e. customize view to get what you need
    
    CLLocation * loca=[[CLLocation alloc]initWithLatitude:User_latitude longitude:User_longitude];
    CLLocationCoordinate2D coordi=loca.coordinate;
    marker=[GMSMarker markerWithPosition:coordi];
    marker.appearAnimation=kGMSMarkerAnimationPop;
    UIImage *markerIcon = [self imageFromView:viewMarker];
    marker.icon = markerIcon;
    marker.map = GoogleMap;
}

- (UIImage *)imageFromView:(UIView *)Customview
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(Customview.frame.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(Customview.frame.size);
    }
    [Customview.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//-(void)rote
//{
//    NSString *urlString = [NSString stringWithFormat:
//                           @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
//                           @"https://maps.googleapis.com/maps/api/directions/json",
//                           currentLocation.location.coordinate.latitude,
//                           currentLocation.location.coordinate.longitude,
//                           latitude,
//                           longitude,
//                           GoogleServerKey];
//    NSURL *directionsURL = [NSURL URLWithString:urlString];
//    
//    
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:directionsURL];
//    [request startSynchronous];
//    NSError *error = [request error];
//    if (!error) {
//        NSString *response = [request responseString];
//        NSLog(@"facebook.com/truqchal %@",response);
//        NSDictionary *json =[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
//        GMSPath *path =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
//        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
//        singleLine.strokeWidth = 7;
//        singleLine.strokeColor = [UIColor greenColor];
//        singleLine.map = self.GoogleMap;
//    }
//    else NSLog(@"facebook.com/truqchal%@",[request error]);
//}
- (IBAction)TrackDriver:(id)sender {
    
    Camera = [GMSCameraPosition cameraWithLatitude: Driver_latitude
                                         longitude: Driver_longitude
                                              zoom:17];
    
    [GoogleMap animateToCameraPosition:Camera];
    
    CLLocation * loca=[[CLLocation alloc]initWithLatitude:Driver_latitude longitude:Driver_longitude];
    CLLocationCoordinate2D coordi=loca.coordinate;
    marker=[GMSMarker markerWithPosition:coordi];
    marker.map = GoogleMap;
    UIImage *mapicon=[UIImage imageNamed:@"pin"];
    marker.icon = mapicon;
    
    /*SerivceHitting= [NSTimer timerWithTimeInterval:10.0
                                            target:self
                                          selector:@selector(UpdateDriverLocation:)
                                          userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:SerivceHitting forMode:NSRunLoopCommonModes];*/
    
    [self DirectionPath];
}
-(void)DirectionPath
{
    NSString *urlStr=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&key=AIzaSyDe-8elGxbNPtTNn6k_uBo983Mw245XEug",Driver_latitude,Driver_longitude,User_latitude,User_longitude];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr=[ urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLResponse *res;
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:url] returningResponse:&res error:&err];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *routes=dic[@"routes"];
    if([routes count]>0){
        GMSPath *path =[GMSPath pathFromEncodedPath:dic[@"routes"][0][@"overview_polyline"][@"points"]];
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
        singleLine.strokeWidth = 3;
        singleLine.strokeColor = [UIColor blueColor];
        singleLine.map = GoogleMap;
    }
   
}

- (IBAction)CancelConfirmation:(id)sender {
    
    
    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) {
        
        [view removeFromSuperview];
        [CancelView setHidden:YES];
        
        
    } else if (btnAuthOptions.tag==2) {
        
        [self SubmitRating];
    }
}
- (IBAction)CloseBtn:(id)sender {
    
    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) {
        
        [SerivceHitting invalidate];

       view=[[[NSBundle mainBundle] loadNibNamed:@"Blurview" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:view];
        view.isNeed=YES;
        view.delegate=self;
        
        [self.view bringSubviewToFront:CancelView];
        CancelView.hidden=NO;


        
    } else if (btnAuthOptions.tag==2) {
        
        [SerivceHitting invalidate];

        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [del LogIn];
    }

}
-(void)CloseBlurView
{
    CancelView.hidden=YES;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Reason_Array count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
          }
         /* if (Reason_Array == nil || [Reason_Array count] == 0)
          {
              if ( [Reason_Array containsObject:indexPath]  )
              {
                  cell.accessoryType = UITableViewCellAccessoryCheckmark;
              }
              else
              {
                  cell.accessoryType = UITableViewCellAccessoryNone;
              }
          }*/
    
    NSIndexPath* selection = [tableView indexPathForSelectedRow];
    if (selection && selection.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }


    DriverRecord *objRec=(DriverRecord*)[Reason_Array objectAtIndex:indexPath.row];
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.text=objRec.reason;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_6) {
        return 59;
    }
    return 49;
}

-(IBAction)callPhone:(id)sender {
     NSString* actionStr = [NSString stringWithFormat:@"telprompt:%@",Driver_MobileNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionStr]];
    
}
-(void)getCancelReason
{
    NSDictionary * parameters=@{@"user_id":[Themes getUserID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web CancelReason:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         NSLog(@"%@",responseDictionary);
         responseDictionary=[Themes writableValue:responseDictionary];

         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         [Themes StopView:self.view];

         if ([comfiramtion isEqualToString:@"1"])
         {
             
             
             for (NSDictionary * objCatDict in responseDictionary[@"response"][@"reason"]) {
                 TrackObj=[[DriverRecord alloc]init];
                 TrackObj.reason=[objCatDict valueForKey:@"reason"];
                 TrackObj.ID_Reason =[objCatDict valueForKey:@"id"]  ;
                 
                 [Reason_Array addObject:TrackObj];
                 
             }
             [ResonTableView reloadData];

             
         }
         else
         {
            
         }
         }
         
     }
                    failure:^(NSError *error)
     {
        [Themes StopView:self.view];
     }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*NSInteger catIndex = [Reason_Array indexOfObject:TrackObj];
    if (catIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:catIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        TrackObj = [Reason_Array objectAtIndex:indexPath.row];
        
        Reason_Str=TrackObj.reason;
        Reason_ID=TrackObj.ID_Reason;
        
        SubmitBtn.backgroundColor=[UIColor orangeColor];
        SubmitBtn.userInteractionEnabled=YES;
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];*/

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    TrackObj = [Reason_Array objectAtIndex:indexPath.row];

    Reason_Str=TrackObj.reason;
    Reason_ID=TrackObj.ID_Reason;
    
    SubmitBtn.backgroundColor=[UIColor orangeColor];
    SubmitBtn.userInteractionEnabled=YES;
    //    cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    /* if (_lastSelectedIndexPath != nil)
     {
     UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:_lastSelectedIndexPath];
     lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
     payment_Name=addressObj.paymentname;
     paymnet_code=addressObj.paymentCode;
     
     Submit.backgroundColor=[UIColor orangeColor];
     Submit.userInteractionEnabled=YES;
     }
     _lastSelectedIndexPath = indexPath;*/
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}


- ( void )SubmitRating
{
    NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                @"ride_id":Ride_ID,
                                @"reason":Reason_ID};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
        [web CancelRide:parameters success:^(NSMutableDictionary *responseDictionary)
         {
            
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
             NSLog(@"%@",responseDictionary);
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             NSString * message=[[responseDictionary valueForKey:@"response"] valueForKey:@"message"];
             NSString * WrongStr=[responseDictionary valueForKey:@"response"];

             [Themes StopView:self.view];
             if ([comfiramtion isEqualToString:@"1"])
             {
                 [SerivceHitting invalidate];

                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];
                 
                 AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [del LogIn];

             }
             else if ([comfiramtion isEqualToString:@"0"])
                 {
                     [SerivceHitting invalidate];

                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:[NSString stringWithFormat:@"your ride already cancelled %@",WrongStr] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [Alert show];
                     
                     AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [del LogIn];
                     

                 }
             }
             
             
         }
                  failure:^(NSError *error)
         {
           [Themes StopView:self.view];
         }];
        
   
}
@end
