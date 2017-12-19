//
//  FareDetailTableViewCell.h
//  Dectar
//
//  Created by Aravind Natarajan on 02/11/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailPageRecord.h"

@interface FareDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
-(void)setDatasToFareCell:(DetailPageRecord *)fareRec;
@end
