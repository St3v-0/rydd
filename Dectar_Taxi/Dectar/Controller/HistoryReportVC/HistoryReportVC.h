//
//  HistoryReportVC.h
//  Dectar
//
//  Created by iOS on 21/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportRecord.h"
@interface HistoryReportVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)didClickBackBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableDetails;
@property (strong, nonatomic) ReportRecord *objreportRec;

@end
