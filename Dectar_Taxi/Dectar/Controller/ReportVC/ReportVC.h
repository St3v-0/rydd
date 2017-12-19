//
//  ReportVC.h
//  Dectar
//
//  Created by iOS on 19/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface ReportVC : UIViewController
- (IBAction)didClickBackBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *Scrolling;
@property (weak, nonatomic) IBOutlet UIView *viewLastTrip;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTripNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTripAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRideStatus;
@property (weak, nonatomic) IBOutlet UIView *viewReport;
@property (weak, nonatomic) IBOutlet UISegmentedControl *RideSegmentedControll;
@property (weak, nonatomic) IBOutlet UITableView *tableData;
@property (assign, nonatomic) NSInteger errorCount;
@property (assign, nonatomic) NSInteger selectedReasonRow;
@property (strong, nonatomic) NSString *issueReasonTextStr;
@property (strong, nonatomic) NSString *issueReasonStr;
- (IBAction)didClickSegmentIndexBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property(assign,nonatomic)BOOL isFromAccount;
@property(strong,nonatomic)NSString * RideID;


- (IBAction)didClickSubmitBtn:(id)sender;

@end
