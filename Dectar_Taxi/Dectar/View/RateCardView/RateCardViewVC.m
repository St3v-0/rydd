//
//  RateCardView.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/10/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "RateCardViewVC.h"
#import "Themes.h"
#import "LanguageHandler.h"

@implementation RateCardViewVC

@synthesize mini_amount,mini_tetx,catergorylabel,condition_lbl,vechiel_label,after_amount,after_text,waiting_amount,waiting_text,Total_Rate_View,viewB,IsComing,CURRENCY;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setObjrecord:(BookingRecord *)Objrecord
{
    Total_Rate_View.layer.cornerRadius = 10;
    Total_Rate_View.layer.masksToBounds = YES;
//    viewB=[[[NSBundle mainBundle] loadNibNamed:@"Blurview" owner:self options:nil] objectAtIndex:0];
//    [self addSubview:viewB];
    [self bringSubviewToFront:Total_Rate_View];
    viewB.isNeed=YES;
    viewB.delegate=self;
    CURRENCY=[Themes findCurrencySymbolByCode:Objrecord.currency];
    [_fare_view_lbl setText:JJLocalizedString(@"Fare_Breakup", nil)];
    
    catergorylabel.text=Objrecord.categorySubName;
    vechiel_label.text=Objrecord.vehicletypes;
    mini_amount.text=[NSString stringWithFormat:@"%@%@",CURRENCY,Objrecord.amountmin_fare];
    mini_tetx.text=Objrecord.min_fare_text;
    after_amount.text=[NSString stringWithFormat:@"%@%@",CURRENCY,Objrecord.amountafter_fare];
    after_text.text=Objrecord.after_fare_text;
    waiting_amount.text=[NSString stringWithFormat:@"%@%@",CURRENCY,Objrecord.amountother_fare];
    waiting_text.text=Objrecord.other_fare_text;
    condition_lbl.text=Objrecord.note;

}
-(void)CloseBlurView
{
    [Total_Rate_View removeFromSuperview];
    [self removeFromSuperview];
}

@end
