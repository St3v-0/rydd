//
//  InviteEarnVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/27/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "InviteEarnVC.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "Themes.h"
#import "UrlHandler.h"
#import "ReferralRecord.h"
#import "REFrostedViewController.h"
#import "LanguageHandler.h"
#import <FBSDKSharekit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKMessageDialog.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>



@interface InviteEarnVC ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate,FBSDKSharingDelegate>
{
   
    NSString * Symbol;
}
@property (strong, nonatomic) IBOutlet UILabel *Amount;
@property (strong, nonatomic) IBOutlet UITextField *referralCode;
@property (strong, nonatomic) IBOutlet UILabel *youramount;
@property (strong, nonatomic) IBOutlet UIButton *MenuBtn;
@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (strong, nonatomic) IBOutlet UILabel *star;
@property (strong, nonatomic) IBOutlet UILabel *letworld;
@property (strong, nonatomic) IBOutlet UILabel *hint_code;

@end

@implementation InviteEarnVC
{
    ReferralRecord*objrecd;
}
@synthesize TableBG,scrollView,Amount,referralCode,youramount,MenuBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self referreal];
    
    
    scrollView.contentSize = CGSizeMake(320, 400);
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    referralCode.inputView = dummyView;
    referralCode.delegate=self;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Invite_Friends", nil)];
    [_star setText:JJLocalizedString(@"Start_Inviting_friends", nil)];
    [_letworld setText:JJLocalizedString(@"Let_the_world_know", nil)];
    [_hint_code setText:JJLocalizedString(@"Share_your_referral_code", nil)];

}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}*/
- (IBAction)ShareBtn:(id)sender {
    NSString * ihave=JJLocalizedString(@"I_have_an", nil);
    NSString * code=JJLocalizedString(@"Coupon_Code_worth", nil);
    NSString * mycode=JJLocalizedString(@"with_My_code", nil);

    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) {
        
       
        
        NSString * msg = [NSString stringWithFormat:@"%@",objrecd.message];
        NSString *encodedURLString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                           NULL,
                                                                                                           (CFStringRef)msg,
                                                                                                           NULL,
                                                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                           kCFStringEncodingUTF8 ));
        NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",encodedURLString];
        NSURL * whatsappURL = [NSURL URLWithString:urlWhats];
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
            [[UIApplication sharedApplication] openURL: whatsappURL];
        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"WhatsApp_not_installed", nil)  message:JJLocalizedString(@"Your_device_has_no_WhatsApp", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (btnAuthOptions.tag==2)
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = [NSString stringWithFormat:@"%@",objrecd.message];
            controller.messageComposeDelegate=self;
            [self presentViewController:controller animated:YES completion:nil];
        }
        

    }
    else if (btnAuthOptions.tag==3) {
        
        /*NSURL *fbURL = [NSURL URLWithString:@"fb-messenger://user-thread/USER_ID"];
        if ([[UIApplication sharedApplication] canOpenURL: fbURL]) {
            [[UIApplication sharedApplication] openURL: fbURL];
        }*/
        
        FBSDKShareLinkContent *shareContent = [[FBSDKShareLinkContent alloc] init];
        [shareContent setContentTitle:[Themes getAppName]];
        [shareContent setContentURL:[NSURL URLWithString:[Themes checkNullValue:objrecd.urlString]]];
         [shareContent setContentDescription:[NSString stringWithFormat:@"%@",objrecd.message]];
        FBSDKMessageDialog *messageDialog = [[FBSDKMessageDialog alloc] init];
        messageDialog.delegate = self;
        [messageDialog setShareContent:shareContent];
        
        if ([messageDialog canShow])
        {
            [messageDialog show];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Facebook_Messenger", nil)  message:JJLocalizedString(@"Your_device_has_no_Facebook_Messenger_installed", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil];
            [alert show];
        }

    }
    else if (btnAuthOptions.tag==4) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
            [composeViewController setToRecipients:@[@""]];
            [composeViewController setMailComposeDelegate:self];
            [composeViewController setSubject:@""];
            [composeViewController setMessageBody:[NSString stringWithFormat:@"%@",objrecd.message] isHTML:NO];
            [composeViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:composeViewController animated:YES completion:nil];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:JJLocalizedString(@"Mail", nil) message:JJLocalizedString(@"please_config_your_mail", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (btnAuthOptions.tag==5) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@",objrecd.message]];
            [tweetSheet addImage:[UIImage imageNamed:@"InviteCar"]];
            [tweetSheet addURL:[NSURL URLWithString:[Themes checkNullValue:objrecd.urlString]]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Oops Twitter!" message:JJLocalizedString(@"Kindly_add_your", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];

        }
    }
    else if (btnAuthOptions.tag==6) {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            
            
            FBSDKShareLinkContent * content = [[FBSDKShareLinkContent alloc] init];
            content.contentURL = [NSURL URLWithString:[Themes checkNullValue:objrecd.urlString]];
            content.contentTitle=[Themes getAppName];
            content.contentDescription=[NSString stringWithFormat:@"%@",objrecd.message];
            
            
            FBSDKShareDialog * dialog = [[FBSDKShareDialog alloc] init];
            dialog.fromViewController = self;
            dialog.shareContent=content;
            dialog.delegate=self;
            dialog.mode = FBSDKShareDialogModeFeedWeb;
            [dialog show];
        }
        else
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Ooops_Facebook", nil) message:JJLocalizedString(@"Kindly_add_your", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
        }
    }


}
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
       [referralCode resignFirstResponder];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)referreal
{
    NSDictionary*paramets=@{@"user_id":[Themes checkNullValue:[Themes getUserID]]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web referCode:paramets success:^(NSMutableDictionary *responseDictionary)
    
    {
        [Themes StopView:self.view];
        
        if ([responseDictionary count]>0)
        {
        responseDictionary=[Themes writableValue:responseDictionary];

        NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
        NSString * alert=[responseDictionary valueForKey:@"response"];
        [Themes StopView:self.view];

        if ([comfiramtion isEqualToString:@"1"])
        {
            objrecd=[[ReferralRecord alloc]init];
            objrecd.friendsamount=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"friends_earn_amount"]];
            objrecd.message=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"message"]];
            objrecd.referral_code=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"referral_code"]];
            objrecd.your_earn=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"your_earn"]];
            objrecd.your_earn_amount=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"your_earn_amount"]];
            objrecd.Currecny=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"currency"]];
            objrecd.earnCondition=[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"your_earn_condition"]];
            objrecd.urlString=[Themes checkNullValue:[NSString stringWithFormat:@"%@",[[[responseDictionary valueForKey:@"response"] valueForKey:@"details"]valueForKey:@"url"]]];
            Symbol=[Themes findCurrencySymbolByCode:objrecd.Currecny];
            
            NSString * friendsrides;
            NSString *completedrids=JJLocalizedString(@"after_their_first_completed_RYDD", nil);
            NSString * friendsjoins=JJLocalizedString(@"Friends_joins", nil);
            NSString *Credit=@"Credit";
            if([objrecd.earnCondition isEqualToString:@"on_first_ride"]){
                 friendsrides=JJLocalizedString(@"Friends_Rides_you_earn", nil);
            }else{
                 friendsrides=JJLocalizedString(@"you_earn", nil);
            }
            youramount.text= [NSString stringWithFormat:@"%@ %@ %@ %@",friendsrides,Symbol, objrecd.your_earn_amount,Credit];
            referralCode.text=objrecd.referral_code;
            Amount.text=[NSString stringWithFormat:@"%@ %@ %@ %@.",friendsjoins,Symbol,objrecd.friendsamount,Credit];
        }
        
        else
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
        }
            
        }
    } failure:^(NSError *error) {
       
        [Themes StopView:self.view];
        [self referreal];
    }];
    
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
            else
                NSLog(@"Message failed");
    }
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults :(NSDictionary*)results {
    NSLog(@"FB: SHARE RESULTS=%@\n",[results debugDescription]);
    if (results[@"postId"])
    {
        [self.view makeToast:JJLocalizedString(@"Posted_in_Timeline", nil)];
    }
    else
    {
        [self.view makeToast:JJLocalizedString(@"Message_Sent", nil)];
    }}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"FB: ERROR=%@\n",[error debugDescription]);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"FB: CANCELED SHARER=%@\n",[sharer debugDescription]);
}

@end
