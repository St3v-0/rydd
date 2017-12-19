//
//  AdvertsVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 10/8/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertsRecord.h"
#import "RootBaseVC.h"


@interface AdvertsVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UILabel *Title_label;
@property (strong, nonatomic) IBOutlet UIImageView *AdsImageView;
@property (strong, nonatomic) IBOutlet UILabel *Description_label;
@property (strong, nonatomic) IBOutlet UIView *Ads_View;
@property (strong ,nonatomic) AdvertsRecord * Ads_ObjRec;
@property (strong, nonatomic) IBOutlet UIButton *okbtn;

@end
