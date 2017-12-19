//
//  MoneyVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/28/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"


@interface MoneyVC : RootBaseVC
@property (weak, nonatomic) IBOutlet UIView *view_cashOption;
@property (strong, nonatomic) IBOutlet UIButton *MuenuBtn;
@property (strong, nonatomic) IBOutlet UILabel *Current_labl;
@property (strong, nonatomic) IBOutlet UIButton *AddMoney_Btn;
@property (strong, nonatomic) IBOutlet UIButton *MaxAmount_lbl;;
@property (strong, nonatomic) IBOutlet UIButton *MiniAmount_lbl;
@property (strong, nonatomic) IBOutlet UIButton *BetweenAmount;
@property (strong, nonatomic) IBOutlet UITextField *Amount_Field;
@property (strong, nonatomic) IBOutlet UIScrollView *Scrollview;
@property (strong, nonatomic) IBOutlet UIWebView *paymentView;
@property (strong, nonatomic) IBOutlet UIButton *Paypal;
@property (strong, nonatomic) IBOutlet UIButton *CerditCard;
@property (strong, nonatomic) IBOutlet UIView *Sucess;

@property (strong, nonatomic) IBOutlet UILabel *Title_Label;
@property (strong, nonatomic) IBOutlet UILabel *Hint_lbl;
@property (strong, nonatomic) IBOutlet UILabel *Option_lbl;
@property (strong, nonatomic) IBOutlet UILabel *hint_yourbalance;
@property(assign,nonatomic)NSInteger errorCount;
@end
