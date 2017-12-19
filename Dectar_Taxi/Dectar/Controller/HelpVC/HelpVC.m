//
//  HelpVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 2/9/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "HelpVC.h"
#import "Constant.h"
#import "LanguageHandler.h"


@interface HelpVC ()

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _Police.layer.borderWidth = 1.0f;
    _Police.layer.borderColor = BGCOLOR.CGColor;
    _Ambulance.layer.borderWidth = 1.0f;
    _Ambulance.layer.borderColor = BGCOLOR.CGColor;
    _Fire.layer.borderWidth = 1.0f;
    _Fire.layer.borderColor = BGCOLOR.CGColor;
    

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    [_Police setTitle:JJLocalizedString(@"Call_Police", nil) forState:UIControlStateNormal];
    [_Ambulance setTitle:JJLocalizedString(@"Call_Ambulance", nil) forState:UIControlStateNormal];
    [_Fire setTitle:JJLocalizedString(@"Call_Fire_Station", nil) forState:UIControlStateNormal];
    [_Header_Lbl setText:JJLocalizedString(@"Emergency_Contact", nil)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)GoBack_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)CallHelp_Action:(id)sender {
    
    UIButton *btnAuthOptions=(UIButton*)sender;
    if (btnAuthOptions.tag==1) { //police
        
        NSString* actionStr = [NSString stringWithFormat:@"tel://%@",@"100"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionStr]];
    }
    else if (btnAuthOptions.tag==2) { // ambulance
        NSString* actionStr = [NSString stringWithFormat:@"tel://%@",@"108"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionStr]];
    }
    else if (btnAuthOptions.tag==3) { // Fire
        NSString* actionStr = [NSString stringWithFormat:@"tel://%@",@"103"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionStr]];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
