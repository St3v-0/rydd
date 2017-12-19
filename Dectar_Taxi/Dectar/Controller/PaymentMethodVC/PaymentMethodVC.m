//
//  PaymentMethodVC.m
//  Dectar
//
//  Created by iOS on 08/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "PaymentMethodVC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "PaymentMethodCell.h"
#import "REFrostedViewController.h"
#import "AddCardVC.h"
#import "RootBaseVC.h"
#import "CardIO.h"
@interface PaymentMethodVC ()<ButtonProtocolName>
{
    NSMutableArray* cardNameArray;
    NSInteger GlobalIndextag;
    NSString * defaultStr;

}
@end

@implementation PaymentMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    [_tableNames setHidden:YES];
    // Do any additional setup after loading the view.
}
-(void)applicationLanguageChangeNotification:(NSNotification*)notification
{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self restrictRotation:NO];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
       [self PaygateDetails];
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
-(void)PaygateDetails
{

    NSDictionary*paramets=@{@"user_id":[Themes getUserID]};
    

    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GetPayGateCardDetails:paramets success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         [_tableNames setHidden:NO];
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
                             PaymentMethodRecord *cardObjRec=[[PaymentMethodRecord alloc]init];
                             cardObjRec.card_id=[Themes checkNullValue:[dict valueForKey:@"card_id"]];
                             cardObjRec.card_number=[Themes checkNullValue:[dict valueForKey:@"CardNumber"]];
                             cardObjRec.CardExpiryDate=[Themes checkNullValue:[dict valueForKey:@"CardExpiryDate"]];
                             cardObjRec.card_type=[Themes checkNullValue:[dict valueForKey:@"brand"]];
                             cardObjRec.cardName=[Themes checkNullValue:[dict valueForKey:@"CardName"]];
                              cardObjRec.cardStatus=[Themes checkNullValue:[dict valueForKey:@"status"]];
                             if ([cardObjRec.cardStatus isEqualToString:@"default"]) {
                                 cardObjRec.isDefault=YES;
                             }
                             else{
                                 cardObjRec.isDefault=NO;
                             }
                             [cardNameArray addObject:cardObjRec];
                         }
                    }
                 }
                 [_tableNames reloadData];

                }
             else if ([comfiramtion isEqualToString:@"2"]){
                   [_tableNames reloadData];
                 _tableNames.hidden=YES;
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
             [self PaygateDetails];
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
     PaymentMethodCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[PaymentMethodCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"Cell"];
    }
    
    [cell setDelegate:self];
    [cell setSelectiveIndexpath:indexPath];
    
    if (cardNameArray.count>0) {
        PaymentMethodRecord *cardObjRec=[cardNameArray objectAtIndex:indexPath.row];
        cell.lblCardNumber.text=[NSString stringWithFormat:@"%@",cardObjRec.card_number];
        cell.lblCardType.text=[NSString stringWithFormat:@"%@",cardObjRec.card_type];
        cell.lblCardName.text=[NSString stringWithFormat:@"%@",cardObjRec.cardName];
        
        if (cardObjRec.isDefault==YES) {
            cell.lblDefault.backgroundColor=[UIColor greenColor];
            cell.lblDefault.layer.cornerRadius=cell.lblDefault.frame.size.width/2;
            cell.lblDefault.clipsToBounds=YES;
            cell.lblDefault.layer.borderWidth=1;
            cell.lblDefault.layer.borderColor=[UIColor blackColor].CGColor;
            
            cardObjRec.cardStatus = @"default";
            
            
    }
        else{
            cell.lblDefault.backgroundColor=[UIColor grayColor];
            cell.lblDefault.layer.cornerRadius=cell.lblDefault.frame.size.width/2;
            cell.lblDefault.clipsToBounds=YES;
            cell.lblDefault.layer.borderWidth=1;
            cell.lblDefault.layer.borderColor=[UIColor blackColor].CGColor;
            
            cardObjRec.cardStatus = @"normal";


    }
        
    }
//    [cell.btnDelete addTarget:self action:@selector(DeleterAction:) forControlEvents:UIControlEventTouchUpInside];
//    cell.btnDelete.tag=indexPath.row+100;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}
//-(void)DeleterAction:(UIButton *)Sender
//{
//    
//    if(cardNameArray.count > 0)
//    {
//        
//        NSInteger  TagValue=Sender.tag-100;
//        cardObjRec=[cardNameArray objectAtIndex:TagValue];
//        [self DeleteCarddetail:cardObjRec.card_id Customer_ID:defaultStr SelectedIndex:TagValue];
//        
//        
//        
//    }
//}
-(void)DeleteCarddetail:(NSString * )CardID Customer_ID:(NSString *)Card_Status

{
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                                                          @"card_status":Card_Status,
                                                          @"card_id":CardID};
    
    [web GetDeleteCardPayGate:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         
         [Themes StopView:self.view];
         if ([responseDictionary count]>0)
         {
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             if ([comfiramtion isEqualToString:@"1"])
             {
                 [self Toast:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]];
//                 if(IndexValue<cardNameArray.count){
//                     
//                     [cardNameArray removeObjectAtIndex:IndexValue];
//                 }
               // [_tableNames reloadData];
                 
                 [self PaygateDetails];
                 
             }
             else{
                 [self Toast:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]];
             }
         }
     }
                   failure:^(NSError *error)
     {
         [self Toast:@"Error in network connection"];
         [Themes StopView:self.view];
         
     }];
    
    
}




-(void)ChooseDefaultCard:(NSString * )CardID Customer_ID:(NSString *)Cust_ID SelectedIndex:(NSInteger )IndexValue
{
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                               @"card_id":CardID
                               
                               };
    
    [web GetDefaultCard:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         
         [_tableNames setHidden:false];
         [Themes StopView:self.view];
         if ([responseDictionary count]>0)
         {
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             if ([comfiramtion isEqualToString:@"1"])
             {
                GlobalIndextag=IndexValue;
                 
                 for (int i =0; i<cardNameArray.count; i++) {
                    
                     PaymentMethodRecord * cardObjRec=[cardNameArray objectAtIndex:i];
                     if(i==IndexValue){
                         cardObjRec.isDefault=YES;
                     }else{
                         cardObjRec.isDefault=NO;
                     }
                 }
                 
                 
                 [_tableNames reloadData];
                 [self Toast:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]];
             }else{
                 [self Toast:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]];
             }
         }
     }
                        failure:^(NSError *error)
     {
         [self Toast:@"Error in network connection"];
          [Themes StopView:self.view];
         
         
        
         
     }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row<[cardNameArray count]){
        
        
        PaymentMethodRecord * cardObjRec=[cardNameArray objectAtIndex:indexPath.row];
        
        cardObjRec.isDefault = YES;
        cardObjRec.cardStatus = @"default";
        
        
        [self ChooseDefaultCard:cardObjRec.card_id Customer_ID:cardObjRec.card_id SelectedIndex:indexPath.row];
    }

}
- (IBAction)didClickBackBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];


}
- (IBAction)didClickAddBtn:(id)sender {
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.hideCardIOLogo=YES;
    scanViewController.collectCVV = NO;
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
    
    
    
}
- (IBAction)didClickCardIO:(id)sender {
    [self restrictRotation:YES];
    
    
}
#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Scan succeeded with info: %@", [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.cardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv]);
    
    AddCardRecord * objRec=[[AddCardRecord alloc]init];
    objRec.cardNumber=[NSString stringWithFormat:@"%@", info.cardNumber];
    objRec.CCExpMonth=[NSString stringWithFormat:@"%02lu", (unsigned long)info.expiryMonth];
   objRec. CCExpYear=[NSString stringWithFormat:@"%lu", (unsigned long)info.expiryYear];
    
    AddCardVC *addcardVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddcardVC"];
    [addcardVC setAddCardRec:objRec];
    [self.navigationController pushViewController:addcardVC animated:YES];
    
    
    
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
    
}

- (IBAction)didClickSubmitBtn:(id)sender {
    
}

-(void)buttonPressedForDelete:(NSIndexPath *)SelectedIndexPath
{
    PaymentMethodRecord * objBookingRecord=[cardNameArray objectAtIndex:SelectedIndexPath.row];
    [self DeleteCarddetail:objBookingRecord.card_id Customer_ID:objBookingRecord. cardStatus];
}

@end
