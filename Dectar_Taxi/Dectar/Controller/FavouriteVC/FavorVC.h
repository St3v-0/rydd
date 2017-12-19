//
//  FavorVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/21/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressRecord.h"
#import "RootBaseVC.h"
#import "HeadingView.h"


@interface FavorVC : RootBaseVC

@property (strong, nonatomic) IBOutlet UIButton * EditFavour;
@property (strong, nonatomic) IBOutlet UIButton *CloseFavour;
@property (strong, nonatomic) IBOutlet UITableView *FavrList;
@property (strong, nonatomic) IBOutlet UIButton *AddFavor;
@property (strong, nonatomic) IBOutlet UILabel *CurrentFavour;
@property (strong, nonatomic) IBOutlet UIView *EmptyFavor;
@property (strong, nonatomic) AddressRecord *objRecord;
@property (strong, nonatomic) IBOutlet UILabel *heading_favour;
@property (strong, nonatomic) IBOutlet UILabel *Add_favourite;
@property (weak, nonatomic) IBOutlet HeadingView *headerView;

@property (strong, nonatomic) IBOutlet UILabel *Not_favour;
@property (strong, nonatomic) IBOutlet UILabel *hint_lbl;
@property (assign, nonatomic) BOOL isfromProfile;
@property (assign, nonatomic) BOOL isfromMenu;
@property (assign, nonatomic) BOOL isfromDrop;
@property (assign, nonatomic) BOOL isfromPickup;

- (IBAction)didClickHomeFavAddress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblFavAddress;
//@property (weak, nonatomic) IBOutlet UILabel *lblHomeFavAddress;
- (IBAction)didClickAdd:(id)sender;
- (IBAction)didClickWorkFavAddress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkAddress;
- (IBAction)didClickWorkAdd:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnWorkAdd;

@end
