//
//  RegisterVC.h
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"
#import "LoginRecord.h"


@interface RegisterVC : RootBaseVC
@property(strong,nonatomic) NSString * NameFB;
@property(strong,nonatomic) NSString * EmailFB;
@property(strong,nonatomic) NSString * IDFB;

@property(strong, nonatomic) IBOutlet UILabel * terms;
@property(strong,nonatomic)LoginRecord * loginrecord;
@property(strong, nonatomic) IBOutlet UIView * SignIn_hint_view;

@end
