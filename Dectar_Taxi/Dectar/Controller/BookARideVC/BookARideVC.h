//
//  BookARideVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 16/07/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>
#import "LoginVC.h"
#import "CarCtryCell.h"
#import "Blurview.h"
#import "RootBaseVC.h"
#import "TimeView.h"
#import "BLMultiColorLoader.h"
#import "AFMInfoBanner.h"
#import "DropVC.h"
#import "UIImageView+WebCache.h"

@class CarCtryCell,TimeView;

@interface BookARideVC : RootBaseVC<ButtonProtocolName,returnLatLongDelegate,UIActionSheetDelegate>


@property (strong , nonatomic) NSString * addressString;
@property (strong , nonatomic) NSString * SearchBarAddress;

@property  (assign,nonatomic)CGFloat latitude;
@property  (assign,nonatomic)CGFloat longitude;
@property  (assign,nonatomic)CGFloat droplatitude;
@property  (assign,nonatomic)CGFloat droplongitude;
@property (strong, nonatomic) IBOutlet UIView *Header_view;
@property (strong, nonatomic) IBOutlet UIView *HeaderConfirmation_View;



@property (strong, nonatomic) NSMutableArray *filteredContentList;
@property(assign,nonatomic)BOOL isLocationSelected;
@property(assign,nonatomic)BOOL isChangeRideNowCategory;
@property(assign,nonatomic)BOOL isInitialButtonSelected;
@property(assign,nonatomic)NSInteger isNoCabsButtonSelectedIndex;
@property (strong, nonatomic) IBOutlet UIButton *locationBtn;
@property (strong, nonatomic)  NSArray *Annotation;
- (IBAction)didClickFavDropLocation:(id)sender;

@property(strong, nonatomic) IBOutlet UITextField * DropField;

@property (strong,nonatomic) IBOutlet UICollectionView * CtryViewCell;
@property (strong,nonatomic) IBOutlet UIView * DownView;
@property (strong,nonatomic) IBOutlet UIButton * CancelButton;
@property (strong,nonatomic) IBOutlet UIButton * ConfirmButton;
@property (weak, nonatomic) IBOutlet UIView *view_popup;
@property (weak, nonatomic) IBOutlet UILabel *lbl_description;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;

@property (strong,nonatomic) IBOutlet UIView *InfoView;
@property (strong,nonatomic) IBOutlet UIView *CouponView;
@property (strong,nonatomic) IBOutlet UIView *EstimationView;
@property (strong,nonatomic) IBOutlet UIView *RateCardView;
@property (strong,nonatomic) IBOutlet UIView *CategoryView;
@property (strong,nonatomic) IBOutlet UIView *PickUptimeView;
@property (strong,nonatomic) IBOutlet UILabel * RideNow_WalletAmount_lbl;
@property (strong,nonatomic) IBOutlet UILabel * infoPicktimeLable;
@property (strong,nonatomic) IBOutlet UILabel * RideLater_WalletAmount_lbl;

@property (strong,nonatomic) IBOutlet UILabel * CategoryLable;
@property (strong,nonatomic) IBOutlet UILabel * pickupLable;
@property (strong, nonatomic) IBOutlet UILabel *CouponCoudLable;
@property (strong, nonatomic) IBOutlet UIButton *FavoriteBTN;


@property (strong,nonatomic) IBOutlet UIView * RateCardDetailView;
@property (strong,nonatomic) IBOutlet UILabel * RateCardCatLable;
@property (strong,nonatomic) IBOutlet UILabel * RateCardVechielLable;
@property (strong,nonatomic) IBOutlet UILabel * MinFarelable;
@property (strong,nonatomic) IBOutlet UILabel * AfterFareLable;
@property (strong,nonatomic) IBOutlet UILabel * WaitingfareLable;
@property (strong,nonatomic) IBOutlet UILabel * Minfare_text;
@property (strong,nonatomic) IBOutlet UILabel * Afterfare_text;
@property (strong,nonatomic) IBOutlet UILabel * waitingfare_text;
@property (strong,nonatomic) IBOutlet UILabel * notelabel;


@property(strong,nonatomic) IBOutlet UIView *EstimationDetailView;
@property(strong,nonatomic) IBOutlet UILabel *pickUplable;
@property(strong,nonatomic) IBOutlet UILabel *dropLable;
@property(strong,nonatomic) IBOutlet UILabel *attLable;
@property(strong,nonatomic) IBOutlet UILabel *minilable;
@property(strong,nonatomic) IBOutlet UILabel *maxlable;
@property(strong,nonatomic) IBOutlet UILabel *noteLable;

@property(strong,nonatomic) IBOutlet UIView * pickerView;
@property(strong,nonatomic) IBOutlet UIDatePicker *RidelatePicker;
@property(strong,nonatomic) IBOutlet UIToolbar * PickerToolbar;
@property (strong, nonatomic) IBOutlet UIButton *EstimateRateCard;

@property(strong,nonatomic) IBOutlet UIButton * EstiamtionCloseButton;

@property(strong,nonatomic) IBOutlet UIView * LateInfoView;
@property(strong,nonatomic) IBOutlet UIView * latecabtypeView;
@property(strong,nonatomic) IBOutlet UIView * latePickUpView;
@property(strong,nonatomic) IBOutlet UIView * lateRateView;
@property(strong,nonatomic) IBOutlet UIView * lateEstiamteionView;
@property(strong,nonatomic) IBOutlet UIView * lateCouponView;

@property(strong,nonatomic) IBOutlet UILabel * lateCabLable;
@property(strong,nonatomic) IBOutlet UILabel * latePickUplbl;
@property(strong,nonatomic) IBOutlet UILabel * lateCouponlbl;
@property (strong, nonatomic) IBOutlet UIView *latepickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *latepicker;
@property(assign,nonatomic)NSInteger selectedBtnIndex;
@property(assign,nonatomic)BOOL isFirstTime;
@property(assign,nonatomic)BOOL islocUpdatedInitially;
@property(assign,nonatomic)BOOL isLoadSingleTime;
@property(assign,nonatomic)BOOL isMoveStarted;
@property(strong,nonatomic) TimeView* TimeViewTiming;


@property (strong, nonatomic) IBOutlet UIView *AddressView;
@property (strong, nonatomic) IBOutlet UILabel *PickUpAddress_label;


@property (strong, nonatomic) IBOutlet UILabel *info_title_pickuptime;
@property (strong, nonatomic) IBOutlet UILabel *info_title_cabtype;
@property (strong, nonatomic) IBOutlet UILabel *info_title_rateCard;
@property (strong, nonatomic) IBOutlet UILabel *info_title_estimate;

@property (strong, nonatomic) IBOutlet UILabel *late_title_pickuptime;
@property (strong, nonatomic) IBOutlet UILabel *late_title_cabtype;
@property (strong, nonatomic) IBOutlet UILabel *late_title_ratecard;
@property (strong, nonatomic) IBOutlet UILabel *late_title_estimate;
@property (weak, nonatomic) IBOutlet UIToolbar *lateToolBar;
@property (weak, nonatomic) IBOutlet UIButton *cabTypebtn;


@property (strong, nonatomic) IBOutlet UILabel *Header_confrimation_lbl;

@property (strong, nonatomic) IBOutlet UILabel *eta_header_lbl;
@property (strong, nonatomic) IBOutlet UILabel *eta_pickup_hinty;
@property (strong, nonatomic) IBOutlet UILabel *eta_drop_hint;
@property(strong,nonatomic)NSString * catgBookId;
-(void)cancelRide;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *latePickCancelBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *latePickDoneBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pickcancelBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pickDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *DriverStatusLbl;
@property (weak, nonatomic) IBOutlet UIImageView *animatedLoadImageView;
@property (weak, nonatomic) IBOutlet BLMultiColorLoader *multiLoadingViewControl;

@end
