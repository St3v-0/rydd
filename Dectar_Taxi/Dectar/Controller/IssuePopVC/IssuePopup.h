//
//  IssuePopup.h
//  Dectar
//
//  Created by iOS on 20/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol senddataDelegate <NSObject>
-(void)sendDataToA:(NSString *)txtStr;
@end
@interface IssuePopup : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
- (IBAction)didClickOkBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtOtherIssue;
@property(nonatomic,assign)id delegate;
- (IBAction)didClickCancel:(id)sender;


@end
