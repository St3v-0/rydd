//
//  PopupVC.m
//  Dectar
//
//  Created by iOS on 08/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "PopupVC.h"
#import "UrlHandler.h"
#import "LanguageHandler.h"
#import "Themes.h"
@interface PopupVC ()
{
    BOOL isCheck;
    
    
}
@end

@implementation PopupVC
- (void)viewDidLoad {
    
    _lblDescription.text=_bookingRec.popup_content;
    _btnOk.layer.cornerRadius=2;
    _btnOk.layer.masksToBounds=YES;
  
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
-(void)ShowPopUp
{
    NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                };
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GetPopUp:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             NSLog(@"%@",responseDictionary);
             responseDictionary=[Themes writableValue:responseDictionary];
             
        
             [Themes StopView:self.view];
             
             [self dismissViewControllerAnimated:YES completion:nil];
         }
         
     }
              failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         if (self.errorCount<2) {
             [self ShowPopUp];
             self.errorCount++;
                      }
         else{
             [self dismissViewControllerAnimated:YES completion:nil];

         }
              }];
   
         }
- (IBAction)didClickCheckBtn:(id)sender {
    
    if (isCheck==NO) {
        isCheck=true;
         [ _btnCheck setImage:[UIImage imageNamed:@"Tick"] forState:UIControlStateNormal];
    }
    else{
        isCheck=false;
        [ _btnCheck setImage:[UIImage imageNamed:@"CheckBox"] forState:UIControlStateNormal];

    }
   
}

- (IBAction)didClickOkBtn:(id)sender {
    if (isCheck==YES) {
        [self ShowPopUp];
    }
    else{
        
        [self dismissViewControllerAnimated:NO completion:nil];
 
    }
   

}
- (IBAction)didClickTCapply:(id)sender {
    NSString*strTerms=[NSString stringWithFormat:@"%@",TermsandConditions];
        NSURL *url = [NSURL URLWithString:strTerms];
    [[UIApplication sharedApplication] openURL:url];
    
}
@end
