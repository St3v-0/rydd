//
//  RateCardTableViewCell.h
//  Dectar
//
//  Created by Aravind Natarajan on 28/11/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@end
