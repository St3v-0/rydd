//
//  NewViewController.h
//  Dectar
//
//  Created by Aravind Natarajan on 12/21/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FareRecord.h"
#import "RootBaseVC.h"
#import "CustomButton.h"
#import "TPFloatRatingView.h"
@interface NewViewController : RootBaseVC<TPFloatRatingViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolling;
@property (strong, nonatomic) IBOutlet UIView *driverImage;
@property (strong, nonatomic) IBOutlet UILabel *driverName;


@property (strong, nonatomic) IBOutlet UIButton *makePayMent;


@property (strong, nonatomic) FareRecord * ObjRc;
@property (strong, nonatomic) IBOutlet UIImageView *image_driver;
@property (strong, nonatomic) IBOutlet UIButton *goBack;

@property (weak, nonatomic) IBOutlet CustomButton *retryButton;
- (IBAction)didClickRetry:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *retryView;
@property (strong, nonatomic) IBOutlet UILabel *hint_processing;
@property (strong, nonatomic) IBOutlet UILabel *wait;



@property (weak, nonatomic) IBOutlet UILabel *driverNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *driverRatingHeaderLbl;
@property (weak, nonatomic) IBOutlet TPFloatRatingView *driverRatingView;
@property (weak, nonatomic) IBOutlet UILabel *tripTotalHeader;
@property (weak, nonatomic) IBOutlet UILabel *tripTotalLbl;

@property (weak, nonatomic) IBOutlet UILabel *durartionHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitingHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitingTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;

@property (weak, nonatomic) IBOutlet UILabel *subTotalHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *serviceTaxHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *serviceTaxLbl;


@property (weak, nonatomic) IBOutlet UIView *tipEnterView;
@property (weak, nonatomic) IBOutlet UIButton *termsBtn;
- (IBAction)didClickTermsBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *termsMessageLbl;
@property (weak, nonatomic) IBOutlet UITextField *tipsTxtField;
- (IBAction)didClickApplyBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property(strong,nonatomic)NSString * RideID;


@property (weak, nonatomic) IBOutlet UIView *tipsRemoveView;
- (IBAction)didClickTipsRemoveBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tipsHeaderLbl;
@property (weak, nonatomic) IBOutlet UILabel *tipsLbl;
@property (strong, nonatomic) IBOutlet UILabel *baseFareHeaderLbl;
@property (strong, nonatomic) IBOutlet UILabel *baseFareAmtLbl;
@property(assign,nonatomic)NSInteger errorCount;
@property(strong,nonatomic)NSString * gateway;

@end
