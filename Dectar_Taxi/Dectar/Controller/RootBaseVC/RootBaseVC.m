//
//  RootBaseVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 10/9/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "RootBaseVC.h"
#import "Themes.h"
#import "AdvertsVC.h"
#import "AdvertsRecord.h"
#import "RatingVC.h"
#import "FareVC.h"
#import "NewViewController.h"
#import "NewTrackVC.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "REFrostedViewController.h"
#import "AppInfoWaitViewController.h"

@interface RootBaseVC ()<MFMailComposeViewControllerDelegate>

{
    UIGestureRecognizer * Tapped;
     AppInfoWaitViewController * objInfoPopup;
}

@end

@implementation RootBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applicationLanguageChangeNotification:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationLanguageChangeNotification:) name:ApplicationLanguageDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OpenAds:) name:@"Advertisment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"waitingfor_payment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewVc:) name:@"payment_paid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cabCame:) name:@"cab_arrived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartRide:) name:@"Ride_start" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RideOver:) name:@"ride_completed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShareETAS:) name:@"ShareETA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(setFeedBackMail:) name: @"feedBackEmail" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(NoNetwork) name: @"NoNetworkMsgPush" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shutTheApp:)
                                                 name:kShutTheApp
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAdvtNotification:)
                                                 name:kDriverAdvtInfo
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showerrorWhenXmppNotConnected:)
                                                 name:@"xmppNotConectNotif"
                                               object:nil];
    
  

//145561368
    // Do any additional setup after loading the view.
}
-(void)receiveAdvtNotification:(NSNotification *) notification
{
    
    if(self.view.window){
        CNPPopupController * objCnpopup=[CNPPopupController alloc];
        NSDictionary * dict=notification.userInfo;
        if([[NSString stringWithFormat:@"%@",[Themes checkNullValue:[dict objectForKey:@"action"]]] isEqualToString:@"ads"]){
            
            
            NSString * titileStr=[Themes checkNullValue:[dict objectForKey:@"key1"]];
            NSString * messageStr=[Themes checkNullValue:[dict objectForKey:@"key2"]];
            NSString * imageStrStr=[Themes checkNullValue:[dict objectForKey:@"key3"]];
            
            
            
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:titileStr attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15], NSParagraphStyleAttributeName : paragraphStyle}];
            
            UIImageView * advtImage;
            if(imageStrStr.length>0){
                advtImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250,250)];
                [advtImage sd_setImageWithURL:[NSURL URLWithString:imageStrStr] placeholderImage:[UIImage imageNamed:@"PlaceHolderImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
            }
            
            NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:messageStr attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName : [UIColor darkGrayColor], NSParagraphStyleAttributeName : paragraphStyle}];
            CNPPopupButton * button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.numberOfLines = 0;
            titleLabel.attributedText = title;
            
            
            [button setTitle:@"OK" forState:UIControlStateNormal];
            button.backgroundColor =BGCOLOR;
            button.tintColor=[UIColor whiteColor];
            button.layer.cornerRadius = 4;
            button.selectionHandler = ^(CNPPopupButton *button){
                [objCnpopup dismissPopupControllerAnimated:YES];
            };
            
            UILabel *lineTwoLabel = [[UILabel alloc] init];
            lineTwoLabel.numberOfLines = 0;
            lineTwoLabel.attributedText = lineTwo;
            
            if(imageStrStr.length>0){
                objCnpopup=      [objCnpopup initWithContents:@[titleLabel,advtImage,lineTwoLabel, button]];
                
                
            }else{
                objCnpopup=      [objCnpopup initWithContents:@[titleLabel, lineTwoLabel, button]];
                
                
            }
            
            
            objCnpopup.theme = [CNPPopupTheme defaultTheme];
            objCnpopup.theme.popupStyle = CNPPopupStyleCentered;
            //  objCnpopup.delegate = self;
            [objCnpopup presentPopupControllerAnimated:YES];
        }
    }
}
- (void)shutTheApp:(NSNotification *) notification
{
    if(self.view.window){
        
        NSDictionary * dict=notification.userInfo;
        
        if([[NSString stringWithFormat:@"%@",[Themes checkNullValue:[dict objectForKey:@"site_mode"]]] isEqualToString:@"development"]){
            
            
            NSString * titileStr=[Themes checkNullValue:[dict objectForKey:@"site_mode_string"]];
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:titileStr attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15], NSParagraphStyleAttributeName : paragraphStyle}];
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.numberOfLines = 0;
            titleLabel.attributedText = title;
            self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel]];
            self.popupController.theme = [CNPPopupTheme defaultTheme];
            self.popupController.theme.popupStyle = CNPPopupStyleCentered;
            self.popupController.theme.maskType=CNPPopupMaskTypeDimmed;
            self.popupController.delegate = self;
            self.popupController.theme.backViewTouch=CNPPopupTouchDisable;
            [self.popupController presentPopupControllerAnimated:YES];
        }
    }
}
-(void)showerrorWhenXmppNotConnected:(NSNotification*)notification{
    if(self.view.window){
        [self.view makeToast:@"We_cant_able_to_connect"];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ApplicationLanguageDidChangeNotification object:nil];

    
}
-(void)NoNetwork{
    [Themes StopView:self.view];
    [self.view makeToast:@"No_Network_Connection"];
}
-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self checkAllDatasAreFetched];
}
-(void)checkAllDatasAreFetched{
    if(![Themes hasAppDetails]){
        if(objInfoPopup==nil){
            objInfoPopup=[self.storyboard instantiateViewControllerWithIdentifier:@"APPinfoWaitVCSID"];
            if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
            {
                //For iOS 8
                objInfoPopup.providesPresentationContextTransitionStyle = YES;
                objInfoPopup.definesPresentationContext = YES;
                objInfoPopup.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            else
            {
                //For iOS 7
                objInfoPopup.modalPresentationStyle = UIModalPresentationCurrentContext;
            }
            [self presentViewController:objInfoPopup animated:NO completion:nil];
        }
    }
}
-(void)ShareETAS:(NSNotification *)notification
{
   // if ([notification.object isKindOfClass:[FareRecord class]])
    //{
    if (self.view.window)
    {

    NewTrackVC *objNewTrackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
    FareRecord*Rec=(FareRecord*)notification.object;
         [objNewTrackVC setRide_ID:Rec.ride_id];
        [self.navigationController pushViewController:objNewTrackVC animated:YES];

    
    }
    //}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setFeedBackMail:(NSNotification *)notice{
    if(self.view.window){
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:[Themes getAppName]];
             NSDictionary * appInfoDict=[Themes AppAllInfoDatas];
            NSString * isHaveContactEmail=[Themes checkNullValue:[appInfoDict objectForKey:@"site_contact_mail"]];
            NSArray *usersTo = [NSArray arrayWithObject: [NSString stringWithFormat:@"%@",isHaveContactEmail] ];
            [controller setToRecipients:usersTo];
            if (controller) [self presentViewController:controller animated:YES completion:nil];
            
        }
        else {
            // Handle the error
        }
        
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)OpenAds:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[AdvertsRecord class]])
    {
        if (self.view.window)
        {
            AdvertsVC * Adverts = [self.storyboard instantiateViewControllerWithIdentifier:@"AdvertsVCID"];
            AdvertsRecord*Rec=(AdvertsRecord*)notification.object;
           
            [Adverts setAds_ObjRec:Rec];
            
            if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
            {
                //For iOS 8
                Adverts.providesPresentationContextTransitionStyle = YES;
                Adverts.definesPresentationContext = YES;
                Adverts.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            else
            {
                //For iOS 7
                Adverts.modalPresentationStyle = UIModalPresentationCurrentContext;
            }
            [self presentViewController:Adverts animated:NO completion:nil];

        }
    }
}

- (void) reviewVc:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[FareRecord class]])
    {
        if(self.view.window){
            RatingVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RatingVCID"];
            FareRecord*Rec=(FareRecord*)notification.object;
            [objLoginVC setRideID_Rating :Rec.ride_id];
            [self.navigationController pushViewController:objLoginVC animated:YES];

        }
        
    }
}

- (void) cabCame:(NSNotification *)notification
{
    if (![self isKindOfClass:[NewTrackVC class]])
    {
        if(self.view.window){
        FareRecord*Rec=(FareRecord*)notification.object;
            
            if([Rec.fromNotification isEqualToString:@"fromPush"])
            {
                
                            NewTrackVC *objNewTrackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                            [objNewTrackVC setRide_ID:Rec.ride_id];
                            [self.navigationController pushViewController:objNewTrackVC animated:YES];

                
            }
            else{
                [self Banner:Rec];
            }
            
       
        
            
        }
        
    }
    
}
-(void)RideOver:(NSNotification*)notification
{
    if (![self isKindOfClass:[NewTrackVC class]])
    {
        if(self.view.window){
            FareRecord*Rec=(FareRecord*)notification.object;
           
            if([Rec.fromNotification isEqualToString:@"fromPush"])
            {
                
                NewTrackVC *objNewTrackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                [objNewTrackVC setRide_ID:Rec.ride_id];
                [self.navigationController pushViewController:objNewTrackVC animated:YES];
            }
            else{
                [self Banner:Rec];
            }        }
        
    }
}
- (void) StartRide:(NSNotification *)notification
{
    if (![self isKindOfClass:[NewTrackVC class]])
    {
        if(self.view.window){
            FareRecord*Rec=(FareRecord*)notification.object;
            
            if([Rec.fromNotification isEqualToString:@"fromPush"])
            {
                
                NewTrackVC *objNewTrackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                [objNewTrackVC setRide_ID:Rec.ride_id];
                [self.navigationController pushViewController:objNewTrackVC animated:YES];
            }
            else{
                [self Banner:Rec];
            }
            
        }
        
    }
    else{
    
    }
}
- (void) notification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[FareRecord class]])
    {
        if (self.view.window)
        {
            //FareVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"FareVCID"];  //NewFareVCID
//            OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Ride_Completed", nil)
//                                                                        message:JJLocalizedString(@"Your Rydd has been completed ", nil)
//                                                              cancelButtonTitle:JJLocalizedString(@"OK", nil)
//                                                              otherButtonTitles:nil];
//            alert.iconType = OpinionzAlertIconSuccess;
          //  [alert show];
            OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:JJLocalizedString(@"Ride_Completed", nil)
                                                                        message:JJLocalizedString(@"Your Rydd has been completed", nil)
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@[JJLocalizedString(@"OK", nil)]
                                                        usingBlockWhenTapButton:^(OpinionzAlertView *alertView, NSInteger buttonIndex) {
                                                            NewViewController * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"NewFareVCID"];
                                                            FareRecord*Rec=(FareRecord*)notification.object;
                                                            
                                                            [addfavour setRideID:Rec.ride_id];
                                                            [self.navigationController pushViewController:addfavour animated:YES];

//                                                            TripDetailViewController * objTripDetailVc=[self.storyboard instantiateViewControllerWithIdentifier:@"TripDetailVCSID"];
//                                                            [objTripDetailVc setTripId:rideId];
//                                                            [objTripDetailVc setIsMoveToHome:YES];
//                                                            [self.navigationController pushViewController:objTripDetailVc animated:YES];
                                                            
                                                        }];
            alert.iconType = OpinionzAlertIconSuccess;
            [alert show];

            
       }
        
    }
    
}
-(void)Banner:(FareRecord*)Rec

{
    if(![self.view.window isKindOfClass:[NewTrackVC class]]){
        [HDNotificationView showNotificationViewWithImage:nil
                                                    title:[Themes getAppName]
                                                  message:Rec.Message
                                               isAutoHide:YES
                                                  onTouch:^{
                    
                                                              /// On touch handle. You can hide notification view or do something
                                                              NewTrackVC *objNewTrackVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NewTrackVCID"];
                                                             [objNewTrackVC setRide_ID:Rec.ride_id];
                                                              [self.navigationController pushViewController:objNewTrackVC animated:YES];
                                                              [HDNotificationView hideNotificationViewOnComplete:nil];
                                                      
                                                  }];
        
    }
   
    
    
    
  
    
}
- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
-(void)Toast:(NSString *)msg
{
    [self.view makeToast:JJLocalizedString(msg, nil)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)applicationLanguageChangeNotification:(NSNotification*)notification
{
    NSLog(@"Either %@ class did not implemented language change notification or it's calling super method",NSStringFromClass([self class]));
}
@end
