//
//  RateCardView.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/10/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingRecord.h"
#import "Blurview.h"

@interface RateCardViewVC: UIView<BlurViewDeletgate>
@property (strong, nonatomic) IBOutlet UILabel *catergorylabel;
@property (strong, nonatomic) IBOutlet UILabel *vechiel_label;
@property (strong, nonatomic) IBOutlet UILabel *mini_amount;
@property (strong, nonatomic) IBOutlet UILabel *after_amount;
@property (strong, nonatomic) IBOutlet UILabel *waiting_amount;
@property (strong, nonatomic) IBOutlet UILabel *mini_tetx;
@property (strong, nonatomic) IBOutlet UILabel *after_text;
@property (strong, nonatomic) IBOutlet UILabel *waiting_text;
@property (strong, nonatomic) IBOutlet UILabel *condition_lbl;
@property (strong, nonatomic) IBOutlet UIView *Total_Rate_View;
@property (strong, nonatomic) BookingRecord * Objrecord;
@property (strong, nonatomic) IBOutlet Blurview * viewB;
@property (assign, nonatomic) BOOL  IsComing;
@property (strong, nonatomic) NSString * CURRENCY;

@property (strong, nonatomic) IBOutlet UILabel *fare_view_lbl;
@end
