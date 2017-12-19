//
//  FareDetailTableViewCell.m
//  Dectar
//
//  Created by Aravind Natarajan on 02/11/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "FareDetailTableViewCell.h"

@implementation FareDetailTableViewCell
@synthesize titleLbl,descLbl;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDatasToFareCell:(DetailPageRecord *)fareRec{
    titleLbl.text=fareRec.hearderTitle;
    descLbl.text=fareRec.descMain;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
