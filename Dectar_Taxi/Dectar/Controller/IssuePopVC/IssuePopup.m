//
//  IssuePopup.m
//  Dectar
//
//  Created by iOS on 20/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "IssuePopup.h"
#import "WBErrorNoticeView.h"
#import "UrlHandler.h"
@interface IssuePopup ()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation IssuePopup
@synthesize delegate;
- (void)viewDidLoad {
    
    [self Padding:_txtOtherIssue];
    _btnOk.layer.cornerRadius=5;
    _btnOk.layer.masksToBounds=YES;
    
    _viewTop.layer.cornerRadius=5;
    _viewTop.layer.masksToBounds=YES;

        [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)Padding:(UITextView *)Field
{
    
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, Field.frame.size.height)];
//    [Field addSubview:paddingView];
//    [Field settex:UITextFieldViewModeAlways];
//    [Field setLeftView:paddingView];
    
    Field.layer.cornerRadius=2;
    Field.layer.masksToBounds=YES;
    Field.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    Field.layer.borderWidth= 1.0f;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

  -(BOOL)ValidateTextView{
     if (_txtOtherIssue.text.length==0)
    {
        [self showErrorMessage:@"Please enter your issues"];
        [_txtOtherIssue becomeFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location == 0 && [text isEqualToString:@" "]) {
        return NO;
    }
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


- (IBAction)didClickOkBtn:(id)sender {
    if ([self ValidateTextView]) {
        if ([self.delegate respondsToSelector:@selector(sendDataToA:)]){
            [delegate sendDataToA:_txtOtherIssue.text];
            [self dismissViewControllerAnimated:NO completion:nil];
        }

    }
    
}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str,nil)];
    [notice show];
}

- (IBAction)didClickCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendDataToA:)]){
        [delegate sendDataToA:@""];
       
    }
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
@end
