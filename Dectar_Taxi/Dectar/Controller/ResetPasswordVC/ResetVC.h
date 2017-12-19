//
//  ResetVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 10/19/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"
#import "ForgotRecord.h"



@interface ResetVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UITextField *Email_fld;
@property (strong, nonatomic) IBOutlet UITextField *password_fld;
@property (strong, nonatomic) IBOutlet UIButton *show_btn;
@property (strong, nonatomic) IBOutlet UIButton *reset_passwrd_btn;
@property (strong, nonatomic) IBOutlet UILabel *showpassword;
@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (strong , nonatomic) ForgotRecord * Forgot_Record;


@end
