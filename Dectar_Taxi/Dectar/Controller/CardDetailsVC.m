//
//  CardDetailsVC.m
//  Dectar
//
//  Created by Casperon on 30/01/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "CardDetailsVC.h"
#import "LanguageHandler.h"
#import "UrlHandler.h"
#import "WebViewVC.h"
#import "WBNoticeView.h"
#import "WBErrorNoticeView.h"
#import "IQActionSheetPickerView.h"


@interface CardDetailsVC ()<UITextFieldDelegate,IQActionSheetPickerViewDelegate>

@end

@implementation CardDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _enterCardNumTxt.delegate=self;
     _enterMontTxt.delegate=self;
    _enterExpYearTxt.delegate=self;
     _enterCVVTxt.delegate=self;
    
    
   [_cardHeaderLbl setText:JJLocalizedString(@"CardDetails_Header", nil)];
    
    _enterCardNumTxt.text=_numberStr;
    _enterMontTxt.text=_monthStr;
    _enterExpYearTxt.text=_yearStr;
    _enterCVVTxt.text=_CVVStr;
    
    
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

- (IBAction)didClickSubmitAction:(id)sender {
    
    [self payGate];
}

-(void)applicationLanguageChangeNotification:(NSNotification*)notification
{
    NSLog(@"Either %@ class did not implemented language change notification or it's calling super method",NSStringFromClass([self class]));
    
    [_cardHeaderLbl setText:JJLocalizedString(@"CardDetails_Header", nil)];
    [_cardNumLbl setText:JJLocalizedString(@"Card_Number", nil)];
    [_expMonthLbl setText:JJLocalizedString(@"Expiry_Month", nil)];
    [_expYearLbl setText:JJLocalizedString(@"Expiry_Year", nil)];
    [_CVVLbl setText:JJLocalizedString(@"CVV_Lbl", nil)];
}
-(void)payGate
{
    if([self validateTextfield])
    {
    
    NSDictionary * paymentDict=@{@"CCExpDay":[Themes checkNullValue:_enterMontTxt.text],
                                 @"CCExpMnth":[Themes checkNullValue:_enterExpYearTxt.text],
                                 @"cardNumber":[Themes checkNullValue:_enterCardNumTxt.text],@"creditCardIdentifier":[Themes checkNullValue:_enterCVVTxt.text]
                                  
                                 };
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:paymentDict options:0 error:nil];
    
    NSString * base64EncodedStr = [jsonData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    
//    NSString * base64EncodedStr=[Themes encodeStringTo64:EncodedStr];

     NSString *ConvertedString=[Themes checkNullValue:base64EncodedStr];
    
    if([_FromPaymentVC isEqualToString:@"FromPayment"])
    {
        WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
        addfavour.FromPaymentVCGateway=YES;
        addfavour.paymentInfo=ConvertedString;
        addfavour.MobileID=_MobileID;
        addfavour.Ride_ID=_rideID;
        [self.navigationController pushViewController:addfavour animated:YES];
    }
    else{
        WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
        addfavour.Fromgateway=YES;
        addfavour.paymentInfo=ConvertedString;
        addfavour.TotalAmount=_AmountTxt;
        [self.navigationController pushViewController:addfavour animated:YES];
        
    }
        
        
        
    
    }

    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == _enterMontTxt)
    {
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Choose Month" delegate:self];
        [picker setTag:1];
        [picker setTitlesForComponenets:@[[Themes GetMonthList]]];
        [picker show];
        [self.view endEditing:YES];
        return NO;
        
    }
     return YES;
}
-(void) actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles{
    switch (pickerView.tag)
    {
            
        case 1:
        {
            [_enterMontTxt setText:[titles componentsJoinedByString:@" - "]];
            [_enterMontTxt resignFirstResponder];
            if([_enterExpYearTxt.text isEqualToString:@""])
            {
                [_enterExpYearTxt becomeFirstResponder];
            }
            
        }
            break;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self validateTextfield])
    {
    if(textField==_enterCardNumTxt)
    {
        [_enterCardNumTxt resignFirstResponder];
        [_enterMontTxt becomeFirstResponder];
        
    }
    else if(textField==_enterMontTxt)
    {
        [_enterMontTxt resignFirstResponder];
        [_enterExpYearTxt becomeFirstResponder];
        
    }
    else if(textField==_enterExpYearTxt)
    {
        [_enterExpYearTxt resignFirstResponder];
        [_enterCVVTxt becomeFirstResponder];
        
    }
    else if(textField==_enterCVVTxt)
    {
        [_enterCVVTxt resignFirstResponder];
        
        
    }
    }
    
    return YES;
    
    
}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str,nil)];
    [notice show];
}
-(BOOL)validateTextfield
{
    if(![self ValidateCardNumber])
    {
        [self showErrorMessage:@"Enter_Card_Num"];
        [_enterCardNumTxt becomeFirstResponder];
        //[SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
    else if (_enterMontTxt.text.length==0)
    {
        [self showErrorMessage:@"Enter_Exp_Month"];
        [_enterMontTxt becomeFirstResponder];
        return NO;
    }
    else if (![self ValidateYear])
    {
        [self showErrorMessage:@"Enter_Exp_Year"];
        [_enterExpYearTxt becomeFirstResponder];
        return NO;
    }
    else if (_enterCVVTxt.text.length==0)
    {
        [self showErrorMessage:@"Enter_CVV"];
        [_enterCVVTxt becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)ValidateCardNumber
{
    if(_enterCardNumTxt.text.length<12 || _enterCardNumTxt.text.length>19)
    {
        return NO;
    }
    
    return YES;
}
-(BOOL)ValidateYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    if([_enterExpYearTxt.text integerValue] < [yearString integerValue] || yearString.length < 4)
    {
        
        return NO;
    }
    return YES;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(range.location==0&&[string isEqualToString:@" "]){
        return NO;
    }
    
    if (textField==_enterCardNumTxt)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <=19;
    }
    
    else if (textField==_enterMontTxt)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 2;
    }
    else if (textField==_enterExpYearTxt)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 4;
    }
    else if (textField==_enterCVVTxt)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 3;
    }
    
    
    return YES;
}
//
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if([self validateTextfield])
//    {
//        return YES;
//    }
//    return YES;
//}


- (IBAction)didClickBackBtnAction:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:JJLocalizedString(@"Warning", nil)
                              
                              message:JJLocalizedString(@"If_you_Close_the", nil)
                              delegate:self
                              cancelButtonTitle:JJLocalizedString(@"CANCEL_Caps", nil)
                              otherButtonTitles:JJLocalizedString(@"ok", nil), nil];
    [alertView show];
    
    
   // [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
      //  [self.view removeFromSuperview];
       // [TransWenView stopLoading];
        
    }
}


@end
