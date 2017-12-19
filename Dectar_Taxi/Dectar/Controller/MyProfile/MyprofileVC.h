//
//  MyprofileVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/27/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"
#import "CountryListViewController.h"
#import "UIImageView+WebCache.h"


@interface MyprofileVC : RootBaseVC<UIActionSheetDelegate,CountryListViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIButton *menubutton;
@property (strong, nonatomic) IBOutlet UIButton *savebtn;
@property (strong, nonatomic) IBOutlet UILabel *email_labl;
@property (strong, nonatomic) IBOutlet UITextField *name_lbl;
@property (strong, nonatomic) IBOutlet UITextField *mobile_labl;
@property (strong, nonatomic) IBOutlet UIButton *logout;
@property (strong, nonatomic) IBOutlet UIButton *nameeditbutton;
@property (strong, nonatomic) IBOutlet UIButton *mbleditbutton;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollingView;
@property (strong, nonatomic) IBOutlet UITextField *country_fld;
@property (strong,nonatomic) NSArray * CountryName_Array;
@property (strong ,nonatomic) NSArray * Countrycode_Array;
- (IBAction)didClickFavLocation:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *Email_hint;
@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (strong, nonatomic) IBOutlet UILabel *signin_details;
@property (strong, nonatomic) IBOutlet UILabel *chang_hint;
@property (strong, nonatomic) IBOutlet UILabel *my_details;
@property (strong, nonatomic) IBOutlet UILabel *name_hint;
@property (strong, nonatomic) IBOutlet UILabel *mobile_hint;
@property (weak, nonatomic) IBOutlet UIButton *profileLangButton;
@property (weak, nonatomic) IBOutlet UILabel *languageLbl;
@property (weak, nonatomic) IBOutlet UILabel *ccodeLbl;
@property (weak, nonatomic) IBOutlet UIButton *userImgBtn;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property(strong,nonatomic)UIImagePickerController *imagePicker;
- (IBAction)didclickCountryList:(id)sender;
- (IBAction)didClickUserImgBtn:(id)sender;


@end
