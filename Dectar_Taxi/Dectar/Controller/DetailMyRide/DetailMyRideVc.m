//
//  DetailMyRideVc.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/26/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "DetailMyRideVc.h"
#import <CoreLocation/CoreLocation.h>
#import "UrlHandler.h"
#import "Themes.h"
#import "Blurview.h"
#import "Constant.h"
#import "RatingVC.h"
#import "DriverRecord.h"
#import "WebViewVC.h"
#import <MessageUI/MessageUI.h>
#import "NewTrackVC.h"
#import "CancelRideVC.h"
#import "PaymentVC.h"
#import "HelpVC.h"
#import "NewViewController.h"
#import "ReportVC.h"
#import "ReportRecord.h"
#import "RecordCell.h"
#import "IssuePopup.h"
#import "WBErrorNoticeView.h"


@interface DetailMyRideVc ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate,senddataDelegate>
{
    NSString * payment_Name,*paymnet_code;
    Blurview*bgView;
    NSString * Mobile_ID;
    NSString * statusCancel;
    NSString * Curerncysymbol;
    UIAlertView * AddTitlel;
    UITextField * title;
    UITextField * Email_fld,*ShareFld,*shareCountryCode;
    UIAlertView * EmailAlert,*ShareAlert;
    NSMutableArray * reasonArray;
    UITableView * reasontabl;
    DriverRecord *TrackObj;
    BOOL isCanceled;
    BOOL isVerified;
    NSString * resonID;
    NSIndexPath * _lastSelectedIndexPath;
    NSString * Display;
    NSMutableArray *RideIssueArray;

}

@end
@implementation DetailMyRideVc
@synthesize CarDetailsLabel,RideIDlabel,StatusLabl,mapBGView,PickUp_Latitude,PickUp_longitude,googlemap,camera,StatusPay,paymentArry,favourite,Scrolling,Status_Track,Status_Favour;
@synthesize Amount_txtFld,AddindTip_View,Apply_tip,Drop_Latitude,Drop_longitude,userRideId,detailePageDataArray;
@synthesize pickUpView,pickUpHeaderLbl,pickupSepLbl1,pickupLocImg,pickupTimerImg,pickupLocLbl,pickupTimerLbl,pickupSep2,DropView,DropHeaderLbl,DropSepLbl1,DropLocImg,DropTimerImg,DropLocLbl,DropTimerLbl,DropSep2,timeView,timeHeaderLbl,timeDistLbl,timeTakenLbl,timeWaitLbl,rateDetailView,rateHeaderView,detailTblView,rideOptionView,
completedOptionView,issueBtn,mailBtn,selectOptionStatus,pickUpAddressStr;


- (void)viewDidLoad {
    [super viewDidLoad];
    RideIssueArray=[[NSMutableArray alloc]init];
    Scrolling.hidden=YES;
    _topView.hidden=YES;
    _viewHelp.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RideStared:) name:@"Ride_start" object:nil];
    [Amount_txtFld setDelegate:self];
}
-(void)RideStared:(NSNotification *)notification
{
    if(self.view.window){
        rideOptionView.hidden=NO;
        completedOptionView.hidden=YES;
        [self loadOptionAccordingToStatus:2];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
     [self retrieveMyRideslist];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Ride_Details", nil)];
    [Apply_tip setTitle:JJLocalizedString(@"Apply", nil) forState:UIControlStateNormal];
    [issueBtn setTitle:JJLocalizedString(@"Report_issues", nil) forState:UIControlStateNormal];
    [mailBtn setTitle:JJLocalizedString(@"Mail_Invoice", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackTo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addFavour:(id)sender {
    
    if ([Status_Favour isEqualToString:@"1"])
    {
        [self.view makeToast:JJLocalizedString(@"You_already_add_this_location", nil)];
    }
    else
    {
        AddTitlel = [[UIAlertView alloc]
                     initWithTitle:JJLocalizedString(@"ENTER_YOUR_FAVORITE_ADDRESS", nil)
                     message:@""
                     delegate:self
                     cancelButtonTitle:JJLocalizedString(@"CANCEL_Caps", nil)
                     otherButtonTitles:JJLocalizedString(@"APPLY_Caps", nil), nil];
        [AddTitlel setAlertViewStyle:UIAlertViewStylePlainTextInput];
        title=[AddTitlel textFieldAtIndex:0];
        title.textAlignment=NSTextAlignmentCenter;
        [title setBorderStyle:UITextBorderStyleNone];
        [title setKeyboardType:UIKeyboardTypeEmailAddress];
        title.autocapitalizationType=NO;
        [AddTitlel show];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==AddTitlel)
    {
        if (buttonIndex==1)
        {
            if ([title.text isEqualToString:@""])
            {
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Sorry", nil) message:JJLocalizedString(@"Please_Enter_the_title_for_your_favorite", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                [Alert show];
            }
        else
        {
            [self setFavourite];
        }
        }
    }
    else if (alertView==EmailAlert)
    {
        if (buttonIndex==1)
        {
            if(Email_fld.text.length==0){
                [self.view makeToast:JJLocalizedString(@"Email_is_mandatory", nil)];
            }else if (![Themes NSStringIsValidEmail:Email_fld.text])

            {
                  [self.view makeToast:JJLocalizedString(@"Please_Enter_Valid_Email", nil)];
                 isVerified=NO;
            }
            else
            {
                 isVerified=YES;
                [self Mail_Invoice];
            }
        }
    }
    else if (alertView==ShareAlert)
    {
        if (buttonIndex==1)
        {
            if ([ShareFld.text length]<=0)
            {
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Sorry", nil) message:JJLocalizedString(@"Please_Enter_Mobile_Number", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                [Alert show];
            }
            else
            {
                [self sendMSG];
            }
        }
    }
}
-(void)Mail_Invoice

{
    if (isVerified==YES)
    {
        NSDictionary * parameters=@{@"email":[Themes checkNullValue:Email_fld.text],
                                    @"ride_id":[Themes checkNullValue:userRideId]};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web MailInvoice:parameters success:^(NSMutableDictionary *responseDictionary)
         
         {
             NSLog(@"%@",responseDictionary);
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
                 responseDictionary=[Themes writableValue:responseDictionary];
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     NSString * messageString=[Themes checkNullValue:[responseDictionary valueForKey:@"response"]];
                     [self.view makeToast:messageString];
                     favourite.hidden=YES;
                     
                     
                 }
                 else
                 {
                     NSString * messageString=[Themes checkNullValue:[responseDictionary valueForKey:@"response"]];
                     [self.view makeToast:messageString];
                     
                 }
                 
             }
             
             
         }
         
                 failure:^(NSError *error)
         {
             [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
             [Themes StopView:self.view];
         }];
    }
    else{
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(@"Please_Enter_Valid_Email", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
        [Alert show];}
}

-(void)sendMSG
{
    NSDictionary * Parameter=@{@"ride_id":RideIDlabel.text,
                               @"mobile_no":ShareFld.text};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web ETAshare:Parameter success:^(NSMutableDictionary *responseDictionary)
     {
        
        NSLog(@"%@",responseDictionary);
        [Themes StopView:self.view];
        
        if ([responseDictionary count]>0)
        {
            responseDictionary=[Themes writableValue:responseDictionary];
            NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
            [Themes StopView:self.view];
            
            if ([comfiramtion isEqualToString:@"1"])
            {
                NSString * messageString=[responseDictionary valueForKey:@"response"];
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"\xF0\x9F\x91\x8D" message:messageString delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                [Alert show];
                
                
            }
            else
            {
                NSString * messageString=[responseDictionary valueForKey:@"response"];
                NSString *titleStr = JJLocalizedString(@"Oops", nil);
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:messageString delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                [Alert show];
                
            }
            
        }
    } failure:^(NSError *error) {
        [Themes StopView:self.view];

    }];
    
}
-(void)setFavourite
{
    
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",PickUp_Latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",PickUp_longitude];
    
    NSDictionary * parameters=@{@"title":title.text,
                                @"latitude":PicklatitudeStr,
                                @"longitude":PicklongitudeStr,
                                @"address":[Themes checkNullValue:pickUpAddressStr],
                                @"user_id":[Themes getUserID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web SaveFavourite:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             [Themes StopView:self.view];
             if ([comfiramtion isEqualToString:@"1"])
             {
                 Status_Favour=@"1";
                 [favourite setImage:[UIImage imageNamed:@"Nolike"] forState:UIControlStateNormal];
                 [self.view makeToast:[Themes checkNullValue:[responseDictionary valueForKey:@"message"]]];
             }
             else
             {
                 NSString * messageString=[Themes checkNullValue:[responseDictionary valueForKey:@"message"]];
                 [self.view makeToast:messageString];
             }
         }
     }
               failure:^(NSError *error)
     {
            [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
         [Themes StopView:self.view];
     }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==Email_fld)
    {
        if(Email_fld.text.length==0){
            [self.view makeToast:JJLocalizedString(@"Email_is_mandatory", nil)];
        }else if (![Themes NSStringIsValidEmail:Email_fld.text])
        {
            [self.view makeToast:JJLocalizedString(@"Please_Enter_Valid_Email", nil)];
           /// [textField becomeFirstResponder];
            isVerified=NO;
        }
        else
        {
            [textField resignFirstResponder];
            isVerified=YES;
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==Amount_txtFld)
    {
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 3 || returnKey;

    }
    if (textField==Amount_txtFld)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"123456789"] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if (textField==ShareFld)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 15;
    }
    else
    {
        NSString *resultingString = [Email_fld.text stringByReplacingCharactersInRange: range withString: string];
        NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
        if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound)
        {
            return YES;
        }  else  {
            return NO;
        }
    }
   
}

   

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==Amount_txtFld)
    {
        Scrolling.contentOffset=CGPointMake(0, 250);
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (Amount_txtFld) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:JJLocalizedString(@"Done", nil)
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        Amount_txtFld.inputAccessoryView = keyboardDoneButtonView;
    }
    if (ShareFld) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:JJLocalizedString(@"Done", nil)
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(doneClickedAction:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        ShareFld.inputAccessoryView = keyboardDoneButtonView;
    }
}
- (void)doneClicked:(id)sender
{
    [Amount_txtFld resignFirstResponder];
    Scrolling.contentOffset=CGPointMake(0, 0);
}
- (void)doneClickedAction:(id)sender
{
    [ShareFld resignFirstResponder];
}
  - (IBAction)Remove_action:(id)sender {
      
      NSDictionary * parameters=@{@"ride_id":RideIDlabel.text};
      
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
                   AddindTip_View.hidden=YES;
                   Amount_txtFld.text=@"";
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
- (IBAction)Apply_action:(id)sender {
    
    NSDictionary * parameters=@{@"tips_amount":Amount_txtFld.text,
                                @"ride_id":RideIDlabel.text};
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
               


             }
             else
             {
                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(@"Kindly_enter_your_tips", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }
         
     }
          failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
    

   }

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
        if(scrollView == Scrolling){
          
             if(Scrolling.contentOffset.y>0){
                 CGFloat offset =  Scrolling.contentOffset.y;
                 
                 
                 CGFloat percentage  = offset / 215;
                 
                 CGFloat value  = _headView.frame.size.height * percentage;
                 _headView.frame = CGRectMake(0, value, _headView.bounds.size.width, 215 - value);
                 NSLog(@"%f",Scrolling.contentOffset.y);
             }else{
                   [Scrolling setContentOffset:CGPointMake(0, 0) animated:NO];
                  _headView.frame = CGRectMake(0,0,  _headView.frame.size.width ,  _headView.frame.size.height);
             }
          
        }else{
             //
        }
}



-(void)retrieveMyRideslist
{
    
    NSDictionary * parameters=@{@"user_id":[Themes checkNullValue:[Themes getUserID]],
                                @"ride_id":[Themes checkNullValue:userRideId]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GetMyRide:parameters success:^(NSMutableDictionary *responseDictionary)
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
                 MyRideRecord * objcRecored=[[MyRideRecord alloc]init];
                 objcRecored.cab_type=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"cab_type"];
                 objcRecored.ride_id_detls =[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"ride_id"] ;
                 objcRecored.ride_status=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"ride_status"];
                 objcRecored.DisPlay_status=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"disp_status"];
                 
                 
                 objcRecored.Currency=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"currency"];
                 objcRecored.CancelStatus=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"do_cancel_action"];
                 
                 objcRecored.Track_Status=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"do_track_action"];
                 objcRecored.Favourite_Status=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"is_fav_location"];
                 Status_Favour=[Themes checkNullValue:objcRecored.Favourite_Status];
                 objcRecored.location=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pickup"] valueForKey:@"location"];
                 pickUpAddressStr=[Themes checkNullValue: objcRecored.location];
                 objcRecored.lon=[NSString stringWithFormat:@"%@",[[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pickup"]  valueForKey:@"latlong"] valueForKey:@"lon"]];
                 objcRecored.lat=[NSString stringWithFormat:@"%@",[[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pickup"]  valueForKey:@"latlong"] valueForKey:@"lat"]];
                 objcRecored.drop_date=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"drop_date"];
                 
                 objcRecored.Drop_lat=[NSString stringWithFormat:@"%@",[[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"drop"]  valueForKey:@"latlong"] valueForKey:@"lat"]];
                   objcRecored.DropLocation=[NSString stringWithFormat:@"%@",[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"drop"]  valueForKey:@"location"] ];
                 objcRecored.Drop_lon=[NSString stringWithFormat:@"%@",[[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"drop"]  valueForKey:@"latlong"] valueForKey:@"lon"]];
                 objcRecored.pickup_date=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pickup_date"];
                 objcRecored.payStatus=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"pay_status"];
                 
                 objcRecored.total_bill=[NSString stringWithFormat:@"%@",[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"total_bill"]] ;
                 objcRecored.Tip_Amount=[NSString stringWithFormat:@"%@",[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"tips_amount"]] ;
                 objcRecored.Coupon_Discount=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"coupon_discount"] ;
                 objcRecored.grand_Bill=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"grand_bill"];
                 objcRecored.total_paid=[NSString stringWithFormat:@"%@",[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"total_paid"]];
                 objcRecored.Wallet_usage=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare"] valueForKey:@"wallet_usage"];
                 objcRecored.distance_unit=[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"distance_unit"] ;
    
                     objcRecored.ride_distance=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"summary"]valueForKey:@"ride_distance"] ;
                     objcRecored.ride_duration=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"summary"]valueForKey:@"ride_duration"] ;
                     objcRecored.waiting_duration=[[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"summary"]valueForKey:@"waiting_duration"];
                 for (NSDictionary * dict1 in responseDictionary[@"response"][@"reports"][@"rydd_issues"]) {
                     ReportRecord *objreportRec=[[ReportRecord alloc]init];
                     objreportRec.custom=[Themes checkNullValue:[dict1 valueForKey:@"custom"]];
                     objreportRec.issue=[Themes checkNullValue:[dict1 valueForKey:@"issue"]];
                     objreportRec.type=[Themes checkNullValue:[dict1 valueForKey:@"type"]];
                     [RideIssueArray addObject:objreportRec];
                 }

                 
                 if([Status_Favour isEqualToString:@"1"]){
                     [favourite setImage:[UIImage imageNamed:@"Nolike"] forState:UIControlStateNormal];
                 }else{
                         [favourite setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
                 }
                 
                 NSDictionary *FareDict =[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"] valueForKey:@"fare_summary"];
                 detailePageDataArray=[[NSMutableArray alloc]init];
                 for (NSDictionary * fDict in FareDict) {
                     DetailPageRecord * objRateRecs=[[DetailPageRecord alloc]init];
                     objRateRecs.hearderTitle=[Themes checkNullValue:[fDict objectForKey:@"title"]];
                     objRateRecs.descMain=[NSString stringWithFormat:@"%@%@",[Themes checkNullValue:[fDict objectForKey:@"value"] ],[Themes findCurrencySymbolByCode:[Themes checkNullValue:objcRecored.Currency]]];
                     [detailePageDataArray addObject:objRateRecs];
                 }
                 [self loadDatasInDetail:objcRecored];
                    Scrolling.hidden=NO;
                  _topView.hidden=NO;
             }else{
                   [self.view makeToast:[Themes checkNullValue:[responseDictionary objectForKey:@"response"]]];
             }
         }
     }
           failure:^(NSError *error)
     {
          [Themes StopView:self.view];
         if(self.errorCount<2){
             [self retrieveMyRideslist];
             self.errorCount++;
         }else{
             [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
         }
        
        
     }];
}
-(void)loadDatasInDetail:(MyRideRecord *)riderRec{
    StatusLabl.text=riderRec.DisPlay_status;
    CarDetailsLabel.text=riderRec.cab_type;
    RideIDlabel.text=riderRec.ride_id_detls;
       PickUp_Latitude=[riderRec.lat floatValue];
        PickUp_longitude=[riderRec.lon floatValue];
    camera = [GMSCameraPosition cameraWithLatitude:PickUp_Latitude
                                         longitude:PickUp_longitude
                                              zoom:15];
    [googlemap animateToCameraPosition:camera];
    googlemap = [GMSMapView mapWithFrame:CGRectMake(0, 0, mapBGView.frame.size.width , mapBGView.frame.size.height) camera:camera];
    if (MapNightMode==1) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSURL *styleUrl = [mainBundle URLForResource:@"Style" withExtension:@"json"];
        NSError *error;
        GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
        if (!style) {
            NSLog(@"The style definition could not be loaded: %@", error);
        }
        else{
            googlemap.mapStyle = style;
        }
    }

    
       Drop_Latitude=[riderRec.Drop_lat floatValue];
    Drop_longitude=[riderRec.Drop_lon floatValue];
    
    GMSMarker *PickUP_Marker=[[GMSMarker alloc]init];
       GMSMarker * Drop_Marker=[[GMSMarker alloc]init];
    if(PickUp_Latitude!=0){
        PickUP_Marker.position=CLLocationCoordinate2DMake(PickUp_Latitude, PickUp_longitude);
        PickUP_Marker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon2 = [UIImage imageNamed:@"pickuploc"];
        PickUP_Marker.icon = markerIcon2;
        PickUP_Marker.map = googlemap;
    }
    if(Drop_Latitude!=0){
        Drop_Marker.position=CLLocationCoordinate2DMake(Drop_Latitude, Drop_longitude);
        Drop_Marker.appearAnimation=kGMSMarkerAnimationPop;
        UIImage *markerIcon2 = [UIImage imageNamed:@"droploc"];
        Drop_Marker.icon = markerIcon2;
        Drop_Marker.map = googlemap;
        [self DrawDirectionPath:PickUp_Latitude userlng:PickUp_longitude drop:Drop_Latitude droplng:Drop_longitude];
    }
    googlemap.userInteractionEnabled=NO;
    [mapBGView addSubview:googlemap];
    [self setDataAndFrame:riderRec];
}
-(void)setDataAndFrame:(MyRideRecord *)riderRec{
    NSString * dropStr=[Themes checkNullValue:riderRec.DropLocation];
    
    NSString * dropTimeStr=[Themes checkNullValue:riderRec.drop_date];
    
    pickUpHeaderLbl.text=JJLocalizedString(@"Pickup_Details", nil);
     pickupLocLbl.numberOfLines=0;
    pickupLocLbl.text=[Themes checkNullValue:riderRec.location];
     [pickupLocLbl sizeToFit];
     pickupSepLbl1.frame=CGRectMake(pickupSepLbl1.frame.origin.x, pickupLocLbl.frame.origin.y+pickupLocLbl.frame.size.height+5, pickupSepLbl1.frame.size.width, pickupSepLbl1.frame.size.height);
      pickupTimerLbl.text=[Themes checkNullValue:riderRec.pickup_date];
    
    pickupTimerImg.frame=CGRectMake(pickupTimerImg.frame.origin.x, pickupLocLbl.frame.origin.y+pickupLocLbl.frame.size.height+12, DropTimerImg.frame.size.width, pickupTimerImg.frame.size.height);
    pickupTimerLbl.frame=CGRectMake(pickupTimerLbl.frame.origin.x,   pickupTimerImg.frame.origin.y, pickupTimerLbl.frame.size.width, pickupTimerLbl.frame.size.height);
    pickupSep2.frame=CGRectMake(pickupSep2.frame.origin.x, pickupTimerLbl.frame.origin.y+pickupTimerLbl.frame.size.height+5, DropSep2.frame.size.width, pickupSep2.frame.size.height);
    pickUpView.frame=CGRectMake(pickUpView.frame.origin.x, pickUpView.frame.origin.y, pickUpView.frame.size.width, pickupSep2.frame.origin.y+pickupSep2.frame.size.height);
    
    if(dropStr.length>0){
         DropView.hidden=NO;
        DropHeaderLbl.text=JJLocalizedString(@"Drop_Details", nil);
        DropLocLbl.numberOfLines=0;
        DropLocLbl.text=dropStr;
        [DropLocLbl sizeToFit];
        DropSepLbl1.frame=CGRectMake(DropSepLbl1.frame.origin.x, DropLocLbl.frame.origin.y+DropLocLbl.frame.size.height+5, DropSepLbl1.frame.size.width, DropSepLbl1.frame.size.height);
        if(dropTimeStr.length>0){
            DropTimerImg.hidden=NO;
            DropTimerLbl.hidden=NO;
            DropSep2.hidden=NO;
            DropTimerLbl.text=dropTimeStr;
            DropTimerImg.frame=CGRectMake(DropTimerImg.frame.origin.x, DropLocLbl.frame.origin.y+DropLocLbl.frame.size.height+12, DropTimerImg.frame.size.width, DropTimerImg.frame.size.height);
            DropTimerLbl.frame=CGRectMake(DropTimerLbl.frame.origin.x,   DropTimerImg.frame.origin.y, DropTimerLbl.frame.size.width, DropTimerLbl.frame.size.height);
            DropSep2.frame=CGRectMake(DropSep2.frame.origin.x, DropTimerLbl.frame.origin.y+DropTimerLbl.frame.size.height+5, DropSep2.frame.size.width, DropSep2.frame.size.height);
            DropView.frame=CGRectMake(DropView.frame.origin.x, pickUpView.frame.origin.y+pickUpView.frame.size.height, DropView.frame.size.width, DropSep2.frame.origin.y+DropSep2.frame.size.height);
        }else{
            DropTimerImg.hidden=YES;
            DropTimerLbl.hidden=YES;
            DropSep2.hidden=YES;
            DropView.frame=CGRectMake(DropView.frame.origin.x, pickUpView.frame.origin.y+pickUpView.frame.size.height, DropView.frame.size.width, DropSepLbl1.frame.origin.y+DropSepLbl1.frame.size.height);
        }
    }else{
        DropView.hidden=YES;
        DropView.frame=CGRectMake(DropView.frame.origin.x, pickUpView.frame.origin.y+pickUpView.frame.size.height, DropView.frame.size.width, 0);
    }
    if ([riderRec.ride_status isEqualToString:@"Completed"]|| [riderRec.ride_status isEqualToString:@"Finished"])
    {
        timeView.hidden=NO;
        rateDetailView.hidden=NO;
        timeHeaderLbl.text=JJLocalizedString(@"Ride_Details", nil);
    
        timeDistLbl.text=[NSString stringWithFormat:@"%@ %@\n%@",riderRec.ride_distance,riderRec.distance_unit,JJLocalizedString(@"ride_distance", nil)];
        timeTakenLbl.text=[NSString stringWithFormat:@"%@\n%@",riderRec.ride_duration,JJLocalizedString(@"time_taken", nil)];
        timeWaitLbl.text=[NSString stringWithFormat:@"%@\n%@",riderRec.waiting_duration, JJLocalizedString(@"wait_time", nil)];
        timeView.frame=CGRectMake(timeView.frame.origin.x, DropView.frame.origin.y+DropView.frame.size.height, timeView.frame.size.width, timeView.frame.size.height);
        if([detailePageDataArray count]>0){
            rateHeaderView.text=JJLocalizedString(@"Fare_Details", nil);
            detailTblView.frame=CGRectMake(detailTblView.frame.origin.x, detailTblView.frame.origin.y, detailTblView.frame.size.width, 300);
            [detailTblView reloadData];
            [_tableIssue reloadData];
             rateDetailView.hidden=NO;
            detailTblView.frame=CGRectMake(detailTblView.frame.origin.x, detailTblView.frame.origin.y, detailTblView.frame.size.width, detailTblView.contentSize.height);
            rateDetailView.frame=CGRectMake(rateDetailView.frame.origin.x, timeView.frame.origin.y+timeView.frame.size.height, rateDetailView.frame.size.width, detailTblView.frame.origin.y+detailTblView.frame.size.height);
            if( [riderRec.ride_status isEqualToString:@"Finished"]){
                AddindTip_View.hidden=YES;
                AddindTip_View.frame=CGRectMake(AddindTip_View.frame.origin.x, rateDetailView.frame.origin.y+rateDetailView.frame.size.height, AddindTip_View.frame.size.width, 0);
            }else{
                AddindTip_View.hidden=YES;
                AddindTip_View.frame=CGRectMake(AddindTip_View.frame.origin.x, rateDetailView.frame.origin.y+rateDetailView.frame.size.height, AddindTip_View.frame.size.width, 0);
            }
        }
                        else{
            rateDetailView.hidden=YES;
              AddindTip_View.hidden=YES;
            rateDetailView.frame=CGRectMake(rateDetailView.frame.origin.x, timeView.frame.origin.y+timeView.frame.size.height, rateDetailView.frame.size.width, 0);
             AddindTip_View.frame=CGRectMake(AddindTip_View.frame.origin.x, rateDetailView.frame.origin.y+rateDetailView.frame.size.height, AddindTip_View.frame.size.width, 0);
        }
    }
    else{
        timeView.hidden=YES;
        rateDetailView.hidden=YES;
         AddindTip_View.hidden=YES;
         timeView.frame=CGRectMake(timeView.frame.origin.x, DropView.frame.origin.y+DropView.frame.size.height, timeView.frame.size.width, 0);
        rateDetailView.frame=CGRectMake(rateDetailView.frame.origin.x, timeView.frame.origin.y+timeView.frame.size.height, rateDetailView.frame.size.width, 0);
         AddindTip_View.frame=CGRectMake(AddindTip_View.frame.origin.x, rateDetailView.frame.origin.y+rateDetailView.frame.size.height, AddindTip_View.frame.size.width, 0);
    }
    if ([RideIssueArray count]>0) {
        _tableIssue.frame=CGRectMake(_tableIssue.frame.origin.x, _tableIssue.frame.origin.y, _tableIssue.frame.size.width,_tableIssue.contentSize.height);
        _btnSubmit.frame=CGRectMake(_btnSubmit.frame.origin.x, _tableIssue.frame.origin.y+_tableIssue.frame.size.height, _btnSubmit.frame.size.width,_btnSubmit.frame.size.height);
        _viewHelp.frame=CGRectMake(_viewHelp.frame.origin.x,rateDetailView.frame.origin.y+rateDetailView.frame.size.height ,_viewHelp.frame.size.width, _btnSubmit.frame.origin.y+_btnSubmit.frame.size.height);
    }
    else{
        _viewHelp.frame=CGRectMake(_viewHelp.frame.origin.x,rateDetailView.frame.origin.y+rateDetailView.frame.size.height ,_viewHelp.frame.size.width, 0);

    }
    Scrolling.contentSize=CGSizeMake(Scrolling.frame.size.width, _viewHelp.frame.origin.y+_viewHelp.frame.size.height+60);
       _bottomView.hidden=NO;
    if ([riderRec.ride_status isEqualToString:@"Arrived"]||[riderRec.ride_status isEqualToString:@"Confirmed"]) {
        rideOptionView.hidden=NO;
        completedOptionView.hidden=YES;
        _viewHelp.hidden=YES;
           if([riderRec.CancelStatus isEqualToString:@"1"]){
                  [self loadOptionAccordingToStatus:1];
           }else{
                  [self loadOptionAccordingToStatus:5];
           }
     
    }else if([riderRec.ride_status isEqualToString:@"Onride"]) {
        rideOptionView.hidden=NO;
        completedOptionView.hidden=YES;
        _viewHelp.hidden=YES;
        [self loadOptionAccordingToStatus:2];
    }
    else if([riderRec.ride_status isEqualToString:@"Finished"]) {
        rideOptionView.hidden=NO;
        completedOptionView.hidden=YES;
        _viewHelp.hidden=NO;

        [self loadOptionAccordingToStatus:3];
    }
    else if([riderRec.ride_status isEqualToString:@"Completed"]) {
        rideOptionView.hidden=YES;
        completedOptionView.hidden=NO;
        _viewHelp.hidden=NO;

        [self loadOptionAccordingToStatus:3];
    }
    else if([riderRec.ride_status isEqualToString:@"Booked"]) {
        rideOptionView.hidden=NO;
        completedOptionView.hidden=YES;
        _viewHelp.hidden=YES;

        if([riderRec.CancelStatus isEqualToString:@"1"]){
              [self loadOptionAccordingToStatus:4];
        }else{
            _bottomView.hidden=YES;
            _viewHelp.hidden=YES;

        }
    }
    else if([riderRec.ride_status isEqualToString:@"Cancelled"]) {
        _bottomView.hidden=YES;
        _viewHelp.hidden=YES;

    }
}
-(void)loadOptionAccordingToStatus:(NSInteger )status{
    
    if(obj==nil){
        obj = [[FFAPSegmentedControl alloc] initWithFrame:CGRectMake(0,0,rideOptionView.frame.size.width+4,rideOptionView.frame.size.height)];
    }
    selectOptionStatus=status;
    if(status==1){
        obj.listOptions = @[JJLocalizedString(@"Cancel_Trip", nil),JJLocalizedString( @"Track_Driver", nil)];//JJLocalizedString( @"Share_My_Ride", (second)nil),
    }
    else if (status==2){
        obj.listOptions = @[JJLocalizedString( @"Track_Driver", nil)];//JJLocalizedString( @"Share_My_Ride", nil),(first)
    }
    else if (status==3){
        obj.listOptions = @[JJLocalizedString( @"Track_Driver", nil),JJLocalizedString( @"Payment", nil)];//JJLocalizedString( @"Share_My_Ride", nil),(first)
    }
    else if (status==4){
        obj.listOptions = @[JJLocalizedString( @"Cancel_Trip", nil)];
    }
    else if (status==5){
           obj.listOptions = @[JJLocalizedString( @"Track_Driver", nil)];//JJLocalizedString( @"Share_My_Ride", nil),(first)
    }
    
    obj.normalBackgroundColor =BGCOLOR;
    obj.normalTextColor = [UIColor whiteColor];
    
    obj.normalBorderColor = [UIColor lightGrayColor];
    obj.selectedBackgroundColor =BGCOLOR;
    obj.selectedBorderColor = [UIColor lightGrayColor];
    obj.delegate=self;
    obj.selectedImage = [UIImage imageNamed:@""];
    obj.borderWidth = 2.0f;
    [rideOptionView addSubview:obj];
}
-(void)didselectOptionIndex:(NSInteger)index{
    if (selectOptionStatus==1) {
        if(index==0){
            [self moveToCancelRide];
        }
//        else if (index==1){
//            [self moveToShareRide];
//        }
        else if (index==1){
            [self moveToTrackDriver];
        }
        
    }else if (selectOptionStatus==2){
//        if(index==0){
//              [self moveToShareRide];
//        }
         if (index==0){
                [self moveToTrackDriver];
        }
    }
    else if (selectOptionStatus==3){
//        if(index==0){
//             [self moveToShareRide];
//        }
         if (index==0){
              [self moveToTrackDriver];
        }
        else if (index==1){
             [self moveToPayment];
        }
    }
    else if (selectOptionStatus==4){
        if(index==0){
            [self moveToCancelRide];
        }
    }
    if (selectOptionStatus==5) {
//        if(index==0){
//          [self moveToShareRide];
//        }
         if (index==0){
            [self moveToTrackDriver];
        }
    }
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
                 singleLine.strokeColor = BGCOLOR;
                 singleLine.map = googlemap;
                 CLLocationCoordinate2D pickPosition = CLLocationCoordinate2DMake(userlat, userlng);
                  CLLocationCoordinate2D dropPosition = CLLocationCoordinate2DMake(droplat, droplng);
                 GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:pathDrawn];
                 GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
                 bounds = [bounds initWithCoordinate:pickPosition   coordinate:dropPosition];
                 [googlemap animateWithCameraUpdate:update];
                 
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
-(NSDictionary *)setParametersDrawLocation:(CGFloat )loclat withLocLong:(CGFloat)locLong withDestLoc:(CGFloat)destLoc withDestLonf:(CGFloat)destLong{
    
    NSDictionary *dictForuser = @{
                                  @"origin":[NSString stringWithFormat:@"%f,%f",loclat,locLong],
                                  @"destination":[NSString stringWithFormat:@"%f,%f",destLoc,destLong],
                                  @"sensor":@"true",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount=0;
    if (tableView==detailTblView) {
        rowCount=[detailePageDataArray count];
    }
    else if (tableView==_tableIssue)
    {
        rowCount=[RideIssueArray count];
    }
    return rowCount;
    //return [detailePageDataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==detailTblView) {
        FareDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FareDetailCellIdentifier"];
        if (cell == nil) {
            cell = [[FareDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"FareDetailCellIdentifier"];
        }
        DetailPageRecord * objRateRecs=[[DetailPageRecord alloc]init];
        objRateRecs=[detailePageDataArray objectAtIndex:indexPath.row];
        [cell setDatasToFareCell:objRateRecs];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }
   
   else
   {
       NSString *reuseIdentifier = @"recordCell"; //should match what you've set in Interface Builder
       RecordCell *recCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
       if (recCell == nil)
       {
           recCell = [[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:nil options:nil] objectAtIndex:0];
           
       }
       recCell.selectionStyle=UITableViewCellSelectionStyleNone;
       ReportRecord *recRep=(ReportRecord *)[RideIssueArray objectAtIndex:indexPath.row];
       recCell.lblReportIssue.text=recRep.issue;
       if (recRep.isSelected==YES) {
           recCell.lblSelect.backgroundColor=BGCOLOR;
           
       }
       else{
           recCell.lblSelect.backgroundColor=[UIColor clearColor];

       }

       return recCell;
       
 
       }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i=0;i<RideIssueArray.count; i++) {
        ReportRecord *recRep=(ReportRecord *)[RideIssueArray objectAtIndex:i];
        if (indexPath.row==i) {
            recRep.isSelected=YES;
            _issueReasonStr=recRep.type;
            _selectedReasonRow=indexPath.row;
            _issueReasonTextStr=[Themes checkNullValue:recRep.issue];

    }
        else{
            recRep.isSelected=NO;
        }
        ReportRecord *record=(ReportRecord *)[RideIssueArray objectAtIndex:indexPath.row];
        [_tableIssue reloadData];
        if ([record.custom isEqualToString:@"yes"]) {
            
            [self SetDataToPopup];
        }

}

}
-(void)sendDataToA:(NSString *)txtStr
{
    if (txtStr.length==0) {
        [self ReloadTableviewDatas];
    }
    else{
        _issueReasonTextStr=[Themes checkNullValue:txtStr];
    }
    
    
}
-(void)ReloadTableviewDatas
{
    for (int i=0; i<RideIssueArray.count; i++) {
        ReportRecord *recRep=(ReportRecord *)[RideIssueArray objectAtIndex:i];
        
        recRep.isSelected=NO;
        
        
    }
        _issueReasonTextStr=@"";
    _issueReasonStr=@"";
    [_tableIssue reloadData];
}

    -(void)SetDataToPopup
    {
        
        IssuePopup *issueVC=[self.storyboard instantiateViewControllerWithIdentifier:@"IssuePopupVC"];
        //[self presentViewController:issueVC animated:NO completion:nil];
        if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
        {
            //For iOS 8
            issueVC.providesPresentationContextTransitionStyle = YES;
            issueVC.definesPresentationContext = YES;
            issueVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        else
        {
            //For iOS 7
            issueVC.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
        issueVC.delegate=self;
        
        [self presentViewController:issueVC animated:NO completion:nil];
    }

- (IBAction)didClickSubmitBtn:(id)sender {
    if (_issueReasonTextStr.length>0 && _issueReasonStr.length>0) {
        [self addReportsDetails];
    }
    else{
        [self showErrorMessage:@"Please Select an issue"];
        
    }

    
}
-(void)addReportsDetails
{
    
    
    
    NSDictionary * parameters=@{@"user_id":[Themes checkNullValue: [Themes getUserID]],
                                @"reason":[Themes checkNullValue:_issueReasonStr],
                                @"reason_text":[Themes checkNullValue:_issueReasonTextStr],
                                @"ride_id":[Themes checkNullValue:userRideId],
                                };
    
    
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    
    
    [web GetAddReports:parameters success:^(NSMutableDictionary *responseDictionary)
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
                 OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"success", nil)
                                                                             message:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]
                                                                   cancelButtonTitle:nil
                                                                   otherButtonTitles:@[JJLocalizedString(@"ok", nil)]
                                                             usingBlockWhenTapButton:^(OpinionzAlertView *alertView, NSInteger buttonIndex) {
                                                                 
                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                                 
                                                             }];
                 alert.iconType = OpinionzAlertIconSuccess;
                 [alert show];
                 
                 [self ReloadTableviewDatas];
             }
             
             else
             {
                 OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Oops", nil)
                                                                             message:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]
                                                                   cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                                   otherButtonTitles:nil];
                 alert.iconType = OpinionzAlertIconWarning;
                 [alert show];
                 
                 
             }
         }
         
         
         
     }
               failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
         // [SignUP_Btn setUserInteractionEnabled:YES];
         
     }];
    
}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str,nil)];
    [notice show];
}

- (IBAction)didClickIssueBtn:(id)sender {
    //[self moveToReport];
    ReportVC *reportVC=[self.storyboard instantiateViewControllerWithIdentifier:@"Reportvc"];
    [[self navigationController]pushViewController:reportVC animated:YES];
}

- (IBAction)didClickMailBtn:(id)sender {
    [self moveToMail];
}
-(void)moveToTrackDriver{
    NewTrackVC*objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
    [objLoginVC setRide_ID:userRideId];
    [self.navigationController pushViewController:objLoginVC animated:YES];
}
-(void)moveToShareRide{
    ShareAlert = [[UIAlertView alloc]
                  initWithTitle:JJLocalizedString(@"ENTER_MOBILE_NUMBER", nil)
                  message:@""
                  delegate:self
                  cancelButtonTitle:JJLocalizedString(@"CANCEL_Caps", nil)
                  otherButtonTitles:JJLocalizedString(@"SEND", nil), nil];
    [ShareAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    ShareFld=[ShareAlert textFieldAtIndex:0];
    ShareFld.textAlignment=NSTextAlignmentCenter;
    ShareFld.delegate=self;
    ShareFld.keyboardType=UIKeyboardTypePhonePad;
    [ShareFld setBorderStyle:UITextBorderStyleNone];
    ShareFld.autocapitalizationType=YES;
    [ShareAlert show];
}
-(void)moveToCancelRide{
    CancelRideVC * ObjCancelRideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CancelRideVCID"];
    [ObjCancelRideVC setRide_ID:RideIDlabel.text];
    [self.navigationController pushViewController:ObjCancelRideVC animated:YES];
}
-(void)moveToPayment{
    NewViewController * fareVc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewFareVCID"];
    [fareVc setRideID:[Themes checkNullValue:userRideId]];
    [self.navigationController pushViewController:fareVc animated:YES];
    
}
//-(void)moveToReport{
//    if ([MFMailComposeViewController canSendMail]) {
//        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
//        NSDictionary * appInfoDict=[Themes AppAllInfoDatas];
//        
//        NSString * isHaveContactEmail=[Themes checkNullValue:[appInfoDict objectForKey:@"site_contact_mail"]];
//        NSArray *usersTo = [NSArray arrayWithObject: [NSString stringWithFormat:@"%@",isHaveContactEmail] ];
//        [composeViewController setToRecipients:usersTo];//@[@"info@zoplay.com"]
//        [composeViewController setMailComposeDelegate:self];
//        [composeViewController setSubject:@""];
//        [composeViewController setMessageBody:@"" isHTML:NO];
//        [composeViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//        [self presentViewController:composeViewController animated:YES completion:nil];
//    }
//    else {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Mail", nil) message:JJLocalizedString(@"please_config_your_mail_account", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil];
//        [alert show];
//    }
//}
-(void)moveToMail{
    EmailAlert = [[UIAlertView alloc]
                  initWithTitle:JJLocalizedString(@"ENTER_YOUR_EMAIL_ID", nil)
                  message:@""
                  delegate:self
                  cancelButtonTitle:JJLocalizedString(@"CANCEL_Caps", nil)
                  otherButtonTitles:JJLocalizedString(@"SEND", nil), nil];
    [EmailAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    Email_fld=[EmailAlert textFieldAtIndex:0];
    Email_fld.textAlignment=NSTextAlignmentCenter;
    Email_fld.delegate=self;
    [Email_fld setBorderStyle:UITextBorderStyleNone];
    Email_fld.autocapitalizationType=YES;
    [EmailAlert show];
}
@end
