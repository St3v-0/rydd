//
//  CancelRideVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 12/30/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverRecord.h"
#import "RootBaseVC.h"
@interface CancelRideVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UITableView *Cancel_tabel;
@property (strong, nonatomic) IBOutlet UIButton *cancel_btn;
@property (strong, nonatomic) IBOutlet UIButton *submit_btn;
@property (strong ,nonatomic) NSMutableArray * Reason_Array;
@property (strong ,nonatomic) DriverRecord * TrackObj;
@property (strong,nonatomic) NSString * Ride_ID;
@property (strong,nonatomic) NSString * Reason_Str;
@property (strong,nonatomic) NSString *Reason_ID;
@property(assign,nonatomic)BOOL isCancellationFee;
@property (strong, nonatomic) IBOutlet UILabel * heading ;
@property (weak, nonatomic) IBOutlet UIView *viewNoteCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblNoteCancel;

@end
