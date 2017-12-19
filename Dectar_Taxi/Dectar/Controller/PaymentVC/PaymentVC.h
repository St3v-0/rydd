//
//  PaymentVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 12/28/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"

@interface PaymentVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UITableView *payment_Table;
@property (strong, nonatomic) IBOutlet UIButton *submit_btn;
@property (strong, nonatomic) NSString * RideID;
@property (strong, nonatomic) IBOutlet UIButton *Cancle_btn;
@property (strong, nonatomic) IBOutlet UILabel * heading ;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end
