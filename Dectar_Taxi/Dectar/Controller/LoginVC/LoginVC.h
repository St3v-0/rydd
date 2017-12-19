//
//  LoginVC.h
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRecord.h"
#import "RootBaseVC.h"
#import "WBErrorNoticeView.h"



@interface LoginVC : RootBaseVC
@property(strong,nonatomic)LoginRecord * loginrecord;

@end
