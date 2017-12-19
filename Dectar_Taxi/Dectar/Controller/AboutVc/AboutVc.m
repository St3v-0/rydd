//
//  AboutVc.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/14/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "AboutVc.h"
#import "Constant.h"
#import "TTTAttributedLabel.h"
#import "REFrostedViewController.h"
#import "Themes.h"

@interface AboutVc ()
{
    NSString *BaseURl;
}

@end

@implementation AboutVc
@synthesize MenuBtn,Describ_label,More_info_URL,headerlbl,powerdLBL,moreinfobtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [_Version_Label setText:[Themes getAppVersionAndBundle]];
    
    
  
    
    BaseURl =[NSString stringWithFormat:@"%@",AppbaseUrl];
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:BaseURl];
    [str addAttribute: NSLinkAttributeName value: AppbaseUrl range: NSMakeRange(0, str.length)];
    More_info_URL.attributedText = str;
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.More_info_URL addGestureRecognizer:singleFingerTap];
    [More_info_URL sizeToFit];
    
    headerlbl.text = JJLocalizedString(@"About",nil);
    Describ_label.numberOfLines=0;
    NSDictionary * appInfoDict=[Themes AppAllInfoDatas];
    NSString * descTxt=    [Themes checkNullValue:[appInfoDict objectForKey:@"about_content"]];
    Describ_label.text =descTxt;
      [Describ_label sizeToFit];
    [moreinfobtn setText:JJLocalizedString(@"More_info",nil)];
    More_info_URL.frame=CGRectMake(More_info_URL.frame.origin.x, Describ_label.frame.origin.y+Describ_label.frame.size.height+25, More_info_URL.frame.size.width, More_info_URL.frame.size.height);
    moreinfobtn.frame=CGRectMake(moreinfobtn.frame.origin.x, Describ_label.frame.origin.y+Describ_label.frame.size.height+25, moreinfobtn.frame.size.width, moreinfobtn.frame.size.height);
    powerdLBL.text =[NSString stringWithFormat:@"%@ %@",JJLocalizedString(@"POWERED",nil),[Themes getAppName]];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:BaseURl]];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
