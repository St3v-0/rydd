//
//  NewTrackVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 12/30/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DriverRecord.h"
#import "RootBaseVC.h"
#import "FareRecord.h"
#import "UIImageView+WebCache.h"
#import "BorderButton.h"
@protocol TrackPageDelegate<NSObject>
@optional
-(void)moveToHome;
@end
@interface NewTrackVC : RootBaseVC
@property(strong,nonatomic)id<TrackPageDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *DriverName;
@property (strong, nonatomic) IBOutlet UILabel *CarModel;
@property (strong, nonatomic) IBOutlet UILabel *CarNumber;

@property (strong, nonatomic) IBOutlet UIView *MapBG;
@property (strong ,nonatomic) DriverRecord * TrackObj;
@property (strong ,nonatomic) NSString * Driver_MobileNumber;
@property (strong ,nonatomic) GMSMapView * GoogleMap;
@property (strong ,nonatomic) GMSCameraPosition * Camera;
@property (strong,nonatomic) NSString * Ride_ID;
@property (strong,nonatomic) NSString * Reason_Str;
@property (strong,nonatomic) NSString *Reason_ID;



@property (strong, nonatomic) IBOutlet UILabel *rating;

@property (strong, nonatomic) IBOutlet UIButton *Cancel_Ride;
@property (strong, nonatomic) IBOutlet UIImageView *Driver_image;
@property (strong, nonatomic) IBOutlet UIImageView * Cap_image;

@property (strong, nonatomic) IBOutlet UILabel *Title_lbl;
@property (strong, nonatomic) IBOutlet UIScrollView *parallax_Scroll;
@property (strong, nonatomic) FareRecord * objrecFar;
@property (strong, nonatomic) IBOutlet UIButton *PanicBtn;
@property (strong, nonatomic) IBOutlet UIButton *done_btn;
@property (strong, nonatomic) IBOutlet UIButton *contact;
@property (weak, nonatomic) IBOutlet BorderButton *contBtn;

@property CGFloat Drop_latitude;
@property CGFloat Drop_longitude;
@property(assign,nonatomic)NSInteger errorCount;
@property (weak, nonatomic) IBOutlet UIButton *headerDoneBtn;

@property (weak, nonatomic) IBOutlet UIView *beforeRideStartView;
@property (weak, nonatomic) IBOutlet UIView *afterRideStartView;


@end
