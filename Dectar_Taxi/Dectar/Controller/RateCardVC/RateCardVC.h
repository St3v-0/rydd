//
//  RateCardVC.h
//  Dectar
//
//  Created by Suresh J on 24/08/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"


@interface RateCardVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UILabel *First_Lbl;
@property (strong, nonatomic) IBOutlet UILabel *After_lbl;
@property (strong, nonatomic) IBOutlet UILabel *headerlbl;
@property (strong, nonatomic) IBOutlet UILabel *standardLBl;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UILabel *extraLbl;

@end
