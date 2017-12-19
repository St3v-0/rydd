//
//  AddCardVC.h
//  Dectar
//
//  Created by iOS on 09/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCardRecord.h"
@interface AddCardVC : UIViewController
- (IBAction)didClickBackBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
- (IBAction)didClickSaveBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *view_enterDetails;
@property (weak, nonatomic) IBOutlet UIView *viewPopup;

@property (weak, nonatomic) IBOutlet UITextField *txtCardNo;
@property (weak, nonatomic) IBOutlet UITextField *txtExpYear;
@property (weak, nonatomic) IBOutlet UITextField *txtExpMonth;
@property (strong, nonatomic) AddCardRecord * addCardRec;
@property (weak, nonatomic) IBOutlet UITextField *txtCardName;
- (IBAction)didClickApply:(id)sender;
- (IBAction)didClickCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewAddName;



- (IBAction)didClickCardIO:(id)sender;

@end
