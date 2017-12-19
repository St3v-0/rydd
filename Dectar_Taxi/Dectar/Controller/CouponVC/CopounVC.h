//
//  CopounVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 2/4/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"
#import "WBErrorNoticeView.h"
@interface CopounVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UITextField *coupon_fld;
@property (strong, nonatomic) IBOutlet UIButton *Apply_btn;
@property (strong, nonatomic) IBOutlet UIView *couonfld_view;
@property (strong, nonatomic) IBOutlet UIView *benefits_view;
@property (strong, nonatomic) IBOutlet UILabel *detail_lbl;

@property (strong, nonatomic) NSString * Type;
@property (strong, nonatomic) NSString * Date;
@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (strong, nonatomic) IBOutlet UILabel *hint;
@property (weak, nonatomic) IBOutlet UIButton *headerCancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *RedeemHintLbl;

@end
