//
//  AdvertsVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 10/8/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "AdvertsVC.h"
#import "AdvertsRecord.h"
#import "Themes.h"
#import "AppDelegate.h"
#import "UIImageView+Network.h"

@interface AdvertsVC ()


@end

@implementation AdvertsVC
@synthesize Ads_View,AdsImageView,Title_label,Description_label,Ads_ObjRec,okbtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Ads_View.layer.cornerRadius = 10;
    Ads_View.layer.masksToBounds = YES;
    
    

    Ads_View.layer.shadowColor = [UIColor whiteColor].CGColor;
    Ads_View.layer.shadowOpacity = 0.5;
    Ads_View.layer.shadowRadius = 2;
    Ads_View.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    [self.view addSubview:Ads_View];
    [self.view bringSubviewToFront:Ads_View];
    
    
    CGSize maxSize = CGSizeMake( Description_label.frame.size.width, MAXFLOAT);
    
    CGRect labelRect = [ Description_label.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: Description_label.font} context:nil];
    
    NSLog(@"size %@", NSStringFromCGSize(labelRect.size));
    
    
    NSString *trimmedString=[Ads_ObjRec.Images substringFromIndex:MAX((int)[Ads_ObjRec.Images length]-15, 0)];
    NSString * cacheStr=[NSString stringWithFormat:@"MyRiD_%@",trimmedString];
    [AdsImageView loadImageFromURL:[NSURL URLWithString:Ads_ObjRec.Images] placeholderImage:[UIImage imageNamed:@""] cachingKey:cacheStr];
    
    [self setAds_ObjRec:Ads_ObjRec];
    // Do any additional setup after loading the view.
  
    [okbtn setTitle:JJLocalizedString(@"ok",nil) forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setAds_ObjRec:(AdvertsRecord *)_Ads_ObjRec
{
    Ads_ObjRec=_Ads_ObjRec;
    Title_label.text=_Ads_ObjRec.Title;
    Description_label.text=_Ads_ObjRec.Description;
    AdsImageView.image=[UIImage imageNamed:_Ads_ObjRec.Images];
    
}
- (IBAction)OK_Action:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
