//
//  RecordCell.m
//  Dectar
//
//  Created by iOS on 19/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblSelect.layer.cornerRadius=self.lblSelect.frame.size.width/2;
    self.lblSelect.layer.borderWidth=1;
    self.lblSelect.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.lblSelect.layer.masksToBounds=YES;
    
    _lblReportIssue.numberOfLines = 2;
    _lblReportIssue.minimumScaleFactor = 0.5;
    _lblReportIssue.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
