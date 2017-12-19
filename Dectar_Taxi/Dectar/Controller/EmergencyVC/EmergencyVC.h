//
//  EmergencyVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/28/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RootBaseVC.h"
#import "CountryListViewController.h"
#import "JJLocationManager.h"


@interface EmergencyVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UIButton *menu;
@property (strong, nonatomic) IBOutlet UIButton *savebtn;
@property (strong, nonatomic) IBOutlet UITextField *name_fld;
@property (strong, nonatomic) IBOutlet UITextField *mbl_fld;
@property (strong, nonatomic) IBOutlet UITextField *email_fld;
@property (strong, nonatomic) IBOutlet UIButton *Edit_btn;
@property (strong, nonatomic) IBOutlet UIButton *Panic_Btn;
@property (strong, nonatomic) IBOutlet UITextField *Country_fld;
@property (strong,nonatomic) NSArray * CountryName_Array;
@property (strong ,nonatomic) NSArray * Countrycode_Array;
@property  CGFloat latitude;
@property  CGFloat longitude;
@property (strong, nonatomic) IBOutlet UILabel *Heading;
@property (strong, nonatomic) IBOutlet UIButton *Remove_btn;
@property (strong, nonatomic) IBOutlet UILabel *hint;
@property (strong, nonatomic) IBOutlet UILabel *note;
- (IBAction)didClickCountryBtn:(id)sender;

@end
