//
//  WebViewVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/15/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "WebViewVC.h"
#import "Themes.h"
#import "Constant.h"
#import "RatingVC.h"
#import "LanguageHandler.h"
#import "MoneyVC.h"
@interface WebViewVC ()
@end

@implementation WebViewVC

@synthesize FromComing,FromWhere,parameters,TransWenView,Ride_ID,StripeProcess;

- (void)viewDidLoad {
    [super viewDidLoad];
    
      if (_isFromMobileGateway==YES) {
        
       
        
        NSString *Urlstr=[NSString stringWithFormat:@"%@?mobileId=%@&payment_info=%@",PaymentPaygateMobile,_MobileID,parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: nsurl];
        [TransWenView loadRequest: request];
    }
    else
    if(_Fromgateway == YES)
    {
        
        NSString *Urlstr=[NSString stringWithFormat:@"%@?user_id=%@&payment_info=%@&total_amount=%@",PayGatewayUrl,[Themes getUserID],_paymentInfo,_TotalAmount];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
//         NSString *body = [NSString stringWithFormat: @"user_id=%@,payment_info=%@&total_amount=%@",[Themes getUserID],_paymentInfo,_TotalAmount];
        
         
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: nsurl];
//        [request setHTTPMethod: @"POST"];
//        [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
        [TransWenView loadRequest: request];
        
    }
    
    else if (_FromPaymentVCGateway==YES)
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@?mobileId=%@&payment_info=%@",PayGatewayPaymentVCUrl,_MobileID,_paymentInfo];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: nsurl];
        [TransWenView loadRequest: request];

    }
    
   else if (FromComing==YES)
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/wallet-recharge/payform?user_id=%@&total_amount=%@",AppbaseUrl,[Themes getUserID],parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];
    }
    else if (StripeProcess==YES)
        
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/wallet-recharge/stripe-process?user_id=%@&total_amount=%@",AppbaseUrl,[Themes getUserID],parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];
    }
    else if (FromComing==NO)
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/proceed-payment?mobileId=%@",AppbaseUrl,parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];
        TransWenView.scalesPageToFit=YES;
    }
    else if (FromWhere==YES)
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/proceed-payment?mobileId=%@",AppbaseUrl,parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];
    }
    else if (FromWhere==NO)
    {
        NSString *Urlstr=[NSString stringWithFormat:@"%@mobile/proceed-payment?mobileId=%@",AppbaseUrl,parameters];
        NSURL *nsurl=[NSURL URLWithString:Urlstr];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [TransWenView loadRequest:nsrequest];

    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Transaction_View", nil)];
}
- (IBAction)Dissmis:(id)sender {
  
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:JJLocalizedString(@"Warning", nil)
                              
                              message:JJLocalizedString(@"If_you_Close_the", nil)
                              delegate:self
                              cancelButtonTitle:JJLocalizedString(@"CANCEL_Caps", nil)
                              otherButtonTitles:JJLocalizedString(@"ok", nil), nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.view removeFromSuperview];
 		[TransWenView stopLoading];
        
    }
}
#pragma mark -
#pragma mark UIWebViewDelegate
- (void)webView:(IMTWebView *)_webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources {
    [self.progressViewLoad setProgress:((float)resourceNumber) / ((float)totalResources)];
    if (resourceNumber == totalResources) {
        _webView.resourceCount = 0;
        _webView.resourceCompletedCount = 0;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    //[Themes StartView:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
   // [Themes StopView:self.view];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSURL *currentURL = [[webView request] URL];
    NSLog(@"webViewDidFinishLoad===========>%@",[currentURL description]);
    
    
    
    if(_Fromgateway == YES)
    {
        if ([[currentURL description] containsString:@"pay-completed"])
        {
                        
            for (UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[MoneyVC class]])
                {
                    //Do not forget to import AnOldViewController.h
                    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    break;
                    
                }
            }
           // [self.view makeToast:JJLocalizedString(@"Amount_Added", nil)];
//            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"success_updated", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
//            [Alert show];
            
        }
        else if ([[currentURL description] containsString:@"pay-failed"]) {
//            NSString *titleStr = JJLocalizedString(@"Oops", nil);
//            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
//            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else  if ([[currentURL description] containsString:@"/wallet-recharge/pay-cancel"]) {
            [self.navigationController popViewControllerAnimated:YES];
//            NSString *titleStr = JJLocalizedString(@"Oops", nil);
//            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
//            [Alert show];
            
        }
        else  if ([[currentURL description] containsString:@"wallet-recharge/failed/"]) {
            [self.navigationController popViewControllerAnimated:YES];
//            NSString *titleStr = JJLocalizedString(@"Oops", nil);
//            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
//            [Alert show];
            
        }
        
    }
    
    else if (_FromPaymentVCGateway==YES)
    {
        
        if ([[currentURL description] containsString:@"pay-completed"])
        {
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            [objLoginVC setRideID_Rating:Ride_ID];
            //[self presentViewController:objLoginVC animated:YES completion:nil];
             [self.navigationController pushViewController:objLoginVC animated:YES];
            
        }
        else if ([[currentURL description] containsString:@"pay-failed"]) {
//            NSString *titleStr = JJLocalizedString(@"Oops", nil);
//            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
//            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else  if ([[currentURL description] containsString:@"/wallet-recharge/pay-cancel"]) {
            [self.navigationController popViewControllerAnimated:YES];
//            NSString *titleStr = JJLocalizedString(@"Oops", nil);
//            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
//            [Alert show];
            
        }
        
        
        
    }
   
  else if (FromComing==YES)
    {
        if ([[currentURL description] containsString:@"/wallet-recharge/failed"]) {
            [self.navigationController popViewControllerAnimated:YES];
            
           /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
        }
        else  if ([[currentURL description] containsString:@"/wallet-recharge/pay-completed"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            
           /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Amount added to you Wallet SccessFully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            // [self MyBalancce];
            
        }
        
        else if ([[currentURL description] containsString:@"/wallet-recharge/failed"]) {
            [self.navigationController popViewControllerAnimated:YES];
            
            /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            
        }
    }
    else if (FromComing==NO)
    {
        if ([[currentURL description] containsString:@"pay-failed"]) {
            /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            [self.navigationController popViewControllerAnimated:YES];

        }
        else  if ([[currentURL description] containsString:@"pay-completed"])
        {
            if (_isFromMobileGateway==NO) {
                RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
                [objLoginVC setRideID_Rating:Ride_ID];
                [self presentViewController:objLoginVC animated:YES completion:nil];

            }
            
        }
        
        else if ([[currentURL description] containsString:@"failed"]) {
           /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
        //    [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if  (FromWhere ==NO || FromWhere ==YES)
    {
        if ([[currentURL description] containsString:@"pay-failed"]) {
           /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            [self.navigationController popViewControllerAnimated:YES];

        }
        else  if ([[currentURL description] containsString:@"pay-completed"])
        {
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            [objLoginVC setRideID_Rating:Ride_ID];
            [self presentViewController:objLoginVC animated:YES completion:nil];
            
            
        } else if ([[currentURL description] containsString:@"failed"]) {
            /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];*/
            
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
    
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"shouldStartLoadWithRequest==============>%@",[request description]);
    
    
    if(_Fromgateway == YES)
    {
        if ([[request description] containsString:@"pay-completed"])
        {
            
            for (UIViewController *controller in self.navigationController.viewControllers)
            {
                if ([controller isKindOfClass:[MoneyVC class]])
                {
                    //Do not forget to import AnOldViewController.h
                    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    break;
                    
                }
            }
            // [self.view makeToast:JJLocalizedString(@"Amount_Added", nil)];
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"success_updated", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            
        }
        else if ([[request description] containsString:@"pay-failed"]) {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else  if ([[request description] containsString:@"/wallet-recharge/pay-cancel"]) {
            [self.navigationController popViewControllerAnimated:YES];
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            
        }
        else  if ([[request description] containsString:@"wallet-recharge/failed/"]) {
            [self.navigationController popViewControllerAnimated:YES];
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            
        }
        
    }
    else if (_isFromMobileGateway==YES)
    {
        if ([[request description] containsString:@"pay-completed"])
        {
        RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
        [objLoginVC setRideID_Rating:Ride_ID];
        // [self presentViewController:objLoginVC animated:YES completion:nil];
        [self.navigationController pushViewController:objLoginVC animated:YES];
        }
    }
    
    else if (_FromPaymentVCGateway==YES)
    {
        
        if ([[request description] containsString:@"pay-completed"])
        {
//            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
//            [objLoginVC setRideID_Rating:Ride_ID];
//            //[self presentViewController:objLoginVC animated:YES completion:nil];
//            [self.navigationController pushViewController:objLoginVC animated:YES];
            
        }
        else if ([[request description] containsString:@"pay-failed"]) {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else  if ([[request description] containsString:@"cancel"]) {
            [self.navigationController popViewControllerAnimated:YES];
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            
        }
        
        
        
    }

    
    
    
  else if (FromComing==YES)
    {
        if ([[request description] containsString:@"/wallet-recharge/failed"]) {
            [self.navigationController popViewControllerAnimated:YES];
            
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            
        }
        else  if ([[request description] containsString:@"/wallet-recharge/pay-completed"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"Amount_added", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Walletrecharged"
                                                                object:nil
                                                              userInfo:nil];
            //[self MyBalancce];
            
            
        }
        else  if ([[request description] containsString:@"/wallet-recharge/pay-cancel"]) {
            [self.navigationController popViewControllerAnimated:YES];
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            
        }
        

    }
    else if (FromComing==NO)
    {
        if ([[request description] containsString:@"pay-failed"]) {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_failed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];

        }
        else  if ([[request description] containsString:@"pay-completed"])
        {
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            [objLoginVC setRideID_Rating:Ride_ID];
           // [self presentViewController:objLoginVC animated:YES completion:nil];
            [self.navigationController pushViewController:objLoginVC animated:YES];
//            MoneyVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MoneyVCID"];
//            //[objLoginVC setRideID_Rating:Ride_ID];
//           // [self presentViewController:objLoginVC animated:YES completion:nil];
//            [self.navigationController pushViewController:objLoginVC animated:YES];
            
            
        }
        else  if ([[request description] containsString:@"Cancel"]) {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_cancelled", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];

        }
        

    }
    else if  (FromWhere ==NO || FromWhere ==YES)
    {
        if ([[request description] containsString:@"pay-failed"]) {
            [self.navigationController popViewControllerAnimated:YES];

        }
        else  if ([[request description] containsString:@"pay-completed"])
        {
           
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            [objLoginVC setRideID_Rating:Ride_ID];
            [self presentViewController:objLoginVC animated:YES completion:nil];
            
        }
        else  if ([[request description] containsString:@"Cancel"]) {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Your_Payment_cancelled", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    }
    
        return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [Themes StopView:self.view];
    
    if([error code] == NSURLErrorCancelled) return;
    
    // report the error inside the webview
    /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Oops\xF0\x9F\x9A\xAB" message:@"Some Network problem try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [Alert show];*/
    [self.navigationController popViewControllerAnimated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
