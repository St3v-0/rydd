//
//  FareVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/2/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FareRecord.h"
#import "RootBaseVC.h"

@interface FareVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *Total_Billing;
@property (strong, nonatomic) IBOutlet UILabel *bill;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *waiting;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UIView *paymeny_View;
@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) IBOutlet UITableView *payment_list;
@property (strong, nonatomic) FareRecord * ObjRc;
@property (strong, nonatomic) IBOutlet UIButton *Payment_btn;
@property (strong, nonatomic) IBOutlet UIScrollView *Scrooling;
@property (strong, nonatomic) IBOutlet UIButton *Apply_btn;
@property (strong, nonatomic) IBOutlet UITextField *Amount_fld;
@property (strong, nonatomic) IBOutlet UIView *Amount_View;
@property (strong, nonatomic) IBOutlet UIView *Remove_View;
@property (strong, nonatomic) IBOutlet UILabel *Amount_lbl;
@property (strong, nonatomic) IBOutlet UIButton *Remove_brn;


@end
