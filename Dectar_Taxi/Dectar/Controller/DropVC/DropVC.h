//
//  DropVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 2/13/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "RootBaseVC.h"
#import "UrlHandler.h"
@protocol returnLatLongDelegate<NSObject>
@optional
-(void)passDropLatLong:(CLLocation *)dLoc withDropTxt:(NSString *)dropPlace;
-(void)passPickUpLatLong:(CLLocation *)dLoc withDropTxt:(NSString *)pickupPlace;
-(void)passEstimateLatLong:(CLLocation *)dLoc withDropTxt:(NSString *)estimatePlace;
@end

@interface DropVC : RootBaseVC
@property(strong,nonatomic)id<returnLatLongDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *address_search;
@property (strong, nonatomic) IBOutlet UITableView *addres_tabel;
@property (strong, nonatomic) IBOutlet UIView *table_content_view;
@property (strong, nonatomic) IBOutlet UIView *mapBG;
@property (strong, nonatomic) IBOutlet UIButton *Back_Btn;
@property (strong, nonatomic) IBOutlet UIButton *done;
@property (strong, nonatomic) IBOutlet UILabel *Header_Lbl;

@property (strong, nonatomic) IBOutlet UILabel *Long_press_lbl;
 
@property (strong, nonatomic) NSMutableArray * filterdata;
@property  (assign,nonatomic)CGFloat latitude;
@property  (assign,nonatomic)CGFloat longitude;

@property(assign,nonatomic)BOOL isFromPickUp;
@property(assign,nonatomic)BOOL isFromDestination;
@property(assign,nonatomic)BOOL isFromEstimation;

@property(strong,nonatomic)NSString * selLocStr;
@property (strong, nonatomic) IBOutlet UIView *DragWrapperView;
@property (strong, nonatomic) IBOutlet UILabel *Drag_lbl;
- (IBAction)didClickRefreshButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *refreshBtn;

@end
