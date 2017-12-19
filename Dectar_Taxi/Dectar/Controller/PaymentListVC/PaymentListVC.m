//
//  PaymentListVC.m
//  Dectar
//
//  Created by iOS on 14/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "PaymentListVC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "PaymentListCell.h"
#import "WBErrorNoticeView.h"
#import "WebViewVC.h"

@interface PaymentListVC ()
{
    NSMutableArray* cardNameArray;
    NSInteger GlobalIndextag;

}
@end

@implementation PaymentListVC
@synthesize paymentObjRec;
- (void)viewDidLoad {
//    _txt_CVV.layer.borderWidth=1;
//    _txt_CVV.layer.borderColor=[UIColor blackColor].CGColor;
//    _txt_CVV.layer.cornerRadius=2;
//    _txt_CVV.layer.masksToBounds=YES;
    [self Padding:_txt_CVV];
    [_table_names setHidden:YES];
    
    _btnSubmit.layer.cornerRadius=2;
    _btnSubmit.layer.masksToBounds=YES;
    _viewBottom.hidden=YES;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self PaymentListDetails];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)paymentInfoDetails
{
        NSDictionary * parameters=@{@"user_id":[Themes checkNullValue: [Themes getUserID]],
                                    @"ride_id":[Themes checkNullValue:_RideID],
                                    @"gateway":[Themes checkNullValue:_gateway],

                                 };

        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
    
        [web GetPaymentByGateway:parameters success:^(NSMutableDictionary *responseDictionary)
    {
         [Themes StopView:self.view];
        [_table_names setHidden:NO];

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
     NSString *strValue=@"";
    for (int i =0; i<cardNameArray.count; i++) {
       
        PaymentMethodRecord *   payRecObj=[cardNameArray objectAtIndex:i];
        if( payRecObj.isDefault==YES){
            strValue=payRecObj.card_id;
            break;
        }
        
    }
    NSDictionary * paymentDict=@{@"creditCardIdentifier":[Themes checkNullValue:_txt_CVV.text],
                                 
                                 @"Card_Id":[Themes checkNullValue:strValue],//@"17438ebb-00ab-47ba-804c-9a9c66fd4ef4"
                                 
                                 };
    
    
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:paymentDict options:0 error:nil];
    
    NSString * base64EncodedStr = [jsonData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    
    //    NSString * base64EncodedStr=[Themes encodeStringTo64:EncodedStr];
    
    NSString *ConvertedString=[Themes checkNullValue:base64EncodedStr];
    WebViewVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewVCID"];
    addfavour.isFromMobileGateway=YES;
    addfavour.MobileID=paymentStr;
    addfavour.parameters=ConvertedString;
    addfavour.Ride_ID=_RideID;
    [self.navigationController pushViewController:addfavour animated:YES];
}
-(void)PaymentListDetails{
    
    
        NSDictionary*paramets=@{@"user_id":[Themes getUserID]};
        
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web GetPayGateCardDetails:paramets success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];
              [_table_names setHidden:NO];
             _viewBottom.hidden=NO;
             if ([responseDictionary count]>0)
             {
                 cardNameArray=[[NSMutableArray alloc]init];
                 
                 NSString * comfiramtion=[Themes checkNullValue:[responseDictionary valueForKey:@"status"]];
                 //NSString * alert=[responseDictionary valueForKey:@"response"];
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     NSArray *Item=[[responseDictionary valueForKey:@"response"] valueForKey:@"cardArray"];
                     if (Item.count >0) {
                         {
                             for (NSDictionary * dict in Item) {
                             PaymentMethodRecord *    payRecObj=[[PaymentMethodRecord alloc]init];
                                 payRecObj.card_id=[Themes checkNullValue:[dict valueForKey:@"card_id"]];
                                 payRecObj.card_number=[Themes checkNullValue:[dict valueForKey:@"CardNumber"]];
                                 payRecObj.CardExpiryDate=[Themes checkNullValue:[dict valueForKey:@"CardExpiryDate"]];
                                 payRecObj.card_type=[Themes checkNullValue:[dict valueForKey:@"brand"]];
                                 NSString * defaultStr=[Themes checkNullValue:[dict valueForKey:@"status"]];
                                 if ([defaultStr isEqualToString:@"default"]) {
                                     payRecObj.isDefault=YES;
                                     
                                 }
                                 else{
                                     payRecObj.isDefault=NO;
                                 }
                                 [cardNameArray addObject:payRecObj];
                             }
                            _gateway=[Themes checkNullValue:[[[responseDictionary valueForKey:@"response"]valueForKey:@"payment"] valueForKey:@"code"]];
                             
                         }
                     }
                     [_table_names reloadData];
                     
                 }
                                 else
                 {
                     
                     NSString *titleStr = JJLocalizedString(@"Oops", nil);
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:@"" delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [Alert show];
                 }
                 
             }
         } failure:^(NSError *error) {
                         [Themes StopView:self.view];
             if (self.errorCount<2) {
                 [self PaymentListDetails];
                 self.errorCount++;
             }
             else{
                 [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
             }
                      }];
        
    }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return cardNameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    PaymentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[PaymentListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"Cell"];
    }
    if (cardNameArray.count>0) {
     PaymentMethodRecord *   payRecObj=[cardNameArray objectAtIndex:indexPath.row];
        cell.lblCardNo.text=[NSString stringWithFormat:@"%@",payRecObj.card_number];
        cell.lblCardType.text=[NSString stringWithFormat:@"%@",payRecObj.card_type];
        if (payRecObj.isDefault==YES) {
            cell.lblDefault.backgroundColor=[UIColor greenColor];
            cell.lblDefault.layer.cornerRadius=cell.lblDefault.frame.size.width/2;
            cell.lblDefault.clipsToBounds=YES;
            cell.lblDefault.layer.borderWidth=1;
            cell.lblDefault.layer.borderColor=[UIColor blackColor].CGColor;
        }
        else{
            cell.lblDefault.backgroundColor=[UIColor grayColor];
            cell.lblDefault.layer.cornerRadius=cell.lblDefault.frame.size.width/2;
            cell.lblDefault.clipsToBounds=YES;
            cell.lblDefault.layer.borderWidth=1;
            cell.lblDefault.layer.borderColor=[UIColor blackColor].CGColor;
            
            
        }
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   

 
//    GlobalIndextag=IndexValue;
    
    for (int i =0; i<cardNameArray.count; i++) {
        
     PaymentMethodRecord *   payRecObj=[cardNameArray objectAtIndex:i];
        if(i==indexPath.row){
            payRecObj.isDefault=YES;
        }else{
            payRecObj.isDefault=NO;

        }
        [cardNameArray setObject:payRecObj atIndexedSubscript:i];
   
    }
     [_table_names reloadData];
    
    
    
    
    

}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str,nil)];
    [notice show];
}

-(BOOL)validateTextfield
{
    [self.view endEditing:YES];
    BOOL isSelectDefault=NO;
    for (int i =0; i<cardNameArray.count; i++) {
        
        PaymentMethodRecord *   payRecObj=[cardNameArray objectAtIndex:i];
        if( payRecObj.isDefault==YES){
            isSelectDefault=YES;
            break;
        }
        
    }
    
    if(isSelectDefault==NO){
        [self showErrorMessage:@"Please Select a Default Card"];
        return NO;
    }
    else    if (_txt_CVV.text.length==0)
    {
        [self showErrorMessage:@"Enter_CVV"];
      
        return NO;
    }
    
    return YES;

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_txt_CVV) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:JJLocalizedString(@"Done", nil)
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        _txt_CVV.inputAccessoryView = keyboardDoneButtonView;
    }
}
- (void)doneClicked:(id)sender
{
    [_txt_CVV resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_txt_CVV) {
        [_txt_CVV resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(range.location==0&&[string isEqualToString:@" "]){
        return NO;
    }
    else if (textField==_txt_CVV)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 4;
    }

    return YES;
}
- (IBAction)didClickBackBtn:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
    
}

- (IBAction)didClickSubmitBtn:(id)sender {
    if ([self validateTextfield]) {
          [self paymentInfoDetails];
    }
  
  
    
}
@end
