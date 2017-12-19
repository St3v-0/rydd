//
//  FavorVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/21/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "FavorVC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "FavourRecord.h"
#import "AddFavrVC.h"
#import "FavorCell.h"
#import "AddressRecord.h"
#import "BookARideVC.h"
#import "Constant.h"
#import "LanguageHandler.h"
#import "REFrostedViewController.h"

@interface FavorVC ()
{
    NSString * UserID;
    NSMutableArray * LocationArray;
     NSMutableArray * LocationTotalArray;
    FavourRecord * objcRecored, *Homeobjrecord, *workRecord;
    
}
@property (strong, nonatomic) IBOutlet UIView *AddFavrView;
@end

@implementation FavorVC
@synthesize FavrList,EmptyFavor,CurrentFavour,objRecord,EditFavour,AddFavrView;



- (void)viewDidLoad {
    [super viewDidLoad];
//      FavrList.frame=CGRectMake(FavrList.frame.origin.x,  _headerView.frame.size.height, FavrList.frame.size.width,AddFavrView.frame.origin.y -_headerView.frame.size.height);
    UserID=[Themes checkNullValue:[Themes getUserID]];
    
    
    [self setObjRecord:objRecord];
    //CurrentFavour.text=objRecord.addressStr;
    FavrList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
}

-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [EditFavour setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [EditFavour setTitle:JJLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [_Add_favourite setText:JJLocalizedString(@"ADD_FAVORITES", nil)];
    [_Not_favour setText:JJLocalizedString(@"No_Favorites_added_yet", nil)];
    [_hint_lbl setText:JJLocalizedString(@"Select_frequent_pickup_location_and", nil)];
    [_heading_favour setText:JJLocalizedString(@"Favorites", nil)];
    [_lblFavAddress setText:@"Enter Your Favourite Location"];
    [_lblWorkAddress setText:@"Enter Your Favourite Location"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setObjRecord:(AddressRecord *)_objRecord
{
    objRecord=_objRecord;
    CurrentFavour.text=objRecord.addressStr;
//    _lblFavAddress.text=objRecord.addressStr;
    
}
- (IBAction)Edit:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    [button setBackgroundColor:[UIColor clearColor]];
    if ([button.titleLabel.text isEqualToString:JJLocalizedString(@"Edit", nil) ])
    {
        [FavrList setEditing:YES animated:YES];
        [button setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
      //  [button setTitleColor:[UIColor colorWithRed:37.0/255.0 green:170.0/255.0 blue:314.0/255.0 alpha:1.0] forState:UIControlStateNormal];
       // [self viewSlideInFromTopToBottom:AddFavrView];
        //[AddFavrView setHidden:YES];

        
        
        //FavrList.frame=CGRectMake(FavrList.frame.origin.x, FavrList.frame.origin.y, FavrList.frame.size.width,  FavrList.frame.size.height+70);

    }
    else if ([button.titleLabel.text isEqualToString:JJLocalizedString(@"Done", nil)])
    {
        [FavrList setEditing:NO animated:YES];
        [EditFavour setTitle:JJLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
       // [self viewSlideInFromBottomToTop:AddFavrView];
        
        //[AddFavrView setHidden:YES];
         //FavrList.frame=CGRectMake(FavrList.frame.origin.x,  _headerView.frame.size.height, FavrList.frame.size.width,AddFavrView.frame.origin.y -_headerView.frame.size.height);
    }

}
-(void)viewSlideInFromBottomToTop:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromTop ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}
-(void)viewSlideInFromTopToBottom:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromBottom ;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    LocationArray=[NSMutableArray array];
    LocationTotalArray=[[NSMutableArray alloc]init];
    [self retrieveFavlist];
    

}
-(void)retrieveFavlist
{
    NSDictionary * parameters=@{@"user_id":UserID};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GetFavrList:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];
         responseDictionary=[Themes writableValue:responseDictionary];

         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         
         if ([comfiramtion isEqualToString:@"1"])
         {
             FavrList.hidden=NO;
             //EmptyFavor.hidden=NO;
             EditFavour.hidden=NO;

             [_btnHomeAdd setTitle:@"Add" forState:UIControlStateNormal];
             [_btnWorkAdd setTitle:@"Add" forState:UIControlStateNormal];

             for (NSDictionary * objCatDict in responseDictionary[@"response"][@"locations"]) {
                 objcRecored=[[FavourRecord alloc]init];
                 objcRecored.Address=[objCatDict valueForKey:@"address"];
                 objcRecored.latitudeStr =[[objCatDict valueForKey:@"latitude"] doubleValue] ;
                 objcRecored.longitude=[[objCatDict valueForKey:@"longitude"]doubleValue] ;
                 objcRecored.titleString=[objCatDict valueForKey:@"title"];
                 objcRecored.locationkey=[objCatDict valueForKey:@"location_key"];
                 if([objcRecored.titleString isEqualToString:@"Home"]||[objcRecored.titleString isEqualToString:@"Work"]){
                     if([objcRecored.titleString isEqualToString:@"Home"]){
                         _lblFavAddress.text=objcRecored.Address;
                         Homeobjrecord  = objcRecored;
                         [_btnHomeAdd setTitle:@"Edit" forState:UIControlStateNormal];
                     }
                     if([objcRecored.titleString isEqualToString:@"Work"]){
                         _lblWorkAddress.text=objcRecored.Address;
                         workRecord  = objcRecored;
                         [_btnWorkAdd setTitle:@"Edit" forState:UIControlStateNormal];

                     }
                 }else{
                     [LocationArray addObject:objcRecored];
                     
                 }
                 [LocationTotalArray addObject:objcRecored];
                 CurrentFavour.text=objcRecored.Address;
                 CurrentFavour.numberOfLines = 3;
                 CurrentFavour.minimumScaleFactor = 0.5;
                 CurrentFavour.adjustsFontSizeToFitWidth = YES;
                 
                 [FavrList reloadData];
             }
             
         }
         else
         {
            // EmptyFavor.hidden=NO;
             FavrList.hidden=YES;
             EditFavour.hidden=YES;
         }
         }
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)BackTo:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    if (_isfromMenu) {
       [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
            [self.frostedViewController presentMenuViewController];

    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [LocationArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    FavorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FavorCell" owner:nil options:nil] objectAtIndex:0];
        
       
    }
       FavourRecord *objRec=(FavourRecord*)[LocationArray objectAtIndex:indexPath.row];
    cell.TitleLable.text=objRec.titleString;
    cell.AddressLable.text=objRec.Address;
    
      return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
            return 100;
   
}

- (NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self viewSlideInFromTopToBottom:AddFavrView];
    [AddFavrView setHidden:YES];

    return JJLocalizedString(@"Edit", nil);
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JJLocalizedString(@"delete", nil);
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
            if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            
            FavourRecord *objRec=(FavourRecord*)[LocationArray objectAtIndex:indexPath.row];
            
            NSDictionary * parameters=@{@"user_id":UserID,
                                        @"location_key":[Themes checkNullValue:objRec.locationkey]};
            
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [Themes StartView:self.view];
            [web DeleteList:parameters success:^(NSMutableDictionary *responseDictionary)
             
             {
                 [Themes StopView:self.view];
                 
                 if ([responseDictionary count]>0)
                 {
                 NSLog(@"%@",responseDictionary);
                 responseDictionary=[Themes writableValue:responseDictionary];

                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                 NSString * message=[responseDictionary valueForKey:@"message"];
                 [Themes StopView:self.view];

                 if ([comfiramtion isEqualToString:@"1"])
                 {
                     
                     [LocationArray removeObjectAtIndex:indexPath.row];
                      
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:YES];
                    [FavrList reloadData];
                     
                     NSString * messageString=[NSString stringWithFormat:@"%@",message];
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:messageString delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [Alert show];
                     NSLog(@"%lu",(unsigned long)[LocationArray count]);
                     
                     if ([LocationArray count]==0)
                     {
                         //EmptyFavor.hidden=NO;
                         FavrList.hidden=YES;
                         EditFavour.hidden=YES;
                         AddFavrView.hidden=NO;
                        
                     }
                     
                }
            }
        }
            failure:^(NSError *error)
            
            {
                [Themes StopView:self.view];
             }];

            
            /*[userlist removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:YES];
            [userlst reloadData];*/
        }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isfromPickup == YES) {
        FavourRecord *objRec=(FavourRecord*)[LocationArray objectAtIndex:indexPath.row];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"PushView" object:objRec];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(_isfromDrop == YES)
    {
        FavourRecord *objRec=(FavourRecord*)[LocationArray objectAtIndex:indexPath.row];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"DropFavourNotifiction" object:objRec];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavourRecord *objRec=(FavourRecord*)[LocationArray objectAtIndex:indexPath.row];

    [self edit:objRec];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // [self viewSlideInFromBottomToTop:AddFavrView];
    [AddFavrView setHidden:NO];

        return YES;
}
- (IBAction)AddFavour:(id)sender
{
        AddFavrVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFavrVCID"];
  //  [addfavour setAddressObj:objRecord];
    [addfavour setIsfromCustom:YES];
     [addfavour setIsFromEdit:NO];
    [self.navigationController pushViewController:addfavour animated:YES];
}
-(void)edit:(FavourRecord*)objRecords
{
    AddFavrVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFavrVCID"];
    [addfavour setFavourObj:objRecords];
    [addfavour setIsfromCustom:YES];
    [addfavour setIsFromEdit:YES];
    [self.navigationController pushViewController:addfavour animated:YES];
}
- (IBAction)didClickHomeFavAddress:(id)sender {
    if(_isfromMenu==NO){
        
        if(_isfromPickup == YES)
        {
        
//        for (int i=0; i<[LocationTotalArray count]; i++) {
//            FavourRecord *     objcRec=[LocationTotalArray objectAtIndex:i];
//            if([objcRec.titleString isEqualToString:@"Home"]){
                [[NSNotificationCenter defaultCenter] postNotificationName: @"PushView" object:Homeobjrecord];
                [self.navigationController popViewControllerAnimated:YES];
                
//                break;
//            }
      //  }
        }
        else if(_isfromDrop == YES)
        {
//            for (int i=0; i<[LocationTotalArray count]; i++) {
//                FavourRecord *     objcRec=[LocationTotalArray objectAtIndex:i];
//                if([objcRec.titleString isEqualToString:@"Home"])
//                {
                    [[NSNotificationCenter defaultCenter] postNotificationName: @"DropFavourNotifiction" object:Homeobjrecord];
                    [self.navigationController popViewControllerAnimated:YES];
//                    break;
//                }
//            }
//        }
        
        
        
    }
    }
}
- (IBAction)didClickAdd:(id)sender {
       AddFavrVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFavrVCID"];
//    for (int i=0; i<[LocationTotalArray count]; i++) {
//      FavourRecord *     objcRec=[LocationTotalArray objectAtIndex:i];
       if([Homeobjrecord.titleString isEqualToString:@"Home"]){
            if(Homeobjrecord.Address.length>0){
                 [addfavour setIsFromEdit:NO];
                  [addfavour setFavourObj:Homeobjrecord];
            }else{
                  [addfavour setIsFromEdit:YES];
                [addfavour setFavourObj:Homeobjrecord];
            }
           
    
      }
            else{
              [addfavour setIsFromEdit:NO];
              [addfavour setFavourObj:Homeobjrecord];
        }
    
//    }
    [addfavour setIsfromHome:YES];
    [self.navigationController pushViewController:addfavour animated:YES];
}

- (IBAction)didClickWorkFavAddress:(id)sender {
    
    if(_isfromMenu==NO){
        
//        for (int i=0; i<[LocationTotalArray count]; i++) {
//            FavourRecord *     objcRec=[LocationTotalArray objectAtIndex:i];
//            if([objcRec.titleString isEqualToString:@"Work"]){
//                [[NSNotificationCenter defaultCenter] postNotificationName: @"PushView" object:workRecord];
//                [self.navigationController popViewControllerAnimated:YES];
        
//                break;
//            }
        
       // }
        
        
        
        
        if (_isfromPickup == YES){
            //          for (int i=0; i<[LocationTotalArray count]; i++) {
            //        FavourRecord *objRec=(FavourRecord*)[LocationTotalArray objectAtIndex:i];
            //              if([objRec.titleString isEqualToString:@"Work"]){
            [[NSNotificationCenter defaultCenter] postNotificationName: @"PushView" object:workRecord];
            [self.navigationController popViewControllerAnimated:YES];
            //                   break;
            //              }
            //    }
        }
        else if(_isfromDrop == YES){
            //        for (int i=0; i<[LocationTotalArray count]; i++) {
            //        FavourRecord *objRec=(FavourRecord*)[LocationTotalArray objectAtIndex:i];
            //         if([objRec.titleString isEqualToString:@"Work"]){
            [[NSNotificationCenter defaultCenter] postNotificationName: @"DropFavourNotifiction" object:workRecord];
            [self.navigationController popViewControllerAnimated:YES];
            //              break;
            //         }
            //        
            //    }
        }
        
        
    }
    
  
}
- (IBAction)didClickWorkAdd:(id)sender {
    AddFavrVC * addfavour = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFavrVCID"];
//    for (int i=0; i<[LocationTotalArray count]; i++) {
//        FavourRecord *     objcRec=[LocationTotalArray objectAtIndex:i];
        if([workRecord.titleString isEqualToString:@"Work"]){
            if(workRecord.Address.length>0){
                [addfavour setIsFromEdit:NO];
                [addfavour setFavourObj:workRecord];
            }else{
                [addfavour setIsFromEdit:YES];
                [addfavour setFavourObj:workRecord];
            }
            
        }else{
            [addfavour setIsFromEdit:NO];
            [addfavour setFavourObj:workRecord];
        }

 //   }
    [addfavour setIsfromWork:YES];
    [self.navigationController pushViewController:addfavour animated:YES];
}
@end
