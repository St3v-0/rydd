//
//  RateCardVC.m
//  Dectar
//
//  Created by Suresh J on 24/08/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "RateCardVC.h"
#import "UrlHandler.h"
#import "RatecardRecord.h"
#import "Themes.h"
#import "REFrostedViewController.h"
#import "RateCardTableViewCell.h"


@interface RateCardVC ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *cityID,*categoryID;
}
@property (strong,nonatomic)IBOutlet UITableView *tblRatecard;
@property (strong,nonatomic)NSMutableArray *rateCardArray;
@property (strong,nonatomic)IBOutlet UIPickerView *cityPicker;
@property (strong,nonatomic)IBOutlet UIPickerView *categoryPicker;
@property (strong,nonatomic)NSMutableArray *cityArray;
@property (strong,nonatomic)NSMutableArray *categoryArray;
@property (strong,nonatomic)IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblCartype;
@property (strong,nonatomic)NSString *currenySymbol;

@property (weak, nonatomic) IBOutlet UILabel *lblFirstkms;
@property (weak, nonatomic) IBOutlet UILabel *lblAfterkms;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstcost;
@property (weak, nonatomic) IBOutlet UILabel *lblAftercost;
@property (strong, nonatomic) IBOutlet UIButton *MennuBtn;
@property (strong, nonatomic) IBOutlet UIButton *CityPickerBtn;
@property (strong, nonatomic) IBOutlet UIButton *CarPickerBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *rateCardScrollview;

@end

@implementation RateCardVC
@synthesize categoryArray,cityArray,rateCardArray,MennuBtn,CarPickerBtn,CityPickerBtn,currenySymbol,First_Lbl,After_lbl,standardLBl,headerlbl,extraLbl,doneBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tblRatecard registerNib:[UINib nibWithNibName:@"RateCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"RateCardTableViewCellIdent"];
    self.tblRatecard.estimatedRowHeight=87;
    self.tblRatecard.rowHeight=UITableViewAutomaticDimension;
     self.tblRatecard.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.cityPicker.hidden=YES;
    self.categoryPicker.hidden=YES;
    self.pickerView.hidden=YES;
    self.rateCardScrollview.contentSize=CGSizeMake(self.view.frame.size.width, 500);
    
    CarPickerBtn.userInteractionEnabled=NO;
    CityPickerBtn.userInteractionEnabled=YES;
    
    headerlbl.text= JJLocalizedString(@"Rate_Card",nil);
    standardLBl.text = JJLocalizedString(@"Standard_Rate", nil);
    extraLbl.text=JJLocalizedString(@"Extra_Charges",nil);
    _lblCity.text=JJLocalizedString(@"City", nil);
    _lblCartype.text=JJLocalizedString(@"Vehicle", nil);
    [doneBtn setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
 
}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
-(void)retrievePickerList:(NSString*)tagValue
{
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    cityArray =[[NSMutableArray alloc]init];
    
    if ([tagValue isEqualToString:@"1"]) {
        NSDictionary * parameters=@{};
        [Themes StartView:self.view];
        [web GetLocationList:parameters success:^(NSMutableDictionary *responseDictionary)
         {
            
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString *status=[responseDictionary valueForKey:@"status"];
             if([status isEqualToString:@"1"]){
                 [Themes StopView:self.view];
                 NSArray *locArr=[[responseDictionary valueForKey:@"response"] valueForKey:@"locations"];
                 for (int i=0; i<[locArr count]; i++) {
                     NSDictionary *locDic=[locArr objectAtIndex:i];
                     RatecardRecord *objRateRecord=[[RatecardRecord alloc]init];
                     objRateRecord.cityID=[locDic valueForKey:@"id"];
                     objRateRecord.cityName=[locDic valueForKey:@"city"];
                     [cityArray addObject:objRateRecord];
                     self.cityPicker.dataSource=self;
                     self.cityPicker.delegate=self;
                     self.categoryPicker.hidden=YES;
                     self.cityPicker.hidden=NO;
                     self.pickerView.hidden=NO;
                     
                 }
                

             }
             
             }
         }
                     failure:^(NSError *error)
         {
             //NSString * messageString=[NSString stringWithFormat:@"%@",error];
//             UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             //[Alert show];
             [Themes StopView:self.view];

         }];
        
    }
    
    else
    {
       
            categoryArray =[[NSMutableArray alloc]init];
            
            NSDictionary * parameters=@{@"location_id":cityID};
            [Themes StartView:self.view];
            
            [web GetCategoryList:parameters success:^(NSMutableDictionary *responseDictionary)
             {
                 [Themes StopView:self.view];
                 
                 if ([responseDictionary count]>0)
                 {
                 
                 NSString *status=[responseDictionary valueForKey:@"status"];
                 if([status isEqualToString:@"1"]){
                     [Themes StopView:self.view];
                     
                     NSArray *locArr=[[responseDictionary valueForKey:@"response"]valueForKey:@"category"];
                     for (int i=0; i<[locArr count]; i++) {
                         NSDictionary *locDic=[locArr objectAtIndex:i];
                         RatecardRecord *objRateRecord=[[RatecardRecord alloc]init];
                         objRateRecord.categoryID=[locDic valueForKey:@"id"];
                         objRateRecord.categoryName=[locDic valueForKey:@"category"];
                         [categoryArray addObject:objRateRecord];
                         self.categoryPicker.dataSource=self;
                         self.categoryPicker.delegate=self;
                         self.cityPicker.hidden=YES;
                         self.categoryPicker.hidden=NO;
                         self.pickerView.hidden=NO;
                         
                     }
                 }
                 
                 
             }
             }
                         failure:^(NSError *error)
             {
                 [Themes StopView:self.view];
                 
//                 NSString * messageString=[NSString stringWithFormat:@"%@",error];
//                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 //[Alert show];
             }];
        }
        
}
#pragma mark --- IBActions
-(IBAction)didClickPickerView:(id)sender
{

    UIButton *btnPickerTag=(UIButton*)sender;
    if (btnPickerTag.tag==1) {
        [self retrievePickerList:@"1"];
    }else if (btnPickerTag.tag==2) {
        
//        if ([cityArray count]<=0)
//        {
//            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//             [Alert show];
//        }
//        else
//        {
            [self retrievePickerList:@"2"];

       // }
        
    }
    
}


-(void)retrieveRatecardDetails
{
    if (cityID!=nil && categoryID!=nil) {
        rateCardArray =[[NSMutableArray alloc]init];
        NSDictionary * parameters=@{@"location_id":cityID,@"category_id":categoryID};
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];

        [web GetRatecardDetails:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];
             
             if ([responseDictionary count]>0)
             {
             
             [Themes StopView:self.view];
             responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString *status=[responseDictionary valueForKey:@"status"];

                 if([status isEqualToString:@"1"]){
                     NSArray*rateCard;
                     rateCard=[[responseDictionary valueForKey:@"response"]valueForKey:@"ratecard"];
                     
                     if ([rateCard count]<=0)
                     {
                         NSString *titleStr = JJLocalizedString(@"Oops", nil);
                         UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"No_data_available", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                         [Alert show];
                     }
                     else
                     {
                         NSArray *locArr=[[[responseDictionary valueForKey:@"response"]valueForKey:@"ratecard"] valueForKey:@"extra_charges"];
                         for (int i=0; i<[locArr count]; i++) {
                             NSDictionary *locDic=[locArr objectAtIndex:i];
                             RatecardRecord *objRateRecord=[[RatecardRecord alloc]init];
                             objRateRecord.title=[locDic valueForKey:@"title"];
                             objRateRecord.fare=[locDic valueForKey:@"fare"];
                             objRateRecord.sub_title=[locDic valueForKey:@"sub_title"];
                             [rateCardArray addObject:objRateRecord];
                         }
                        
                         [self.tblRatecard reloadData];
                         
                         currenySymbol=[Themes findCurrencySymbolByCode:[[[responseDictionary valueForKey:@"response"]valueForKey:@"ratecard"] valueForKey:@"currency"]];
                         NSArray *rateArr=[[[responseDictionary valueForKey:@"response"]valueForKey:@"ratecard"] valueForKey:@"standard_rate"];
                         self.lblFirstkms.text=[[rateArr objectAtIndex:0] valueForKey:@"title"];
                         self.lblFirstcost.text=[NSString stringWithFormat:@"%@%@",currenySymbol,[[rateArr objectAtIndex:0] valueForKey:@"fare"]];
                         self.lblAfterkms.text=[[rateArr objectAtIndex:1] valueForKey:@"title"];
                         self.lblAftercost.text=[NSString stringWithFormat:@"%@%@",currenySymbol,[[rateArr objectAtIndex:1] valueForKey:@"fare"]];
                         
                         self.tblRatecard.frame=CGRectMake(self.tblRatecard.frame.origin.x, self.tblRatecard.frame.origin.y, self.tblRatecard.frame.size.width, self.tblRatecard.contentSize.height+100);
                         self.contentView.frame=CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.tblRatecard.frame.origin.y+self.tblRatecard.frame.size.height);
                          self.rateCardScrollview.contentSize=CGSizeMake(self.view.frame.size.width, self.contentView.frame.size.height);

                     }
                     
                     
                 }


                 else
                 {
                     NSString *titleStr = JJLocalizedString(@"Oops", nil);
                     UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"No_data_available", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                     [Alert show];
                 }
             
         }
             
             else
             {
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"No_data_available", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                  [Alert show];
             }
         }
                        failure:^(NSError *error)
         {
             [Themes StopView:self.view];

//             NSString * messageString=[NSString stringWithFormat:@"%@",error];
//             UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            // [Alert show];
         }];
        
        
    }
    
}
#pragma mark --- UITableview Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [rateCardArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RateCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RateCardTableViewCellIdent"];
    if (cell == nil) {
        cell = [[RateCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:@"RateCardTableViewCellIdent"];
    }
     RatecardRecord *objRateCard=(RatecardRecord*)[rateCardArray objectAtIndex:indexPath.row];
    if (![objRateCard.fare isEqualToString:@""]) {
        cell.timeLbl.text=[NSString stringWithFormat:@"%@%@",currenySymbol,objRateCard.fare];
        
    }
    cell.titleLbl.text=[Themes checkNullValue:objRateCard.title];
    cell.descLbl.numberOfLines=0;
    cell.descLbl.text=[Themes checkNullValue:objRateCard.sub_title];
      [cell.descLbl sizeToFit];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
    return cell;
    
    
    
    
}



#pragma  mark --- UIPickerview Datasource
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==self.categoryPicker) {
        return [categoryArray count];

    }else
    {
        return [cityArray count];

    }
    return [cityArray count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==self.categoryPicker) {
        RatecardRecord *object=(RatecardRecord*)[categoryArray objectAtIndex:row];
        return object.categoryName;
        
    }else
    {
        RatecardRecord *object=(RatecardRecord*)[cityArray objectAtIndex:row];
        return object.cityName;
        
    }
    return cityArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
   // self.pickerView.hidden=YES;

//    if (pickerView==self.categoryPicker) {
//        RatecardRecord *object=(RatecardRecord*)[categoryArray objectAtIndex:row];
//        self.lblCartype.text=object.categoryName;
//        categoryID=object.categoryID;
//        [self retrieveRatecardDetails];
//
//    }else
//    {
//        RatecardRecord *object=(RatecardRecord*)[cityArray objectAtIndex:row];
//        cityID=object.cityID;
//        self.lblCity.text=object.cityName;
//        CarPickerBtn.userInteractionEnabled=YES ;
//        CityPickerBtn.userInteractionEnabled=YES;
//
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Pickerselected:(id)sender {
    
    if (_cityPicker.hidden==NO)
    {
        NSInteger row;
        row = [_cityPicker selectedRowInComponent:0];
        RatecardRecord *object=(RatecardRecord*)[cityArray objectAtIndex:row];
        cityID=object.cityID;
        self.lblCity.text=object.cityName;
        self.pickerView.hidden=YES;
        CarPickerBtn.userInteractionEnabled=YES ;
        CityPickerBtn.userInteractionEnabled=YES;
    }
    else
    {
        NSInteger row;
        row = [_categoryPicker selectedRowInComponent:0];
        RatecardRecord *object=(RatecardRecord*)[categoryArray objectAtIndex:row];
        categoryID=object.categoryID;
        self.lblCartype.text=object.categoryName;
        self.pickerView.hidden=YES;
        [self retrieveRatecardDetails];

    }
   
}

@end
