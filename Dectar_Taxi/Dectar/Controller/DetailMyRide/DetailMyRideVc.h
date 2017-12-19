//
//  DetailMyRideVc.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/26/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRideRecord.h"
#import <GoogleMaps/GoogleMaps.h>
#import "RootBaseVC.h"
#import "FFAPSegmentedControl.h"
#import "DetailPageRecord.h"
#import "FareDetailTableViewCell.h"


@interface DetailMyRideVc : RootBaseVC<UIScrollViewDelegate,didSelectOptionIndex>{
       FFAPSegmentedControl *obj;
}
@property (strong, nonatomic) IBOutlet UILabel *CarDetailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *RideIDlabel;
@property (strong, nonatomic) IBOutlet UILabel *StatusLabl;
@property (strong, nonatomic) IBOutlet UIView *mapBGView;
@property (strong, nonatomic) IBOutlet UIButton *favourite;
@property (strong, nonatomic) IBOutlet UIScrollView *Scrolling;

@property(strong,nonatomic)NSString * pickUpAddressStr;

@property (assign,nonatomic)CGFloat PickUp_Latitude;
@property (assign,nonatomic)CGFloat PickUp_longitude;

@property (assign,nonatomic)CGFloat Drop_Latitude;
@property (assign,nonatomic)CGFloat Drop_longitude;
@property(strong ,nonatomic) GMSMapView * googlemap;
@property (strong ,nonatomic) GMSCameraPosition*camera;
@property (strong,nonatomic) NSString * StatusPay;
@property (strong,nonatomic) NSString * userRideId;

@property(strong,nonatomic)NSMutableArray * paymentArry;

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic)  NSString *Status_Track;
@property (strong, nonatomic)  NSString *Status_Favour;
@property (strong, nonatomic) IBOutlet UIView *AddindTip_View;
@property (strong, nonatomic) IBOutlet UITextField *Amount_txtFld;
@property (strong, nonatomic) IBOutlet UIButton *Apply_tip;


@property (strong, nonatomic) IBOutlet UIButton *PanicBtn;


@property (strong, nonatomic) IBOutlet UILabel *heading;



@property(strong,nonatomic)NSMutableArray * detailePageDataArray;

@property (weak, nonatomic) IBOutlet UIView *pickUpView;
@property (weak, nonatomic) IBOutlet UILabel *pickUpHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *pickupSepLbl1;
@property (weak, nonatomic) IBOutlet UIImageView *pickupLocImg;
@property (weak, nonatomic) IBOutlet UIImageView *pickupTimerImg;
@property (weak, nonatomic) IBOutlet UILabel *pickupLocLbl;
@property (weak, nonatomic) IBOutlet UILabel *pickupTimerLbl;
@property (weak, nonatomic) IBOutlet UILabel *pickupSep2;
@property (weak, nonatomic) IBOutlet UIView *topView;


@property (weak, nonatomic) IBOutlet UIView *DropView;
@property (weak, nonatomic) IBOutlet UILabel *DropHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *DropSepLbl1;
@property (weak, nonatomic) IBOutlet UIImageView *DropLocImg;
@property (weak, nonatomic) IBOutlet UIImageView *DropTimerImg;
@property (weak, nonatomic) IBOutlet UILabel *DropLocLbl;
@property (weak, nonatomic) IBOutlet UILabel *DropTimerLbl;
@property (weak, nonatomic) IBOutlet UILabel *DropSep2;

@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeDistLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeTakenLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeWaitLbl;

@property (weak, nonatomic) IBOutlet UIView *rateDetailView;
@property (weak, nonatomic) IBOutlet UILabel *rateHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *detailTblView;

@property (weak, nonatomic) IBOutlet UIView *rideOptionView;
@property (weak, nonatomic) IBOutlet UIView *completedOptionView;
@property (weak, nonatomic) IBOutlet UIButton *issueBtn;
@property (weak, nonatomic) IBOutlet UIButton *mailBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property(assign,nonatomic)NSInteger selectOptionStatus;
@property(assign,nonatomic)NSInteger errorCount;
@property(strong,nonatomic)NSString * favLocationId;
@property (weak, nonatomic) IBOutlet UIView *viewHelp;
@property (weak, nonatomic) IBOutlet UITableView *tableIssue;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (assign, nonatomic) NSInteger selectedReasonRow;
@property (strong, nonatomic) NSString *issueReasonTextStr;
@property (strong, nonatomic) NSString *issueReasonStr;
//@property (strong, nonatomic) NSString *ride_id;

- (IBAction)didClickSubmitBtn:(id)sender;

- (IBAction)didClickIssueBtn:(id)sender;
- (IBAction)didClickMailBtn:(id)sender;

@end
