//
//  HistoryReportVC.m
//  Dectar
//
//  Created by iOS on 21/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "HistoryReportVC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "ReportRecord.h"
#import "HistoryReportCell.h"
@interface HistoryReportVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *RideIssueArray;
}
@end

@implementation HistoryReportVC

- (void)viewDidLoad {
    [_tableDetails setHidden:YES];
    RideIssueArray=[[NSMutableArray alloc]init];
    [self showDetailsList];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)showDetailsList
{
    
        
        
        NSDictionary * parameters=@{@"user_id":[Themes checkNullValue: [Themes getUserID]],
                                    
                                    };
        
        
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        
        
        [web GetHistoryReport:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];
             [_tableDetails setHidden:NO];
             if ([responseDictionary count]>0)
             {
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 //
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     for (NSDictionary * dict1 in responseDictionary[@"response"][@"reportsList"]) {
                         ReportRecord *objreportRec=[[ReportRecord alloc]init];
                         objreportRec.reason=[Themes checkNullValue:[dict1 valueForKey:@"reason"]];
                         objreportRec.reason_text=[Themes checkNullValue:[dict1 valueForKey:@"reason_text"]];
                         objreportRec.report_date=[Themes checkNullValue:[dict1 valueForKey:@"report_date"]];
                         objreportRec.report_time=[Themes checkNullValue:[dict1 valueForKey:@"report_time"]];
                         objreportRec.ride_id=[Themes checkNullValue:[dict1 valueForKey:@"ride_id"]];
                         objreportRec.type=[Themes checkNullValue:[dict1 valueForKey:@"type"]];
                         [RideIssueArray addObject:objreportRec];
                     }
                    [_tableDetails reloadData];
                    //                     OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"success", nil)
//                                                                                 message:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]
//                                                                       cancelButtonTitle:nil
//                                                                       otherButtonTitles:@[JJLocalizedString(@"ok", nil)]
//                                                                 usingBlockWhenTapButton:^(OpinionzAlertView *alertView, NSInteger buttonIndex) {
//                                                                     
//                                                                     [self.navigationController popViewControllerAnimated:YES];
//                                                                     
//                                                                 }];
//                     alert.iconType = OpinionzAlertIconSuccess;
//                     [alert show];
                     
                     
                 }
                 if ([comfiramtion isEqualToString:@"0"]) {
                     
                     [self.view makeToast:[Themes checkNullValue:[responseDictionary objectForKey:@"response"]]];
                     [_tableDetails setHidden:YES];
                 }

                 else
                 {
//                     OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Oops", nil)
//                                                                                 message:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]
//                                                                       cancelButtonTitle:JJLocalizedString(@"ok", nil)
//                                                                       otherButtonTitles:nil];
//                     alert.iconType = OpinionzAlertIconWarning;
//                     [alert show];
//                     
                     
                 }
             }
             
             
             
         }
                   failure:^(NSError *error)
         {
             [Themes StopView:self.view];
             [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
             // [SignUP_Btn setUserInteractionEnabled:YES];
             
         }];
        
    }

- (IBAction)didClickBackBtn:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [RideIssueArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    HistoryReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    if (cell == nil) {
        cell = [[HistoryReportCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"HistoryCell"];
    }
    ReportRecord *objreportRec=[RideIssueArray objectAtIndex:indexPath.row];
  
    cell.lblIssues.text=[NSString stringWithFormat:@"%@",objreportRec.reason_text];
    cell.lblType.text=[NSString stringWithFormat:@"%@",objreportRec.reason];
   cell.lblIssues.numberOfLines = 1;
    cell.lblIssues.minimumScaleFactor = 0.5;
    cell.lblIssues.adjustsFontSizeToFitWidth = YES;
   

    if ([objreportRec.type isEqualToString:@"account_issues"]) {
        cell.lblTimeandDate.text=@"";
        cell.lblRideId.text=[NSString stringWithFormat:@"%@ to %@",objreportRec.report_date,objreportRec.report_time];
     //   cell.lblRideId.hidden=YES;
    }
    else{
        cell.lblTimeandDate.text=[NSString stringWithFormat:@"%@ to %@",objreportRec.report_date,objreportRec.report_time];
        cell.lblRideId.text=[NSString stringWithFormat:@"CRN %@",objreportRec.ride_id];
      //  cell.lblRideId.hidden=NO;
    }
    return cell;
}

@end
