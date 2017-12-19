//
//  ChangePasswordVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/27/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "LanguageHandler.h"

@interface ChangePasswordVC ()<UITextFieldDelegate>

@end

@implementation ChangePasswordVC
@synthesize newpsd_fld,confim_fld,current_fld,saveBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self padding:newpsd_fld];
    [self padding:confim_fld];
    [self padding:current_fld];

    
    // Do any additional setup after loading the view.
    
}
-(void)padding:(UITextField*)field
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    field.leftView = paddingView;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.layer.borderColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    field.layer.borderWidth=0.8f;
    field.layer.cornerRadius=3.0f;
    field.layer.masksToBounds=YES;
    [field setReturnKeyType:UIReturnKeyDone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    
    [_heading setText:JJLocalizedString(@"change_password", nil)];
    [saveBtn setTitle:JJLocalizedString(@"save", nil) forState:UIControlStateNormal];
    [current_fld setPlaceholder:JJLocalizedString(@"old_password", nil)];
    [newpsd_fld setPlaceholder:JJLocalizedString(@"new_password", nil)];
    [confim_fld setPlaceholder:JJLocalizedString(@"confirm_password", nil)];
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
     if(textField==confim_fld)
    {
        if (![newpsd_fld.text isEqualToString:confim_fld.text])
        {
            [self showErrorMessage:@"PASSWORD_MISS_MATCH"];
            [saveBtn setHidden:NO];
        }
     
    }
    return YES;
}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str,nil)];
    [notice show];
}
- (IBAction)savepsd:(id)sender {
    
    if (![newpsd_fld.text isEqualToString:confim_fld.text])
    {
        //dhiravida
        if(confim_fld.text.length==0 || [confim_fld.text isEqualToString:@""])
        {
            [self showErrorMessage:@"Confirm_password_is_mandatory"];
        }else{
            [self showErrorMessage:@"PASSWORD_MISS_MATCH"];
        }
        
        
    }
    else
    {
        [saveBtn setHidden:NO];
        if(current_fld.text.length==0){
            [self showErrorMessage:@"Password_is_mandatory"];
        }
       else   if(current_fld.text.length<passwordMininumWidth){
            [self showErrorMessage:[NSString stringWithFormat:@"%@ %d %@",JJLocalizedString(@"password_mimimum_check", nil),passwordMininumWidth,JJLocalizedString(@"characters", nil)]];
        }else if (newpsd_fld.text.length==0){
              [self showErrorMessage:@"New_password_is_mandatory"];
        }
        else   if(newpsd_fld.text.length<passwordMininumWidth){
            [self showErrorMessage:[NSString stringWithFormat:@"%@ %d %@",JJLocalizedString(@"password_mimimum_check", nil),passwordMininumWidth,JJLocalizedString(@"characters", nil)]];
        }else{
               [self saveData];
        }
     

    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.location==0&&[string isEqualToString:@" "]){
        return NO;
    }
    return YES;
}
- (IBAction)backto:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)saveData
{
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                               @"password":current_fld.text,
                               @"new_password":confim_fld.text};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web passwrdChange:parameters success:^(NSMutableDictionary *responseDictionary)
     
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
                 
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                 [Alert show];
                 [saveBtn setHidden:NO];

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
        failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];

}

@end
