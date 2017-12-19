//
//  AboutVc.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/14/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"


@interface AboutVc : RootBaseVC
@property (strong, nonatomic) IBOutlet UIButton *MenuBtn;
@property (strong, nonatomic) IBOutlet UILabel *Describ_label;
@property (strong, nonatomic) IBOutlet UILabel *Version_Label;
@property (strong, nonatomic) IBOutlet UILabel *More_info_URL;
@property (strong, nonatomic) IBOutlet UILabel *headerlbl;
@property (strong, nonatomic) IBOutlet UILabel *powerdLBL;
@property (strong, nonatomic) IBOutlet UILabel *moreinfobtn;
 
@end
