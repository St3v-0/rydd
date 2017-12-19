//
//  PopupVC.h
//  Dectar
//
//  Created by iOS on 08/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingRecord.h"
@interface PopupVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewPopup;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) BookingRecord *bookingRec;
- (IBAction)didClickCheckBtn:(id)sender;
- (IBAction)didClickOkBtn:(id)sender;
@property(assign,nonatomic)NSInteger errorCount;

- (IBAction)didClickTCapply:(id)sender;

@end
