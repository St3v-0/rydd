//
//  FareVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/2/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "FareVC.h"
#import "FareRecord.h"
#import "Blurview.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "MyRideRecord.h"
#import "Constant.h"
#import "RatingVC.h"
#import "WebViewVC.h"

@interface FareVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    Blurview*bgView;
    MyRideRecord *addressObj;
    NSMutableArray *paymentArry;
    NSString * payment_Name,*paymnet_code;
    NSString * ride_Str;
    NSString * Mobile_ID;
    NSString * currency;


}

@end

@implementation FareVC
@synthesize Total_Billing,distance,duration,waiting,submit,payment_list,paymeny_View,bill,ObjRc,Payment_btn,Amount_fld,Amount_lbl,Amount_View,Apply_btn,Remove_brn,Remove_View,Scrooling;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    paymentArry=[NSMutableArray array];
    [Payment_btn setHidden:NO];
    bgView.hidden=YES;

    paymeny_View.layer.cornerRadius = 5;
    paymeny_View.layer.masksToBounds = YES;

    Payment_btn.layer.cornerRadius = 5;
    Payment_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    Payment_btn.layer.shadowOpacity = 0.5;
    Payment_btn.layer.shadowRadius = 2;
    Payment_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    [self shadow:Remove_brn];
    [self shadow:Apply_btn];

    
    payment_list.delegate=self;
    payment_list.dataSource=self;
    [self setObjRc:ObjRc];
    Scrooling.contentSize=CGSizeMake(Scrooling.frame.size.width, Payment_btn.frame.origin.y+Payment_btn.frame.size.height+200);
    [Amount_fld setDelegate:self];
    Amount_View.hidden=NO;
    
   }
-(void)shadow:(UIView*)View
{
    View.layer.shadowColor = [UIColor blackColor].CGColor;
    View.layer.shadowOpacity = 0.5;
    View.layer.shadowRadius = 1;
    View.layer.shadowOffset = CGSizeMake(1.5f,1.5f);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setObjRc:(FareRecord *)_ObjRc
{
    ObjRc=_ObjRc;
    Total_Billing.text=[NSString stringWithFormat:@"%@%@",currency,_ObjRc.TotalBill];
    bill.text=[NSString stringWithFormat:@"%@%@",currency,_ObjRc.TotalBill];
    waiting.text=_ObjRc.waiting;
    ride_Str=_ObjRc.ride_id;
    duration.text=_ObjRc.duration;
    distance.text=_ObjRc.distance;
    currency=[Themes findCurrencySymbolByCode:_ObjRc.CurrencySymbol];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)PaymentMode:(id)sender {
    
    [self listPayment];
}
-(void)listPayment

{
    paymentArry=[NSMutableArray array];

    submit.backgroundColor=[UIColor lightGrayColor];
    submit.userInteractionEnabled=NO;
    
    NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                @"ride_id": ride_Str};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web PaymentType:parameters success:^(NSMutableDictionary *responseDictionary)
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
                 
                 for (NSDictionary * objCatDict in responseDictionary[@"response"][@"payment"]) {
                     addressObj=[[MyRideRecord alloc]init];
                     addressObj.paymentname=[objCatDict valueForKey:@"name"];
                     addressObj.paymentCode =[objCatDict valueForKey:@"code"];
                     
                     [paymentArry addObject:addressObj];
                     
                 }
                 
                 paymeny_View.hidden=NO;
                 bgView=[[[NSBundle mainBundle] loadNibNamed:@"Blurview" owner:self options:nil] objectAtIndex:0];
                 bgView.frame=self.view.frame;
                 bgView.isNeed=NO;
                 [self.view addSubview:bgView];
                 [self.view bringSubviewToFront:paymeny_View];
                 [payment_list reloadData];
                 
                 
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [paymentArry count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
    }
    /*if (paymentArry == nil || [paymentArry count] == 0)
    {
        if ( [paymentArry containsObject:indexPath]  )
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
    MyRideRecord *objRec=(MyRideRecord*)[paymentArry objectAtIndex:indexPath.row];
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.text=objRec.paymentname;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   /* NSInteger catIndex = [paymentArry indexOfObject:addressObj];
    if (catIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:catIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        addressObj = [paymentArry objectAtIndex:indexPath.row];
        
        payment_Name=addressObj.paymentname;
        paymnet_code=addressObj.paymentCode;
        
        submit.backgroundColor=[UIColor orangeColor];
        submit.userInteractionEnabled=YES;
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];*/
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    addressObj = [paymentArry objectAtIndex:indexPath.row];

    payment_Name=addressObj.paymentname;
    paymnet_code=addressObj.paymentCode;
    
    submit.backgroundColor=[UIColor orangeColor];
    submit.userInteractionEnabled=YES;
    //    cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    /* if (_lastSele
     ctedIndexPath != nil)
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}


- (IBAction)Submit_pay:(id)sender {
    
    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) {
        
        [bgView setHidden:YES];
        [paymeny_View setHidden:YES];
        
    } else if (btnAuthOptions.tag==2) {
        
        [self sumbitpaymethod];
    }
}
-(void)sumbitpaymethod
{
    if ([paymnet_code isEqualToString:@"cash"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":ride_Str};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web CashPayment:parameters success:^(NSMutableDictionary *responseDictionary)
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
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"Your_Payment_successfully_finished",nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [alert show];
                     // if(self.view.window){
                     /* */
                     //}
                     
                     RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:ride_Str];
                     //[self presentViewController:objLoginVC animated:YES completion:nil];
                     
                     [Payment_btn setHidden:YES];
                     [Amount_View setHidden:YES];
                     [Remove_View setHidden:YES];
                     [bgView setHidden:YES];
                     [paymeny_View setHidden:YES];
                     
                     
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
    else if ([paymnet_code isEqualToString:@"wallet"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":ride_Str};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web WalletPayment:parameters success:^(NSMutableDictionary *responseDictionary)
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
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"Your_Payment_successfully_finished",nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [alert show];
                     [bgView setHidden:YES];
                     [paymeny_View setHidden:YES];
                     RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:ride_Str];
                     [self.navigationController pushViewController:objLoginVC animated:YES];

                     
                     
                     
                 }
                 else if ([comfiramtion isEqualToString:@"2"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"Your_Wallet_amount_successfully_used",nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [alert show];
                     [self listPayment];
                     [payment_list reloadData];
                     [bgView setHidden:YES];
                     [paymeny_View setHidden:YES];
                     
                 }
                 
                 else if ([comfiramtion isEqualToString:@"0"])
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"\xF0\x9F\x91\x8D" message:@"Your wallet is empty"  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [alert show];
                     [self listPayment];
                     [payment_list reloadData];
                     [bgView setHidden:YES];
                     [paymeny_View setHidden:YES];
                     
                     
                 }
             }
             
         }
                   failure:^(NSError *error)
         {
             [Themes StopView:self.view];
         }];
        
    }
    else if ([paymnet_code isEqualToString:@"auto_detect"])
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":ride_Str};
        
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
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"Your_Payment_successfully_finished",nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [alert show];
                     RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                     [objLoginVC setRideID_Rating:ride_Str];
                     [self.navigationController pushViewController:objLoginVC animated:YES];

                     
                     
                     
                     
                 }
                 /*  else if ([comfiramtion isEqualToString:@"2"])
                  {
                  UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:@"Your Wallet amount successfully used"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
                  [self listPayment];
                  [paymnetTabel reloadData];
                  [bgView setHidden:YES];
                  [paymentView setHidden:YES];
                  
                  }
                  
                  else if ([comfiramtion isEqualToString:@"0"])
                  {
                  UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:@"Your wallet is empty"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alert show];
                  [self listPayment];
                  [paymnetTabel reloadData];
                  [bgView setHidden:YES];
                  [paymentView setHidden:YES];
                  
                  
                  }*/
             }
             
             
             
         }
                failure:^(NSError *error)
         {
             [Themes StopView:self.view];
         }];
    }
    else
    {
        NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                    @"ride_id":ride_Str,
                                    @"gateway":paymnet_code};
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        
        [web Getwaypayment:parameters success:^(NSMutableDictionary *responseDictionary)
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
                     Mobile_ID=[responseDictionary valueForKey:@"mobile_id"];
                     
                     WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
                     addfavour.FromWhere=NO;
                     addfavour.parameters=Mobile_ID;
                     addfavour.Ride_ID=ride_Str;
                     [self.navigationController pushViewController:addfavour animated:YES];

                     
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
    /*else if ([paymnet_code isEqualToString:@"1"])
     {
     NSDictionary * parameters=@{@"user_id":[Themes getUserID],
     @"ride_id":ride_Str,
     @"gateway":paymnet_code};
     
     UrlHandler *web = [UrlHandler UrlsharedHandler];
     [Themes StartView:self.view];
     [web Getwaypayment:parameters success:^(NSMutableDictionary *responseDictionary)
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
     Mobile_ID=[responseDictionary valueForKey:@"mobile_id"];
     
     WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
     addfavour.FromWhere=YES;
     addfavour.parameters=Mobile_ID;
     addfavour.Ride_ID=ride_Str;
     [self presentViewController:addfavour animated:YES completion:nil];
     
     
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
     else if ([paymnet_code isEqualToString:@"2"])
     {
     NSDictionary * parameters=@{@"user_id":[Themes getUserID],
     @"ride_id":ride_Str,
     @"gateway":paymnet_code};
     
     UrlHandler *web = [UrlHandler UrlsharedHandler];
     [Themes StartView:self.view];
     [web Getwaypayment:parameters success:^(NSMutableDictionary *responseDictionary)
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
     Mobile_ID=[responseDictionary valueForKey:@"mobile_id"];
     WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
     addfavour.FromWhere=NO;
     addfavour.parameters=Mobile_ID;
     addfavour.Ride_ID=ride_Str;
     [self presentViewController:addfavour animated:YES completion:nil];
     
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
     }*/
    
}

/*#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSURL *currentURL = [[webView request] URL];
    NSLog(@"%@",[currentURL description]);
    
    if ([[currentURL description] containsString:@"pay-failed"]) {
        PaymentWebView.hidden=YES;
        [bgView setHidden:NO];
        [paymeny_View setHidden:NO];
    }
    else  if ([[currentURL description] containsString:@"pay-completed"])
    {
        [PaymentWebView setHidden:YES];
        [bgView setHidden:YES];
        [paymeny_View setHidden:YES];
        RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
        [objLoginVC setRideID_Rating:ride_Str];
        [self presentViewController:objLoginVC animated:YES completion:nil];


    } else if ([[currentURL description] containsString:@"failed"]) {
        PaymentWebView.hidden=YES;
        [bgView setHidden:NO];
        [paymeny_View setHidden:NO];
    }
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[request description] containsString:@"pay-failed"]) {
        PaymentWebView.hidden=YES;
        [bgView setHidden:NO];
        [paymeny_View setHidden:NO];
    }
    else  if ([[request description] containsString:@"pay-completed"])
    {
        [PaymentWebView setHidden:YES];
        [bgView setHidden:YES];
        [paymeny_View setHidden:YES];
        RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
        [objLoginVC setRideID_Rating:ride_Str];
        [self presentViewController:objLoginVC animated:YES completion:nil];

    }
    else  if ([[request description] containsString:@"Cancel"]) {
        PaymentWebView.hidden=YES;
        [bgView setHidden:NO];
        [paymeny_View setHidden:NO];
    }
    
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    
//    // report the error inside the webview
//    NSString* errorString = [NSString stringWithFormat:
//                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
//                             error.localizedDescription];
//    [PaymentWebView loadHTMLString:errorString baseURL:nil];
    [PaymentWebView setHidden:YES];
    [bgView setHidden:YES];
    [paymeny_View setHidden:YES];
    
}
*/
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==Amount_fld)
    {
        Scrooling.contentOffset=CGPointMake(0, 200);
    }
    return YES;
}
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField==Amount_fld)
    {
        NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 3 || returnKey;
    }
    else if (textField==Amount_fld)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"123456789"] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (Amount_fld) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:JJLocalizedString(@"Done",nil)
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        Amount_fld.inputAccessoryView = keyboardDoneButtonView;
    }
}
- (void)doneClicked:(id)sender
{
    [Amount_fld resignFirstResponder];
    Scrooling.contentOffset=CGPointMake(0, 0);

}
- (IBAction)Apply_action:(id)sender {
    
    
    NSDictionary * parameters=@{@"tips_amount":Amount_fld.text,
                                @"ride_id":ride_Str};
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
                 Amount_View.hidden=YES;
                 Remove_View.hidden=NO;
                 [Amount_fld resignFirstResponder];
                 Scrooling.contentOffset=CGPointMake(0, 0);
                NSString * value=[[responseDictionary valueForKey:@"response"] valueForKey: @"tips_amount"];
                 
                    Amount_lbl.text=[Themes writableValue:[NSString stringWithFormat:@"%@ %@%@",JJLocalizedString(@"tips_amount", nil),currency,value]];
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
- (IBAction)Remove_Action:(id)sender {

    NSDictionary * parameters=@{@"ride_id":ride_Str};
    
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
                 Amount_View.hidden=NO;       
                 Remove_View.hidden=YES;
                 Amount_fld.text=@"";
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
@end
