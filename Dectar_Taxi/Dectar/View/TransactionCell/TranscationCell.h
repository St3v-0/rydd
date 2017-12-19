//
//  TranscationCell.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/28/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranscationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *CRView;
@property (strong, nonatomic) IBOutlet UIView *DRView;
@property (strong, nonatomic) IBOutlet UILabel *Balance;
@property (strong, nonatomic) IBOutlet UILabel *Title;
@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (strong, nonatomic) IBOutlet UILabel *Currentbalance;
@property (weak, nonatomic) IBOutlet UILabel *crLbl;
@property (weak, nonatomic) IBOutlet UILabel *drLbl;

@end
