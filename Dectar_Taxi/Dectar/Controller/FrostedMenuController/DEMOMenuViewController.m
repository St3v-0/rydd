//
//  DEMOMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "BookARideVC.h"
#import "MyRideVC.h"
#import "Constant.h"
#import "LoginMainVC.h"
#import "Themes.h"
#import "FavorVC.h"
#import "AddressRecord.h"
#import "MyprofileVC.h"
#import "AppDelegate.h"
#import "InviteEarnVC.h"
#import "MoneyVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "RateCardVC.h"
#import "AboutVc.h"
#import "FareVC.h"
#import "FareRecord.h"
#import "RatingVC.h"
#import "AdvertsRecord.h"
#import "AdvertsVC.h"
#import "DEMONavigationController.h"
#import "EmergencyVC.h"
#import "MenuTableViewCell.h"
#import "LanguageHandler.h"
#import "PaymentMethodVC.h"
#import "AppInfoRecords.h"
#import "ReportVC.h"

@interface DEMOMenuViewController (){
    UIImageView *imageView ;
    NSString * MoneyName;
    JJLocationManager * jjLocManager;

}

@end

@implementation DEMOMenuViewController
@synthesize titleArray;
@synthesize ImgArray;

- (void)viewDidLoad
{
    
    
    
    
    [super viewDidLoad];
   // NSString * money=JJLocalizedString(@"money", nil);
   // MoneyName=[NSString stringWithFormat:@"%@ %@",[Themes getAppName],money];
    if(jjLocManager==nil){
        jjLocManager=[JJLocationManager sharedManager];
        
    }

    MoneyName=JJLocalizedString(@"My_Wallet", nil);
    
//    titleArray=[[NSMutableArray alloc]initWithObjects:JJLocalizedString(@"Book_a_Ride", nil),JJLocalizedString(@"My_Rides", nil),JJLocalizedString(@"Rate_Card", nil),MoneyName,JJLocalizedString(@"invite_and_earn", nil),JJLocalizedString(@"Emergency_Contact", nil),JJLocalizedString(@"Report_issues", nil),JJLocalizedString(@"About_us", nil), nil];
    NSDictionary * appInfoDict=[Themes AppAllInfoDatas];
    if (appInfoDict!=nil) {
          NSString * isHaveEmergeny=[Themes checkNullValue:[appInfoDict objectForKey:@"user_emergency_page"]];
        if ([isHaveEmergeny isEqualToString:@"no"] || [isHaveEmergeny isEqualToString:@""]) {
            titleArray=[[NSMutableArray alloc]initWithObjects:@"Book_a_Ride",@"My_Rides",@"Payment",@"Favourites",MoneyName,@"invite_and_earn",@"Report_issues",@"Settings", @"About_us",nil];
               ImgArray=[[NSMutableArray alloc]initWithObjects:@"TaxiMenu",@"Wheel",@"MenuPayment",@"OpinionzAlertIconHeart",@"MenuWallet",@"menuTicke", @"Report",@"Setting", @"About",nil];
        }
        else{
            titleArray=[[NSMutableArray alloc]initWithObjects:@"Book_a_Ride",@"My_Rides",@"Payment",@"Favourites",MoneyName,@"invite_and_earn",@"Report_issues",@"Settings",@"About_us",@"Emergency_Contact", nil];
            ImgArray=[[NSMutableArray alloc]initWithObjects:@"TaxiMenu",@"Wheel",@"MenuPayment",@"OpinionzAlertIconHeart",@"MenuWallet",@"menuTicke",@"Report",@"Setting",@"About",@"MenuEmergency", nil];
        }
    }
    else{
        titleArray=[[NSMutableArray alloc]initWithObjects:@"Book_a_Ride",@"My_Rides",@"Payment",@"Favourites",MoneyName,@"invite_and_earn",@"Report_issues",@"Settings",@"About_us", nil];
        ImgArray=[[NSMutableArray alloc]initWithObjects:@"TaxiMenu",@"Wheel",@"MenuPayment",@"OpinionzAlertIconHeart",@"MenuWallet", @"menuTicke",@"Report",@"Setting",@"About",nil];
    }
  
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:54.0/255.0 blue:58.0/255.0 alpha:1.0];
    self.tableView.tableHeaderView = ({
      

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 174.0f)];
       imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 50, 50)];
         
        UITapGestureRecognizer * Coupon=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(PushToProfile)];
        Coupon.numberOfTapsRequired = 1;
        [view addGestureRecognizer:Coupon];
       // imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 25.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[Themes fatechUserImage]] placeholderImage:[UIImage imageNamed:@"Drivericon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
       
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 68, 0, 24)];
        
        label.text = [Themes checkNullValue:[Themes getUserName]];
        label.numberOfLines = 1;
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
     

        [label sizeToFit];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 97, 0, 24)];
        
        label1.text = [NSString stringWithFormat:@"%@-%@",[Themes GetCountryCode],[Themes getmobileNumber]];
        label1.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor whiteColor];
        [label1 sizeToFit];
        
        //label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 174, self.tableView.frame.size.width, .5)];
        line.backgroundColor = self.tableView.separatorColor;
        [view addSubview:imageView];
        [view addSubview:label];
        [view addSubview:label1];
        [view addSubview:line];
        view;
        
      
        
    });
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[Themes fatechUserImage]] placeholderImage:[UIImage imageNamed:@"Drivericon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}
-(void)PushToProfile
{
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"StarterNavVCSID"];
    MyprofileVC *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileVCID"];
    navigationController.viewControllers = @[homeViewController];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
  
//    [self presentViewController:ObjMyprofileVC animated:YES completion:nil];
   
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"StarterNavVCSID"];
    
    if ( indexPath.row == 0) {
        BookARideVC *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BookARideVCID"];
        navigationController.viewControllers = @[homeViewController];
        
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    } else if(indexPath.row==1) {
        MyRideVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRideVCID"];
        navigationController.viewControllers = @[secondViewController];
        
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    }
//    else if(indexPath.row==2) {
//        RateCardVC *thirdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RateCardVCID"];
//        navigationController.viewControllers = @[thirdViewController];
//        
//        self.frostedViewController.contentViewController = navigationController;
//        [self.frostedViewController hideMenuViewController];
//    }
    else if(indexPath.row==2) {
        PaymentMethodVC *FourthViewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentMethodVc"];
        navigationController.viewControllers = @[FourthViewController1];
        
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];

            }
    else if(indexPath.row==3) {
        FavorVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"FavourVCID"];
        AddressRecord * objRec=[[AddressRecord alloc]init];
        objRec.ADDlatitude=jjLocManager.currentLocation.coordinate.latitude;
        objRec.ADDlongitude=jjLocManager.currentLocation.coordinate.longitude;
        [addfavour setObjRecord:objRec];
        addfavour.isfromMenu = true;

        navigationController.viewControllers = @[addfavour];
        
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
       
    }

    else if(indexPath.row==4) {
        MoneyVC *FourthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyVCID"];
        navigationController.viewControllers = @[FourthViewController];
        
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];

            }

    else if(indexPath.row==5) {
        InviteEarnVC *FifthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteVCID"];
        navigationController.viewControllers = @[FifthViewController];
        
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    }
       else if(indexPath.row==6) {
           ReportVC *FifthViewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Reportvc"];
           navigationController.viewControllers = @[FifthViewController1];
           
           self.frostedViewController.contentViewController = navigationController;
           [self.frostedViewController hideMenuViewController];

    }
       else if(indexPath.row==7) {
          MyprofileVC *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileVCID"];
           navigationController.viewControllers = @[homeViewController];
           
           self.frostedViewController.contentViewController = navigationController;
           [self.frostedViewController hideMenuViewController];
       }

    else if(indexPath.row==8) {
        AboutVc *EighthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutVCID"];
        navigationController.viewControllers = @[EighthViewController];
        
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    }
    else if(indexPath.row==9) {
        
        EmergencyVC *SixViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmergencyVCID"];
        navigationController.viewControllers = @[SixViewController];
        
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    }

//    self.frostedViewController.contentViewController = navigationController;
//    [self.frostedViewController hideMenuViewController];
}


-(void)openEmailfeedback{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"feedBackEmail"
     object:self userInfo:nil];
    
}
   //Add an alert in case of failure
    
/*-(void)Logout{
    
    [self showActivityIndicator:YES];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web LogoutDriver:[self setParametersForLogout]
              success:^(NSMutableDictionary *responseDictionary)
     {
         [self stopActivityIndicator];
         //if ([[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"status"]]isEqualToString:@"1"]) {
         AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
         [Theme ClearUserDetails];
         [testAppDelegate logoutXmpp];
         LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
         testAppDelegate.window.rootViewController = navigationController;
         self.view.userInteractionEnabled=YES;
         //         }else{
         //
         //             [self.view makeToast:kErrorMessage];
         //         }
     }
              failure:^(NSError *error)
     {
         
         [self stopActivityIndicator];
         AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
         [testAppDelegate logoutXmpp];
         [Theme ClearUserDetails];
         LoginViewController * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"InitialVCSID"];
         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
         testAppDelegate.window.rootViewController = navigationController;
         self.view.userInteractionEnabled=YES;
         [self.view makeToast:kErrorMessage];
         
     }];
}
-(void)showActivityIndicator:(BOOL)isShow{
    if(isShow==YES){
        if(custIndicatorView==nil){
            custIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePulse color:SetThemeColor];
            
        }
        custIndicatorView.center =self.view.center;
        [custIndicatorView startAnimating];
        [self.view addSubview:custIndicatorView];
        [self.view bringSubviewToFront:custIndicatorView];
    }
}
-(void)stopActivityIndicator{
    [custIndicatorView stopAnimating];
    custIndicatorView=nil;
}
-(NSDictionary *)setParametersForLogout{
    NSString * driverId=@"";
    if([Theme UserIsLogin]){
        NSDictionary * myDictionary=[Theme DriverAllInfoDatas];
        driverId=[myDictionary objectForKey:@"driver_id"];
    }
    NSDictionary *dictForuser = @{
                                  @"driver_id":driverId,
                                  @"device":@"IOS"
                                  };
    return dictForuser;
}*/

#pragma mark -
#pragma mark UITableView Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==[titleArray count]){
        return 120;
    }
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *lastCellIdentifier = @"LastCellIdentifier";
     static NSString *NormalCellIdentifier = @"MenuListIdentifier";
    
    if(indexPath.row==([titleArray count])){ //This is last cell so create normal cell
        UITableViewCell *lastcell = [tableView dequeueReusableCellWithIdentifier:lastCellIdentifier];
        if(!lastcell){
            lastcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellIdentifier];
            CGRect frame = CGRectMake((self.tableView.frame.size.width/2)-(200/2),40,200,50);
            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [aButton addTarget:self action:@selector(btnAddRowTapped:) forControlEvents:UIControlEventTouchUpInside];
            aButton.frame = frame;
            aButton.layer.cornerRadius=5;
            aButton.layer.masksToBounds=YES;
            [aButton setTitle:JJLocalizedString(@"logout", nil) forState:UIControlStateNormal];
            
            aButton.backgroundColor=BGCOLOR;
            aButton.titleLabel.textColor=[UIColor whiteColor];
           [lastcell addSubview:aButton];
            lastcell.separatorInset = UIEdgeInsetsMake(0.f, lastcell.bounds.size.width, 0.f, 0.f);
                   }
        return lastcell;
    }else{
        MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
        if (cell == nil) {
            cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:NormalCellIdentifier];
        }
        
      
          NSString * textStr=[Themes checkNullValue:[titleArray objectAtIndex:indexPath.row]];
        if([textStr isEqualToString:MoneyName]){
            cell.walletLbl.text=[Themes checkNullValue:[Themes GetFullWallet]];
               NSString * textStr=[Themes checkNullValue:[titleArray objectAtIndex:indexPath.row]];
                cell.titleLbl.text= textStr;
        }else{
             cell.walletLbl.text=@"";
               NSString * textStr=[Themes checkNullValue:JJLocalizedString([titleArray objectAtIndex:indexPath.row], nil)];
            cell.titleLbl.text= textStr;
           
        }
        cell.IconImgView.image=[UIImage imageNamed:[ImgArray objectAtIndex:indexPath.row]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary * appInfoDict=[Themes AppAllInfoDatas];

    NSString *OperatingHours=[Themes checkNullValue:[appInfoDict objectForKey:@"operating_hours"]];
    UILabel *lblOperatingHours = [[UILabel alloc] init];
    lblOperatingHours.frame = CGRectMake(10, 0, self.tableView.frame.size.width, 150);
    lblOperatingHours.numberOfLines=0;
    lblOperatingHours.textAlignment=NSTextAlignmentCenter;
    lblOperatingHours.text=[NSString stringWithFormat:@"Operating Hours \n Mon – Thurs 5:00PM to 1:00AM \nFri & Sat 4:00PM to 3:00AM \n Sun & Public holidays 4:00PM to 12:00AM \n\n  "];//OperatingHours
    lblOperatingHours.textColor=[UIColor whiteColor];
    lblOperatingHours.font = [UIFont fontWithName:@"HelveticaNeue" size:13];

    [lblOperatingHours sizeToFit];
    lblOperatingHours.backgroundColor = [UIColor clearColor];
    return lblOperatingHours;
}
-(IBAction)btnAddRowTapped:(id)sender{
     //[self Logout];
}
@end
