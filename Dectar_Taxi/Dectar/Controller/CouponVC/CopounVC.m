//
//  CopounVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 2/4/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "CopounVC.h"
#import "Themes.h"
#import "Constant.h"
#import "UrlHandler.h"
#import "LanguageHandler.h"

@interface CopounVC ()<UITextFieldDelegate>

@end

@implementation CopounVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_coupon_fld setText:[Themes GetCoupon]];
    if ([_coupon_fld.text length]<=0) {
        [_benefits_view setHidden:YES];
        [_Apply_btn setTitle:JJLocalizedString(@"Apply", nil)  forState:UIControlStateNormal];
    }
    else
    {
        [_benefits_view setHidden:NO];
        [_Apply_btn setTitle:JJLocalizedString(@"Remove", nil) forState:UIControlStateNormal];
       [_detail_lbl setText:[Themes GetCouponDetails]];
    }
    
    
    
    _detail_lbl.layer.borderColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    _detail_lbl.layer.borderWidth=1.0f;
    _detail_lbl.layer.cornerRadius=5.0f;
    _detail_lbl.layer.masksToBounds=YES;
    _detail_lbl.textAlignment = NSTextAlignmentCenter;
    [_detail_lbl setNumberOfLines:0];
    _detail_lbl.frame=CGRectMake(_detail_lbl.frame.origin.x, _detail_lbl.frame.origin.y, _detail_lbl.frame.size.width, _detail_lbl.frame.size.height);
    [self textfieldleftpadding:_coupon_fld];
    
    
    // Do any additional setup after loading the view.
}
-(void)textfieldleftpadding:(UITextField*)feld
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    feld.leftView = paddingView;
    feld.leftViewMode = UITextFieldViewModeAlways;
    feld.layer.borderColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    feld.layer.borderWidth=1.0f;
    feld.layer.cornerRadius=5.0f;
    feld.layer.masksToBounds=YES;

}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    _heading.text=JJLocalizedString(@"Coupon", nil);
    _hint.text=JJLocalizedString(@"Your_Allowance", nil);
    _coupon_fld.placeholder=JJLocalizedString(@"Add_Coupon_Code", nil);
    [_headerCancelBtn setTitle:JJLocalizedString(@"Back", nil) forState:UIControlStateNormal];
   // _RedeemHintLbl.text=JJLocalizedString(@"Redeem_your_free", nil);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField.text length] ==0 && [string isEqualToString:@" "] ){
        return NO;
    }
    
    return YES;
    
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)apply_action:(id)sender {
    if(_coupon_fld.text.length>0){
        UIButton *resultButton = (UIButton *)sender;
        
        if ([resultButton.currentTitle isEqualToString:JJLocalizedString(@"Apply", nil)])
        {
            NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                                       @"code":_coupon_fld.text,
                                       @"pickup_date":_Date};
            
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
                        [_coupon_fld resignFirstResponder];
                        NSString * alert=[Themes checkNullValue:[[responseDictionary valueForKey:@"response"]valueForKey:@"message"]];
                        NSString * code=[[responseDictionary valueForKey:@"response"]valueForKey:@"code"];
                        NSString * Type=[[responseDictionary valueForKey:@"response"]valueForKey:@"discount_type"];
                        NSString * Amount=[[responseDictionary valueForKey:@"response"]valueForKey:@"discount_amount"];
                        NSString * curr=[Themes findCurrencySymbolByCode:[[responseDictionary valueForKey:@"response"]valueForKey:@"currency_code"]];
                        
                        
                        
                        
                        
                        [Themes SaveCoupon:code];
                    
                        [self.view makeToast:alert];
                        
                        [_Apply_btn setTitle:JJLocalizedString(@"Remove", nil)  forState:UIControlStateNormal];
                        [[NSNotificationCenter defaultCenter] postNotificationName: @"CouponApplied" object:nil];
                        [_benefits_view setHidden:NO];
                        if ([Type isEqualToString:@"Percent"]) {
                            NSString *Precent=@"%";
                            NSString * success=JJLocalizedString(@"You_have_successfully", nil);
                            NSString * amount=JJLocalizedString(@"will_be_reduce", nil);
                            //                        NSString * curr1=[NSString stringWithFormat:@"%@",curr];
                            //                        NSString *test = [success stringByAppendingString:curr1];
                            //curr1.stringByAppendingString:@"%@",[Themes findCurrencySymbolByCode:]
                            [_detail_lbl setText:[NSString stringWithFormat:@"%@ %@%@ %@",success,Amount,Precent,amount]];
                            //[_detail_lbl setText:[NSString stringWithFormat:@"%@",test]];
                            
                            [_detail_lbl sizeToFit];
                            [Themes SaveCouponDetails:_detail_lbl.text];
                            
                            
                        }
                        else
                        {
                            
                            NSString * success=JJLocalizedString(@"You_have_successfully", nil);
                            NSString * amount=JJLocalizedString(@"will_be_reduce", nil);
                            
                            [_detail_lbl setText:[NSString stringWithFormat:@"%@%@%@ %@",success,curr,Amount,amount]];
                            [_detail_lbl sizeToFit];
                            [Themes SaveCouponDetails:_detail_lbl.text];
                            
                        }
                        
                        
                    }
                    else
                    {
                        NSString * alert=[Themes checkNullValue:[responseDictionary valueForKey:@"response"]];
                       
                         [self.view makeToast:alert];
                        [Themes SaveCoupon:@""];
                        [Themes SaveCouponDetails:@""];
                        [_coupon_fld resignFirstResponder];
                        
                    }
                    
                }
            }
                     failure:^(NSError *error) {
                         [Themes StopView:self.view];
                         [_coupon_fld resignFirstResponder];
                         
                         
                         
                     }];
        }
        else if ([resultButton.currentTitle isEqualToString:JJLocalizedString(@"Remove", nil) ])
        {
            [self.view makeToast:JJLocalizedString(@"Your_Coupon_Successfully_Removed", nil)];
            [_benefits_view setHidden:YES];
            [Themes SaveCoupon:@""];
            [_coupon_fld setText:@""];
            [Themes SaveCouponDetails:@""];
            [_Apply_btn setTitle:JJLocalizedString(@"Apply", nil) forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] postNotificationName: @"CouponApplied" object:nil];
        }
    }else{
        [self showErrorMessage:JJLocalizedString(@"ENTER_APPLY_COUPON_CODE", nil)];
    }
   
}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str,nil)];
    [notice show];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}

@end
