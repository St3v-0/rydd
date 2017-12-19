//
//  MyRideVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/13/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownListView.h"
#import "RootBaseVC.h"



@interface MyRideVC : RootBaseVC<kDropDownListViewDelegate>
{
    DropDownListView * Dropobj;
}
@property (strong, nonatomic) IBOutlet UIView *NorideVIEW;
@property (strong, nonatomic) IBOutlet UIView *GOTOride;
@property (weak, nonatomic) IBOutlet UIButton *Sort_Btn;
@property (strong, nonatomic) IBOutlet UILabel *noride;
@property (strong, nonatomic) IBOutlet UILabel *hint_noride;
@property (strong, nonatomic) IBOutlet UIButton *bookaride_btn;
@property (weak, nonatomic) IBOutlet UILabel *HeaderLbl;
@property(assign,nonatomic)NSInteger errorCount;
@end
