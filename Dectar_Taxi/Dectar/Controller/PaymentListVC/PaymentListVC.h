//
//  PaymentListVC.h
//  Dectar
//
//  Created by iOS on 14/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentMethodRecord.h"
#import "PaymentListRecord.h"
@interface PaymentListVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
- (IBAction)didClickBackBtn:(id)sender;
- (IBAction)didClickSubmitBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt_CVV;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) PaymentListRecord *paymentObjRec;
@property(strong,nonatomic)NSString * RideID;
@property(strong,nonatomic)NSString * gateway;
@property(assign,nonatomic)NSInteger errorCount;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITableView *table_names;

@end
