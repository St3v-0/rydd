//
//  NewViewController.m
//  Dectar
//
//  Created by Aravind Natarajan on 12/21/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "NewViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UrlHandler.h"
#import "Themes.h"
#import "UIImageView+Network.h"
#import "PaymentVC.h"
#import "RatingVC.h"
#import "LanguageHandler.h"
#define ACCEPTABLE_CHARECTERS @"123456789."
#import "UIImageView+Network.h"
#import "UIImageView+WebCache.h"
#import "PaymentListVC.h"
#import "WebViewVC.h"


const static CGFloat kCustomIOS7MotionEffectExtent = 10.0;

@interface NewViewController ()<UITextFieldDelegate>
{
    float userlat;
    float userlon;
    float drlat;
    float drlng;
    BOOL checkBoxSelected;
    
    
 
    NSString * CouponAmount;
    NSString * TipAmount;
    NSString * Currency;
    NSString * FullTotalAmount;
    
    NSString  *stripe_connected;
    NSString * payment_timeout;
    NSTimer *payment_timer;
    NSString *Distance_unit;
    AppDelegate *appDel;
    NSMutableArray* cardNameArray;



}
@property(strong ,nonatomic) GMSMapView * googlemap;
@property (strong ,nonatomic) GMSCameraPosition*camera;
@end

@implementation NewViewController
@synthesize ObjRc;
@synthesize driverNameLbl,
driverRatingHeaderLbl,
driverRatingView,
tripTotalHeader,
tripTotalLbl,
durartionHeaderLbl,
durationTimeLbl,
waitingHeaderLbl,
waitingTimeLbl,
distanceHeaderLbl,
distanceLbl,
subTotalHeaderLbl,
subTotalLbl,
serviceTaxHeaderLbl,
serviceTaxLbl,
tipEnterView,
termsBtn,
termsMessageLbl,
tipsTxtField,
tipsRemoveView,
tipsHeaderLbl,
tipsLbl,RideID;

- (void)viewDidLoad {
    
    self.retryView.hidden = NO;
    self.retryButton.hidden = YES;
    
    [super viewDidLoad];
    
    tipEnterView.hidden=NO;
    tipsRemoveView.hidden=YES;
    
  
 
    
    _image_driver.layer.cornerRadius = _image_driver.frame.size.width/2;
    _image_driver.layer.masksToBounds = YES;
    
    tipsTxtField.layer.cornerRadius =3;
    tipsTxtField.layer.borderColor=BGCOLOR.CGColor;
    tipsTxtField.layer.borderWidth=.75;
    _image_driver.layer.masksToBounds = YES;
    

    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
   
    
    [_goBack setTitle:JJLocalizedString(@"GoBack", nil)  forState:UIControlStateNormal];
    [_heading setText:JJLocalizedString(@"Fare_Details", nil)];
    [_applyBtn setTitle:JJLocalizedString(@"Apply", nil) forState:UIControlStateNormal];
   [driverRatingHeaderLbl setText:JJLocalizedString(@"driver_rating", nil)];
    [tripTotalHeader setText:JJLocalizedString(@"trip_total", nil)];
    [durartionHeaderLbl setText:JJLocalizedString(@"duration_fare", nil)];
    [waitingHeaderLbl setText:JJLocalizedString(@"waiting_fare", nil)];
   [ distanceHeaderLbl setText:JJLocalizedString(@"distance_fare", nil)];
    [subTotalHeaderLbl setText:JJLocalizedString(@"sub_total", nil)];
    [serviceTaxHeaderLbl setText:JJLocalizedString(@"service_tax", nil)];
   [ termsMessageLbl setText:JJLocalizedString(@"want_tips", nil)];
      tipsTxtField.placeholder= JJLocalizedString(@"tips", nil);
   [ tipsHeaderLbl setText:JJLocalizedString(@"tips", nil)];
    [_makePayMent setTitle:JJLocalizedString(@"make_a_payment", nil) forState:UIControlStateNormal];
    
    [_retryButton setTitle:JJLocalizedString(@"Retry", nil) forState:UIControlStateNormal];
    [_wait setText:JJLocalizedString(@"Please_wait", nil)];
    [_hint_processing setText:JJLocalizedString(@"processing", nil)];
    
    [_baseFareHeaderLbl setText:JJLocalizedString(@"Base_Fare", nil)];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
       [self getFareData];
}




-(void)getFareData
{
    NSDictionary * parameter=@{@"user_id":[Themes getUserID],
                               @"ride_id":RideID};
    [Themes StartView:self.view];
    UrlHandler * web=[UrlHandler UrlsharedHandler];
    [web FareBreakUp:parameter success:^(NSMutableDictionary *responseDictionary) {
        if ([responseDictionary count]>0)
        {
        [Themes StopView:self.view];
        responseDictionary=[Themes writableValue:responseDictionary];
        NSString * status=[responseDictionary valueForKey:@"status"];
               [Themes StopView:self.view];

            if ([status isEqualToString:@"1"])
            {
                self.retryView.hidden = YES;
                [Themes StopView:self.view];

                Currency=[Themes findCurrencySymbolByCode:[[responseDictionary valueForKey:@"response" ] valueForKey:@"currency"]];
                
                
                NSString * imageStr=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"driverinfo"]valueForKey:@"image"];
                  NSString * ratingStr=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"driverinfo"]valueForKey:@"ratting"];
                   _driverName.text=[[[responseDictionary valueForKey:@"response" ] valueForKey:@"driverinfo"]valueForKey:@"name"];
                
                _gateway=[[[responseDictionary valueForKey:@"response"]valueForKey:@"payment"]valueForKey:@"code"];
                [_image_driver sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"driverSample.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
                CouponAmount=[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"coupon_amount"];
               
                if ([CouponAmount isEqualToString:@"0.00"]) {
                   
                }
                NSInteger tipAmt= [[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"tip_amount"] integerValue];
                if(tipAmt>0){
                    tipEnterView.hidden=YES;
                    tipsRemoveView.hidden=NO;
                    tipsLbl.text=[NSString stringWithFormat:@"%@%@",Currency,[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"tip_amount"]];
                }else{
                    tipEnterView.hidden=NO;
                    tipsRemoveView.hidden=YES;
                }
               
                

                Distance_unit=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"distance_unit"]];
                NSString * timeDuration=[Themes checkNullValue:[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"ride_duration"]];
                NSString * timeUnit=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"ride_duration_unit"]];
                durationTimeLbl.text=[NSString stringWithFormat:@"%@ %@",timeDuration,timeUnit];
                
                  NSString * distanceTaken=[Themes checkNullValue:[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"ride_distance"]];
                    distanceLbl.text=[NSString stringWithFormat:@"%@ %@",distanceTaken,Distance_unit];
                
                   NSString * subTotalStr=[Themes checkNullValue:[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"sub_total"]];
                   NSString * serviceTaxStr=[Themes checkNullValue:[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"tax_amount"]];
                subTotalLbl.text=[NSString stringWithFormat:@"%@%@",Currency,subTotalStr];
                serviceTaxLbl.text=[NSString stringWithFormat:@"%@%@",Currency,serviceTaxStr];
                
                NSString * BaseAmount=[Themes checkNullValue:[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"base_fare"]];
                
                _baseFareAmtLbl.text=[NSString stringWithFormat:@"%@%@",Currency,BaseAmount];
                
                
                
                tripTotalLbl.text=[NSString stringWithFormat:@"%@%@",Currency,[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"total"]];
                tripTotalLbl.numberOfLines = 0;
                tripTotalLbl.adjustsFontSizeToFitWidth = YES;
                tripTotalLbl.lineBreakMode = NSLineBreakByClipping;
                [self loadRating:[Themes checkNullValue:ratingStr]];
                stripe_connected=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"stripe_connected"]];
                payment_timeout=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"]valueForKey:@"fare"] valueForKey:@"payment_timeout"]];
                if([stripe_connected  isEqualToString: @"Yes"])
                {
                float Timing = [payment_timeout floatValue];

                    payment_timer=[NSTimer scheduledTimerWithTimeInterval: Timing
                                                                   target: self
                                                                 selector:@selector(invoke_payment)
                                                                 userInfo: nil repeats:YES];
    
                }
                
                _scrolling.contentSize=CGSizeMake(_scrolling.frame.size.width, self.tipEnterView.frame.origin.y+self.tipEnterView.frame.size.height+20);
            }
            else
            {
                self.retryView.hidden = NO;
                self.retryButton.hidden = NO;
                
                [Themes StopView:self.view];
            }
        }
    } failure:^(NSError *error) {
        
        self.retryView.hidden = NO;
        self.retryButton.hidden = NO;
        [Themes StopView:self.view];
        
    }];
    
}
-(void)loadRating:(NSString *)ratingCount{
    float rateCount=[ratingCount floatValue];
    self.driverRatingView.delegate = self;
    self.driverRatingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.driverRatingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
    self.driverRatingView.contentMode = UIViewContentModeScaleAspectFill;
    self.driverRatingView.maxRating = 5;
    self.driverRatingView.minRating = 0;
    self.driverRatingView.rating = rateCount;
    self.driverRatingView.editable = NO;
    self.driverRatingView.halfRatings = YES;
    self.driverRatingView.floatRatings = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shadow:(UIView*)View
{
    View.layer.shadowColor = [UIColor blackColor].CGColor;
    View.layer.shadowOpacity = 0.5;
    View.layer.shadowRadius = 1;
    View.layer.shadowOffset = CGSizeMake(1.5f,1.5f);
}
- (IBAction)payment_action:(id)sender {
    RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
    [objLoginVC setRideID_Rating:RideID];
    [self.navigationController pushViewController:objLoginVC animated:YES];
 //   [self invoke_payment];

}

-(void)paymentInfoDetails
{
    NSDictionary * parameters=@{@"user_id":[Themes checkNullValue: [Themes getUserID]],
                                @"ride_id":[Themes checkNullValue:RideID],
                                @"gateway":[Themes checkNullValue:_gateway],
                                
                                };
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    
    [web GetPaymentByGateway:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             //
             [Themes StopView:self.view];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 NSString *MobileId=[Themes checkNullValue:[responseDictionary valueForKey:@"mobile_id"]];
                 
                 [self continuePayment:MobileId];
             }
             
             else
             {
                 NSString * Response=[responseDictionary valueForKey:@"response"];
                 [self.view makeToast:Response];
             }
         }
         
         
         
     }
                     failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         if (self.errorCount<2) {
             [self paymentInfoDetails];
             self.errorCount++;
         }
         else{
             [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
             
         }
         // [SignUP_Btn setUserInteractionEnabled:YES];
         
     }];
    
}
-(void)continuePayment:(NSString *)paymentStr
{
    WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
    addfavour.isFromMobileGateway=YES;
    addfavour.MobileID=paymentStr;
    addfavour.Ride_ID=RideID;
    [self.navigationController pushViewController:addfavour animated:YES];
}


-(void)invoke_payment
{
    [payment_timer invalidate];

    if([stripe_connected  isEqual: @"Yes"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":RideID};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web AutoDetect:parameters success:^(NSMutableDictionary *responseDictionary)
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
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"Your_Payment_successfully_finished", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                     RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:RideID];
                     [self.navigationController pushViewController:objLoginVC animated:YES];
                     
                 }
             }
         }
                failure:^(NSError *error)
         {
             [Themes StopView:self.view];
         }];
    }
    else
    {
        [self paymentInfoDetails];
        
        
//        PaymentListVC *paymentlist=[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentlistVC"];
//        [paymentlist setRideID:RideID];
//        [self.navigationController pushViewController:paymentlist animated:YES];
        
//        PaymentVC * PaymentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentVCID"];
//        [PaymentVC setRideID:RideID];
//        [self.navigationController pushViewController:PaymentVC animated:YES];

    }

}
-(void)paymentListDetails
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==tipsTxtField)
    {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 3 || returnKey;
    }
    else if (textField==tipsTxtField)
    {
        if ([string isEqualToString:@"0"] && range.location == 0) {
            return NO;
        }
    }
    else if (textField==tipsTxtField)
        
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"123456789"] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
   
    return YES;
}

-(IBAction)goback_Action:(id)sender
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del LogIn];
}

#pragma mark Did Click retry

- (IBAction)didClickRetry:(id)sender {
    
    @try {
        
        if (!appDel) {
            appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        }
        
        if (appDel.isNetworkAvailable) {
            
            self.retryView.hidden=NO;
            self.retryButton.hidden = YES;
            [self getFareData];
        }
        else
        {
            self.retryView.hidden=NO;
            self.retryButton.hidden = NO;
            [self.view makeToast:@"No_Network_Connection"];
        }
       
    }
    @catch (NSException *exception) {
        
    }
    

}
- (IBAction)didClickTermsBtn:(id)sender {
    UIButton * btn=(UIButton *)sender;
    UIImage * img=[UIImage imageNamed:@"PaymentChecked"];
    if([btn.currentImage isEqual:img]){
        [btn setImage:[UIImage  imageNamed:@"PaymentUnchecked"] forState:UIControlStateNormal];
        self.applyBtn.hidden=YES;
        self.tipsTxtField.hidden=YES;
    }else{
            [btn setImage:[UIImage  imageNamed:@"PaymentChecked"] forState:UIControlStateNormal];
        self.applyBtn.hidden=NO;
        self.tipsTxtField.hidden=NO;
    }

}
- (IBAction)didClickApplyBtn:(id)sender {
    [self.view endEditing:YES];
    if(!([tipsTxtField.text intValue]==0||[tipsTxtField.text isEqualToString:@""]))
    {
        NSDictionary * parameters=@{@"tips_amount":[Themes checkNullValue:tipsTxtField.text],
                                    @"ride_id":[Themes checkNullValue:RideID]};
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        
        [web Add_Tips:parameters success:^(NSMutableDictionary *responseDictionary)
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
                     tipsLbl.text=[NSString stringWithFormat:@"%@%@",Currency,[[responseDictionary valueForKey:@"response"]valueForKey:@"tips_amount"]];
                     tripTotalLbl.text=[NSString stringWithFormat:@"%@%@",Currency,[[responseDictionary valueForKey:@"response"]valueForKey:@"total"] ];
                     tipEnterView.hidden=YES;
                     tipsRemoveView.hidden=NO;
                     
                 }
                 else
                 {
                     NSString* mesg=[Themes checkNullValue:[responseDictionary valueForKey:@"response"]];
                     [self.view makeToast:mesg];
                    
                 }
                 
             }
             
             
         }
              failure:^(NSError *error)
         {
             [Themes StopView:self.view];
              [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
         }];
    }
    else
    {  //dhiravida
        if([tipsTxtField.text isEqualToString:@""])
        {
            [self.view makeToast:JJLocalizedString(@"Kindly_Enter_Amt", nil)];
            
        }
        else{
            
            [self.view makeToast:JJLocalizedString(@"Amount_is_low", nil)];
        }
        
    }

}
- (IBAction)didClickTipsRemoveBtn:(id)sender {
      [self.view endEditing:YES];
    NSDictionary * parameters=@{@"ride_id":[Themes checkNullValue:RideID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    
    [web Remove_Tips:parameters success:^(NSMutableDictionary *responseDictionary)
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
                 tipsLbl.text=[NSString stringWithFormat:@"%@%@",Currency,[[responseDictionary valueForKey:@"response"]valueForKey:@"tips_amount"]];
                 tripTotalLbl.text=[NSString stringWithFormat:@"%@%@",Currency,[[responseDictionary valueForKey:@"response"]valueForKey:@"total"] ];
                 tipEnterView.hidden=NO;
                 tipsRemoveView.hidden=YES;
                  tipsTxtField.text=@"";
                 
             }
             else
             {
                 NSString* mesg=[Themes checkNullValue:[responseDictionary valueForKey:@"response"]];
                 [self.view makeToast:mesg];
             }
             
         }
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
     }];

}
@end
