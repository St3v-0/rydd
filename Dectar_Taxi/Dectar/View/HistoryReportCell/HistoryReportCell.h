//
//  HistoryReportCell.h
//  Dectar
//
//  Created by iOS on 21/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblRideId;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeandDate;
@property (weak, nonatomic) IBOutlet UILabel *lblIssues;
@property (weak, nonatomic) IBOutlet UILabel *lblType;

@end
