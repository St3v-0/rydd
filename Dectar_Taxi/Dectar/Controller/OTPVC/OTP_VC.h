//
//  OTP_VC.h
//  Dectar
//
//  Created by Casperon Technologies on 9/30/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"
#import "ForgotRecord.h"

 

@interface OTP_VC : RootBaseVC
@property (weak, nonatomic) IBOutlet UITextField *OTP_field;
@property (weak, nonatomic) IBOutlet UIButton *Verify_btn;
@property (strong, nonatomic) NSString * OTP_Status;
@property (strong, nonatomic) NSString * OTP_Code;
@property (strong, nonatomic) NSString * user_name;
@property (strong, nonatomic) NSString * email_id;
@property (strong, nonatomic) NSString * password;
@property (strong, nonatomic) NSString * confirm_password;
@property (strong, nonatomic) NSString * refrrelcode;
@property (strong, nonatomic) NSString * mobile_number;
@property (strong, nonatomic) NSString * country_code;
@property (strong, nonatomic) IBOutlet UILabel *timerlabel;
@property (strong, nonatomic) IBOutlet UIButton *Resend;
@property (strong, nonatomic) NSString * Checkking;
@property (strong, nonatomic) NSString * Media_ID;
@property (strong, nonatomic) IBOutlet UILabel *Kindly_hint;
@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (assign , nonatomic) ForgotRecord * Forgot_Record;


@end
