//
//  ChangePasswordVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/27/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"
#import "WBErrorNoticeView.h"


@interface ChangePasswordVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UITextField *current_fld;
@property (strong, nonatomic) IBOutlet UITextField *confim_fld;
@property (strong, nonatomic) IBOutlet UITextField *newpsd_fld;
@property (strong, nonatomic) IBOutlet UILabel *heading;

@end
