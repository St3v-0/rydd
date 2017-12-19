//
//  MyRideCell.m
//  Dectar
//
//  Created by Suresh J on 22/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "MyRideCell.h"

@implementation MyRideCell
- (void)awakeFromNib {
    _conatin_view.layer.cornerRadius=8.0f;
    _conatin_view.layer.masksToBounds=YES;
    _lblMileage.numberOfLines = 1;
    _lblMileage.minimumScaleFactor = 0.5;
    _lblMileage.adjustsFontSizeToFitWidth = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
