//
//  TranscationVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/28/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "TranscationVC.h"
#import "TranscationCell.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "TranscationRecord.h"
#import "LanguageHandler.h"

@interface TranscationVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString * TypeString;
    TranscationRecord * recordObj;
    NSString * CurrencySymbol;
}

@end

@implementation TranscationVC
@synthesize AllArray,CerditArray,DebitArray,ContentTableView,SegmentTrans;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AllArray =[NSMutableArray array];
    CerditArray =[NSMutableArray array];
    DebitArray =[NSMutableArray array];

    [self ChnageSegment:SegmentTrans];
    [self retrieveFavlist];

    
    ContentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _headerLbl.text=JJLocalizedString(@"Transaction", nil);

}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    
    [SegmentTrans setTitle:JJLocalizedString(@"all", nil) forSegmentAtIndex:0];
    [SegmentTrans setTitle:JJLocalizedString(@"credit", nil) forSegmentAtIndex:1];
    [SegmentTrans setTitle:JJLocalizedString(@"debit", nil) forSegmentAtIndex:2];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackTo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)ChnageSegment:(id)sender {
    switch (SegmentTrans.selectedSegmentIndex)
    {
        case 0:
            TypeString=@"all";
            break;
        case 1:
            TypeString=@"credit";
            break;
        case 2:
            TypeString=@"debit";
            
            break;
        default:
            break;
    }
    [ContentTableView reloadData];
    //[self retrieveFavlist];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowcount=0;
    if(SegmentTrans.selectedSegmentIndex==0){
        
       rowcount= [AllArray count];
        
    }else if (SegmentTrans.selectedSegmentIndex==1){
        rowcount=[CerditArray count];

        
    }else if (SegmentTrans.selectedSegmentIndex==2){
        rowcount=[DebitArray count];

        
    }
    return rowcount;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    
    TranscationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TranscationCell" owner:nil options:nil] objectAtIndex:0];
        
        
    }
    TranscationRecord *objRec;
    if(SegmentTrans.selectedSegmentIndex==0){
        
        objRec=(TranscationRecord*)[AllArray objectAtIndex:indexPath.row];
        
        if ([objRec.type isEqualToString:@"CREDIT"])
        {
            cell.CRView.hidden=NO;
            cell.DRView.hidden=YES;
            cell.crLbl.text=JJLocalizedString(@"credit", nil);
        }
        else if ([objRec.type isEqualToString:@"DEBIT"])
        {
            cell.CRView.hidden=YES;
            cell.DRView.hidden=NO;
               cell.drLbl.text=JJLocalizedString(@"debit", nil);
        }

        
    }else if (SegmentTrans.selectedSegmentIndex==1){
        objRec=(TranscationRecord*)[CerditArray objectAtIndex:indexPath.row];
        
        if ([objRec.type isEqualToString:@"CREDIT"])
        {
            cell.CRView.hidden=NO;
            cell.DRView.hidden=YES;
               cell.crLbl.text=JJLocalizedString(@"credit", nil);
        }
        else if ([objRec.type isEqualToString:@"DEBIT"])
        {
            cell.CRView.hidden=YES;
            cell.DRView.hidden=NO;
              cell.drLbl.text=JJLocalizedString(@"debit", nil);
        }
     
      
        

    }else if (SegmentTrans.selectedSegmentIndex==2){
       objRec=(TranscationRecord*)[DebitArray objectAtIndex:indexPath.row];
        
        if ([objRec.type isEqualToString:@"CREDIT"])
        {
            cell.CRView.hidden=NO;
            cell.DRView.hidden=YES;
             cell.crLbl.text=JJLocalizedString(@"credit", nil);
        }
        else if ([objRec.type isEqualToString:@"DEBIT"])
        {
            cell.CRView.hidden=YES;
            cell.DRView.hidden=NO;
               cell.drLbl.text=JJLocalizedString(@"debit", nil);
        }
        
       
     
    }
   
    cell.Balance.text=[NSString stringWithFormat:@"%@%@",CurrencySymbol,objRec.updatebalance];
    cell.Time.text=objRec.time;
    cell.Title.text=objRec.title;
    NSString * Balance=JJLocalizedString(@"Balance", nil);
    cell.Currentbalance.text=[NSString stringWithFormat:@"%@: %@%@",Balance,CurrencySymbol,objRec.Currentbalance];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)retrieveFavlist
{
    NSDictionary * parameters=@{@"user_id":[Themes getUserID],
                                @"type":@"all"};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web GETTranscationList:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
         NSLog(@"%@",responseDictionary);
         responseDictionary=[Themes writableValue:responseDictionary];
         NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
         [Themes StopView:self.view];
         if ([comfiramtion isEqualToString:@"1"])
         {
            
             
             for (NSDictionary * objCatDict in responseDictionary[@"response"][@"trans"]) {
                 recordObj=[[TranscationRecord alloc]init];
                 recordObj.Currentbalance=[objCatDict valueForKey:@"balance_amount"];
                 recordObj.time =[objCatDict valueForKey:@"trans_date"];
                 recordObj.updatebalance=[objCatDict valueForKey:@"trans_amount"];
                 recordObj.type=[objCatDict valueForKey:@"type"];
                 recordObj.title=[objCatDict valueForKey:@"title"];
                 
                 if([recordObj.type isEqualToString:@"CREDIT"])
                 {
                     [CerditArray addObject:recordObj];
                     
                 }
                 
                 else if ([recordObj.type isEqualToString:@"DEBIT"])
                 {
                     [DebitArray addObject:recordObj];
                 }
                 
                 [AllArray addObject:recordObj];
                 
                
             }
             CurrencySymbol=[Themes findCurrencySymbolByCode:responseDictionary[@"response"][@"currency"]];
             [ContentTableView reloadData];
         }
         else
         {
             /*EmptyFavor.hidden=NO;
             FavrList.hidden=YES;
             EditFavour.hidden=YES;*/
         }
         }
         
     }
             failure:^(NSError *error)
     {
         [Themes StopView:self.view];
    }];
    
}

@end
