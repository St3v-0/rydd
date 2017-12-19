//
//  AddFavrVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/24/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AddressRecord.h"
#import "FavourRecord.h"
#import "RootBaseVC.h"
#import "WBErrorNoticeView.h"


@interface AddFavrVC : RootBaseVC<GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *Title;
@property (strong, nonatomic) IBOutlet UITextView *Address;
@property (strong, nonatomic) IBOutlet UIView *MapBG;
@property (strong, nonatomic) IBOutlet UIButton *Save;
@property (strong, nonatomic) IBOutlet UIButton *close;
@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (weak, nonatomic) IBOutlet UIView *viewUnderTitle;

@property (strong, nonatomic) GMSMapView * GoogleMap;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCategory;
@property (strong, nonatomic) GMSCameraPosition * Camera;

@property (strong,nonatomic) AddressRecord* addressObj;
@property (strong,nonatomic) FavourRecord * favourObj;
- (IBAction)didClickCategory:(id)sender;
@property(assign,nonatomic)BOOL isFromEdit;
@property  CGFloat latitude;
@property  CGFloat longitude;
@property (weak, nonatomic) IBOutlet UILabel *lblGetFavPlace;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFav;
@property (strong,nonatomic)NSString * locationKey;

@property (strong,nonatomic) NSString * UserID;
@property (strong, nonatomic) NSMutableArray * filterdatas;


@property (strong, nonatomic) IBOutlet UIButton *pinpoint;
@property (strong, nonatomic) IBOutlet UIButton *current_Loc;
@property (assign, nonatomic) BOOL isfromHome;
@property (assign, nonatomic) BOOL isfromWork;
@property (assign, nonatomic) BOOL isfromCustom;
@property (strong, nonatomic) IBOutlet UISearchBar *addressSearchBar;
@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (strong, nonatomic) IBOutlet UITableView *address_table_view;
@end
