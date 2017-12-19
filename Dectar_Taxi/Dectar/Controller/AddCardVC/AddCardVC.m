//
//  AddCardVC.m
//  Dectar
//
//  Created by iOS on 09/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "AddCardVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "LanguageHandler.h"
#import "WBErrorNoticeView.h"
#import "IQActionSheetPickerView.h"

@interface AddCardVC ()<IQActionSheetPickerViewDelegate>

@end

@implementation AddCardVC
@synthesize addCardRec;
- (void)viewDidLoad {
    
    
//    _txtCardNo.layer.borderWidth=1;
//    _txtCardNo.layer.borderColor=[UIColor blackColor].CGColor;
//    _txtCardNo.layer.masksToBounds=YES;
//    _txtCardNo.layer.cornerRadius=2;
//    
//    _txtExpMonth.layer.borderWidth=1;
//    _txtExpMonth.layer.borderColor=[UIColor blackColor].CGColor;
//    _txtExpMonth.layer.masksToBounds=YES;
//    _txtExpMonth.layer.cornerRadius=2;
//
//    _txtExpYear.layer.borderWidth=1;
//    _txtExpYear.layer.borderColor=[UIColor blackColor].CGColor;
//    _txtExpYear.layer.masksToBounds=YES;
//    _txtExpYear.layer.cornerRadius=2;
    
    _viewAddName.layer.cornerRadius=5;
    _viewAddName.layer.masksToBounds=YES;
    _viewAddName.layer.borderColor=[UIColor blackColor].CGColor;
    _viewAddName.layer.borderWidth=1;

    _viewPopup.hidden=YES;
    
    [self Padding:_txtCardNo];
    [self Padding:_txtExpMonth];
    [self Padding:_txtExpYear];
    [self Padding:_txtCardName];
    
    [_txtCardNo setText:addCardRec.cardNumber];
      [_txtExpMonth setText:addCardRec.CCExpMonth];
    [_txtExpYear setText:addCardRec.CCExpYear];
   _txtCardName.text=@"";
    [_txtCardName setPlaceholder:@"Enter Card Name"];
    [_txtExpMonth setUserInteractionEnabled:NO];
    [_txtCardNo setUserInteractionEnabled:NO];
    [_txtExpYear setUserInteractionEnabled:NO];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)Padding:(UITextField *)Field
{
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, Field.frame.size.height)];
    [Field addSubview:paddingView];
    [Field setLeftViewMode:UITextFieldViewModeAlways];
    [Field setLeftView:paddingView];
    
    Field.layer.cornerRadius=2;
    Field.layer.masksToBounds=YES;
    Field.layer.borderColor = [[UIColor blackColor] CGColor];
    Field.layer.borderWidth= 1.0f;
    
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
-(void)AddCarddetails
{
    if ([self validateTextfield]) {
        NSDictionary * paymentDict=@{@"CCExpDay":[Themes checkNullValue:_txtExpMonth.text],
                                     @"CCExpMnth":[Themes checkNullValue:_txtExpYear.text],
                                     @"cardNumber":[Themes checkNullValue:_txtCardNo.text],
                                     @"cardName":[Themes checkNullValue:_txtCardName.text],
                                     
                                     };

    
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:paymentDict options:0 error:nil];
    
    NSString * base64EncodedStr = [jsonData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    
    //    NSString * base64EncodedStr=[Themes encodeStringTo64:EncodedStr];
    
    NSString *ConvertedString=[Themes checkNullValue:base64EncodedStr];
    NSDictionary * parameters=@{@"user_id":[Themes checkNullValue: [Themes getUserID]],
                                                          @"card_info":[Themes checkNullValue:ConvertedString],
                                
                                
                                
//                                @"cardNumber":[Themes checkNullValue: _txtCardNo.text],
                                                                };
    
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    
    
    [web GetAddCard:parameters success:^(NSMutableDictionary *responseDictionary)
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
                 [_txtCardName resignFirstResponder];

                OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"success", nil)
                                                                            message:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@[JJLocalizedString(@"ok", nil)]
                                                            usingBlockWhenTapButton:^(OpinionzAlertView *alertView, NSInteger buttonIndex) {
                                                                
                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                
                                                            }];
                alert.iconType = OpinionzAlertIconSuccess;
                [alert show];
                
             }
             
             else
             {
               OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Oops", nil)
                                                                           message:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]
                                                                 cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                                 otherButtonTitles:nil];
               alert.iconType = OpinionzAlertIconWarning;
               [alert show];
                 
                 // [SignUP_Btn setUserInteractionEnabled:YES];
                 
             }
         }
         
         // [SignUP_Btn setUserInteractionEnabled:YES];
         
         
     }
                failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         // [SignUP_Btn setUserInteractionEnabled:YES];
         
     }];
 
}
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if(textField == _txtExpMonth)
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
            [_txtExpMonth setText:[titles componentsJoinedByString:@" - "]];//
            [_txtExpMonth resignFirstResponder];
            
        }
            break;
    }
    
}

-(BOOL)validateTextfield
{
    if(![self ValidateCardNumber])
    {
        [self showErrorMessage:@"Enter_Card_Num"];
        [_txtCardNo becomeFirstResponder];
        //[SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
    else if (_txtExpMonth.text.length==0)
    {
        [self showErrorMessage:@"Enter_Exp_Month"];
        [_txtExpMonth becomeFirstResponder];
        return NO;
    }
    else if (_txtCardName.text.length==0){
        [self showErrorMessage:@"Enter Card Name"];

        [_txtCardName becomeFirstResponder];
        return NO;
    }
        else if (![self ValidateYear])
    {
        [self showErrorMessage:@"Enter Exp Year"];
        [_txtExpYear becomeFirstResponder];
        return NO;
    }
           return YES;
}

-(BOOL)ValidateCardNumber
{
    if(_txtCardNo.text.length<12 || _txtCardNo.text.length>19)
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
    
    if([_txtExpYear.text integerValue] < [yearString integerValue] || yearString.length < 4)
    {
        
        return NO;
    }
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self validateTextfield])
    {
        if(textField==_txtCardNo)
        {
            [_txtCardNo resignFirstResponder];
            [_txtExpMonth becomeFirstResponder];
            
        }
        else if(textField==_txtExpMonth)
        {
            [_txtExpMonth resignFirstResponder];
            [_txtExpYear becomeFirstResponder];
            
        }
        else if(textField==_txtExpYear)
        {
            [_txtExpYear resignFirstResponder];
           
            
        }
        else if(textField==_txtCardName)
        {
            [_txtCardName resignFirstResponder];
            
            
        }
          }
    
    return YES;
    
    
}

-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str,nil)];
    [notice show];
}

- (IBAction)didClickBackBtn:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
}
- (IBAction)didClickSaveBtn:(id)sender {
    _viewPopup.hidden=NO;
    
    _txtCardName.layer.cornerRadius=2;
    _txtCardName.layer.borderWidth=1;
    _txtCardName.layer.borderColor=[UIColor blackColor].CGColor;
    _txtCardName.layer.masksToBounds=YES;

//    if ([self validateTextfield]) {
//       
//           [self AddCarddetails];
//    }
 
    }
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(range.location==0&&[string isEqualToString:@" "]){
        return NO;
    }
    
    if (textField==_txtCardNo)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <=19;
    }
    
    else if (textField==_txtExpMonth)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 2;
    }
    else if (textField==_txtExpYear)
    {
        if (range.length+range.location>textField.text.length) {
            return NO;
        }
        NSUInteger newLengeth=[textField.text length] + [string length] - range.length;
        return newLengeth<=4;
    }
    
    
    return YES;
}





- (IBAction)didClickApply:(id)sender {
    if ([self validateTextfield]) {
        [self AddCarddetails];
    }

}

- (IBAction)didClickCancel:(id)sender {
    _viewPopup.hidden=YES;
}
@end
