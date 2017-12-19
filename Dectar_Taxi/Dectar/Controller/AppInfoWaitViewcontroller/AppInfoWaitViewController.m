//
//  AppInfoWaitViewController.m
//  DectarDriver
//
//  Created by Aravind Natarajan on 27/04/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import "AppInfoWaitViewController.h"
#import "AppDelegate.h"
#import "LoginMainVC.h"

@interface AppInfoWaitViewController ()

@end

@implementation AppInfoWaitViewController
@synthesize containerView,initialLoadingImageView,headerlbl,subheaderLbl,descLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLocUpdateNotification:)
                                                 name:@"NotifForAppInfo"
                                               object:nil];

    containerView.layer.cornerRadius=5;
    containerView.layer.masksToBounds=YES;
    if ([AppbaseUrl rangeOfString:isCabilyProduct].location == NSNotFound) {
        initialLoadingImageView.image= [UIImage imageNamed:@"InitialPattern"];
    } else {
          initialLoadingImageView.image= [UIImage imageNamed:@"DefaultLoading"];
    }
    initialLoadingImageView.frame=self.view.frame;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLocIsWrong:)
                                                 name:@"whenLocAppIsWrong"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAppInfoNotification:)
                                                 name:@"moveToApp"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getLocationInitially:)
                                                 name:kJJLocationManagerNotificationLocationUpdatedInitially
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStatusChangeNotification:)
                                                 name:@"internetConnectedAndChangeStatus"
                                               object:nil];
    headerlbl.text = JJLocalizedString(@"Sorry_for_the_delay",nil);
    subheaderLbl.text = JJLocalizedString(@"we_had_some_problem_connecting",nil);
    descLbl.text=JJLocalizedString(@"fetching_data",nil);
      [descLbl setTextColor:BGCOLOR];
       AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _proceedBtn.hidden=YES;
    if(![del isNetworkAvailable]){
        descLbl.text=JJLocalizedString(@"No_internet_connection_found",nil);
    }else{
        descLbl.text=JJLocalizedString(@"fetching_data",nil);
    }
    [_proceedBtn setTitle:JJLocalizedString(@"continue_to_login", nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

-(void)receiveLocIsWrong:(NSNotification *)notification
{
    
    if (self.view.window)
    {
        NSDictionary * dict=(NSDictionary *)notification.userInfo;
        if([dict count]>0)
        {
            NSString * str=[Themes checkNullValue:[dict objectForKey:@"message"]];
       //     [self.view makeToast:str];
              descLbl.text=str;
            _proceedBtn.hidden=NO;
            [Themes ClearUserInfo];
            
            AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appdelegate disconnect];
            LoginMainVC * objLoginVc=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginMainVCID"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objLoginVc];
            appdelegate.window.rootViewController = navigationController;
        }
    }
  
}
- (void)receiveLocUpdateNotification:(NSNotification *) notification
{
      descLbl.text=JJLocalizedString(@"updating_your_location",nil);
    
}
- (void)receiveStatusChangeNotification:(NSNotification *) notification
{
    descLbl.text=JJLocalizedString(@"fetching_data",nil);
}
- (void)receiveAppInfoNotification:(NSNotification *) notification
{
    initialLoadingImageView.hidden=YES;
    CLLocation *location = [[JJLocationManager sharedManager] currentLocation];
    if(location==nil||location.coordinate.latitude==0){
        
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    
}
-(void)getLocationInitially:(NSNotification*)notification
{
    CLLocation *location = [[JJLocationManager sharedManager] currentLocation];
   if(location!=nil||location.coordinate.latitude!=0){
       if([Themes hasAppDetails]){
            [self dismissViewControllerAnimated:NO completion:nil];
       }
   }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (IBAction)didClickProceedBtn:(id)sender {
}
@end
