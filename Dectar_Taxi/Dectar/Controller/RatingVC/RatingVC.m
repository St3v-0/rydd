//
//  RatingVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/3/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "RatingVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "ReviewRecord.h"
#import "RatingCell.h"
#import "LanguageHandler.h"

@interface RatingVC ()<UITableViewDataSource,UITableViewDelegate,RatingViewDelegate,UITextViewDelegate,TPFloatRatingViewDelegate>
{
    NSMutableArray * reviewArray;
    NSString * ratingcount;
    CGFloat mainRating;
    BOOL resnslctd;         //Sri Ram
   
}
@end

@implementation RatingVC
@synthesize submit_btn,rating_table,RideID_Rating,Rated_View,Header_labl,Tick_View,Skip_Btn,objRec,CommentText;

- (void)viewDidLoad {
    [super viewDidLoad];
    reviewArray=[NSMutableArray array];
    rating_table.delegate=self;
    rating_table.hidden=YES;
    rating_table.dataSource=self;
     [Themes StopView:self.view];
    _totalScrollView.hidden=YES;
    
    _viewOtherPopup.hidden=YES;
    _viewOtherOption.layer.cornerRadius=5;
    _viewOtherOption.layer.masksToBounds=YES;
   
    
    _txtPopup.text=@"Enter Your Reviews";
    _txtPopup.textColor=[UIColor lightGrayColor];
    _txtPopup.delegate = self;
    
    resnslctd=NO;
    
    _txtPopup.layer.cornerRadius=2;
    _txtPopup.layer.masksToBounds=YES;
    _txtPopup.layer.borderWidth=1;
    _txtPopup.layer.borderColor=[UIColor blackColor].CGColor;

    [self setRateValue:0];
    //rating_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    CommentText.frame=CGRectMake(CommentText.frame.origin.x, 5, CommentText.frame.size.width, CommentText.frame.size.height);
    //rating_table.frame=CGRectMake(rating_table.frame.origin.x, CommentText.frame.origin.y+CommentText.frame.size.height+20, CommentText.frame.size.width, CommentText.frame.size.height);
    _totalScrollView.frame=CGRectMake(_totalScrollView.frame.origin.x, 70, _totalScrollView.frame.size.width, self.view.frame.size.height-130);
    [CommentText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [CommentText.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    CommentText.layer.cornerRadius = 5;
    CommentText.clipsToBounds = YES;
  
    Tick_View.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [self setDatasToView];
    
    // [self setObjRec:_objRec];
    [self listPayment];
    
    [Header_labl setText:JJLocalizedString(@"Rating", nil)];
    [Skip_Btn setTitle:JJLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [_Thanks_Lbl setText:JJLocalizedString(@"thanks", nil)];
    [_Already setText:JJLocalizedString(@"You_rated", nil)];
    [submit_btn setTitle:JJLocalizedString(@"Rate_Driver", nil) forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
   // [Themes StopView:self.view];
    
    CommentText.text=JJLocalizedString(@"Please_enter_your_comments_about_your_ride", nil) ;
    
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    CommentText.text=JJLocalizedString(@"Please_enter_your_comments_about_your_ride", nil) ;
    [Header_labl setText:JJLocalizedString(@"Rating", nil) ];
    [Skip_Btn setTitle:JJLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [_Thanks_Lbl setText:JJLocalizedString(@"thanks", nil)];
    [_Already setText:JJLocalizedString(@"You_rated", nil)];
    [submit_btn setTitle:JJLocalizedString(@"Rate_Driver", nil) forState:UIControlStateNormal];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [_txtPopup.text isEqualToString:@" "];
    
//    if ([_txtPopup.text isEqualToString:@" "]) {
//        
//    }
    
}
- (void) textViewDidBeginEditing:(UITextView *) textView {
    _txtPopup.textColor=[UIColor blackColor];
    
    if ([textView.text  isEqualToString:@"Enter Your Reviews"]) {
         _txtPopup.text=@"";
    }
    if ([textView.text  isEqualToString:@""]) {
        _txtPopup.text=@"";
    }
    
    
    
    
        
    

    
    
//    CommentText.textColor=[UIColor blackColor];
//    
//    if([textView.text isEqualToString:JJLocalizedString(@"Please_enter_your_comments_about_your_ride", nil)])
//    {
//        
//        
//        CommentText.text=@"";
//        
//        
//    }
//    
//    if([textView.text isEqualToString:@""])
//    {
//        CommentText.text=@"";
//        
//    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        
        if(range.location==0)
        {
            CommentText.text = JJLocalizedString(@"Please_enter_your_comments_about_your_ride", nil);
            CommentText.textColor=[UIColor lightGrayColor];
            
        }
        if (range.location==0) {
//            _txtPopup.text=@"Please Enter Your Reviews";
//            _txtPopup.textColor=[UIColor lightGrayColor];
        }
        return NO;
    }
    //    if(range.location==0 && ![text isEqualToString:@""])
    //    {
    //         CommentText.text = @"";
    //    }
    //    else if(range.location==0)
    //    {
    //         CommentText.text = JJLocalizedString(@"Please_enter_your_comments_about_your_ride", nil);
    //        CommentText.textColor=[UIColor lightGrayColor];
    //
    //    }
    
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setDatasToView
{
    //RideID_Rating=objRec.ride_id;
    [Themes StopView:self.view];
}
-(void)listPayment

{
    NSDictionary * parameters=@{@"optionsFor":@"driver",
                                @"ride_id":RideID_Rating};
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web ListReview:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             
             NSLog(@"%@",responseDictionary);
             responseDictionary=[Themes writableValue:responseDictionary];
             
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 [Themes StopView:self.view];
                 
                 
                 NSString * RateStatus=[Themes checkNullValue:[responseDictionary valueForKey:@"ride_ratting_status"]];
                 
                 if([RateStatus  isEqual: @"1"])
                 {
                    // rating_table.hidden=YES;
                     Rated_View.hidden=NO;
                     
                     [Header_labl setText:JJLocalizedString(@"thanks", nil) ];
                     
                     //Header_labl.text=@"Thanks";
                     [Skip_Btn setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
                     
                     [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                         // animate it to the identity transform (100% scale)
                         Tick_View.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished){
                         // if you want to do something once the animation finishes, put it here
                     }];
                     
                     
                     
                 }
                 else
                 {
                     [Header_labl setText:JJLocalizedString(@"Rating", nil) ];
                     [Skip_Btn setTitle:JJLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
                     //                 [Skip_Btn setTitle:@"Skip" forState:UIControlStateNormal];
                     //
                     //                 Header_labl.text=@"Rating";
                     
                    // rating_table.hidden=NO;
                     Rated_View.hidden=YES;
                     for (NSDictionary * objCatDict in responseDictionary[@"review_options"]) {
                      ReviewRecord *   recordObj=[[ReviewRecord alloc]init];
                         recordObj.Review_title=[objCatDict valueForKey:@"option_title"];
                         recordObj.Review_ID =[objCatDict valueForKey:@"option_id"];
                         recordObj.ReasonStatus =[Themes checkNullValue:[objCatDict valueForKey:@"popstatus"]];

                         recordObj.Review_Rating=@"";
                         [reviewArray addObject:recordObj];
                         
                     }
//                     NSString *strRate=@"3";
//                     if (recordObj.Review_Rating<strRate) {
//                         recordObj.isSelectBtn=NO;
//                     }
//                     else{
//                         recordObj.isSelectBtn=YES;
//
//                     }
                     [rating_table reloadData];
                    // rating_table.frame=CGRectMake(rating_table.frame.origin.x, CommentText.frame.origin.y+CommentText.frame.size.height+20, rating_table.frame.size.width, rating_table.contentSize.height);
                     
                     _totalScrollView.contentSize=CGSizeMake(_totalScrollView.frame.size.width, rating_table.frame.origin.y+rating_table.frame.size.height+20);
                      _totalScrollView.hidden=NO;
                 }
                 
             }
             else
             {
                 [self.view makeToast:[Themes checkNullValue:[responseDictionary valueForKey:@"response"]]];
                 
             }
         }
         
     }
            failure:^(NSError *error)
     {
         [Themes StopView:self.view];
         if(self.errorCount<2){
             [self listPayment];
             self.errorCount++;
         }else{
             [self.view makeToast:JJLocalizedString(@"Error_in_connection", nil)];
         }
     }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviewArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";//RatingCell
    
    RatingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RatingCell" owner:nil options:nil] objectAtIndex:0];
        
        
    }
    
    ReviewRecord *objRec=(ReviewRecord*)[reviewArray objectAtIndex:indexPath.row];
  
    [cell setSelectiveIndexpath:indexPath];
    [cell setObjReviewRecord:objRec];
    cell.delegate=self;
    if (objRec.isSelectBtn==YES) {
        cell.lblSelectCategory.backgroundColor=[UIColor greenColor];
        cell.lblSelectCategory.layer.cornerRadius=cell.lblSelectCategory.frame.size.width/2;
        cell.lblSelectCategory.clipsToBounds=YES;
        cell.lblSelectCategory.layer.borderWidth=1;
        cell.lblSelectCategory.layer.borderColor=[UIColor blackColor].CGColor;
        
    }
    else{
        cell.lblSelectCategory.backgroundColor=[UIColor whiteColor];
        cell.lblSelectCategory.layer.cornerRadius=cell.lblSelectCategory.frame.size.width/2;
        cell.lblSelectCategory.clipsToBounds=YES;
        cell.lblSelectCategory.layer.borderWidth=1;
        cell.lblSelectCategory.layer.borderColor=[UIColor blackColor].CGColor;
        
        
    }

    
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    resnslctd=true;

    for (int i =0; i<reviewArray.count; i++) {
        
        ReviewRecord *   ReviewRecObj=[reviewArray objectAtIndex:i];
        if(i==indexPath.row){
            ReviewRecObj.isSelectBtn=YES;
            if ([ReviewRecObj.ReasonStatus isEqualToString:@"1"]) {
                _viewOtherPopup.hidden=NO;
                _viewSubmit.hidden=YES;
                
                //rating_table.hidden=YES;
            }
        }else{
            ReviewRecObj.isSelectBtn=NO;
            _viewSubmit.hidden=NO;
        }

        [reviewArray setObject:ReviewRecObj atIndexedSubscript:i];
        
    }
   [rating_table reloadData];
   
    
    }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
    
}

- (void)RatingGiven:(NSIndexPath *)SelectedIndexPath withValue:(CGFloat)value
{
    @try {
    ReviewRecord * objBookingRecord=[reviewArray objectAtIndex:SelectedIndexPath.row];
    objBookingRecord.Review_Rating=[NSString stringWithFormat:@"%.2f", value];
    [reviewArray setObject:objBookingRecord atIndexedSubscript:SelectedIndexPath.row];
    [rating_table reloadData];
                //NSString *ratevalue=@"3";
         } @catch (NSException *exception) {
        
    }

    
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{
    mainRating=rating;
    if (rating<4) {
        
        rating_table.hidden=NO;
        [rating_table reloadData];
        resnslctd=NO;
    }
    else{

        rating_table.hidden=YES;
        _viewSubmit.hidden=NO;
         resnslctd=YES;
        
        
    }
    [rating_table reloadData];
}
- (IBAction)Submit_rating:(id)sender {
    
       NSLog(@"%@",RideID_Rating);
    
    
    if(resnslctd ==NO)
    {
        [self.view makeToast:JJLocalizedString(@"Please_slct_reason", nil)];
    }
    else{

    NSMutableDictionary * objRateDict=[[NSMutableDictionary alloc]init];
    if (mainRating<3) {
        for (int i=0; i<[reviewArray count]; i++) {
            ReviewRecord * onjReviewRec=[reviewArray objectAtIndex:i];
            
            if (onjReviewRec.isSelectBtn==YES) {
                NSString * str1=[NSString stringWithFormat:@"ratings[%d][option_title]",i+1];
                NSString * str2=[NSString stringWithFormat:@"ratings[%d][option_id]",i+1];
              //  NSString * str3=[NSString stringWithFormat:@"ratings[%d][rating]",i+1];
                
                //	 ratings[1][rating] = 3, comments = good, ratings[1][option_id] = 13,  ratings[1][option_title] = Others
                
                //	ratings[0][option_id] = 2, ratings[0][option_title] = Driver rating, comments = , ratings[0][rating] = 3,
                
                if([onjReviewRec.ReasonStatus isEqualToString:@"1"]){
                      [objRateDict setObject:[Themes checkNullValue:onjReviewRec.Review_Rating] forKey:@"comments"];
                }
                [objRateDict setObject:onjReviewRec.Review_title forKey:str1];
                [objRateDict setObject:onjReviewRec.Review_ID forKey:str2];
            }
            
       
            
        }
         [objRateDict setObject:[NSString stringWithFormat:@"%f",mainRating] forKey:@"ratings[0][rating]"];
    }
    else{
        [objRateDict setObject:[NSString stringWithFormat:@"%f",mainRating] forKey:@"ratings[0][rating]"];
      
    }
    [objRateDict setObject:@"driver" forKey:@"ratingsFor"];
    
    [objRateDict setObject:RideID_Rating forKey:@"ride_id"];
//    NSString * commentStr=@"";
//    if (![CommentText.text isEqualToString:JJLocalizedString(@"Please_enter_your_comments_about_your_ride", nil)])
//    {
//      commentStr= [Themes checkNullValue:CommentText.text];
//        
//    }
    
    
//    [objRateDict setObject:commentStr forKey:@"comments"];
    [Themes writableValue:objRateDict];
    if (mainRating>0) {
        
        [self setobjRating:objRateDict];
    }else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Sorry", nil) message:JJLocalizedString(@"please_give_the_review", nil )  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
}

-(void)setobjRating:(NSMutableDictionary*)dic
{
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web SubmirReview:dic success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             NSLog(@"%@",responseDictionary);
             responseDictionary=[Themes writableValue:responseDictionary];
             
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             NSString * message=[Themes checkNullValue:[responseDictionary valueForKey:@"response"]];
             [Themes StopView:self.view];
             if ([comfiramtion isEqualToString:@"1"])
             {
                
                 [self.view makeToast:message];
                 
                 [self performSelector:@selector(moveToHome) withObject:self afterDelay:1];
              
             }
             else if ([comfiramtion isEqualToString:@"0"])
                 
             {
                   [self.view makeToast:message];
                    [self performSelector:@selector(moveToHome) withObject:self afterDelay:1];
             }
             
         }
     }
              failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
}
-(void)moveToHome{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del LogIn];
}
- (IBAction)Skip_rating:(id)sender {
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del LogIn];
}
-(void)setRateValue:(NSString *)value{
    _viewRate.delegate = self;
    _viewRate.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    _viewRate.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
    _viewRate.contentMode = UIViewContentModeScaleAspectFill;
    _viewRate.maxRating = 5;
    _viewRate.minRating = 0;
    _viewRate.rating = [value floatValue];
    _viewRate.editable = YES;
    _viewRate.halfRatings = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField==_txtOther) {
        [_txtOther resignFirstResponder];
    }
    return YES;
}
- (IBAction)didClickCancel:(id)sender {
    for (int i=0; i<reviewArray.count; i++) {
        ReviewRecord *   ReviewRecObj=[reviewArray objectAtIndex:i];
        if ([ReviewRecObj.ReasonStatus isEqualToString:@"1"]) {
            ReviewRecObj.Review_Rating=@"";
            [self.view endEditing:YES];
        
        }
    }

    _viewOtherPopup.hidden=YES;
}

- (IBAction)didClickOk:(id)sender {
    //ReviewRecord * onjReviewRec;
    for (int i=0; i<reviewArray.count; i++) {
        ReviewRecord *   ReviewRecObj=[reviewArray objectAtIndex:i];
        if ([ReviewRecObj.ReasonStatus isEqualToString:@"1"]) {
            ReviewRecObj.Review_Rating=[Themes checkNullValue:_txtPopup.text];
            if ([ReviewRecObj.Review_Rating isEqualToString:@""] || [ReviewRecObj.Review_Rating isEqualToString:@"Enter Your Reviews"]) {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Sorry", nil) message:JJLocalizedString(@"please_give_the_review", nil )  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                        [alert show];

                
            }
            else{
                [self Submit_rating:self];
               

            }
        }
    }
     //[self Submit_rating:self];
}
//    if ([onjReviewRec.Review_Rating isEqualToString:@" "]) {
//       UIAlertView * alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Sorry", nil) message:JJLocalizedString(@"please_give_the_review", nil )  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
//    else{
//        for (int i=0; i<reviewArray.count; i++) {
//            ReviewRecord *   ReviewRecObj=[reviewArray objectAtIndex:i];
//            if ([ReviewRecObj.ReasonStatus isEqualToString:@"1"]) {
//                ReviewRecObj.Review_Rating=[Themes checkNullValue:_txtPopup.text];
//                
//            }
//        }
//        
//        [self Submit_rating:self];
//        
//    }
//


    
    
@end
