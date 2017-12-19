//
//  HistoryReportCell.m
//  Dectar
//
//  Created by iOS on 21/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "HistoryReportCell.h"

@implementation HistoryReportCell
@synthesize lblType,lblIssues,lblRideId,lblTimeandDate;
- (void)awakeFromNib {
    lblTimeandDate.numberOfLines = 1;
    lblTimeandDate.minimumScaleFactor = 0.5;
    lblTimeandDate.adjustsFontSizeToFitWidth = YES;
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
