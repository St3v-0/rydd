//
//  TrackRideVC.h
//  Dectar
//
//  Created by Suresh J on 20/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DriverRecord.h"
#import "RootBaseVC.h"
@interface TrackRideVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *DriverName;
@property (strong, nonatomic) IBOutlet UILabel *CarModel;
@property (strong, nonatomic) IBOutlet UILabel *CarNumber;
@property CGFloat Driver_latitude;
@property CGFloat Driver_longitude;
@property CGFloat User_latitude;
@property CGFloat User_longitude;
@property (strong, nonatomic) IBOutlet UIView *MapBG;
@property (strong ,nonatomic) DriverRecord * TrackObj;
@property (strong ,nonatomic) NSString * Driver_MobileNumber;
@property (strong ,nonatomic) GMSMapView * GoogleMap;
@property (strong ,nonatomic) GMSCameraPosition * Camera;
@property (strong, nonatomic) IBOutlet UIView *CancelView;
@property (strong, nonatomic) IBOutlet UITableView *ResonTableView;
@property (strong ,nonatomic) NSMutableArray * Reason_Array;
@property (strong, nonatomic) IBOutlet UIButton *SubmitBtn;
@property (strong,nonatomic) NSString * Ride_ID;
@property (strong,nonatomic) NSString * Reason_Str;
@property (strong,nonatomic) NSString *Reason_ID;
@property (strong, nonatomic) IBOutlet UILabel *rating;

@property (strong, nonatomic) IBOutlet UIButton *Cancel_Ride;

@end
