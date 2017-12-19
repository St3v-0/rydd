//
//  TranscationVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/28/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"


@interface TranscationVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UITableView *ContentTableView;
@property (strong, nonatomic)  NSMutableArray *AllArray,*CerditArray,*DebitArray;
@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentTrans;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;

@end
