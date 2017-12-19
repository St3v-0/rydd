//
//  CardDetailsVC.h
//  Dectar
//
//  Created by Casperon on 30/01/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootBaseVC.h"

@interface CardDetailsVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UILabel *cardNumLbl;
@property (strong, nonatomic) IBOutlet UITextField *enterCardNumTxt;
@property (strong, nonatomic) IBOutlet UILabel *expMonthLbl;
@property (strong, nonatomic) IBOutlet UITextField *enterMontTxt;
@property (strong, nonatomic) IBOutlet UILabel *expYearLbl;
@property (strong, nonatomic) IBOutlet UITextField *enterExpYearTxt;
@property (strong, nonatomic) IBOutlet UILabel *CVVLbl;
@property (strong, nonatomic) IBOutlet UITextField *enterCVVTxt;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)didClickSubmitAction:(id)sender;

@property (strong, nonatomic) NSString *numberStr;
@property (strong, nonatomic) NSString *monthStr;
@property (strong, nonatomic) NSString *yearStr;
@property (strong, nonatomic) NSString *CVVStr;

@property (strong, nonatomic) NSString *AmountTxt;

@property (strong, nonatomic) NSString *MobileID;
@property (strong, nonatomic) NSString *FromPaymentVC;
@property (strong, nonatomic) NSString *rideID;


@property (strong, nonatomic) IBOutlet UILabel *cardHeaderLbl;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)didClickBackBtnAction:(id)sender;

@end
