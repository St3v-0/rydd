//
//  MyRideVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/13/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "MyRideVC.h"
#import "MyRideCell.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "MyRideRecord.h"
#import "DetailMyRideVc.h"
#import "Constant.h"
#import "REFrostedViewController.h"
#import "LanguageHandler.h"

@interface MyRideVC ()
{
    NSString *totalRides;
    NSString * rideID;
    NSString * userID;
    NSString * ride_Status;
    MyRideRecord *objcRecored;
    NSMutableArray *sortArray;
    
    
}

@property (strong) IBOutlet UITableView * MyRideTable;
@property (strong) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *Rides_Segement;
@property (strong, nonatomic)  NSString *Rides_type;
@property (strong, nonatomic)  NSMutableArray *RideAllArray;
@property (strong, nonatomic)  NSMutableArray *UpcomingArray;
@property (strong, nonatomic)  NSMutableArray *CompleteArray;
@property (assign, nonatomic) BOOL isSort;


@end

@implementation MyRideVC
@synthesize Rides_type,Rides_Segement,RideAllArray,NorideVIEW,UpcomingArray,CompleteArray,isSort,Sort_Btn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   


    //[_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self segmentAction:Rides_Segement];
    
    _MyRideTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Set the gesture
    RideAllArray=[NSMutableArray array];
    UpcomingArray=[NSMutableArray array];
    CompleteArray=[NSMutableArray array];
    //Sort_Btn.hidden=YES;
    userID=[Themes getUserID];
    objcRecored=[[MyRideRecord alloc]init];
    [self GetRideList];
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
/*-(void)viewWillAppear:(BOOL)animated{
   
    
    
}*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [Rides_Segement setTitle:JJLocalizedString(@"all", nil) forSegmentAtIndex:0];
    [Rides_Segement setTitle:JJLocalizedString(@"complete", nil) forSegmentAtIndex:1];
   // [Rides_Segement setTitle:JJLocalizedString(@"complete", nil) forSegmentAtIndex:2];

    [_noride setText:JJLocalizedString(@"No_Rides_Booked", nil)];
    [_hint_noride setText:JJLocalizedString(@"There_are_no_rides_for_you", nil)];
    [_bookaride_btn setTitle:JJLocalizedString(@"BOOK_A_RIDE", nil) forState:UIControlStateNormal];
    [_HeaderLbl setText:JJLocalizedString(@"my_ride", nil)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
- (IBAction)segmentAction:(id)sender
{
    isSort=NO;

    switch (self.Rides_Segement.selectedSegmentIndex)
    {
        case 0:
            Rides_type=@"all";
            break;
//        case 1:
//            Rides_type=@"upcoming";
//            break;
        case 1:
            Rides_type=@"completed";
            break;
        default:
            break;
    }
    [_MyRideTable reloadData];
}
-(void)GetRideList
{
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                               @"type":Rides_type};
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web Myride:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             [Themes StopView:self.view];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 [_MyRideTable setHidden:NO];
                 NorideVIEW.hidden=YES;
                 
                 for (NSDictionary * objCatDict in responseDictionary[@"response"][@"rides"]) {
                     objcRecored=[[MyRideRecord alloc]init];
                     objcRecored.pickup=[Themes checkNullValue:[objCatDict valueForKey:@"pickup"]];
                     objcRecored.ride_date =[Themes checkNullValue:[objCatDict valueForKey:@"ride_date"]]  ;
                     objcRecored.ride_id=[Themes checkNullValue:[objCatDict valueForKey:@"ride_id"] ];
                     objcRecored.ride_time=[Themes checkNullValue:[objCatDict valueForKey:@"ride_time"]] ;
                     objcRecored.group=[Themes checkNullValue:[objCatDict valueForKey:@"group"] ];
                     objcRecored.myride_status=[Themes checkNullValue:[objCatDict valueForKey:@"ride_status"]];
                     objcRecored.dateTime=[Themes checkNullValue:[objCatDict valueForKey:@"datetime"]];
                     objcRecored.myride_display_status=[Themes checkNullValue:[objCatDict valueForKey:@"display_status"]];
                     objcRecored.drivername=[Themes checkNullValue:[objCatDict valueForKey:@"drivername"]];
                     objcRecored.mileage=[Themes checkNullValue:[objCatDict valueForKey:@"mileage"]];
                     objcRecored.CancellationFee=[Themes checkNullValue:[objCatDict valueForKey:@"ride_fare"]];
                     objcRecored.CancellationStatus=[Themes checkNullValue:[objCatDict valueForKey:@"cancellation"]];
                     if([objcRecored.group isEqualToString:@"upcoming"]){
                         [UpcomingArray addObject:objcRecored];
                         
                     }else if ([objcRecored.group isEqualToString:@"completed"]){
                         [CompleteArray addObject:objcRecored];
                     }
                     [RideAllArray addObject:objcRecored];
                     
                 }
                 [_MyRideTable reloadData];
                 
                 totalRides=[[responseDictionary valueForKey:@"response"] valueForKey:@"total_rides"];
                 
             }
             else
             {
                 
             }
         }
     }
        failure:^(NSError *error) {
              [Themes StopView:self.view];
            if(self.errorCount<2){
                [self GetRideList];
                self.errorCount++;
            }else{
                [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
            }
          
        }];
}

- (IBAction)BookRide:(id)sender {
    
    AppDelegate*appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appdelegate setInitialViewController];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowcount=0;
    
    if(Rides_Segement.selectedSegmentIndex==0){
        
        if(isSort==YES){
            rowcount=[sortArray count];
            
            if (rowcount ==0)
            {
               [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
                ///Sort_Btn.hidden=YES;
            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
                Sort_Btn.hidden=NO;

            }
            
        }
        else
        {
            rowcount=[RideAllArray count];
            if (rowcount ==0)
            {
                [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
                
               // Sort_Btn.hidden=YES;

            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
                Sort_Btn.hidden=NO;

            }

        }
        
    }
//    else if (Rides_Segement.selectedSegmentIndex==1)
//    {
//        if(isSort==YES){
//            rowcount=[sortArray count];
//            
//            if (rowcount ==0)
//            {
//                [_MyRideTable setHidden:YES];
//                NorideVIEW.hidden=NO;
//                //Sort_Btn.hidden=YES;
//
//            }
//            else
//            {
//                [_MyRideTable setHidden:NO];
//                NorideVIEW.hidden=YES;
//                Sort_Btn.hidden=NO;
//           }
//        }
//        else
//        {
//            rowcount=[UpcomingArray count];
//            if (rowcount ==0)
//            {
//                [_MyRideTable setHidden:YES];
//                NorideVIEW.hidden=NO;
//                //Sort_Btn.hidden=YES;
//
//            }
//            else
//            {
//                [_MyRideTable setHidden:NO];
//                NorideVIEW.hidden=YES;
//                Sort_Btn.hidden=NO;
//            }
//            
//        }

        
   // }
else if (Rides_Segement.selectedSegmentIndex==1){
        if(isSort==YES){
            rowcount=[sortArray count];
            
            if (rowcount ==0)
            {
                [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
                //Sort_Btn.hidden=YES;

            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
                Sort_Btn.hidden=NO;

            }
            
        }
        else
        {
            rowcount=[CompleteArray count];
            if (rowcount ==0)
            {
                [_MyRideTable setHidden:YES];
                NorideVIEW.hidden=NO;
               //Sort_Btn.hidden=YES;

            }
            else
            {
                [_MyRideTable setHidden:NO];
                NorideVIEW.hidden=YES;
               Sort_Btn.hidden=NO;

            }
            
        }

    }
    return rowcount;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"MyRideCell"; //should match what you've set in Interface Builder
    MyRideCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRideCell" owner:nil options:nil] objectAtIndex:0];
      
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    MyRideRecord *objRec;
    
    if(Rides_Segement.selectedSegmentIndex==0){
       
        
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
        }else{
            objRec=(MyRideRecord*)[RideAllArray objectAtIndex:indexPath.row];
            
        }
        ride_Status=objRec.myride_status;
        /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:objRec.dateTime];
        
        [self relativeDateStringForDate:dateFromString];*/
        
        cell.placelable.text=objRec.myride_display_status;
                if ([ride_Status isEqualToString:@"Booked"] || [ride_Status isEqualToString:@"Onride"])
        {
           
            cell.placelable.text=@"On RYDD";
               [cell.placelable setTextColor:[UIColor orangeColor]];
            cell.lblMileage.hidden=YES;
            cell.imgMileage.hidden=YES;
            cell.lblCancellationFee.hidden=YES;
            cell.imgCancelFee.hidden=YES;
                   }
        else if ([ride_Status isEqualToString:@"Finished"])
            
        {
           cell.placelable.text=@"Unpaid";
               [cell.placelable setTextColor:[UIColor blueColor]];
            cell.lblMileage.hidden=NO;
            cell.imgMileage.hidden=NO;
            cell.lblCancellationFee.hidden=YES;
            cell.imgCancelFee.hidden=YES;

        }
        else if ([ride_Status isEqualToString:@"Completed"])
            
        {
            
               [cell.placelable setTextColor:[UIColor purpleColor]];
            cell.lblMileage.hidden=NO;
            cell.imgMileage.hidden=NO;
            cell.lblCancellationFee.hidden=NO;
            cell.imgCancelFee.hidden=NO;

        }
        else if ([ride_Status isEqualToString:@"Cancelled"])
            
        {
            
               [cell.placelable setTextColor:[UIColor redColor]];
            cell.lblMileage.hidden=YES;
            cell.imgMileage.hidden=YES;
            cell.lblCancellationFee.hidden=YES;
            cell.imgCancelFee.hidden=YES;

            if ([objRec.CancellationStatus isEqualToString:@"1"]) {
                cell.lblCancellationFee.hidden=NO;
                cell.imgCancelFee.hidden=NO;
                cell.lblCancellationFee.text=objRec.CancellationFee;
            }
            else{
                cell.lblCancellationFee.hidden=YES;
                cell.imgCancelFee.hidden=YES;

                cell.lblCancellationFee.text=objRec.CancellationFee;
            }


        }
        else if ([ride_Status isEqualToString:@"Confirmed"])
            
        {
            
            cell.placelable.text=@"On RYDD";
               [cell.placelable setTextColor:[UIColor brownColor]];
            cell.lblMileage.hidden=YES;
            cell.imgMileage.hidden=YES;
            cell.lblCancellationFee.hidden=YES;
            cell.imgCancelFee.hidden=YES;


        }
        else if ([ride_Status isEqualToString:@"Arrived"])
        {
         
            cell.placelable.text=@"On RYDD";
            [cell.placelable setTextColor:[UIColor magentaColor]];
            cell.lblMileage.hidden=YES;
            cell.imgMileage.hidden=YES;
            cell.lblCancellationFee.hidden=YES;
            cell.imgCancelFee.hidden=YES;


        }
        cell.placelable.hidden=NO;
        cell.status.hidden=NO;
        
    }
//    else if (Rides_Segement.selectedSegmentIndex==1)
//    {
//        
//        if(isSort==YES){
//            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
//        }else{
//            objRec=(MyRideRecord*)[UpcomingArray objectAtIndex:indexPath.row];
//            
//        }
//        
//        cell.status.hidden=YES;
//    }
    else if (Rides_Segement.selectedSegmentIndex==1){
        
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
        }else{
            objRec=(MyRideRecord*)[CompleteArray objectAtIndex:indexPath.row];
            
        }
        cell.status.hidden=YES;
        cell.lblMileage.hidden=NO;
        cell.imgMileage.hidden=NO;
        cell.lblCancellationFee.hidden=NO;
        cell.imgCancelFee.hidden=NO;
    }
    NSString * from=JJLocalizedString(@"from", nil);
    cell.Timelable.text=[NSString stringWithFormat:@"%@ %@ %@",objRec.ride_time,from,objRec.pickup];
    cell.Datelable.text=objRec.ride_date;
    cell.lblDriverName.text=objRec.drivername;
    cell.lblCancellationFee.text=objRec.CancellationFee;
    cell.lblMileage.text=[NSString stringWithFormat:@"%@ Km",objRec.mileage];
        return cell;
    }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRideRecord *objRec;
    
    
    if(Rides_Segement.selectedSegmentIndex==0)
    {
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;

        }else{
            objRec=(MyRideRecord*)[RideAllArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;
        }
        
    }
    
//    else if (Rides_Segement.selectedSegmentIndex==1)
//    {
//        if(isSort==YES){
//            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
//            rideID= objRec.ride_id;
//            
//        }else{
//            objRec=(MyRideRecord*)[UpcomingArray objectAtIndex:indexPath.row];
//            rideID= objRec.ride_id;
//        }
//    }
    else if (Rides_Segement.selectedSegmentIndex==1){
      
        if(isSort==YES){
            objRec=(MyRideRecord*)[sortArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;
            
        }else{
            objRec=(MyRideRecord*)[CompleteArray objectAtIndex:indexPath.row];
            rideID= objRec.ride_id;
        }
    }
    if(rideID.length>0){
        DetailMyRideVc * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsMyrideVCID"];
        [addfavour setUserRideId:rideID];
        [self.navigationController pushViewController:addfavour animated:YES];
    }
}

- (IBAction)didClickFilterBtn:(id)sender {
    _MyRideTable.userInteractionEnabled=NO;
    NSArray * arryList=[[NSArray alloc]init];
    arryList=@[JJLocalizedString(@"All_Caps", nil) ,JJLocalizedString(@"Last_one_week", nil),JJLocalizedString(@"Last_two_weeks", nil),JJLocalizedString(@"Last_one_month", nil),JJLocalizedString(@"Last_one_year", nil)];
    [Dropobj fadeOut];
    [self showPopUpWithTitle:JJLocalizedString(@"Sort", nil)  withOption:arryList xy:CGPointMake(self.view.frame.size.width-205, 57) size:CGSizeMake(195, 310) isMultiple:NO];
}
///////FilterView
-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDown_R:255.0 G:255.0 B:255.0 alpha:0.90];
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
      _MyRideTable.userInteractionEnabled=YES;
    isSort=YES;
    [self filterTripAccordingToDate:anIndex];
}
-(void)filterTripAccordingToDate:(NSInteger)index{
    switch (index) {
        case 0:
            isSort=NO;
            break;
        case 1:
            [self filterTableViewWithIndex:1];
            break;
        case 2:
            [self filterTableViewWithIndex:2];
            break;
        case 3:
            [self filterTableViewWithIndex:3];
            break;
        case 4:
            [self filterTableViewWithIndex:4];
            break;
        default:
            break;
    }
    [_MyRideTable reloadData];
}
-(void)filterTableViewWithIndex:(NSInteger)index{
    sortArray=[[NSMutableArray alloc]init];
    NSMutableArray * dummayArray=[[NSMutableArray alloc]init];
    if(Rides_Segement.selectedSegmentIndex==0){
        dummayArray=RideAllArray;
    }
//    else if (Rides_Segement.selectedSegmentIndex==1){
//        dummayArray=UpcomingArray;
//    }
    else if (Rides_Segement.selectedSegmentIndex==1){
        dummayArray=CompleteArray ;
    }
    for (int i=0; i<[dummayArray count]; i++) {
        MyRideRecord * objTripRecs=[dummayArray objectAtIndex:i];
        NSTimeInterval distanceBetweenDates = [[self getDateWithIndex:index] timeIntervalSinceDate:[self setDate:objTripRecs.dateTime]];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates <= 0){
            [sortArray addObject:objTripRecs];
        }
    }
}
-(NSDate*)setDate:(NSString*)dateStr{
    if ([dateStr isKindOfClass:[NSDate class]]) {
        return (NSDate*)dateStr;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
}
-(NSDate *)getDateWithIndex:(NSInteger)index{
    NSDate *now = [NSDate date];
    NSDate *sevenDaysAgo;
    if(index==1){
        sevenDaysAgo = [now dateByAddingTimeInterval:-7*24*60*60];
    }
    else if (index==2){
        sevenDaysAgo = [now dateByAddingTimeInterval:-14*24*60*60];
    }else if (index==3){
        sevenDaysAgo = [now dateByAddingTimeInterval:-31*24*60*60];
    }else if (index==3){
        sevenDaysAgo = [now dateByAddingTimeInterval:-365*24*60*60];
    }
    return sevenDaysAgo;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
      _MyRideTable.userInteractionEnabled=YES;
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
    }
    [_MyRideTable reloadData];
}
- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            
            return @"Yesterday";
        }
    } else {
        return @"Today";
    }
}

@end
