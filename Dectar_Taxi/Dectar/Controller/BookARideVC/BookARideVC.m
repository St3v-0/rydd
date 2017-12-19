//
//  BookARideVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 16/07/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "BookARideVC.h"
#import "PopupVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import <UIKit/UIKit.h>
#import "Themes.h"
#import "UrlHandler.h"
#import "Search.h"
#import "BookingRecord.h"
#import "CarCtryCell.h"
#import "EstimationRecord.h"
#import "Constant.h"
#import "FavorVC.h"
#import "AddressRecord.h"
#import "AddFavrVC.h"
#import "DriverRecord.h"
#import "FareRecord.h"
#import "FareVC.h"
#import "RateCardViewVC.h"
#import "RatingVC.h"
#import "NewViewController.h"
#import "NewTrackVC.h"
#import "CopounVC.h"
#import "HelpVC.h"
#import "ATAppUpdater.h"
#import "DropVC.h"
#import "REFrostedViewController.h"
#import "LanguageHandler.h"
#import "AddCardVC.h"
#import <QuartzCore/QuartzCore.h>
#import "CardIOPaymentViewController.h"
#import "CardIO.h"

@interface BookARideVC ()<GMSMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UISearchBarDelegate,UITextFieldDelegate,TrackPageDelegate,CardIOPaymentViewControllerDelegate>
{
    NSIndexPath * selectedindex;
    NSString * pickUptime;
    NSString * pickupdate;
    UITextField *CouponTextField;
    FavourRecord *message;
    NSString * nameofcar;
    NSString * couponCode;
    UIAlertView *couponAlert;
    NSTimer*timingLoading;
    NSTimer*timingLoading2;
    NSMutableDictionary *SearchResponDict;
    NSMutableArray *SearchResultArray;
    int retrrycount ;
    UIAlertView*RetryAlert;
    UIAlertView * ConfrimAlertlater;
    NSString * ETAtimeTaking;
    BOOL isRetry;
    BOOL showinAlert;
    NSString * iswhichEstimate;
    NSString * Currency;
    JJLocationManager * jjLocManager;
    UIAlertView * addcardAlert;
    NSString *RequestTimeCount;
    NSInteger retryRequestCount;

    BOOL SearchAddress;
    NSString * search_address_str;
    NSString * RetryTimeStr;
    
     NSTimer*retryLoading;
     BOOL isRetrySucess;
    
    NSInteger popcount;

    
}
@property (weak, nonatomic) IBOutlet UIView *popupview;

@property(nonatomic,strong)NSTimer *connectionTimer;

@property (strong, nonatomic) IBOutlet UIView *RideView;
@property (strong, nonatomic) IBOutlet UIButton *rideLater_btn;
@property (strong, nonatomic) IBOutlet UIButton *rideNow_btn;

@property (nonatomic, strong) IBOutlet UIView * BGmapView;
@property (nonatomic, strong) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) GMSMapView * GoogleMap;
@property (strong, nonatomic) GMSCameraPosition * Camera;
@property (strong, nonatomic) IBOutlet UIButton *defaultAnno;
@property (strong, nonatomic) IBOutlet UITextField *AddressField;
@property (strong ,nonatomic) NSString * CarCategoryString;
@property  CLLocationCoordinate2D center;
@property (strong ,nonatomic) NSString * UserID;
@property (strong , nonatomic) NSMutableArray * categoryArray;
@property (strong ,nonatomic)BookingRecord * categaory;
@property (assign ,nonatomic) BOOL SearchControl;
@property(strong,nonatomic) NSString * ButtontypeStr;
@property (strong,nonatomic)NSString * DropAddressSrting;

@property (assign ,nonatomic) BOOL Favour;
@property (assign ,nonatomic) BOOL IsPickerView;
@property (assign ,nonatomic) BOOL isETAView;
@property (assign ,nonatomic) BOOL isChangingNetwork;



@property (strong ,nonatomic) NSArray * TimeArray;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong ,nonatomic) NSMutableDictionary * ResponseArray;
@property (strong ,nonatomic) UITapGestureRecognizer * tapges;
@property (strong,nonatomic) NSString * TimeString;
@property (strong,nonatomic) NSString * DateString;
@property (strong,nonatomic) NSString * DelayTimeStr;
@property (strong,nonatomic) NSString * DelayDateStr;

@property(strong ,nonatomic) EstimationRecord * estiamtion;
@property(strong ,nonatomic) AddressRecord * AddObj;
@property(strong,nonatomic) DriverRecord *Record_Driver;
@property (strong, nonatomic) IBOutlet BLMultiColorLoader *loadingView_View;
@property (strong, nonatomic) IBOutlet UILabel *timing_label;
@property (strong, nonatomic) IBOutlet UILabel *staticMinus_Lbl;

@property (strong, nonatomic) IBOutlet UIImageView *ConfirmPin;

@end

@implementation BookARideVC
@synthesize Camera,GoogleMap,BGmapView,addressString,AddressField,latitude,longitude,center,isLocationSelected,Annotation,CarCategoryString,UserID,categoryArray,categaory,ResponseArray,ButtontypeStr,SearchControl,locationBtn,DropAddressSrting,TimeString,DateString,droplatitude,droplongitude,estiamtion,EstimationDetailView,maxlable,minilable,attLable,dropLable,pickUplable,noteLable,RidelatePicker,pickerView,DelayTimeStr,DelayDateStr,infoPicktimeLable,EstiamtionCloseButton,LateInfoView,latecabtypeView,latePickUpView,lateEstiamteionView,lateRateView,lateCouponView,lateCabLable,lateCouponlbl,latePickUplbl,AddObj,isInitialButtonSelected,Favour,RideView,CouponCoudLable,isNoCabsButtonSelectedIndex,Record_Driver,TimeViewTiming,IsPickerView,selectedBtnIndex,isETAView,FavoriteBTN,RideNow_WalletAmount_lbl,RideLater_WalletAmount_lbl,isChangingNetwork,catgBookId,rightBtn,DriverStatusLbl,animatedLoadImageView,btnOk,btnCheck,lblAlert,lbl_description,view_popup;

@synthesize CtryViewCell;
@synthesize nameArray;
@synthesize TimeArray;
@synthesize DownView;
@synthesize CancelButton;
@synthesize ConfirmButton;
@synthesize InfoView;
@synthesize PickUptimeView;
@synthesize CategoryView;
@synthesize CouponView;
@synthesize EstimationView;
@synthesize RateCardView;
@synthesize pickupLable;
@synthesize CategoryLable;
@synthesize tapges;
@synthesize RateCardDetailView;
@synthesize RateCardCatLable;
@synthesize RateCardVechielLable;
@synthesize Minfare_text;
@synthesize MinFarelable;
@synthesize notelabel;
@synthesize Afterfare_text;
@synthesize AfterFareLable;
@synthesize waitingfare_text;
@synthesize WaitingfareLable;


- (void)viewDidLoad {
    
    retryRequestCount=0;
    
    SearchAddress=NO;
    view_popup.hidden=YES;
    [self restrictRotation:NO];
retrrycount = 1;
    [super viewDidLoad];
    if(jjLocManager==nil){
        jjLocManager=[JJLocationManager sharedManager];
        [[JJLocationManager sharedManager]updateLocationToServerManually];
    }
   // [_popupview addSubview:self.defaultAnno];
  
     [self loadBookrideUI];
    if([Themes getCategoryString]==nil||[[Themes getCategoryString]isEqualToString:@""]||jjLocManager.currentLocation.coordinate.latitude==0){
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdateToGetDatas) name:kLocationUpdate object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(locationUpdateToGetDatas)
                                                     name:@"moveToApp"
                                                   object:nil];
        
    }else{
        
         [self loadGoogleMap];
        [self LoadWholeView];
    }
    
    [self Padding:AddressField :@"home_search"];
    
    self.latePickCancelBtn.title=JJLocalizedString(@"Cancel", nil);
    self.latePickDoneBtn.title=JJLocalizedString(@"Done", nil);
    self.pickcancelBtn.title=JJLocalizedString(@"Cancel", nil);
    self.pickDoneBtn.title=JJLocalizedString(@"Done", nil);
    
    //[self.btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
   
  
    DriverStatusLbl.numberOfLines = 0;
    DriverStatusLbl.adjustsFontSizeToFitWidth = YES;
    DriverStatusLbl.lineBreakMode = NSLineBreakByClipping;
    
}
-(void)viewDidAppear:(BOOL)animated{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [animatedLoadImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    popcount = 1;
    
}

-(void)showcontpopup{
    
}

-(void)Padding:(UITextField *)Field :(NSString *)imagename{
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    imgView.image = [UIImage imageNamed:imagename];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, Field.frame.size.height)];
    imgView.center=paddingView.center;
    [paddingView addSubview:imgView];
    [Field setLeftViewMode:UITextFieldViewModeAlways];
    [Field setLeftView:paddingView];
    /*Field.layer.borderColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    Field.layer.borderWidth=0.8f;
    Field.layer.cornerRadius=5.0f;
    Field.layer.masksToBounds=YES;
    
    _btnMenu.layer.borderColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    _btnMenu.layer.borderWidth=0.8f;*/
    _btnMenu.layer.cornerRadius=3.0f;
    _btnMenu.layer.masksToBounds=NO;
    _btnMenu.layer.shadowOffset = CGSizeMake(0, 0.5);
    _btnMenu.layer.shadowRadius = 5.0;
    _btnMenu.layer.shadowOpacity = 0.5;

    
}

-(void)locationUpdateToGetDatas{
    CarCategoryString=[Themes getCategoryString];
    if(jjLocManager.currentLocation.coordinate.latitude!=0 && [Themes AppAllInfoDatas]){
        if(GoogleMap==nil){
            [self loadGoogleMap];
        }
        [self LoadWholeView];
    }
}


-(void)LoadWholeView{
   
    selectedBtnIndex=0;
    categoryArray=[[NSMutableArray alloc]init];
    estiamtion=[[EstimationRecord alloc]init];
    Record_Driver=[[DriverRecord alloc]init];
    AddObj =[[AddressRecord alloc]init];
    NSLog(@"%@",[Themes GetCoupon]);
   
    
    if ([Themes GetCoupon].length==0)
    {
        CouponCoudLable.text=JJLocalizedString(@"Apply_Coupon", nil) ;
        lateCouponlbl.text=JJLocalizedString(@"Apply_Coupon", nil);
        
    }
    else
    {
        CouponCoudLable.text=[Themes GetCoupon];
        lateCouponlbl.text=[Themes GetCoupon];
    }
    categoryArray=[NSMutableArray array];

     [_defaultAnno setImage:[UIImage imageNamed:@"pindrop"] forState:UIControlStateNormal];
    [self loadDriverStatus:NO withText:@"Pickup_Loc_Status"];
    
}

-(void)loadDriverStatus:(BOOL)availStatus withText:(NSString *)txt{
    rightBtn.hidden=availStatus;
   // DriverStatusLbl.hidden=availStatus;
    DriverStatusLbl.text=JJLocalizedString(txt, nil);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the    controller
    //
    [self.frostedViewController presentMenuViewController];
}
- (UIView*)putView:(UIView*)view insideShadowWithColor:(UIColor*)color andRadius:(CGFloat)shadowRadius andOffset:(CGSize)shadowOffset andOpacity:(CGFloat)shadowOpacity
{
    CGRect shadowFrame; // Modify this if needed
    shadowFrame.size.width = 0.f;
    shadowFrame.size.height = 0.f;
    shadowFrame.origin.x = 0.f;
    shadowFrame.origin.y = 0.f;
    UIView * shadow = [[UIView alloc] initWithFrame:shadowFrame];
    shadow.layer.shadowColor = color.CGColor;
    shadow.layer.shadowOffset = shadowOffset;
    shadow.layer.shadowRadius = shadowRadius;
    shadow.layer.masksToBounds = NO;
    shadow.clipsToBounds = NO;
    shadow.layer.shadowOpacity = shadowOpacity;
    [view.superview insertSubview:shadow belowSubview:view];
    shadow.userInteractionEnabled=YES;
    view.userInteractionEnabled=YES;
    [shadow addSubview:view];
    return shadow;
}

-(void)loadBookrideUI{
    UserID=[Themes getUserID];
    
    [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideNow_btn setUserInteractionEnabled:NO];
    
    [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideLater_btn setUserInteractionEnabled:NO];
    
    
//    _loadingView_View.frame=CGRectMake(_loadingView_View.frame.origin.x-05, _loadingView_View.frame.origin.y, _loadingView_View.frame.size.width, _loadingView_View.frame.size.width);
 //   _loadingView_View.lineWidth = 2.0;
    _multiLoadingViewControl.lineWidth = 2.0;
   // _loadingView_View.colorArray = [NSArray arrayWithObjects:BGCOLOR, nil];
      _multiLoadingViewControl.colorArray = [NSArray arrayWithObjects:BGCOLOR, nil];
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor colorWithRed:41.0/255.0 green:180.0/255.0 blue:219.0/255.0 alpha:1.0]];
    
    locationBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    locationBtn.layer.shadowOpacity = 0.5;
    locationBtn.layer.shadowRadius = 2;
    locationBtn.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    _defaultAnno.layer.shadowColor = [UIColor blackColor].CGColor;
    _defaultAnno.layer.shadowOpacity = 0.5;
    _defaultAnno.layer.shadowRadius = 2;
    _defaultAnno.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    [_AddressView setHidden:YES];
        AddressField.delegate=self;
    
    _Header_view.layer.cornerRadius=5.0f;
    _Header_view.layer.masksToBounds=NO;
    _Header_view.layer.shadowOffset = CGSizeMake(0, 0.5);
    _Header_view.layer.shadowRadius = 5;
    _Header_view.layer.shadowOpacity = 0.5;
    

   /*[self putView:_Header_view insideShadowWithColor:[UIColor blackColor] andRadius:5.0 andOffset:CGSizeMake(0, 0.5) andOpacity:0.5];
    _Header_view.layer.cornerRadius = 5.0;
    _Header_view.layer.masksToBounds = YES;*/
   
    
    _AddressView.layer.shadowColor = [UIColor blackColor].CGColor;
    _AddressView.layer.shadowOpacity = 0.5;
    _AddressView.layer.shadowRadius = 2;
    _AddressView.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    _DropField.layer.cornerRadius=5.0f;
    _DropField.layer.masksToBounds=YES;
    _DropField.layer.borderColor=[UIColor whiteColor].CGColor;
    _DropField.layer.borderWidth=1.0f;
    
    RateCardDetailView.layer.cornerRadius = 10;
    RateCardDetailView.layer.masksToBounds = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    DateString = [formatter stringFromDate:[NSDate date]];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    TimeString = [dateFormatter stringFromDate:now];
    
    RidelatePicker.minimumDate=[[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 3600 ];
   
    RidelatePicker.maximumDate=[[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval)3600*24*14];
    
    UITapGestureRecognizer * estimate=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(Estimate:)];
    estimate.numberOfTapsRequired = 1;
    [lateEstiamteionView addGestureRecognizer:estimate];
    
    UITapGestureRecognizer * NowEstimation=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(Estimate:)];
    NowEstimation.numberOfTapsRequired = 1;
    [EstimationView addGestureRecognizer:NowEstimation];
    

    
    UITapGestureRecognizer * Coupon=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(CallCoupon)];
    Coupon.numberOfTapsRequired = 1;
    [lateCouponView addGestureRecognizer:Coupon];
    
    UITapGestureRecognizer * currerntcoupon=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(CallCoupon)];
    currerntcoupon.numberOfTapsRequired = 1;
    [CouponView addGestureRecognizer:currerntcoupon];
    
   
    
    tapges = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(rate)] ;
    tapges.numberOfTapsRequired = 1;
    [lateRateView addGestureRecognizer:tapges];
    
    UITapGestureRecognizer * Nowrate = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(rate)] ;
    Nowrate.numberOfTapsRequired = 1;
    [RateCardView addGestureRecognizer:Nowrate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"PushView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushnotification:) name:@"pushnotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveTimer:) name:@"removeView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplyCoupoun:) name:@"CouponApplied" object:nil];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropAddressNotification:) name:@"DropFavourNotifiction" object:nil];
   
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewVc:) name:@"payment_paid" object:nil];
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"ride_completed" object:nil];
}



-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [AddressField setText:JJLocalizedString(@"Getting_Address", nil)];
    [lateCouponlbl setText:JJLocalizedString(@"Apply_Coupon", nil)];
    [CouponCoudLable setText:JJLocalizedString(@"Apply_Coupon", nil)];

    [_info_title_cabtype setText:JJLocalizedString(@"Cab_type", nil)];
    [_info_title_estimate setText:JJLocalizedString(@"Estimation", nil)];
    [_info_title_pickuptime setText:JJLocalizedString(@"Pick_up_time", nil)];
    [_info_title_rateCard setText:JJLocalizedString(@"Rate_card", nil)];
    
    _info_title_estimate.numberOfLines = 0;
    _info_title_estimate.adjustsFontSizeToFitWidth = YES;
    _info_title_estimate.lineBreakMode = NSLineBreakByClipping;
    
    
    [_late_title_cabtype setText:JJLocalizedString(@"Cab_type", nil)];
    [_late_title_estimate setText:JJLocalizedString(@"Estimation", nil)];
    [_late_title_pickuptime setText:JJLocalizedString(@"Pick_up_time", nil)];
    [_late_title_ratecard setText:JJLocalizedString(@"Rate_card", nil)];
    _late_title_estimate.numberOfLines = 0;
    _late_title_estimate.adjustsFontSizeToFitWidth = YES;
    _late_title_estimate.lineBreakMode = NSLineBreakByClipping;
    
    [_Header_confrimation_lbl setText:JJLocalizedString(@"Confirmation", nil)];
    [_PickUpAddress_label setText:JJLocalizedString(@"Pickup_location", nil)];
    [_DropField setPlaceholder:JJLocalizedString(@"Drop_location", nil)];
    
    [_eta_drop_hint setText:JJLocalizedString(@"Drop", nil)];
    [_eta_header_lbl setText:JJLocalizedString(@"Ride_Estimation", nil)];
   // [_eta_pickup_hinty setText:JJLocalizedString(@"Pickup", nil)];
   _eta_pickup_hinty.text=JJLocalizedString(@"Pick_up_Estimate", nil);
    [EstiamtionCloseButton setTitle:JJLocalizedString(@"ok", nil) forState:UIControlStateNormal];
    
    [_rideLater_btn setTitle:JJLocalizedString(@"RIDE_LATER", nil) forState:UIControlStateNormal];
    [_rideNow_btn setTitle:JJLocalizedString(@"RIDE_NOW", nil) forState:UIControlStateNormal];
    [CancelButton setTitle:JJLocalizedString(@"CANCEL_Caps", nil) forState:UIControlStateNormal];
    [ConfirmButton setTitle:JJLocalizedString(@"CONFIRM", nil) forState:UIControlStateNormal];
    
    NSString * YourWallet=JJLocalizedString(@"Your_wallet_money", nil);
    RideNow_WalletAmount_lbl.text=[NSString stringWithFormat:@"%@ %@",YourWallet,[Themes GetFullWallet]];
}


-(void)loadGoogleMap{
      CarCategoryString=[Themes getCategoryString];
    if(TARGET_IPHONE_SIMULATOR)
    {
        Camera = [GMSCameraPosition cameraWithLatitude:jjLocManager.currentLocation.coordinate.latitude
                                             longitude:jjLocManager.currentLocation.coordinate.longitude
                                                  zoom:15];
    }else{
        Camera = [GMSCameraPosition cameraWithLatitude:jjLocManager.currentLocation.coordinate.latitude
                                             longitude:jjLocManager.currentLocation.coordinate.longitude
                                                  zoom:15];
    }
   
    latitude =jjLocManager.currentLocation.coordinate.latitude;
    longitude =jjLocManager.currentLocation.coordinate.longitude;
    Camera = [GMSCameraPosition cameraWithLatitude: jjLocManager.currentLocation.coordinate.latitude
                                         longitude: jjLocManager.currentLocation.coordinate.longitude
                                              zoom:17];
    GoogleMap = [GMSMapView mapWithFrame:BGmapView.frame camera:Camera];
    
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
   
    
    
    self.isLoadSingleTime=YES;
    CGRect mapFrame=GoogleMap.frame;
    mapFrame.origin.y=0;
    GoogleMap.frame=mapFrame;
    GoogleMap.delegate = self;
    [BGmapView addSubview:GoogleMap];
    //[BGmapView addSubview:_defaultAnno];
    GoogleMap.myLocationEnabled = YES;
    GoogleMap.userInteractionEnabled=YES;
    BGmapView.userInteractionEnabled=YES;
    GoogleMap.settings.allowScrollGesturesDuringRotateOrZoom = NO;
    GoogleMap.settings.rotateGestures=NO;

    [self updateUserLocation];
}



- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)enteredForeground{
    if(self.view.window){
        [[ATAppUpdater sharedUpdater] showUpdateWithForce];
    }
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[ATAppUpdater sharedUpdater] showUpdateWithForce];
    ConfirmButton.enabled=YES;
  
    if(jjLocManager.currentLocation.coordinate.latitude!=0){
        if(self.islocUpdatedInitially==YES){
            self.islocUpdatedInitially=NO;
              [self updateUserLocation];
        }
      
    }
    _connectionTimer = [NSTimer scheduledTimerWithTimeInterval: 50
                                                        target: self
                                                      selector: @selector(refreshLocation)
                                                      userInfo: nil
                                                       repeats: YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
      [animatedLoadImageView.layer removeAnimationForKey:@"transform.rotation.z"];
    [_connectionTimer invalidate];
    _connectionTimer=nil;
     [Themes StopView:self.view];
}


-(void)refreshLocation{
    
    
    @try {
        [self CheckHomepage];
       
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in checkConnectionTimer..");
    }

}

-(void)CheckHomepage
{
    
    [self mapView:GoogleMap idleAtCameraPosition:GoogleMap.camera];

}

-(void)ApplyCoupoun:(NSNotification *)notification

{
    if ([Themes GetCoupon].length>0)
    {
        CouponCoudLable.text=[Themes GetCoupon];
        lateCouponlbl.text=[Themes GetCoupon];
    }
    else{
        CouponCoudLable.text=JJLocalizedString(@"Apply_Coupon", nil) ;
        lateCouponlbl.text=JJLocalizedString(@"Apply_Coupon", nil) ;
    }
}
- (void) RemoveTimer:(NSNotification *)notification
{
    retryRequestCount=0;
    [retryLoading invalidate];
    retryLoading=nil;
    
    [self view:InfoView boolen:YES];
    [self view:FavoriteBTN boolen:YES];
    [self view:CancelButton boolen:YES];
    [self view:ConfirmButton boolen:YES];
    [self view:AddressField boolen:YES];
    [self view:_btnMenu boolen:YES];
    [self view:_HeaderConfirmation_View boolen:YES];
     [self view:_DropField boolen:YES];
    [timingLoading2 invalidate];
    [timingLoading invalidate];
    
}

/*- (void) notification:(NSNotification *)notification
 {
 if ([notification.object isKindOfClass:[FareRecord class]])
 {
 

 NewViewController * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"NewFareVCID"];
 FareRecord*Rec=(FareRecord*)notification.object;
 Rec=[notification object];
 [addfavour setObjRc:Rec];
 [self presentViewController:addfavour animated:YES completion:nil];
 }
 
 }
 */
//- (void) reviewVc:(NSNotification *)notification
//{
//    if ([notification.object isKindOfClass:[FareRecord class]])
//    {
//        //if(self.view.window){
//        RatingVC *objRatingVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
//        FareRecord*Rec=(FareRecord*)notification.object;
//        [objRatingVC setRideID_Rating :Rec.ride_id];
//        [self.navigationController pushViewController:objRatingVC animated:YES];
//        //}
//        
//    }
//}

-(void)dropAddressNotification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[FavourRecord class]])
    {
    message = [notification object];
    droplatitude=message.latitudeStr;
    droplongitude=message.longitude;
    _DropField.text=message.Address;
    }
}

- (void) incomingNotification:(NSNotification *)notification{
    
    if ([notification.object isKindOfClass:[FavourRecord class]])
    {
        message = [notification object];
        latitude=message.latitudeStr;
        longitude=message.longitude;
        AddressField.text=message.Address;
        selectedBtnIndex=0;
        Favour=YES;
        Camera = [GMSCameraPosition cameraWithLatitude: latitude
                                             longitude: longitude
                                                  zoom:17];
        [GoogleMap animateToCameraPosition:Camera];
        
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [nameArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CarCtryCell *cell = (CarCtryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if([nameArray count]>0){
        BookingRecord *objRecord=(BookingRecord*)[nameArray objectAtIndex:indexPath.row];
        
        [cell setDelegate:self];
        [cell setSelectiveIndexpath:indexPath];
        [cell setDatasToCategoryCell:objRecord];
        
    }
    
    return cell;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // Add inset to the collection view if there are not enough cells to fill the width.
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.width;
    NSInteger cellCount = [collectionView numberOfItemsInSection:section];
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + cellSpacing))) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(0.0, inset, 0.0, 0.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getCurrentLocation:(id)sender
{
    
    CLLocation *location = GoogleMap.myLocation;
    if (location) {
        CLLocationCoordinate2D myCoordinate = GoogleMap.myLocation.coordinate;
        latitude=myCoordinate.latitude;
        longitude=myCoordinate.longitude;
        
        [GoogleMap animateToLocation:location.coordinate];
        [GoogleMap animateToZoom:15.0];
        GoogleMap.padding = UIEdgeInsetsMake(64, 0, 64, 0);
        
        [Themes StopView:self.view];
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    DropVC *objDropVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DropVCID"];
    if (textField==AddressField)
    {
        [objDropVC setIsFromPickUp:YES];
    }
    else if (textField==_DropField)
    {
        [objDropVC setIsFromDestination:YES];
        
    }
    
    objDropVC.delegate=self;
    [self.navigationController pushViewController:objDropVC animated:YES];
    }
    
    //objDropVC.delegate=self;
    //[self.navigationController pushViewController:objDropVC animated:YES];
    


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    self.isMoveStarted=YES;
    if (Favour==YES)
    {
        AddressField.text=message.Address;
      //  _DropField.text=message.Address;
        [self GetHomePages:selectedBtnIndex];
    }
    else if (Favour==NO)
    {
        [AddressField resignFirstResponder];
        if(isLocationSelected==NO){
            AddressField.placeholder=JJLocalizedString(@"Getting_Address", nil);
        }
        
        latitude=mapView.camera.target.latitude;
        longitude=mapView.camera.target.longitude;
        [self getGoogleAdrressFromLatLong:latitude lon:longitude];
    }
    Favour=NO;
}


-(void)ifNoAddress{
    AddressField.placeholder =JJLocalizedString(@"Sorry_we_couldnt_fetch", nil);
    
    [CtryViewCell setHidden:YES];
    [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideNow_btn setUserInteractionEnabled:NO];
    
    [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideLater_btn setUserInteractionEnabled:NO];
    [_defaultAnno setUserInteractionEnabled:NO];
}
-(void)isHaveAddress:(NSString *)addStr{
    
    if (SearchAddress==YES) {
        AddressField.text = search_address_str;
        SearchAddress=NO;
    }
    else{
    
    
    AddressField.text=[Themes checkNullValue:addStr];
    }
    [CtryViewCell setHidden:NO];
    [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rideNow_btn setUserInteractionEnabled:YES];
    
    [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rideLater_btn setUserInteractionEnabled:YES];
    [_defaultAnno setUserInteractionEnabled:YES];
    
    isLocationSelected=NO;
    nameArray=[NSMutableArray new];
    [nameArray removeAllObjects];
    if(self.isMoveStarted==YES){
    [self GetHomePages:selectedBtnIndex];
    }
    [Themes StopView:self.view];
    
}





- (NSRange)fullRange
{
    return (NSRange){0, [addressString length]};
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField==AddressField)
    {
        if(range.location==0&&[string isEqualToString:@","]){
            return NO;
        }
    }
    
    return YES;
}

#pragma Address From Lat And Lng


-(void)getGoogleAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParametersForAddr:lat withLon:lon]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             NSArray* jsonResults = [[responseDictionary valueForKey:@"results"]valueForKey:@"formatted_address"];
             if([jsonResults count]>0){
                 NSString * str;
                  str=[Themes checkNullValue: [jsonResults objectAtIndex:0]];
                 if(str.length==0){
                     [self ifNoAddress];
                 }else{
                     [self isHaveAddress:str];
                 }
                 
             }else{
                 [self Toast:@"cant_find_address"];
                 [self ifNoAddress];
             }
         }
         @catch (NSException *exception) {
             
         }
         
        
     }
                           failure:^(NSError *error)
     {
         [self Toast:@"cant_find_address"];
          [self ifNoAddress];
         
     }];
    
}

-(NSDictionary *)setParametersForAddr:(float )lat withLon:(float)lon{
    
    NSDictionary *dictForuser = @{
                                  @"latlng":[NSString stringWithFormat:@"%f,%f",lat,lon],
                                  @"sensor":@"false",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}
/*-(void)latitude:(CGFloat )lat longitude:(CGFloat )lng
 {
 [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(lat, lng) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
 
 GMSAddress * address=[response firstResult];
 NSString * temp1=[address.lines objectAtIndex:0];
 NSString *temp2=[address.lines objectAtIndex:1];
 //NSString * final=[NSString stringWithFormat:@"%@, %@", temp1 ,temp2];
 
 NSString *undesired = @"(null),(null)";
 NSString *desired   = @"";
 
 addressString=[NSString stringWithFormat:@"%@,%@",temp1,temp2];
 
 if ([addressString isEqualToString:@"(null),(null)"])
 {
 AddressField.text=@"Getting Address..";
 }
 
 else
 {
 
 AddressField.text = [addressString stringByReplacingOccurrencesOfString:undesired
 withString:desired];
 AddressField.text = addressString;
 }
 }];
 
 
 }*/

//Anand
-(void)getGoogleAdrressFromStr:(NSString *)addrStr{
    

    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParametersToaddr:addrStr]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             NSArray* jsonResults = [responseDictionary valueForKey:@"results"][0][@"geometry"][@"location"];
             if([jsonResults count]>0){
                 double latitude1 = 0, longitude1 = 0;
                 
                 latitude1 = [[jsonResults valueForKey:@"lat"] doubleValue];
                 longitude1 = [[jsonResults valueForKey:@"lng"] doubleValue];
                 
                 
                 
                 
                 NSArray *results = (NSArray *) responseDictionary[@"results"];
                 
                 if ([results count]>0)
                 {
                     
                     if (SearchControl==YES)
                     {
                         center.latitude = latitude1;
                         center.longitude = longitude1;
                         
                         [GoogleMap animateToLocation:CLLocationCoordinate2DMake(center.latitude, center.longitude)];
                         [GoogleMap animateToZoom:14.0];
                         isLocationSelected=YES;
                         
                         latitude=latitude1;
                         longitude=longitude1;
                         
                         
                         [Themes StopView:self.view];
                         SearchControl=NO;
                         
                     }
                     
                     else if (SearchControl==NO)
                     {
                         
                         //japahar
                                         droplatitude=latitude1;
                                         droplongitude=longitude1;
                         [self dataEstiamtion];

                     }
                 }
                 else
                 {
                     //Anand
                     //                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Cabily" message:@"" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                     //                 [alert show];
                     
                     [self Toast:@"Cant_fetch_Address"];
                 }
                 
                 
                 
             }else{
                 [self Toast:@"Cant_fetch_Address"];
             }
         }
         @catch (NSException *exception) {
             
         }
        
         
        
     }
                           failure:^(NSError *error)
     {
         
         [self Toast:@"Cant_fetch_Address"];
         [Themes StopView:self.view];
         
         
     }];
 }


-(NSDictionary *)setParametersToaddr:(NSString *)addr{
    
    NSDictionary *dictForuser = @{
                                  @"address":addr,
                                  @"sensor":@"false",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}






-(void)updateUserLocation
{
    
    NSString*latitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*longitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSDictionary * parameters=@{@"user_id":UserID,
                                @"latitude":latitudeStr,
                                @"longitude":longitudeStr};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
     [web GetGoeUpate:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         if ([responseDictionary count]>0)
         {
             [RideView setBackgroundColor:BGCOLOR];
             [RideView setUserInteractionEnabled:YES];
             responseDictionary=[Themes writableValue:responseDictionary];
             
             NSString * comfiramtion=[Themes checkNullValue:[responseDictionary valueForKey:@"status"]];
         
             [Themes StopView:self.view];
             if ([comfiramtion isEqualToString:@"1"])
             {
                
                 [Themes StopView:self.view];
                 
                 [Themes SaveWallet:[Themes checkNullValue:[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"wallet_amount"]]]];
                 CarCategoryString=[Themes checkNullValue:[Themes checkNullValue:[responseDictionary valueForKey:@"category_id"]]];
                 
                 Currency=[Themes checkNullValue:[responseDictionary valueForKey:@"currency"]];
                 Currency=[Themes findCurrencySymbolByCode:Currency];
                 [Themes SaveFullWallet:[NSString stringWithFormat:@"%@%@",Currency,[Themes GetWallet]]];
                 
                 
                 
             }
             else
             {
                  [self Toast:[Themes checkNullValue:[responseDictionary objectForKey:@"message"]]];
                 
                 [Themes StopView:self.view];
                 
             }
             
         }
         
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         [RideView setBackgroundColor:[UIColor lightGrayColor]];
         [RideView setUserInteractionEnabled:NO];
         [_defaultAnno setUserInteractionEnabled:NO];
     }];
    
}
#pragma  mark --- CategoryButton action

-(void)buttonWasPressed:(NSIndexPath *)SelectedIndexPath
{
    isInitialButtonSelected=YES;
    if([nameArray count]>0){
        BookingRecord * objBookingRecord=[nameArray objectAtIndex:SelectedIndexPath.row];
        CarCategoryString=objBookingRecord.categoryID;
        selectedBtnIndex=SelectedIndexPath.row;
        [GoogleMap animateToZoom:15.0];
        [Themes StartView:self.view];
       
        [self GetHomePages:SelectedIndexPath.row];
    }
}
#pragma  mark --- Timer

-(void)timerBlock
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Timer called");
    });
}
#pragma  mark --- GetHomePages

-(void)GetHomePages:(NSInteger)index
{
 
    CtryViewCell.userInteractionEnabled=NO;
    [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideNow_btn setUserInteractionEnabled:NO];
    
    [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rideLater_btn setUserInteractionEnabled:NO];
    
   
    
    
    [_defaultAnno setUserInteractionEnabled:NO];

    [Themes StopView:self.view];
    
    NSString*latitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*longitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    
    NSDictionary * parameters=@{@"user_id":UserID,
                                @"lat":latitudeStr,
                                @"lon":longitudeStr,
                                @"category":CarCategoryString};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    if(DownView.hidden==NO){
        [Themes StartView:self.view];
    }
    //[Themes StartView:self.view];
  //  [_loadingView_View startAnimation];
    [_multiLoadingViewControl startAnimation];
      animatedLoadImageView.hidden=YES;
    [_timing_label setHidden:YES];
    [_staticMinus_Lbl setHidden:YES];
    nameArray=[[NSMutableArray alloc]init];
    
    [web GetMapView:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [_rideNow_btn setUserInteractionEnabled:YES];
         
         [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [_rideLater_btn setUserInteractionEnabled:YES];
         
         if([responseDictionary count]==0 || responseDictionary==nil)
         {
             
             
             [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [_rideNow_btn setUserInteractionEnabled:NO];
             
             [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [_rideLater_btn setUserInteractionEnabled:NO];
             [_defaultAnno setUserInteractionEnabled:NO];
             [_defaultAnno setUserInteractionEnabled:NO];

             [Themes StopView:self.view];
             
         }
         else
         {
             [_defaultAnno setUserInteractionEnabled:YES];

             ResponseArray=[[NSMutableDictionary alloc]initWithDictionary:responseDictionary];
             //NSLog(@"%@",responseDictionary);
             responseDictionary=[Themes writableValue:responseDictionary];
             [Themes StopView:self.view];
             
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             NSString * alert=[responseDictionary valueForKey:@"response"];
             [Themes StopView:self.view];
         //    [_loadingView_View stopAnimation];
             [_multiLoadingViewControl stopAnimation];
             if ([comfiramtion isEqualToString:@"1"])
             {
                 [CtryViewCell setHidden:NO];
                 
                 [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 [_rideNow_btn setUserInteractionEnabled:YES];
                 
                 [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 [_rideLater_btn setUserInteractionEnabled:YES];
                 [_defaultAnno setUserInteractionEnabled:YES];
                 
                 if([nameArray count]!=0)
                 {
                     [nameArray removeAllObjects];
                 }
                 //Anand
//                 else
//                 {
                     for (NSDictionary * objCatDict in responseDictionary[@"response"][@"category"]) {

                         
                         categaory=[[BookingRecord alloc]init];
                         categaory.categoryID=[objCatDict valueForKey:@"id"];
                         categaory.categoryETA=[objCatDict valueForKey:@"eta"];
                         categaory.categoryName=[objCatDict valueForKey:@"name"];
                            categaory.etaTimeDigit=[objCatDict valueForKey:@"eta_time"];
                         categaory.Normal_image=[objCatDict valueForKey:@"icon_normal"];
                         categaory.Active_Image=[objCatDict valueForKey:@"icon_active"];
                         categaory.icon_car_image=[objCatDict valueForKey:@"icon_car_image"];
                         categaory.isSelected=NO;
                         [nameArray addObject:categaory];
                         
                         
                         
                         //   }
                     }
                     
//                 }
                 
                 categaory.currency=[[ResponseArray valueForKey:@"response"] valueForKey:@"currency"];
                 categaory.show_popup=[[ResponseArray valueForKey:@"response"] valueForKey:@"show_popup"];
                 categaory.popup_content=[[ResponseArray valueForKey:@"response"]valueForKey:@"popup_content"];
                 if ([categaory.show_popup isEqualToString:@"1"] && popcount ==1) {
                     
                     popcount++;
                     PopupVC *popupvc=[self.storyboard instantiateViewControllerWithIdentifier:@"popupVC"];
                     [popupvc setBookingRec:categaory];
                  
                     if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
                     {
                         //For iOS 8
                         popupvc.providesPresentationContextTransitionStyle = YES;
                         popupvc.definesPresentationContext = YES;
                         popupvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                     }
                     else
                     {
                         //For iOS 7
                         popupvc.modalPresentationStyle = UIModalPresentationCurrentContext;
                     }
                     [self presentViewController:popupvc animated:NO completion:nil];

                 }
                 
                 NSDictionary * rateCard=[[ResponseArray valueForKey:@"response"] valueForKey:@"ratecard"];
                 NSString *selectCategory=[[ResponseArray valueForKey:@"response"] valueForKey:@"selected_category"];
                 if ([rateCard count]>0)
                 {
                     categaory.note=[rateCard valueForKey:@"note"];
                     
                     NSDictionary * FareDict=[rateCard valueForKey:@"farebreakup"];
                     if ([FareDict count]>0)
                     {
                         categaory.vehicletypes=[FareDict valueForKey:@"vehicletypes"];
                         categaory.amountafter_fare=[[FareDict valueForKey:@"after_fare"]valueForKey:@"amount"];
                         categaory.after_fare_text=[[FareDict valueForKey:@"after_fare"]valueForKey:@"text"];
                         categaory.amountmin_fare=[[FareDict valueForKey:@"min_fare"]valueForKey:@"amount"];
                         categaory.min_fare_text=[[FareDict valueForKey:@"min_fare"]valueForKey:@"text"];
                         categaory.amountother_fare=[[FareDict valueForKey:@"other_fare"]valueForKey:@"amount"];
                         categaory.other_fare_text=[[FareDict valueForKey:@"other_fare"]valueForKey:@"text"];
                         categaory.categorySubName=[FareDict valueForKey:@"category"];
                     }
                     
                 }
                 
                 Currency=[Themes findCurrencySymbolByCode:categaory.currency];
                 [Themes SaveCurrency:Currency];
                 
                 if([nameArray count]>0){
                     for (int i=0; i<[nameArray count]; i++) {
                         BookingRecord * objBookingRecord=[nameArray objectAtIndex:i];
                         if([selectCategory isEqualToString:objBookingRecord.categoryID])
                       {
                           selectedBtnIndex=i;
                        
                             objBookingRecord.isSelected=YES;
                             nameofcar=objBookingRecord.categoryName;
                             CarCategoryString=objBookingRecord.categoryID;
                             ETAtimeTaking=objBookingRecord.categoryETA;
                              NSString * FromNow=JJLocalizedString(@"from_now", nil);
                             infoPicktimeLable.text=[NSString stringWithFormat:@"%@ %@",ETAtimeTaking,FromNow];
                             CategoryLable.text=nameofcar;
                             [_timing_label setHidden:NO];
                             [_staticMinus_Lbl setHidden:NO];
                             
                             NSString * etaTimeDigit=[Themes checkNullValue:objBookingRecord.etaTimeDigit];
                             if(etaTimeDigit.length>0){
                                 NSInteger etaDigit=[etaTimeDigit integerValue];
                                 NSString * concatStr=@"";
                                 if (etaDigit <=1) {
                                     concatStr=JJLocalizedString(@"minute", nil);
                                 }else{
                                     concatStr=JJLocalizedString(@"minutes", nil);
                                 }
                                    [_timing_label setText:[NSString stringWithFormat:@"%@\n%@",objBookingRecord.etaTimeDigit,concatStr]];
                             }else{
                                   [_timing_label setText:[Themes checkNullValue:objBookingRecord.etaTimeDigit]];
                             }
                         }
                         else
                         {
                             objBookingRecord.isSelected=NO;
                             
                         }
                         
                         [nameArray setObject:objBookingRecord atIndexedSubscript:i];
                     }
                 }
                 
                 if ([nameArray count]<=0)
                 {
                   
                     [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                     [_rideNow_btn setUserInteractionEnabled:NO];
                     
                     [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [_rideLater_btn setUserInteractionEnabled:YES];
                     [_defaultAnno setUserInteractionEnabled:NO];
                     
                     [CtryViewCell setHidden:YES];
                     [Themes StopView:self.view];
                     
                   //  [_loadingView_View stopAnimation];
                     [_multiLoadingViewControl stopAnimation];
                     
                 }
                 else
                 {
                     [CtryViewCell setHidden:NO];
                     
                     
                     [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [_rideNow_btn setUserInteractionEnabled:YES];
                     
                     [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [_rideLater_btn setUserInteractionEnabled:YES];
                     [_defaultAnno setUserInteractionEnabled:YES];
                   
                    // ConfirmButton.userInteractionEnabled=YES;
                     [self AddAndRemooveAnnotation:nameArray SelectedIndex:selectedBtnIndex];
                     [CtryViewCell reloadData];
                 }
             }
             
             else
             {
                   [GoogleMap clear];
                 [CtryViewCell setHidden:YES];
                 [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                 [_rideNow_btn setUserInteractionEnabled:NO];
                 [_defaultAnno setUserInteractionEnabled:NO];
                 [_rideLater_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                 [_rideLater_btn setUserInteractionEnabled:NO];
                
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:nil message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                 [Alert show];

                 //[self.view makeToast:[Themes checkNullValue:alert]];
                 CtryViewCell.hidden=YES;
             }
         }
           CtryViewCell.userInteractionEnabled=YES;
          [Themes StopView:self.view];
            self.islocUpdatedInitially=YES;
     }
     
            failure:^(NSError *error)
     {
         [Themes StopView:self.view];
      //   [_loadingView_View stopAnimation];
         [_multiLoadingViewControl stopAnimation];
           animatedLoadImageView.hidden=NO;
           CtryViewCell.userInteractionEnabled=YES;
     }];
    
    
}
#pragma  mark --- AddAndRemooveAnnotation

-(void)AddAndRemooveAnnotation:(NSMutableArray*)objRecArray SelectedIndex:(NSInteger) Indexpath
{
    NSMutableArray *aray =[[ResponseArray valueForKey:@"response"] valueForKey:@"drivers"];
    
    if ([aray count]>0) {
        [CtryViewCell setHidden:NO];
        [_rideNow_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rideNow_btn setUserInteractionEnabled:YES];
        
        [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rideLater_btn setUserInteractionEnabled:YES];
        
        [_defaultAnno setImage:[UIImage imageNamed:@"pindrop"] forState:UIControlStateNormal];
        [self loadDriverStatus:NO withText:@"Pickup_Loc_Status"];
        animatedLoadImageView.hidden=NO;
        [_loadingView_View setHidden:NO];
        [_timing_label setHidden:NO];
        [_staticMinus_Lbl setHidden:NO];
        [_defaultAnno setUserInteractionEnabled:YES];
        NSString * result = [aray componentsJoinedByString:@""];
        
        [GoogleMap clear];
        if ([result isEqualToString:@""])
        {
            
            
        }
        for(int i=0;i<[aray count];i++){
                BookingRecord *ObjRec=[objRecArray objectAtIndex:Indexpath];
            NSDictionary *dict=(NSDictionary *)[aray objectAtIndex:i];
            double la=[[dict objectForKey:@"lat"] doubleValue];
            double lo=[[dict objectForKey:@"lon"] doubleValue];
            
            CLLocation * loca=[[CLLocation alloc]initWithLatitude:la longitude:lo];
            CLLocationCoordinate2D coordi=loca.coordinate;
            
            GMSMarker*marker=[[GMSMarker alloc]init];
            marker=[GMSMarker markerWithPosition:coordi];
            marker.map = GoogleMap;
            marker.appearAnimation=kGMSMarkerAnimationPop;
            
            UIImageView *Image_view=[[UIImageView alloc] init];
            
            [Image_view sd_setImageWithURL:[NSURL URLWithString:ObjRec.icon_car_image] placeholderImage:[UIImage imageNamed:@"PrimCab"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                marker.icon = Image_view.image;
                
                
            }];
            
            marker.icon = Image_view.image;
            
            
            [CtryViewCell reloadData];
            
        }
        [ConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ConfirmButton setUserInteractionEnabled:YES];
        ConfirmButton.enabled=YES;
       
    }
    else
    {
        [CtryViewCell setHidden:NO];
        [_rideNow_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_rideNow_btn setUserInteractionEnabled:NO];
        
        [_rideLater_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rideLater_btn setUserInteractionEnabled:YES];
        
        [_defaultAnno setImage:[UIImage imageNamed:@"pindrop"] forState:UIControlStateNormal];
        [self loadDriverStatus:YES withText:@"NO_Cars_Avail"];
         infoPicktimeLable.text=[NSString stringWithFormat:@"%@",ETAtimeTaking];
        
        [_loadingView_View setHidden:NO];
        [_timing_label setHidden:YES];
        [_staticMinus_Lbl setHidden:YES];
        [_defaultAnno setUserInteractionEnabled:NO];
        
        [GoogleMap clear];
        if(LateInfoView.hidden==YES){
            [ConfirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [ConfirmButton setUserInteractionEnabled:NO];
            ConfirmButton.enabled=NO;
        }else{
            [ConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [ConfirmButton setUserInteractionEnabled:YES];
            ConfirmButton.enabled=YES;
        }
        
    }
}


#pragma  mark --- ViewAnimation

-(void)ViewShowing:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromTop ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}
-(void)ViewHidding:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromBottom ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

#pragma  mark --- RideNow
- (IBAction)Anno_Action:(id)sender {
    UIButton *btnAuthOptions=(UIButton*)sender;
    btnAuthOptions.tag=2;
    [_PickUpAddress_label setText:AddressField.text];
    [self RideNow:sender];
}


-(IBAction)RideNow:(id)sender
{
    if (![AddressField.text isEqualToString:@""])
    {
        UIButton *btnAuthOptions=(UIButton*)sender;
        if (btnAuthOptions.tag==1)//LAter
        {
            [_defaultAnno setUserInteractionEnabled:NO];
            [_loadingView_View setHidden:YES];
            [_defaultAnno setHidden:YES];
              [_popupview setHidden:YES];
            [_ConfirmPin setHidden:NO];
            [_AddressView setHidden:NO];
            
            [_PickUpAddress_label setText:AddressField.text];
            
            [_Header_view setHidden:YES];
            [_HeaderConfirmation_View setHidden:NO];
          //  [_DropField setText:@""];
            ButtontypeStr=@"1";
            IsPickerView=YES;
            isETAView=YES;
            AddressField.enabled=NO;
            GoogleMap.userInteractionEnabled=NO;
            BGmapView.userInteractionEnabled=NO;
            locationBtn.hidden=YES;
            pickerView.hidden=NO;
        //    FavoriteBTN.userInteractionEnabled=NO;
            
            //}
            
        }
        
        else if (btnAuthOptions.tag==2) { //NOW
            if([nameArray count]>0){
            
            [_defaultAnno setUserInteractionEnabled:NO];
            [_loadingView_View setHidden:YES];
            [_defaultAnno setHidden:YES];
                    [_popupview setHidden:YES];
            [_ConfirmPin setHidden:NO];
            [_AddressView setHidden:NO];
            [_PickUpAddress_label setText:AddressField.text];
              //  [_DropField setText:@""];

            
            [_Header_view setHidden:YES];
            [_HeaderConfirmation_View setHidden:NO];
            
            ButtontypeStr=@"0";
            CtryViewCell.hidden=YES;
            DownView.hidden=NO;
            AddressField.enabled=NO;
            [AddressField setTextColor:[UIColor lightGrayColor]];
            GoogleMap.userInteractionEnabled=NO;
            BGmapView.userInteractionEnabled=NO;
            locationBtn.hidden=YES;
            isETAView=NO;
            InfoView.hidden=NO;
            NSString * YourWallet=JJLocalizedString(@"Your_wallet_money", nil);
                
            RideNow_WalletAmount_lbl.text=[NSString stringWithFormat:@"%@ %@",YourWallet,[Themes GetFullWallet]];
            
            
            [UIView animateWithDuration:0.50 animations:^{
                InfoView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
                NSString * FromNow=JJLocalizedString(@"from_now", nil);

                infoPicktimeLable.text=[NSString stringWithFormat:@"%@ %@",ETAtimeTaking,FromNow];
                CategoryLable.text=nameofcar;
                
                
            }];
           // FavoriteBTN.userInteractionEnabled=NO;
            
        }
        }
        
        
    }
    else
    {
        [self Toast:@"We_are_fetching_your"];
    }
    
}
#pragma  mark --- LateinfoView Pickerdate change

-(IBAction)latepickerDate:(id)sender
{
    ButtontypeStr=@"1";
    
    AddressField.enabled=NO;
    GoogleMap.userInteractionEnabled=NO;
    BGmapView.userInteractionEnabled=NO;
    locationBtn.hidden=YES;
    LateInfoView.hidden=YES;
    IsPickerView=NO;
    pickerView.hidden=NO;
}
#pragma  mark --- LateinfoView name change

-(IBAction)lateCategoryName:(id)sender
{
    UIButton * btn=(UIButton *)sender;
    if([btn isEqual:self.cabTypebtn]){
//        BookingRecord * objBookingRecord=[nameArray objectAtIndex:SelectedIndexPath.row];
//        CarCategoryString=objBookingRecord.categoryID;
//        selectedBtnIndex=SelectedIndexPath.row;
//        [GoogleMap animateToZoom:15.0];
//        [Themes StartView:self.view];
//        
//        [self GetHomePages:SelectedIndexPath.row];
        self.isChangeRideNowCategory=YES;
        [ConfirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [ConfirmButton setUserInteractionEnabled:NO];
       
    }
    AddressField.enabled=NO;
    GoogleMap.userInteractionEnabled=NO;
    BGmapView.userInteractionEnabled=NO;
    locationBtn.hidden=YES;
    LateInfoView.hidden=YES;
    _latepicker.delegate=self;
    _latepicker.dataSource=self;
    _latepickerView.hidden=NO;
 
}
#pragma  mark --- UIPickerview Datasource
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [nameArray count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BookingRecord *object;
    if ([nameArray count]>0) {
        object=(BookingRecord*)[nameArray objectAtIndex:row];
        return object.categoryName;
    }
       return [Themes checkNullValue:object.categoryName];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row<[nameArray count]){
        BookingRecord *object=(BookingRecord*)[nameArray objectAtIndex:row];
        _latepicker.showsSelectionIndicator=YES;
        nameofcar=object.categoryName;
        CarCategoryString=object.categoryID;
        selectedBtnIndex=[_latepicker selectedRowInComponent:0];
    }
   
}
#pragma  mark --- Header Cancel

- (IBAction)backfrom_action:(id)sender {
    [Themes SaveCoupon:@""];
    [Themes SaveCouponDetails:@""];
    UIButton *btnAuthOptions=(UIButton*)sender;
    btnAuthOptions.tag=1;
    
    [_defaultAnno setUserInteractionEnabled:YES];
    [_loadingView_View setHidden:NO];
    [_defaultAnno setHidden:NO];
      [_popupview setHidden:NO];
    //[_ConfirmPin setHidden:YES];
    [_ConfirmPin setHidden:NO];
    
    [self Confimation:sender];
    //[self PickerAction:sender];
    [_defaultAnno setUserInteractionEnabled:YES];
    [_loadingView_View setHidden:NO];
    [_defaultAnno setHidden:NO];
        [_popupview setHidden:NO];
   // [_ConfirmPin setHidden:YES];
     [_ConfirmPin setHidden:NO];
    pickerView.hidden=YES;
    _latepickerView.hidden=YES;
}
#pragma  mark --- Cancel and Confirm

-(IBAction)Confimation:(id)sender
{
    
    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) {    //Cancel
        [_defaultAnno setUserInteractionEnabled:YES];
        [_loadingView_View setHidden:NO];
        [_defaultAnno setHidden:NO];
        [_popupview setHidden:NO];
        //[_ConfirmPin setHidden:YES];
         [_ConfirmPin setHidden:NO];
        DownView.hidden=YES;
        CtryViewCell.hidden=NO;
        
        [_Header_view setHidden:NO];
        [_HeaderConfirmation_View setHidden:YES];
        
        AddressField.enabled=YES;
        GoogleMap.userInteractionEnabled=YES;
        BGmapView.userInteractionEnabled=YES;
        locationBtn.hidden=NO;
        [AddressField setTextColor:[UIColor blackColor]];
        [_AddressView setHidden:YES];
        
        
        [UIView animateWithDuration:0.50 animations:^{
            [InfoView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            InfoView.hidden=YES;
        }];
        
        [UIView animateWithDuration:0.50 animations:^{
            [LateInfoView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            LateInfoView.hidden=YES;
        }];
        FavoriteBTN.userInteractionEnabled=YES;
        [Themes SaveCoupon:@""];
        [Themes SaveCouponDetails:@""];
        CouponCoudLable.text=JJLocalizedString(@"Apply_Coupon", nil) ;
        lateCouponlbl.text=JJLocalizedString(@"Apply_Coupon", nil) ;
        
        _DropField.text=@"";
        droplatitude = 0;
         droplongitude  =0 ;
        
        
    } else if (btnAuthOptions.tag==2) { //CONFIRM
        ConfirmButton.enabled=NO;
        DownView.hidden=NO;
        [self ConfirmRide];
    }
}
#pragma  mark --- ConfirmRide


-(void)ConfirmRide
{
    
    
    if ([ButtontypeStr isEqualToString:@"1"])
    {
        pickUptime=DelayTimeStr;
        pickupdate=DelayDateStr;
    }
    else if ([ButtontypeStr isEqualToString:@"0"])
    {
        pickUptime=TimeString;
        pickupdate=DateString;
        
    }
    if ([CouponCoudLable.text isEqualToString:JJLocalizedString(@"Apply_Coupon", nil)]||[lateCouponlbl.text isEqualToString:JJLocalizedString(@"Apply_Coupon", nil)])
    {
        
        couponCode=@"";
        
    }
    else
    {
        couponCode=[Themes GetCoupon];
    }
    
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    NSString*DroplatitudeStr=[NSString stringWithFormat:@"%f",droplatitude];
    NSString*DroplongitudeStr=[NSString stringWithFormat:@"%f",droplongitude];
    
    
    
    NSDictionary *parameters=@{@"user_id":[Themes checkNullValue:UserID],
                               @"pickup":[Themes checkNullValue:AddressField.text],
                               @"drop_loc":[Themes checkNullValue:_DropField.text],
                               @"pickup_lat":[Themes checkNullValue:PicklatitudeStr],
                               @"pickup_lon":[Themes checkNullValue:PicklongitudeStr],
                               @"drop_lat":[Themes checkNullValue:DroplatitudeStr],
                               @"drop_lon":[Themes checkNullValue:DroplongitudeStr],
                               @"category":[Themes checkNullValue:CarCategoryString],
                               @"type":[Themes checkNullValue:ButtontypeStr],
                               @"pickup_date":[Themes checkNullValue:pickupdate],
                               @"pickup_time":[Themes checkNullValue:pickUptime],//"06:17 PM";
                               @"code":[Themes checkNullValue:couponCode]};//[Themes GetCoupon]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web ConfirmRide:parameters success:^(NSMutableDictionary *responseDictionary)
     {
     
         
         if([responseDictionary count]>0)
         {
             NSLog(@"%@",responseDictionary);
             NSString * status=[responseDictionary valueForKey:@"status"];
             NSString * response=[responseDictionary valueForKey:@"response"];
             if ([status isEqualToString:@"0"])
             {
                 [Themes StopView:self.view];

                
                 
                  [self.view makeToast:[Themes checkNullValue:response]];
                 ConfirmButton.enabled=YES;

                 
             }
             else if ([status isEqualToString:@"2"])
             {
                 [self AddCard];
                
             }
             else
             {
                 ConfirmButton.enabled=YES;
                 
          

                 NSString * type=[[responseDictionary valueForKey:@"response"] valueForKey:@"type"];
                 categaory.timinrloading=[[responseDictionary valueForKey:@"response"] valueForKey:@"response_time"];
                 categaory.Booking_ID=[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"];
                 categaory.retryTime=[Themes checkNullValue:[[responseDictionary valueForKey:@"response"]valueForKey:@"retry_time"]];
                 RequestTimeCount=[Themes checkNullValue:[[responseDictionary valueForKey:@"response"]valueForKey:@"retry_request_count"]];
                 catgBookId=[Themes checkNullValue:[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"]];
                 
                 if ([type isEqualToString:@"1"])
                 {
                     [Themes StopView:self.view];
                     [Themes SaveCoupon:@""];
                     isChangingNetwork=YES;
                     
                     if (showinAlert==NO)
                     {
                         NSString * successfullybooked=JJLocalizedString(@"Your_book_successfully_registerd", nil);
                         NSString * messageSTR   =[NSString stringWithFormat:@"%@ %@",successfullybooked,pickUptime];
                         ConfrimAlertlater =[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:messageSTR delegate:self cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                         [ConfrimAlertlater show];
                         showinAlert=YES;
                     }
                     AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [del LogIn];
                     
                     
                 }
                 else
                 {
                     timingLoading= [NSTimer scheduledTimerWithTimeInterval:[categaory.timinrloading doubleValue]
                                                                     target:self
                                                                   selector:@selector(loadingView)
                                                                   userInfo:nil
                                                                    repeats:NO];
                     [Themes StopView:self.view];
                     [Themes SaveCoupon:@""];
                     isChangingNetwork=YES;
                     
                             isRetrySucess=NO;
                     retryLoading= [NSTimer scheduledTimerWithTimeInterval:[categaory.retryTime doubleValue]
                                                                     target:self
                                                                   selector:@selector(RetryCount)
                                                                   userInfo:nil
                                                                    repeats:YES];
                     retryRequestCount=2;
                     
                     TimeViewTiming=[[[NSBundle mainBundle] loadNibNamed:@"TimeView" owner:self options:nil] objectAtIndex:0];
                     
                     TimeViewTiming.frame=self.view.frame;
                     [TimeViewTiming setUserInteractionEnabled:YES];
                     
                     [self view:InfoView boolen:NO];
                     [self view:FavoriteBTN boolen:NO];
                     [self view:CancelButton boolen:NO];
                     [self view:ConfirmButton boolen:NO];
                     [self view:AddressField boolen:NO];
                     [self view:_btnMenu boolen:NO];
                     [self view:_HeaderConfirmation_View boolen:NO];
                     [self view:_DropField boolen:NO];
                     [self.view addSubview:TimeViewTiming];
                     [self.view bringSubviewToFront:TimeViewTiming.closereq];
                     [TimeViewTiming setRecordObj:categaory];
                     
                     isRetry=YES;
                     
                 }
                 
             }
             
             
             
         }else{
             [Themes StopView:self.view];
             ConfirmButton.enabled=YES;
         }
         
         
         
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         ConfirmButton.enabled=YES;

         
     }];
    
}
-(void)AddCard{
    
    addcardAlert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                 message:JJLocalizedString(@"To_book_a_RYDD_please_add_a_credit_card_to_your_profile", nil)
                                                delegate:self
                                       cancelButtonTitle:JJLocalizedString(@"Cancel", nil)
                                       otherButtonTitles:JJLocalizedString(@"Ok", nil), nil];
    [addcardAlert show];
    
    
    
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    }

-(void)view:(UIView *)Views boolen:(BOOL)boolean
{
    [Views setUserInteractionEnabled:boolean];
}
#pragma  mark --- Timing View

-(void)loadingView
{
    [retryLoading invalidate];
    retryLoading=nil;
    retryRequestCount=0;
    
    
    if (isRetry==YES)
    {
        [self view:InfoView boolen:YES];
        [self view:FavoriteBTN boolen:YES];
        [self view:CancelButton boolen:YES];
        [self view:ConfirmButton boolen:YES];
        [self view:AddressField boolen:YES];
        [self view:_btnMenu boolen:YES];
         [self view:_DropField boolen:YES];
      
        [Themes StopView:self.view];
        NSString * nodriver=JJLocalizedString(@"No_Driver_Available_RETRY", nil);
        if(self.view.window)
        {
//         RetryAlert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Sorry", nil) message:nodriver delegate:self cancelButtonTitle:JJLocalizedString(@"Retry", nil) otherButtonTitles:JJLocalizedString(@"Cancel", nil), nil];
//        [RetryAlert show];
            
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Sorry", nil) message:JJLocalizedString(@"No_Drivers_Available",nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                [Alert show];                        //Sri Ram
            
        }
    }
    else if (isRetry==NO)
    {
        [self view:InfoView boolen:YES];
        [self view:FavoriteBTN boolen:YES];
        [self view:CancelButton boolen:YES];
        [self view:ConfirmButton boolen:YES];
        [self view:AddressField boolen:YES];
        [self view:_btnMenu boolen:YES];
         [self view:_DropField boolen:YES];

        [timingLoading2 invalidate];
        [timingLoading invalidate];
        [Themes StopView:self.view];
        [self cancelRide];
        retrrycount=1;
    }
    
}
#pragma  mark --- Ride Confirm Notification

- (void) pushnotification:(NSNotification *)notification
{
    retryRequestCount=0;
    [retryLoading invalidate];
    retryLoading=nil;
    [Themes StopView:self.view];
    
    [timingLoading invalidate]; //key 5
    [timingLoading2 invalidate];
    [Themes StopView:self.view];
    
    
    [self view:InfoView boolen:YES];
    [self view:FavoriteBTN boolen:YES];
    [self view:CancelButton boolen:YES];
    [self view:ConfirmButton boolen:YES];
    [self view:AddressField boolen:YES];
    [self view:_btnMenu boolen:YES];
     [self view:_DropField boolen:YES];
    
    [TimeViewTiming removeFromSuperview];
    
    if ([notification.object isKindOfClass:[NSDictionary class]])
    {
        
       
        Record_Driver.Ride_ID=[Themes checkNullValue: [notification.object valueForKey:@"key9"]];
        NewTrackVC*objNewTrackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
        [objNewTrackVC setRide_ID:[Themes checkNullValue: Record_Driver.Ride_ID]];
        objNewTrackVC.delegate=self;
        [self.navigationController pushViewController:objNewTrackVC animated:YES];
    }
    else
    {
       
    }
    
    
    
}
-(void)moveToHome{
    droplatitude=0;
    droplongitude=0;
    self.DropField.text=@"";
    [self backfrom_action:CancelButton];
}
#pragma  mark --- PickerAction Cancel and Done LateinfoView


- (IBAction)latepiackerAction:(id)sender {
    UIBarButtonItem *btnAuthOptions=(UIBarButtonItem*)sender;
    
    if (btnAuthOptions.tag==1)
    {
        _latepickerView.hidden=YES;
        if(_isChangeRideNowCategory==YES){
         
              LateInfoView.hidden=YES;
               _isChangeRideNowCategory=NO;
        }else{
                LateInfoView.hidden=NO;
        }
    
    }
    else if (btnAuthOptions.tag==2) {
        
        if ([nameArray count]>0) {
            _latepickerView.hidden=YES;
               if(_isChangeRideNowCategory==YES){
                   LateInfoView.hidden=YES;
                 
               }else{
                   LateInfoView.hidden=NO;
                   lateCabLable.text=nameofcar;
               }
          
            
            [self GetHomePages:selectedBtnIndex];
            
        }
        
        
    }
}
#pragma  mark --- PickerAction Cancel and Done Ride Later

-(IBAction)PickerAction:(id)sender
{
    UIBarButtonItem *btnAuthOptions=(UIBarButtonItem*)sender;
    if (btnAuthOptions.tag==1) //cancel
    {
        
        
        if (IsPickerView==YES)
        {
            [_loadingView_View setHidden:NO];
            [_defaultAnno setHidden:NO];
              [_popupview setHidden:NO];
           // [_ConfirmPin setHidden:YES];
             [_ConfirmPin setHidden:NO];
            pickerView.hidden=YES;
            GoogleMap.userInteractionEnabled=YES;
            BGmapView.userInteractionEnabled=YES;
            
            locationBtn.hidden=NO;
            
            FavoriteBTN.userInteractionEnabled=YES;
            
            [_Header_view setHidden:NO];
            [_HeaderConfirmation_View setHidden:YES];
            [_AddressView setHidden:YES];
            
            
        }
        else if (IsPickerView==NO)
        {
            [_loadingView_View setHidden:YES];
            [_defaultAnno setHidden:YES];
               [_popupview setHidden:YES];
            [_ConfirmPin setHidden:NO];
            pickerView.hidden=YES;
            GoogleMap.userInteractionEnabled=NO;
            BGmapView.userInteractionEnabled=NO;
            
            locationBtn.hidden=YES;
            LateInfoView.hidden=NO;
            
        }
        
    }
    
    else if (btnAuthOptions.tag==2) { //done
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY-MM-dd"];
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"hh:mm a"];
        
        DelayDateStr = [NSString stringWithFormat:@"%@",
                        [df stringFromDate:RidelatePicker.date]];
        
        DelayTimeStr = [NSString stringWithFormat:@"%@",
                        [timeFormat stringFromDate:RidelatePicker.date]];
        
        pickerView.hidden=YES;
        
        NSString * YourWallet=JJLocalizedString(@"Your_wallet_money", nil);
        
        RideLater_WalletAmount_lbl.text=[NSString stringWithFormat:@"%@ %@",YourWallet,[Themes GetFullWallet]];
        
        
        locationBtn.hidden=NO;
        
        CtryViewCell.hidden=YES;
        DownView.hidden=NO;
        AddressField.enabled=NO;
        [AddressField setTextColor:[UIColor lightGrayColor]];
        GoogleMap.userInteractionEnabled=NO;
        BGmapView.userInteractionEnabled=NO;
        
        locationBtn.hidden=YES;
        
        LateInfoView.hidden=NO;
        
        [UIView animateWithDuration:0.50 animations:^{
            LateInfoView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
            NSDateFormatter *dateFormet = [[NSDateFormatter alloc] init];
            
            [dateFormet setDateFormat:@"YYYY-MM-dd"];
            
            NSDate *date = [dateFormet dateFromString:DelayDateStr];
            
            [dateFormet setDateFormat:@"MM-dd"];
            
            NSString *finalDate = [dateFormet stringFromDate:date];
            
            NSDateFormatter *timeFormate = [[NSDateFormatter alloc] init];
            
            [timeFormate setDateFormat:@"hh:mm a"];
            
            NSDate *Time = [timeFormate dateFromString:DelayTimeStr];
            
            [timeFormate setDateFormat:@"hh:mm a"];
            
            NSString *finalTime = [timeFormate stringFromDate:Time];
            
            NSString*compained=[NSString stringWithFormat:@"%@,%@",finalDate,finalTime];
            latePickUplbl.text=compained;
            lateCabLable.text=nameofcar;
    
        }];
        [ConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ConfirmButton setUserInteractionEnabled:YES];
        ConfirmButton.enabled=YES;
        
    }
    
}
- (IBAction)LabelChange:(id)sender
{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    DelayDateStr = [NSString stringWithFormat:@"%@",
                    [df stringFromDate:RidelatePicker.date]];
    
    DelayTimeStr = [NSString stringWithFormat:@"%@",
                    [timeFormat stringFromDate:RidelatePicker.date]];
    
}
#pragma  mark --- FavourView Moving

- (IBAction)signMeUpButtonPressed:(id)sender {
    
    FavorVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"FavourVCID"];
    
    AddObj.addressStr=AddressField.text;
   
    AddObj.ADDlatitude=latitude;
    AddObj.ADDlongitude=longitude;
    [addfavour setObjRecord:AddObj];
    [addfavour setIsfromPickup:YES];
    [self.navigationController pushViewController:addfavour animated:YES];
}
#pragma  mark --- RateCard View

-(void)rate
{
    
    RateCardViewVC * rateamount_view=[[[NSBundle mainBundle] loadNibNamed:@"RateCardViewVC" owner:self options:nil] objectAtIndex:0];
    rateamount_view.frame=self.view.frame;
    rateamount_view.Total_Rate_View.center=self.view.center;
    [self.view addSubview:rateamount_view];
    [self.view bringSubviewToFront:rateamount_view];
    [rateamount_view setObjrecord:categaory];
    
    
    
}

-(void)rateCardDetails:(BookingRecord*)objRecord
{
    RateCardCatLable.text=objRecord.categorySubName;
    RateCardVechielLable.text=objRecord.vehicletypes;
    MinFarelable.text=[NSString stringWithFormat:@"%@%@",Currency, objRecord.amountmin_fare];
    Minfare_text.text=objRecord.min_fare_text;
    AfterFareLable.text=[NSString stringWithFormat:@"%@%@",Currency,  objRecord.amountafter_fare];
    Afterfare_text.text=objRecord.after_fare_text;
    WaitingfareLable.text=[NSString stringWithFormat:@"%@%@",Currency,objRecord.amountother_fare];
    waitingfare_text.text=objRecord.other_fare_text;
    notelabel.text=objRecord.note;
    
}
-(IBAction)EtaRateCard:(id)sender
{
  //  [self rate];
}
#pragma  mark --- Estimation View


-(void)Estimate:(UITapGestureRecognizer *)sender
{
    if(droplatitude==0){
        DropVC *objDropVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DropVCID"];
        [objDropVC setIsFromEstimation:YES];
        objDropVC.delegate=self;
        [self.navigationController pushViewController:objDropVC animated:YES];
    }else{
        [self dataEstiamtion];
    }
}
#pragma mark - Data Estimation
-(void)dataEstiamtion
{
    _eta_pickup_hinty.text=JJLocalizedString(@"Pick_up_Estimate", nil);
  
    if ([ButtontypeStr isEqualToString:@"1"])
    {
        pickUptime=DelayTimeStr;
        pickupdate=DelayDateStr;
    }
    else if ([ButtontypeStr isEqualToString:@"0"])
    {
        pickUptime=TimeString;
        pickupdate=DateString;
        
    }
    
    
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSString*DroplatitudeStr=[NSString stringWithFormat:@"%f",droplatitude];
    NSString*DroplongitudeStr=[NSString stringWithFormat:@"%f",droplongitude];
    
    NSDictionary *parameters=@{@"user_id":[Themes checkNullValue:UserID],
                               @"pickup":[Themes checkNullValue:AddressField.text],
                               @"drop":[Themes checkNullValue:_DropField.text],
                               @"pickup_lat":[Themes checkNullValue:PicklatitudeStr],
                               @"pickup_lon":[Themes checkNullValue:PicklongitudeStr],
                               @"drop_lat":[Themes checkNullValue:DroplatitudeStr],
                               @"drop_lon":[Themes checkNullValue:DroplongitudeStr],
                               @"category":[Themes checkNullValue:CarCategoryString],
                               @"type":[Themes checkNullValue:ButtontypeStr],
                               @"pickup_date":[Themes checkNullValue:pickupdate],
                               @"pickup_time":[Themes checkNullValue:pickUptime]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GetEta:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         [Themes StopView:self.view];
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             NSString * alert=[responseDictionary valueForKey:@"response"]; // //@"message"
             [Themes StopView:self.view];
             if ([comfiramtion isEqualToString:@"1"])
             {
                 estiamtion.attString=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"att"];
                 estiamtion.dropStr=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"drop"];
                 estiamtion.PickupStr=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"pickup"];
                 estiamtion.min_amount=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"min_amount"];
                 estiamtion.max_amount=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"max_amount"];
                 estiamtion.note=[[[responseDictionary valueForKey:@"response"]valueForKey:@"eta"]valueForKey:@"note"];
                 
                 [self EstimationDetails:estiamtion];
                 [EstimationDetailView setHidden:NO];
                 [self.view bringSubviewToFront:EstimationDetailView];
                 
             }
             else
             {
                
                 [self.view makeToast:[Themes checkNullValue:alert]];
             }
         }
         
         
         
     }
        failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    
}
-(void)EstimationDetails:(EstimationRecord *)estimate
{
    dropLable.text=estimate.dropStr;
    
    pickUplable.text=estimate.PickupStr;
    
    NSString *amount=[NSString stringWithFormat:@"%@ %@ - %@ %@",Currency, estimate.min_amount,Currency,estimate.max_amount];
    minilable.text=amount;
    //maxlable.text=;
    NSString * approx=JJLocalizedString(@"APPOX_TRAVEL_TIME", nil);
    
    NSString *TimeLable=[NSString stringWithFormat:@"%@ %@",approx,estimate.attString];
    attLable.text=TimeLable;
    noteLable.text=estimate.note;
      [Themes StopView:self.view];
}
-(IBAction)ETAClose:(id)sender
{
    EstimationDetailView.hidden=YES;
    [_AddressView setHidden:NO];
    
    if (isETAView==NO)
    {
        LateInfoView.hidden=YES;
        DownView.hidden=NO;
        InfoView.hidden=NO;
        [_HeaderConfirmation_View setHidden:NO];
    }
    else if (isETAView==YES)
    {
        InfoView.hidden=YES;
        DownView.hidden=NO;
        LateInfoView.hidden=NO;
        [_HeaderConfirmation_View setHidden:NO];
        
    }
    
    
}
#pragma  mark --- Alert Coupon

-(void)CallCoupon
{
    CopounVC * ObjCopounVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CopounVCID"];
    if ([ButtontypeStr isEqualToString:@"1"])
    {
        [ObjCopounVC setDate:DelayDateStr];
        
    }
    else if ([ButtontypeStr isEqualToString:@"0"])
    {
        
        [ObjCopounVC setDate:DateString];
        
    }
    [self.navigationController pushViewController:ObjCopounVC animated:YES];
    
    
}
#pragma  mark --- Alert Delegate Retry Cancel and Coupon

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([CouponCoudLable.text isEqualToString:JJLocalizedString(@"Apply_Coupon", nil)]||[lateCouponlbl.text isEqualToString:JJLocalizedString(@"Apply_Coupon", nil)])
    {
        couponCode=@"";
    }
    else
    {
        couponCode=CouponTextField.text;
    }
    if (alertView==ConfrimAlertlater)
    {
        ConfrimAlertlater = nil;
    }
    
    else if (alertView==couponAlert)
    {
        if ([ButtontypeStr isEqualToString:@"1"])
        {
            pickUptime=DelayTimeStr;
            pickupdate=DelayDateStr;
        }
        else if ([ButtontypeStr isEqualToString:@"0"])
        {
            pickUptime=TimeString;
            pickupdate=DateString;
            
        }
        
        if (buttonIndex == 1)
        {
            NSDictionary *parameters=@{@"user_id":UserID,
                                       @"code":CouponTextField.text,
                                       @"pickup_date":pickupdate};
            
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [Themes StartView:self.view];
            [web ApplyCoupon:parameters success:^(NSMutableDictionary *responseDictionary) {
                
                [Themes StopView:self.view];
                if ([responseDictionary count]>0)
                {
                    responseDictionary=[Themes writableValue:responseDictionary];
                    NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                    
                    [Themes StopView:self.view];
                    if ([comfiramtion isEqualToString:@"1"])
                    {
                        NSString * alert=[[responseDictionary valueForKey:@"response"]valueForKey:@"message"];
                        categaory.CouponCode=[[responseDictionary valueForKey:@"response"]valueForKey:@"code"];
                        [Themes SaveCoupon:categaory.CouponCode];
                        CouponCoudLable.text=categaory.CouponCode;
                        lateCouponlbl.text=categaory.CouponCode;
                        [self.view makeToast:[Themes checkNullValue:alert]];
                       
                        
                    }
                    else
                    {
                        NSString * alert=[responseDictionary valueForKey:@"response"];
                        
                         [self.view makeToast:[Themes checkNullValue:alert]];
                       
                        [Themes SaveCoupon:@""];
                        CouponCoudLable.text=JJLocalizedString(@"Apply_Coupon", nil) ;
                        lateCouponlbl.text=JJLocalizedString(@"Apply_Coupon", nil) ;
                    }
                    
                }
            }
                     failure:^(NSError *error) {
                         [Themes StopView:self.view];
                         
                         
                     }];
        }
        
    }
    
    else if (alertView==RetryAlert)
    {
        if (buttonIndex == 0)
        {
            
            NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
            NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
            NSString*DroplatitudeStr=[NSString stringWithFormat:@"%f",droplatitude];
            NSString*DroplongitudeStr=[NSString stringWithFormat:@"%f",droplongitude];
            NSDictionary *parameters=@{@"user_id":[Themes checkNullValue:UserID],
                                       @"pickup":[Themes checkNullValue:AddressField.text],
                                       @"drop_loc":[Themes checkNullValue:_DropField.text],
                                       @"drop_lat":[Themes checkNullValue:DroplatitudeStr],
                                       @"drop_lon":[Themes checkNullValue:DroplongitudeStr],
                                       @"pickup_lat":[Themes checkNullValue:PicklatitudeStr],
                                       @"pickup_lon":[Themes checkNullValue:PicklongitudeStr],
                                       @"category":[Themes checkNullValue:CarCategoryString],
                                       @"type":[Themes checkNullValue:ButtontypeStr],
                                       @"pickup_date":[Themes checkNullValue:DateString],
                                       @"pickup_time":[Themes checkNullValue:TimeString],
                                       @"Code":[Themes checkNullValue:couponCode],
                                       @"ride_id":[Themes checkNullValue:catgBookId],
                                       @"try":@"2"};//[Themes GetCoupon]};
            
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [Themes StartView:self.view];
            [web BookingRetry:parameters success:^(NSMutableDictionary *responseDictionary)
             
             {
                 [Themes StopView:self.view];
                 if ([responseDictionary count]>0)
                 {
                     responseDictionary=[Themes writableValue:responseDictionary];
                     if ([[responseDictionary valueForKey:@"status"] isEqualToString:@"1"]) {
                         
                         
                         
                         if ([[responseDictionary valueForKey:@"acceptance"] isEqualToString:@"Yes"])
                         {
                             
                             Record_Driver.Driver_Name=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_name"];
                             Record_Driver.Car_Name=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"vehicle_model"];
                             Record_Driver.Car_Number=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"vehicle_number"];
                             Record_Driver.latitude_driver=[[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_lat"] doubleValue];
                             Record_Driver.longitude_driver=[[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_lon"] doubleValue];
                             Record_Driver.Driver_moblNumber=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"phone_number"];
                             Record_Driver.ETA=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"min_pickup_duration"];
                             Record_Driver.rating=[[[responseDictionary valueForKey:@"response"]valueForKey:@"driver_profile"] valueForKey:@"driver_review"];
                             Record_Driver.latitude_User=[PicklatitudeStr doubleValue];
                             Record_Driver.longitude_User=[PicklongitudeStr doubleValue];
                             Record_Driver.Ride_ID=[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"];
                             Record_Driver.message=[[responseDictionary valueForKey:@"response"]valueForKey:@"message"];
                             Record_Driver.isCancel=YES;
                             //Record_Driver.DriverImage=[[responseDictionary valueForKey:@"message"] valueForKey:@"key5"];
                            // [currentLocation stopUpdatingLocation];
                             
                             isChangingNetwork=YES;
                             // TrackRideVC*objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"TrackRideVCID"];
                             NewTrackVC*objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                             [objLoginVC setRide_ID:Record_Driver.Ride_ID];
                           
                             [self.navigationController pushViewController:objLoginVC animated:YES];
                         }
                         else
                         {
                             
                             categaory.timinrloading=[[responseDictionary valueForKey:@"response"] valueForKey:@"response_time"];
                             timingLoading2= [NSTimer scheduledTimerWithTimeInterval:[categaory.timinrloading doubleValue]
                                                                              target:self
                                                                            selector:@selector(loadingView)
                                                                            userInfo:nil
                                                                             repeats:NO];
                             isChangingNetwork=YES;
                             
                             categaory.Booking_ID=[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"];
                              catgBookId=[Themes checkNullValue:[[responseDictionary valueForKey:@"response"]valueForKey:@"ride_id"]];
                             
                             [Themes StopView:self.view];
                             //[self.view setUserInteractionEnabled:NO];
                             
                             
                             [self view:InfoView boolen:NO];
                             [self view:FavoriteBTN boolen:NO];
                             [self view:CancelButton boolen:NO];
                             [self view:ConfirmButton boolen:NO];
                             [self view:AddressField boolen:NO];
                             [self view:_btnMenu boolen:NO];
                             [self view:_HeaderConfirmation_View boolen:NO];
                             [self view:_DropField boolen:NO];
                             
                             TimeViewTiming=[[[NSBundle mainBundle] loadNibNamed:@"TimeView" owner:self options:nil] objectAtIndex:0];
                             [TimeViewTiming setRecordObj:categaory];
                             TimeViewTiming.frame=self.view.frame;
                             TimeViewTiming.Timing.center=self.view.center;
                             TimeViewTiming.hintView.center=CGPointMake(self.view.center.x,self.view.center.y-100);
                             [self.view addSubview:TimeViewTiming];
                         
                         }
                     }
                     else{
                         
                         NSString *Msg=[Themes checkNullValue:[responseDictionary valueForKey:@"response"]];
                        
                          [self.view makeToast:[Themes checkNullValue:Msg]];
                     }
                     
                 }
                 
                 
                 
             }
                     failure:^(NSError *error)
             {
                 [Themes StopView:self.view];
             }];
        }
        else if (buttonIndex==1)
        {
            [self cancelRide];
        }
    }
    if(alertView == addcardAlert)
    {
        
        if(buttonIndex == 1)
        {
            CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
            scanViewController.hideCardIOLogo=YES;
            scanViewController.collectCVV = NO;
            scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:scanViewController animated:YES completion:nil];

//            AddCardVC *addCardVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddcardVC"];
//            [[self navigationController]pushViewController:addCardVC animated:YES];
//            [Themes StopView:self.view];
            
                   }
        
    }

}
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Scan succeeded with info: %@", [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.cardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv]);
    
    AddCardRecord * objRec=[[AddCardRecord alloc]init];
    objRec.cardNumber=[NSString stringWithFormat:@"%@", info.cardNumber];
    objRec.CCExpMonth=[NSString stringWithFormat:@"%02lu", (unsigned long)info.expiryMonth];
    objRec. CCExpYear=[NSString stringWithFormat:@"%lu", (unsigned long)info.expiryYear];
    AddCardVC *addcardVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddcardVC"];
    [addcardVC setAddCardRec:objRec];
    [self.navigationController pushViewController:addcardVC animated:YES];
    
    
    
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
    
}

#pragma  mark --- Cancel Ride

-(void)cancelRide
{
    NSDictionary *parameters=@{@"user_id":UserID,
                               @"ride_id":catgBookId};//[Themes GetCoupon]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web Bookingcancel:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];
         NSString *status=[responseDictionary valueForKey:@"status"];
         {
             if ([status isEqualToString:@"1"]) {
                 if ([responseDictionary count]>0)
                 {
                     retryRequestCount=0;
                     [retryLoading invalidate];
                     retryLoading=nil;
                     
                     responseDictionary=[Themes writableValue:responseDictionary];
                     
                     [Themes StopView:self.view];
                     NSString * cancelled=JJLocalizedString(@"Booking_Request_Cancelled", nil);
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:cancelled delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [Alert show];
                     
                 }
                 
             }
             else
             {
                 NSString *Msg=[responseDictionary valueForKey:@"response"];
                  [self.view makeToast:[Themes checkNullValue:Msg]];
                 
             }
         }
         
         
         
         
         
     }
               failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
}
-(void)passDropLatLong:(CLLocation *)dLoc withDropTxt:(NSString *)dropPlace{
    droplatitude=dLoc.coordinate.latitude;
    droplongitude=dLoc.coordinate.longitude;
    _DropField.text=dropPlace;
    
}
-(void)passPickUpLatLong:(CLLocation *)dLoc withDropTxt:(NSString *)pickupPlace{
    latitude=dLoc.coordinate.latitude;
    longitude=dLoc.coordinate.longitude;
    AddressField.text=[Themes checkNullValue:pickupPlace];
    [GoogleMap animateToLocation:CLLocationCoordinate2DMake(latitude, longitude)];
    [GoogleMap animateToZoom:14.0];
}
-(void)passEstimateLatLong:(CLLocation *)dLoc withDropTxt:(NSString *)estimatePlace{
    droplatitude=dLoc.coordinate.latitude;
    droplongitude=dLoc.coordinate.longitude;
    _DropField.text=estimatePlace;
       [self dataEstiamtion];
}
-(void)RetryCount
{
    
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    NSString*DroplatitudeStr=[NSString stringWithFormat:@"%f",droplatitude];
    NSString*DroplongitudeStr=[NSString stringWithFormat:@"%f",droplongitude];
    NSDictionary *parameters=@{@"user_id":[Themes checkNullValue:UserID],
                               @"pickup":[Themes checkNullValue:AddressField.text],
                               @"drop_loc":[Themes checkNullValue:_DropField.text],
                               @"drop_lat":[Themes checkNullValue:DroplatitudeStr],
                               @"drop_lon":[Themes checkNullValue:DroplongitudeStr],
                               @"pickup_lat":[Themes checkNullValue:PicklatitudeStr],
                               @"pickup_lon":[Themes checkNullValue:PicklongitudeStr],
                               @"category":[Themes checkNullValue:CarCategoryString],
                               @"type":[Themes checkNullValue:ButtontypeStr],
                               @"pickup_date":[Themes checkNullValue:DateString],
                               @"pickup_time":[Themes checkNullValue:TimeString],
                               @"Code":[Themes checkNullValue:couponCode],
                               @"ride_id":[Themes checkNullValue:catgBookId],
                               @"try":[NSString stringWithFormat:@"%ld",(long)retryRequestCount],
                               };//[Themes GetCoupon]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
//    [Themes StartView:self.view];
    [web BookingRetry:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         [Themes StopView:self.view];
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             if ([[responseDictionary valueForKey:@"status"] isEqualToString:@"1"])
             {
                 retryRequestCount++;
//                  isRetrySucess=YES;
             }
             else{
                 
//                 NSString *Msg=[Themes checkNullValue:[responseDictionary valueForKey:@"response"]];
//                 
//                 [self.view makeToast:[Themes checkNullValue:Msg]];
             }
             
         }
         
     }
              failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
}
- (IBAction)didClickFavDropLocation:(id)sender {
    FavorVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"FavourVCID"];
 
         AddObj.addressStr=_DropField.text;
 
         AddObj.ADDlatitude=latitude;
         AddObj.ADDlongitude=longitude;
         [addfavour setObjRecord:AddObj];
         [addfavour setIsfromDrop:YES];
 
         [self.navigationController pushViewController:addfavour animated:YES];

}
@end
