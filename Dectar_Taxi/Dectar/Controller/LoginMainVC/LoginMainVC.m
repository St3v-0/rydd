//
//  ViewController.m
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "LoginMainVC.h"
#import "LoginVC.h"
#import "RegisterVC.h"
#import "LanguageHandler.h"

@interface LoginMainVC ()

@end
@implementation LoginMainVC
@synthesize Sign_btn,Register_btn;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Sign_btn.layer.cornerRadius = 5;
    Sign_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    Sign_btn.layer.shadowOpacity = 0.5;
    Sign_btn.layer.shadowRadius = 2;
    Sign_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    //Register_btn.layer.cornerRadius = 5;
    Register_btn.layer.shadowColor = [UIColor blackColor].CGColor;
    Register_btn.layer.shadowOpacity = 0.5;
    Register_btn.layer.shadowRadius = 2;
    Register_btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
  
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    
    [Sign_btn setTitle:JJLocalizedString(@"SIGN_IN", nil) forState:UIControlStateNormal];
    [Register_btn setTitle:JJLocalizedString(@"REGISTER", nil) forState:UIControlStateNormal];

}
#pragma mark --- IBActions
- (IBAction)didClickAuthenticateOptions:(id)sender {
    
    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) {

        LoginVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVCID"];
        [self.navigationController pushViewController:objLoginVC animated:YES];
        
    } else if (btnAuthOptions.tag==2) {
            RegisterVC *objRegisterVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVCID"];
            [self.navigationController pushViewController:objRegisterVC animated:YES];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
