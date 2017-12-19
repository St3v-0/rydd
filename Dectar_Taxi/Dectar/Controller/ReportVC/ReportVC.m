//
//  ReportVC.m
//  Dectar
//
//  Created by iOS on 19/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "ReportVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "REFrostedViewController.h"
#import "MyRideRecord.h"
#import "ReportRecord.h"
#import "RecordCell.h"
#import "IssuePopup.h"
#import "WBErrorNoticeView.h"
#import "HistoryReportVC.h"
@interface ReportVC ()<UITableViewDelegate,UITableViewDataSource,senddataDelegate>
{
    NSMutableArray *rideArray;
    NSMutableArray *RideIssueArray;
    NSMutableArray *accountIssueArray;
    NSMutableArray *listArray;
    BOOL isSet;
    NSString *RideID;
    
}
@end

@implementation ReportVC
@synthesize issueReasonStr,selectedReasonRow,issueReasonTextStr;
- (void)viewDidLoad {
    [self reportDetails];
    
    rideArray=[[NSMutableArray alloc]init];
    RideIssueArray=[[NSMutableArray alloc]init];
    accountIssueArray=[[NSMutableArray alloc]init];
    _Scrolling.hidden=YES;
    _btnSubmit.hidden=YES;
    
    
    _lblDateTime.numberOfLines = 1;
    _lblDateTime.minimumScaleFactor = 0.5;
    _lblDateTime.adjustsFontSizeToFitWidth = YES;
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
-(void)reportDetails
{
    
               NSDictionary * parameters=@{@"user_id":[Themes checkNullValue: [Themes getUserID]],
                                                                             };
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [Themes StartView:self.view];
            
            
            [web GetShowReports:parameters success:^(NSMutableDictionary *responseDictionary)
             {
                 [Themes StopView:self.view];
                 _Scrolling.hidden=NO;
                 _btnSubmit.hidden=NO;
                 if ([responseDictionary count]>0)
                 {
                    
                     
                     NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                     //
                     [Themes StopView:self.view];
                     
                     if ([comfiramtion isEqualToString:@"1"])
                     {
                         NSDictionary * dict = [[responseDictionary objectForKey:@"response"] objectForKey:@"rides"] ;
                         if (dict.count>0) {
                             _isFromAccount=NO;
                             MyRideRecord *riderecord=[[MyRideRecord alloc]init];
                             riderecord.ride_status=[Themes checkNullValue:[dict valueForKey:@"ride_status"]];
                             riderecord.ride_id=[Themes checkNullValue:[dict valueForKey:@"ride_id"]];
                             riderecord.ride_date=[Themes checkNullValue:[dict valueForKey:@"ride_date"]];
                             riderecord.ride_time=[Themes checkNullValue:[dict valueForKey:@"ride_time"]];
                             riderecord.RideAmount=[Themes checkNullValue:[dict valueForKey:@"ride_amount"]];
                             riderecord.driverImage=[Themes checkNullValue:[dict valueForKey:@"driverImage"]];
                             riderecord.Currency=[Themes checkNullValue:[Themes findCurrencySymbolByCode:[dict valueForKey:@"currency"]]];
//                             riderecord.Currency=[NSString stringWithFormat:@"%@",[Themes checkNullValue:[Themes findCurrencySymbolByCode:[Themes checkNullValue:riderecord.Currency]]]];
                             RideID = riderecord.ride_id;
                              //currencySymbol=[Themes findCurrencySymbolByCode:[[responseDictionary valueForKey:@"response"] valueForKey:@"currency"]];
                             // [NSString stringWithFormat:@"%@%@",[Themes checkNullValue: ],[Themes findCurrencySymbolByCode:[Themes checkNullValue:objcRecored.Currency]]];
                             _lblRideStatus.text=riderecord.ride_status;
                             _lblDateTime.text=[NSString stringWithFormat:@"%@ to %@",riderecord.ride_date,riderecord.ride_time];
                             _lblDateTime.numberOfLines = 1;
                             _lblDateTime.minimumScaleFactor = 0.5;
                             _lblDateTime.adjustsFontSizeToFitWidth = YES;
                             _lblTripAmount.text=[NSString stringWithFormat:@"%@ %@",riderecord.Currency,riderecord.RideAmount];
                             
                             _lblTripNumber.text=[NSString stringWithFormat:@"CRN %@",riderecord.ride_id];
                             
                             [_imgUser sd_setImageWithURL:[NSURL URLWithString:[Themes FetchUserImage]] placeholderImage:[UIImage imageNamed:@"Drivericon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                             }];

                         }
                         else{
                             _isFromAccount=YES;
                         }
                         
                          
                             
                       
                         for (NSDictionary * dict1 in responseDictionary[@"response"][@"reports"][@"account_issues"]) {
                             ReportRecord *objreport=[[ReportRecord alloc]init];
                             objreport.custom=[Themes checkNullValue:[dict1 valueForKey:@"custom"]];
                             objreport.issue=[Themes checkNullValue:[dict1 valueForKey:@"issue"]];
                             objreport.type=[Themes checkNullValue:[dict1 valueForKey:@"type"]];
                             [accountIssueArray addObject:objreport];
                             
                         }
                         for (NSDictionary * dict1 in responseDictionary[@"response"][@"reports"][@"rydd_issues"]) {
                             ReportRecord *objreportRec=[[ReportRecord alloc]init];
                             objreportRec.custom=[Themes checkNullValue:[dict1 valueForKey:@"custom"]];
                             objreportRec.issue=[Themes checkNullValue:[dict1 valueForKey:@"issue"]];
                             objreportRec.type=[Themes checkNullValue:[dict1 valueForKey:@"type"]];
                             [RideIssueArray addObject:objreportRec];
                    }
                        
                         if (_isFromAccount==YES) {
                             _RideSegmentedControll.selectedSegmentIndex=1;
                             [self didClickSegmentIndexBtn:self];
                         }
                         else{
                              [_tableData reloadData];
                               [self setFrameDetails];
                         }
                       
                     }
                     
                     else
                     {
                         
                         // [SignUP_Btn setUserInteractionEnabled:YES];
                         
                     }
                 }
                 
                 // [SignUP_Btn setUserInteractionEnabled:YES];
                 
                 
             }
                    failure:^(NSError *error)
             {
                 [Themes StopView:self.view];
                 if (self.errorCount<2) {
                     [self reportDetails];
                     self.errorCount++;
                     
                 }
                 else{
                     [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];

                 }
                 // [SignUP_Btn setUserInteractionEnabled:YES];
                 
             }];
            
        }

-(void)setFrameDetails{
    if (_isFromAccount==YES) {
        _tableData.frame=CGRectMake(self.tableData.frame.origin.x,0, self.tableData.frame.size.width, self.tableData.contentSize.height);
        _viewReport.frame=CGRectMake(self.viewReport.frame.origin.x, 0,self.viewReport.frame.size.width,  self.tableData.frame.origin.y+self.tableData.frame.size.height);
        _Scrolling.contentSize=CGSizeMake(self.Scrolling.frame.size.width, self.viewReport.frame.origin.y+self.viewReport.frame.size.height);
        
    }
    else{
        _tableData.frame=CGRectMake(self.tableData.frame.origin.x, self.tableData.frame.origin.y, self.tableData.frame.size.width, self.tableData.contentSize.height);
        _viewReport.frame=CGRectMake(self.viewReport.frame.origin.x, self.viewReport.frame.origin.y,self.viewReport.frame.size.width,  self.tableData.frame.origin.y+self.tableData.frame.size.height);
        _Scrolling.contentSize=CGSizeMake(self.Scrolling.frame.size.width, self.viewReport.frame.origin.y+self.viewReport.frame.size.height);
    }
    
    
}

- (IBAction)didClickBackBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];

    
}
-(void)ReloadTableviewDatas
{
    for (int i=0; i<RideIssueArray.count; i++) {
        ReportRecord *recRep=(ReportRecord *)[RideIssueArray objectAtIndex:i];
        
        recRep.isSelected=NO;
        
        
    }
    for (int i=0; i<accountIssueArray.count; i++) {
        ReportRecord *recRep=(ReportRecord *)[accountIssueArray objectAtIndex:i];
        
        recRep.isSelected=NO;
        
        
    }
    issueReasonTextStr=@"";
    issueReasonStr=@"";
    [_tableData reloadData];
    [self setFrameDetails];
}
- (IBAction)didClickSegmentIndexBtn:(id)sender {
    
    [self ReloadTableviewDatas];
 
}

- (IBAction)didClickSubmitBtn:(id)sender {
    
    
    if (issueReasonTextStr.length>0 && issueReasonStr.length>0) {
         [self addReportsDetails];
    }
    else{
        [self showErrorMessage:@"Please Select an issue"];

    }
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSInteger rowcount=0;
    if (_RideSegmentedControll.selectedSegmentIndex==0) {
      rowcount=  [RideIssueArray count];
    }
    else if (_RideSegmentedControll.selectedSegmentIndex==1)
    {
     rowcount=   [accountIssueArray count];
}
    return rowcount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *reuseIdentifier = @"recordCell"; //should match what you've set in Interface Builder
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:nil options:nil] objectAtIndex:0];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
    if (_RideSegmentedControll.selectedSegmentIndex==0) {
               ReportRecord *recRep=(ReportRecord *)[RideIssueArray objectAtIndex:indexPath.row];
         cell.lblReportIssue.text=recRep.issue;
          if (recRep.isSelected==YES) {
              cell.lblSelect.backgroundColor=BGCOLOR;
             
           }
          else{
              cell.lblSelect.backgroundColor=[UIColor clearColor];

          }
    }
    if (_RideSegmentedControll.selectedSegmentIndex==1) {
         ReportRecord *recRep=(ReportRecord *)[accountIssueArray objectAtIndex:indexPath.row];
        cell.lblReportIssue.text=recRep.issue;

        if (recRep.isSelected==YES) {
            cell.lblSelect.backgroundColor=BGCOLOR;

        }
        else{
            cell.lblSelect.backgroundColor=[UIColor clearColor];


        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_RideSegmentedControll.selectedSegmentIndex==0) {
        for (int i=0; i<RideIssueArray.count; i++) {
            ReportRecord *recRep=(ReportRecord *)[RideIssueArray objectAtIndex:i];
            if (indexPath.row==i) {
                recRep.isSelected=YES;
                issueReasonStr=recRep.type;
                selectedReasonRow=indexPath.row;
                issueReasonTextStr=[Themes checkNullValue:recRep.issue];
            }
            else{
                recRep.isSelected=NO;
            }
           
        }
        ReportRecord *recRep=(ReportRecord *)[RideIssueArray objectAtIndex:indexPath.row];
        [_tableData reloadData];
        [self setFrameDetails];
        if ([recRep.custom isEqualToString:@"yes"]) {
            
            [self SetDataToPopup];
        }

        
     
      

    }
    
 else    if (_RideSegmentedControll.selectedSegmentIndex==1) {
     for (int i=0; i<accountIssueArray.count; i++) {
         ReportRecord *recRep=(ReportRecord *)[accountIssueArray objectAtIndex:i];
         if (indexPath.row==i) {
             recRep.isSelected=YES;
             issueReasonStr=recRep.type;
             selectedReasonRow=indexPath.row;
               issueReasonTextStr=[Themes checkNullValue:recRep.issue];
         }
         else{
             recRep.isSelected=NO;
         }
         
     }
     [_tableData reloadData];
     [self setFrameDetails];
     ReportRecord *recRep=(ReportRecord *)[accountIssueArray objectAtIndex:indexPath.row];
     if ([recRep.custom isEqualToString:@"yes"]) {
         [self SetDataToPopup];
         
     }
    }
}



-(void)sendDataToA:(NSString *)txtStr
{
    if (txtStr.length==0) {
        [self ReloadTableviewDatas];
    }
    else{
             issueReasonTextStr=[Themes checkNullValue:txtStr];
    }
 
  
}
-(void)SetDataToPopup
{
  
        IssuePopup *issueVC=[self.storyboard instantiateViewControllerWithIdentifier:@"IssuePopupVC"];
        //[self presentViewController:issueVC animated:NO completion:nil];
        if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
        {
            //For iOS 8
            issueVC.providesPresentationContextTransitionStyle = YES;
            issueVC.definesPresentationContext = YES;
            issueVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        else
        {
            //For iOS 7
            issueVC.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
       issueVC.delegate=self;

        [self presentViewController:issueVC animated:NO completion:nil];
    }
-(void)addReportsDetails
{
    
 

    NSDictionary * parameters=@{@"user_id":[Themes checkNullValue: [Themes getUserID]],
                                @"reason":[Themes checkNullValue:issueReasonStr],
                                @"reason_text":[Themes checkNullValue:issueReasonTextStr],
                                @"ride_id":[Themes checkNullValue:RideID],
                        
                                };
   
    
    
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [Themes StartView:self.view];
            
            
    [web GetAddReports:parameters success:^(NSMutableDictionary *responseDictionary)
             {
                 [Themes StopView:self.view];
                 
                 if ([responseDictionary count]>0)
                 {
                     responseDictionary=[Themes writableValue:responseDictionary];
                     
                     NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                     //
                     [Themes StopView:self.view];
                     
                     if ([comfiramtion isEqualToString:@"1"])
                     {
                         OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"success", nil)
                                                                                     message:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@[JJLocalizedString(@"ok", nil)]
                                                                     usingBlockWhenTapButton:^(OpinionzAlertView *alertView, NSInteger buttonIndex) {
                                                                         
                                                                         [self.navigationController popViewControllerAnimated:YES];
                                                                         
                                                                     }];
                         alert.iconType = OpinionzAlertIconSuccess;
                         [alert show];

                           [self ReloadTableviewDatas];
                     }
                     
                     else
                     {
                         OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Oops", nil)
                                                                                     message:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]
                                                                           cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                                           otherButtonTitles:nil];
                         alert.iconType = OpinionzAlertIconWarning;
                         [alert show];

                         
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
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str,nil)];
    [notice show];
}
- (IBAction)didClickHistory:(id)sender {
    HistoryReportVC *historyVC=[self.storyboard instantiateViewControllerWithIdentifier:@"historyreportVC"];
    
    [[self navigationController]pushViewController:historyVC animated:YES];
}




@end
