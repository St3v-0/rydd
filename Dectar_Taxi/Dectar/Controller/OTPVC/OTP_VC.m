//
//  OTP_VC.m
//  Dectar
//
//  Created by Casperon Technologies on 9/30/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "OTP_VC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "RegisterVC.h"
#import "ResetVC.h"
#import "LanguageHandler.h"




@interface OTP_VC ()<UITextFieldDelegate>
{
    int direction;
    int shakes;
    int seconds;
    NSTimer * timer;
}
@property (strong , nonatomic) NSString * CategoryString;
@property (strong , nonatomic) NSString * UserName;
@property (strong , nonatomic) NSString * userEmail;
@property (strong , nonatomic) NSString * UserPhoneNumber;
@property (strong , nonatomic) NSString * UserImage;
@property (strong , nonatomic) NSString * userIDString;
@property (strong , nonatomic) NSString * AmountWallet;
@property (strong , nonatomic) NSString * currency;
@property (strong , nonatomic) NSString * countryCode;




@end

@implementation OTP_VC
@synthesize OTP_field,Verify_btn,OTP_Code,OTP_Status,email_id,user_name,mobile_number,country_code,confirm_password,password,refrrelcode,Resend;

@synthesize CategoryString,UserName,userEmail,userIDString,UserImage,UserPhoneNumber,AmountWallet,currency,countryCode,timerlabel,Media_ID,Forgot_Record;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Verify_btn.layer.cornerRadius = 5;
    Verify_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    Verify_btn.layer.shadowOpacity = 0.5;
    Verify_btn.layer.shadowRadius = 2;
    Verify_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    OTP_field.font=[UIFont fontWithName:@"HelveticaNeue-Medium " size:20];
    [OTP_field setDelegate:self];
    
   
    if ([_Checkking isEqualToString:@"Register"])
    {
        if ([OTP_Status isEqualToString:@"development"])
        {
            OTP_field.text=OTP_Code;
        }
        else
        {
            OTP_field.text=@"";
        }
        //timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self   selector:@selector(updateCountdown) userInfo:nil repeats: YES];
        
        seconds=30;
        [timerlabel setHidden:YES];
    }
    
    if ([_Checkking isEqualToString:@"Myprofile"])
        
    {
        if ([OTP_Status isEqualToString:@"development"])
        {
            OTP_field.text=OTP_Code;
        }
        else
        {
            OTP_field.text=@"";
        }
        //timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self   selector:@selector(updateCountdown) userInfo:nil repeats: YES];
        
        seconds=30;
        [timerlabel setHidden:YES];
    }
    if ([_Checkking isEqualToString:@"ForgetPassowrd"])
    {
        [timerlabel setHidden:YES];

        if ([OTP_Status isEqualToString:@"development"])
        {
            OTP_field.text=OTP_Code;
        }
        else
        {
            OTP_field.text=@"";
        }
        [timer invalidate];
    }
    if ([_Checkking isEqualToString:@"Facebook"])
        
    {
        if ([OTP_Status isEqualToString:@"development"])
        {
            OTP_field.text=OTP_Code;
        }
        else
        {
            OTP_field.text=@"";
        }
        //timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self   selector:@selector(updateCountdown) userInfo:nil repeats: YES];
        
        seconds=30;
        [timerlabel setHidden:YES];
    }
   
    


    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_Kindly_hint setText:JJLocalizedString(@"Kindly_Enter_your_OTP", nil)];
    [Verify_btn setTitle:JJLocalizedString(@"Verify", nil) forState:UIControlStateNormal];
    [_heading setText:JJLocalizedString(@"Verification", nil)];
    [OTP_field setPlaceholder:JJLocalizedString(@"Enter_Your_OTP", nil)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) updateCountdown
{
    
    int  secondsleft;
    secondsleft = (seconds %3600) % 60;
    timerlabel.text = [NSString stringWithFormat:@"00:%02d", seconds];
    NSLog(@"%@",timerlabel.text);
    seconds--;
    
    if (seconds<0)
    {
        [timer invalidate];
        [Resend setHidden:NO];
        [timerlabel setHidden:YES];
    }
}
- (IBAction)back_to:(id)sender {
    
   // regisVC=[[RegisterVC alloc]init];
    if ([_Checkking isEqualToString:@"ForgetPassowrd"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        [timer invalidate];
    }
   

    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

   // [self dismissViewControllerAnimated:YES completion:nil];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==OTP_field) {
        [textField resignFirstResponder];
    }
    return YES;
}
- (IBAction)Resnd_OTP:(id)sender {
    [Resend setHidden:YES];
    [timer invalidate];

}

- (IBAction)Register:(id)sender {
    
    if ([_Checkking isEqualToString:@"Register"])
    {

        if ([OTP_field.text isEqualToString:OTP_Code])
        {
            [timer invalidate];

            NSDictionary *parameters=@{@"user_name":user_name,
                                       @"email":email_id,
                                       @"password":password,
                                       @"country_code":country_code,
                                       @"phone_number":mobile_number,
                                       @"referal_code":refrrelcode,
                                       @"deviceToken":[Themes writableValue:[Themes GetDeviceToken]],
                                       @"gcm_id":@""};
            
            parameters=[Themes writableValue:parameters];
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            
            [Themes StartView:self.view];
            
            [web OTPcheck:parameters success:^(NSMutableDictionary *responseDictionary)
             {
                 [Themes StopView:self.view];
                  
                 if ([responseDictionary count]>0)
                 {
                     
                     responseDictionary=[Themes writableValue:responseDictionary];
                     NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                     NSString * alert=[responseDictionary valueForKey:@"response"];
                     [Themes StopView:self.view];
                     
                     if ([comfiramtion isEqualToString:@"1"])
                     {
                         userIDString=[responseDictionary valueForKey:@"user_id"];
                         UserImage=[responseDictionary valueForKey:@"user_image"];
                         CategoryString=[responseDictionary valueForKey:@"category"];
                         userEmail=[responseDictionary valueForKey:@"email"];
                         UserName=[responseDictionary valueForKey:@"user_name"];
                         UserPhoneNumber=[responseDictionary valueForKey:@"phone_number"];
                         AmountWallet=[responseDictionary valueForKey:@"wallet_amount"];
                         currency=[responseDictionary valueForKey:@"currency"];
                         countryCode=[responseDictionary valueForKey:@"country_code"];
                         
                         [Themes saveXmppUserCredentials:[responseDictionary valueForKey:@"sec_key"]];
                         [Themes saveUserID:userIDString];
                         [Themes SaveuserDP:UserImage];
                         [Themes SaveCategoryString:CategoryString];
                         [Themes SaveuserEmail:userEmail];
                         [Themes saveUserName:UserName];
                         [Themes SaveMobileNumber:UserPhoneNumber];
                         [Themes SaveCurrency:currency];
                         [Themes SaveWallet:AmountWallet];
                         [Themes SaveCountryCode:countryCode];
                         
                         
                         AppDelegate*appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                         [appdelegate connectToXmpp];
                            [appdelegate GetAppInfo];
                         [appdelegate setInitialViewController];
                         [Themes SaveUserImage:[responseDictionary valueForKey:@"user_image"]];
                     }
                     else
                     {
                         NSString *titleStr = JJLocalizedString(@"Oops", nil);
                         UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                         [Alert show];
                         
                     }
                     
                 }
             }
                  failure:^(NSError *error) {
                      
                      [Themes StopView:self.view];
                  }];
            
            
        }
        else
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Please_Enter_Valid_OTP", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            
            direction = 1;
            shakes = 0;
            [self shake:OTP_field];
            [Alert show];
            
        }
    }
    if ([_Checkking isEqualToString:@"ForgetPassowrd"])
        
    {
        if ([OTP_field.text isEqualToString:OTP_Code])
        {
            ResetVC * resetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetVCID"];
            [resetVC setForgot_Record:Forgot_Record];
            [self.navigationController pushViewController:resetVC animated:YES];
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"Verification_Complete", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];

        }
        else
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Please_Enter_Valid_OTP", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            
            direction = 1;
            shakes = 0;
            [self shake:OTP_field];
            [Alert show];
            
        }
        
    }
     if ([_Checkking isEqualToString:@"Myprofile"])
        
    {
        if ([OTP_field.text isEqualToString:OTP_Code])
        {
            [timer invalidate];
        NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                                   @"country_code":country_code,
                                   @"phone_number":mobile_number,
                                   @"otp":OTP_field.text
                                   };
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web numberChange:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
                 //  NSLog(@"response%@",responseDictionary);
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 NSString * alert=[responseDictionary valueForKey:@"response"];
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [Alert show];
                     
                     countryCode=[responseDictionary valueForKey:@"country_code"];
                     mobile_number=[responseDictionary valueForKey:@"phone_number"];
                     
                     [Themes SaveMobileNumber:mobile_number];
                     [Themes SaveCountryCode:countryCode];
                     
                     [self.navigationController popViewControllerAnimated:YES];

                     
                     
                 }
                 else
                 {
                     NSString *titleStr = JJLocalizedString(@"Oops", nil);
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [Alert show];
                     
                     
                 }
                 
             }
         }
                  failure:^(NSError *error) {
                      
                      [Themes StopView:self.view];
                      
                      
                  }];
        }
        
        else
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Please_Enter_Valid_OTP", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            
            direction = 1;
            shakes = 0;
            [self shake:OTP_field];
            [Alert show];
            
        }
    }
    
    if ([_Checkking isEqualToString:@"Facebook"])
    {
        
        if ([OTP_field.text isEqualToString:OTP_Code])
        {
            [timer invalidate];
            
            NSDictionary *parameters=@{@"user_name":user_name,
                                       @"media_id":Media_ID,
                                       @"email":email_id,
                                       @"password":password,
                                       @"country_code":country_code,
                                       @"phone_number":mobile_number,
                                       @"referal_code":refrrelcode,
                                       @"deviceToken":[Themes writableValue:[Themes GetDeviceToken]],
                                       @"gcm_id":@"",
                                       @"media":@"Facebook"};
            
            parameters=[Themes writableValue:parameters];
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            
            [Themes StartView:self.view];
            
            [web login_Social:parameters success:^(NSMutableDictionary *responseDictionary)
             {
                 [Themes StopView:self.view];
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 if ([responseDictionary count]>0)
                 {
                     
                     responseDictionary=[Themes writableValue:responseDictionary];
                     NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                     NSString * alert=[responseDictionary valueForKey:@"response"];
                     [Themes StopView:self.view];
                     
                     if ([comfiramtion isEqualToString:@"1"])
                     {
                         userIDString=[responseDictionary valueForKey:@"user_id"];
                         UserImage=[responseDictionary valueForKey:@"user_image"];
                         CategoryString=[responseDictionary valueForKey:@"category"];
                         userEmail=[responseDictionary valueForKey:@"email"];
                         UserName=[responseDictionary valueForKey:@"user_name"];
                         UserPhoneNumber=[responseDictionary valueForKey:@"phone_number"];
                         AmountWallet=[responseDictionary valueForKey:@"wallet_amount"];
                         currency=[responseDictionary valueForKey:@"currency"];
                         countryCode=[responseDictionary valueForKey:@"country_code"];
                         
                         
                         [Themes saveUserID:userIDString];
                         [Themes SaveuserDP:UserImage];
                         [Themes SaveCategoryString:CategoryString];
                         [Themes SaveuserEmail:userEmail];
                         [Themes saveUserName:UserName];
                         [Themes SaveMobileNumber:UserPhoneNumber];
                         [Themes SaveCurrency:currency];
                         [Themes SaveWallet:AmountWallet];
                         [Themes SaveCountryCode:countryCode];
                         
                         AppDelegate*appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate]; 
                         [appdelegate connectToXmpp];
                            [appdelegate GetAppInfo];
                         [appdelegate setInitialViewController];
                             [Themes SaveUserImage:[responseDictionary valueForKey:@"user_image"]];
                     }
                     else
                     {
                         NSString *titleStr = JJLocalizedString(@"Oops", nil);
                         UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                         [Alert show];
                         
                     }
                     
                 }
             }
                  failure:^(NSError *error) {
                      
                      [Themes StopView:self.view];
                  }];
            
            
        }
        else
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Please_Enter_Valid_OTP", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            
            direction = 1;
            shakes = 0;
            [self shake:OTP_field];
            [Alert show];
            
        }
    }
    
}
-(void)shake:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 10)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         shakes++;
         direction = direction * -1;
         [self shake:theOneYouWannaShake];
     }];
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
