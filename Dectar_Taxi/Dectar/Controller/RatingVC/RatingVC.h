//
//  RatingVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/3/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewRecord.h"
#import "FareRecord.h"
#import "RootBaseVC.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TPFloatRatingView.h"

@interface RatingVC : RootBaseVC
@property (strong, nonatomic) IBOutlet UIButton *submit_btn;
@property (strong, nonatomic) IBOutlet UITableView *rating_table;

@property (strong ,nonatomic) NSString *  RideID_Rating;
@property (strong ,nonatomic) FareRecord * objRec;
@property (strong, nonatomic) IBOutlet UIView *Rated_View;
@property (strong, nonatomic) IBOutlet UILabel *Header_labl;
@property (strong, nonatomic) IBOutlet UIImageView *Tick_View;
@property (strong, nonatomic) IBOutlet UIButton *Skip_Btn;
@property (strong, nonatomic) IBOutlet UILabel *Thanks_Lbl;
@property (weak, nonatomic) IBOutlet UITextView *txtPopup;
@property (strong, nonatomic) IBOutlet UILabel *Already;
@property (weak, nonatomic) IBOutlet UITextView *CommentText;
@property(assign,nonatomic)NSInteger errorCount;
@property (weak, nonatomic) IBOutlet UIView *viewOtherOption;

@property (weak, nonatomic) IBOutlet UIView *viewSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblOther;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *totalScrollView;
@property (weak, nonatomic) IBOutlet UIView *viewMainRating;
//@property (weak, nonatomic) IBOutlet UIView *viewRate;
@property (weak, nonatomic) IBOutlet TPFloatRatingView *viewRate;
@property (weak, nonatomic) IBOutlet UILabel *lblDriver;
@property (weak, nonatomic) IBOutlet UITextField *txtOther;
- (IBAction)didClickCancel:(id)sender;
- (IBAction)didClickOk:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewOtherPopup;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrolling;

@end
