//
//  AddFavrVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/24/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "AddFavrVC.h"
#import "UrlHandler.h"
#import "Themes.h"
#import "Constant.h"
#import "LanguageHandler.h"
#import "FavouriteCategoryCel.h"
#import "FavouriteListCell.h"

@interface AddFavrVC ()<UITableViewDelegate,UITableViewDataSource,categoryFavourite,UISearchBarDelegate>
{
    NSArray *arrayCategory;
    NSString *btnSelectedStr;
    NSMutableArray *SearchResultArray;

     JJLocationManager * jjLocManager;
}
@property (strong, nonatomic) IBOutlet UIButton *locaBtn;
@property (strong, nonatomic) IBOutlet UITextField *address_fld;



@end

@implementation AddFavrVC
@synthesize Title,Address,MapBG,Camera,GoogleMap,longitude,latitude,addressObj,locaBtn,locationKey,favourObj,isFromEdit,UserID,addressSearchBar,filterdatas,addressView,address_table_view;


- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewFav.hidden=YES;
    Title.hidden=YES;
    _viewUnderTitle.hidden=YES;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [addressView setHidden:YES];
    [addressSearchBar setDelegate:self];


   // [self.view addGestureRecognizer:tap];
    arrayCategory=[[NSArray alloc]initWithObjects:@"Home",@"Work",@"Custom", nil];
    UserID=[Themes getUserID];
    filterdatas=[[NSMutableArray alloc]init];

    if(jjLocManager==nil){
        jjLocManager=[JJLocationManager sharedManager];
        [[JJLocationManager sharedManager]updateLocationToServerManually];
    }
    if (isFromEdit==YES)
    {
        [self setFavourObj:favourObj];
        if( favourObj.titleString.length>0){
            Title.text=favourObj.titleString;
        }
        if(favourObj.latitudeStr==0){
            latitude=jjLocManager.currentLocation.coordinate.latitude;
            longitude=jjLocManager.currentLocation.coordinate.longitude;
        }
        Camera = [GMSCameraPosition cameraWithLatitude:latitude
                                             longitude:longitude
                                                  zoom:15];
        [GoogleMap animateToCameraPosition:Camera];

    }
    else if (isFromEdit==NO)
    {
    [self setAddressObj:favourObj];
        if(favourObj.latitudeStr==0){
            latitude=jjLocManager.currentLocation.coordinate.latitude;
            longitude=jjLocManager.currentLocation.coordinate.longitude;
        }
        Camera = [GMSCameraPosition cameraWithLatitude:latitude
                                             longitude:longitude
                                                  zoom:15];
        [GoogleMap animateToCameraPosition:Camera];

    }
    if (_isfromHome==YES) {
        _lblGetFavPlace.text=@"Home";
        Title.text=@"Home";
    }
    else if (_isfromWork==YES)
    {
        _lblGetFavPlace.text=@"Work";
        Title.text=@"Work";
    }
    else if (_isfromCustom==YES)
    {
        _lblGetFavPlace.text=@"Custom";
        Title.hidden=NO;
        _viewUnderTitle.hidden=NO;
    }
   /* CGRect mapFrame=GoogleMap.frame;
    mapFrame.origin.y=0;
    GoogleMap.frame=mapFrame;*/

    GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, MapBG.frame.size.width , MapBG.frame.size.height) camera:Camera];
    if (MapNightMode==1) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSURL *styleUrl = [mainBundle URLForResource:@"Style" withExtension:@"json"];
        NSError *error;
        GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
        if (!style) {
            NSLog(@"The style definition could not be loaded: %@", error);
        }
        else{
            GoogleMap.mapStyle = style;
        }
    }

    GoogleMap.myLocationEnabled = YES;

    GoogleMap.delegate = self;
    [MapBG addSubview:GoogleMap];
    
    [MapBG addSubview:_pinpoint];
    [MapBG addSubview:_current_Loc];
    _tableViewFav.delegate=self;
    _tableViewFav.dataSource=self;
    // Do any additional setup after loading the view.
}
-(void)dismissKeyboard
{
    [Title resignFirstResponder];
    [addressView resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==Title) {
        [Title resignFirstResponder];
    }
    [Address resignFirstResponder];
        return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [Address resignFirstResponder];
        return NO;
    }
   
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==Title) {
        if (textField==self.Title&&range.location==0) {
            if ([string hasPrefix:@" "]) {
                return NO;
            }
        }

    }
    return YES;
}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_heading setText:JJLocalizedString(@"Add_Favorite", nil)] ;
    [Title setPlaceholder:JJLocalizedString(@"Name_of_your_favorites", nil)];
    [_Save setTitle:JJLocalizedString(@"save", nil) forState:UIControlStateNormal];
    [self.addressSearchBar setPlaceholder:JJLocalizedString(@"search_pickup_location", nil)];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [addressView setHidden:YES];
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    
}//sushmitha
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}//sushmitha


-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([searchBar.text isEqualToString:@""])
    {
        filterdatas=nil;
        [_Save setHidden:YES];
        
        
    }
    else
    {
        NSString *text1=[searchBar.text stringByAppendingString:text];
        
        if ([text1 containsString:@"\n"])
        {
            [addressSearchBar resignFirstResponder];
        }
        else
        {
            
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [web getGoogleAddress:[self setParametersfromSearchBar:text1]
                          success:^(NSMutableDictionary *responseDictionary)
             {
                 @try {
                     NSArray* jsonResults = [responseDictionary valueForKey:@"predictions"];
                     if([jsonResults count]>0){
                         [addressView setHidden:NO];
                         [_Save setHidden:NO];
                         SearchResultArray= (NSMutableArray *) responseDictionary[@"predictions"];
                         filterdatas  = (NSMutableArray *) [SearchResultArray valueForKey:@"description"];
                         
                         [self updateTableWithFilteredData:filterdatas];
                     }
                     else{
                         [self Toast:@"cant_find_address"];
                     }
                 }
                 @catch (NSException *exception) {
                     
                 }
             }
                          failure:^(NSError *error)
             {
                 [self Toast:@"cant_find_address"];
                 [Themes StopView:self.view];
                 
             }];
            
            
        }
        
        
    }
    
    return YES;
}

-(NSDictionary *)setParametersfromSearchBar:(NSString *)addr{
    
    NSDictionary *dictForuser = @{
                                  @"input":addr,
                                  @"language":@"en",
                                  @"location":[NSString stringWithFormat:@"%f,%f",jjLocManager.currentLocation.coordinate.latitude,jjLocManager.currentLocation.coordinate.longitude],
                                  @"key":GoogleServerKey
                                  };
    
    
    
    return dictForuser;
}
- (void)updateTableWithFilteredData:(NSMutableArray *)filteredData
{
    filterdatas = filteredData;
    [address_table_view setDelegate:self];
    [address_table_view setDataSource:self];
    [address_table_view reloadData];
}

-(void)setAddressObj:(FavourRecord *)_addressObj
{
    favourObj=_addressObj;
    latitude=_addressObj.latitudeStr;
    longitude=_addressObj.longitude;
    addressSearchBar.text=_addressObj.Address;
    
}


-(void)setFavourObj:(FavourRecord *)_favourObj
{
    favourObj=_favourObj;
    addressSearchBar.text=_favourObj.Address;
    latitude=_favourObj.latitudeStr;
    longitude=_favourObj.longitude;
    locationKey=_favourObj.locationkey;
    Title.text=_favourObj.titleString;
    _address_fld.text=_favourObj.Address;
   
}
- (IBAction)SaveAddress:(id)sender {
    if (isFromEdit==YES)
    {
       
        if ([Title.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"check", nil)  message:JJLocalizedString(@"Kindly_Enter_Name_of_your_favorites", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
        }
 		else if ([addressSearchBar.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"check", nil) message:JJLocalizedString(@"Kindly_Enter_Address", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
        }
        else
        {
            [self EditFavour];

        }
    
    }
    else if (isFromEdit==NO)
    {
        
        if ([Title.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"check", nil)  message:JJLocalizedString(@"Kindly_Enter_Name_of_your_favorites", nil)   delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
          [Alert show];
        }
		 else if ([addressSearchBar.text isEqualToString:@""])
        {
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"check", nil)  message:JJLocalizedString(@"Kindly_Enter_Address", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
        }
        else
        {
            [self AddFavor];

        }
    }
}

- (IBAction)BackTo:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];

    }

}
-(void)AddFavor
{
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSDictionary * parameters=@{@"title":[Themes checkNullValue:Title.text],
                                @"latitude":[Themes checkNullValue:PicklatitudeStr],
                                @"longitude":[Themes checkNullValue:PicklongitudeStr],
                                @"address":[Themes checkNullValue:addressSearchBar.text],
                                @"user_id":[Themes checkNullValue:UserID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web SaveFavourite:parameters success:^(NSMutableDictionary *responseDictionary)
     
     {
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self.view];

         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             [Themes StopView:self.view];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                 NSString * messageString=[responseDictionary valueForKey:@"message"];
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:messageString delegate:self cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }
             else
             {
                 NSString * messageString=[responseDictionary valueForKey:@"message"];
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:messageString delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }
         }
         
         
     }
     
               failure:^(NSError *error)
     {
         [Themes StopView:self.view];
     }];
}
-(void)EditFavour
{
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSDictionary * parameters=@{@"title":[Themes checkNullValue:Title.text],
                                @"latitude":[Themes checkNullValue:PicklatitudeStr],
                                @"longitude":[Themes checkNullValue:PicklongitudeStr],
                                @"address":[Themes checkNullValue:addressSearchBar.text],
                                @"user_id":[Themes checkNullValue:UserID],
                                @"location_key":[Themes checkNullValue:locationKey]
                                    };
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    
    [web EditListFavour :parameters success:^(NSMutableDictionary *responseDictionary)
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
                 NSString * messageString=[responseDictionary valueForKey:@"message"];
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:messageString delegate:self cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }
             else
             {
                 NSString * messageString=[NSString stringWithFormat:@"%@",@"message"];
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:messageString delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                 [Alert show];
                 
             }
             

         }
         
     }
     
               failure:^(NSError *error)
     {
        
         [Themes StopView:self.view];
     }];

}
- (IBAction)CurrentLocation:(id)sender {
    CLLocation *location = GoogleMap.myLocation;
    if (location) { //https://maps.googleapis.com/maps/api/distancematrix/json?
        [GoogleMap animateToLocation:location.coordinate];
    }
    
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    
    [Address resignFirstResponder];
    [Title resignFirstResponder];
    
   
    
    
    
    /* [geocoder reverseGeocodeLocation:newLocation
     completionHandler:^(NSArray *placemarks, NSError *error) {
     
     if (error) {
     NSLog(@"Geocode failed with error: %@", error);
     return;
     }
     
     if (placemarks && placemarks.count > 0)
     {
     CLPlacemark *placemark = placemarks[0];
     
     NSDictionary *addressDictionary =
     placemark.addressDictionary;
     
     NSString *address = [addressDictionary
     objectForKey:(NSString *)kABPersonAddressStreetKey];
     NSString *city = [addressDictionary
     objectForKey:(NSString *)kABPersonAddressCityKey];
     NSString *state = [addressDictionary
     objectForKey:(NSString *)kABPersonAddressStateKey];
     //                           NSString *zip = [addressDictionary
     //                                            objectForKey:(NSString *)kABPersonAddressZIPKey];
     
     NSString *SunLocal =[addressDictionary objectForKey:@"SubAdministrativeArea"];
     
     NSString *undesired = @"(null),";
     NSString *desired   = @"";
     
     addressString=[NSString stringWithFormat:@"%@,%@,%@,%@",address,city,SunLocal,state];
     if(isLocationSelected==NO){
     AddressField.text = [addressString stringByReplacingOccurrencesOfString:undesired
     withString:desired];
     }
     isLocationSelected=NO;
     }
     
     }];*/
}
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    CGPoint point = GoogleMap.center;
    CLLocationCoordinate2D coor = [mapView.projection coordinateForPoint:point];
    
    /* CLGeocoder *geocoder = [[CLGeocoder alloc] init];
     
     CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:coor.latitude
     longitude:coor.longitude];
     latitude=coor.latitude;
     longitude=coor.longitude;*/
    
    latitude=coor.latitude;
    longitude=coor.longitude;
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(coor.latitude, coor.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        if(error==nil){
            GMSAddress * address=[response firstResult];
            if([address.lines count]>0){
                NSString * temp1=[address.lines objectAtIndex:0];
                NSString *temp2;
                if([address.lines count]>1){
                    temp2=[address.lines objectAtIndex:1];
                }
                
                //  NSString * final=[NSString stringWithFormat:@"%@, %@", temp1 ,temp2];
                
                NSString *undesired = @",(null)";
                NSString *desired   = @"";
                
                NSString *addressString=[NSString stringWithFormat:@"%@,%@",temp1,temp2];
                
                addressSearchBar.text = [addressString stringByReplacingOccurrencesOfString:undesired
                                                                        withString:desired];
                NSArray *elements = [addressSearchBar.text componentsSeparatedByString:@","];
                NSMutableArray *outputElements = [[NSMutableArray alloc] init];
                for (NSString *element in elements)
                    if ([element length] > 0)
                        [outputElements addObject:element];
                
                addressSearchBar.text= [outputElements componentsJoinedByString:@","];
                _address_fld.text= [addressString stringByReplacingOccurrencesOfString:undesired
                                                                            withString:desired];
                
                
                latitude=coor.latitude;
                longitude=coor.longitude;
            }else{
                [self.view makeToast:@"Cant_fetch_Address"];
            }
            
        }else{
              [self.view makeToast:@"Cant_fetch_Address"];
        }
        
        
        
        //NSLog(@"Geocode failed with error: %f %f", latitude,longitude);
        
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [arrayCategory count];
    return [filterdatas count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [filterdatas objectAtIndex:indexPath.row];
    
    return cell;
//    static NSString *simpleTableIdentifier = @"FavouriteListCellIdentifier";
//    
//    FavouriteListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[FavouriteListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    cell.lblCategory.text = [arrayCategory objectAtIndex:indexPath.row];
//    return cell;
    
//    static NSString *CellIdentifier = @"CategoryFavouriteCell";
//    
//    FavouriteCategoryCel *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[FavouriteCategoryCel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
//        cell.lblFavourite.text=@"home";
//    }
//    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [addressSearchBar resignFirstResponder];
    [addressView setHidden:YES];
    
    addressSearchBar.text=[filterdatas objectAtIndex:indexPath.row];
    [self getGoogleAdrressFromStr:[filterdatas objectAtIndex:indexPath.row]];
//    _tableViewFav.hidden=YES;
//    btnSelectedStr=[arrayCategory objectAtIndex:indexPath.row];
//    [_btnSelectCategory setTitle:btnSelectedStr forState:UIControlStateNormal];
//    if (indexPath.row==2) {
//        Title.hidden=NO;
//        _viewUnderTitle.hidden=NO;
//        Title.text=@"";
//    }
//    else{
//        Title.hidden=YES;
//        _viewUnderTitle.hidden=YES;
//        Title.text=btnSelectedStr;
//        
//    }

}-(void)getGoogleAdrressFromStr:(NSString *)addrStr{
    
    [Themes StartView:self.view];
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParametersToaddr:addrStr]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             [Themes StopView:self.view];
             
             NSArray* jsonResults = [responseDictionary valueForKey:@"results"][0][@"geometry"][@"location"];
             if([jsonResults count]>0){
                 double latitude1 = 0, longitude1 = 0;
                 
                 latitude1 = [[jsonResults valueForKey:@"lat"] doubleValue];
                 longitude1 = [[jsonResults valueForKey:@"lng"] doubleValue];
                 
                 latitude=latitude1;
                 longitude=longitude1;
                 [GoogleMap animateToLocation:CLLocationCoordinate2DMake(latitude, longitude)];
                 [GoogleMap animateToZoom:17.0];
                 
                 //                 _DropMarker.position=CLLocationCoordinate2DMake(_latitude, _longitude);
                 //                 _DropMarker.map = _GoogleMap;
                 //                 _DropMarker.title = JJLocalizedString(@"This_is_your_Drop_Location",nil);
                 //                 _DropMarker.snippet = _address_search.text;
                 //                 UIImage *mapicon=[UIImage imageNamed:@"drop_pin"];
                 //                 _DropMarker.icon = mapicon;
                 //                 _DropMarker.appearAnimation=kGMSMarkerAnimationPop;
                 _Save.hidden=NO;
                 
             }else{
                 [self Toast:@"cant_find_address"];
             }
         }
         @catch (NSException *exception) {
             
         }
         
         
     }
                           failure:^(NSError *error)
     {
         [self Toast:@"cant_find_address"];
         [Themes StopView:self.view];
         
         
     }];
    
}

-(NSDictionary *)setParametersToaddr:(NSString *)addr{
    
    NSDictionary *dictForuser = @{
                                  @"address":addr,
                                  @"sensor":@"false",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    _tableData.hidden=YES;
//    btnSelectedStr=[arrayCategory objectAtIndex:indexPath.row];
//    [_btnSelectCategory setTitle:btnSelectedStr forState:UIControlStateNormal];
//    if (indexPath.row==2) {
//        Title.hidden=NO;
//        _viewUnderTitle.hidden=NO;
//        Title.text=@"";
//    }
//    else{
//        Title.hidden=YES;
//        _viewUnderTitle.hidden=YES;
//        Title.text=btnSelectedStr;
//
//    }
//    }

- (IBAction)didClickCategory:(id)sender {
    
        [_tableViewFav setHidden:NO];
    
}
- (void)indexpath:(NSIndexPath *)categoryIndex;
{
    
}

-(void)showAlertForAppInfo:(NSString *)msg withStatus:(NSString *)msgStatus{
    NSString * title=JJLocalizedString(@"Oops", nil);
    NSInteger IconType=OpinionzAlertIconWarning;
    if([msgStatus isEqualToString:@"1"]){
        title=JJLocalizedString(@"success", nil);
        IconType=OpinionzAlertIconSuccess;
    }
    OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:title
                                                                message:msg
                                                      cancelButtonTitle:JJLocalizedString(@"ok", nil)
                                                      otherButtonTitles:nil];
    alert.iconType = IconType;
    [alert show];
}

-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str, nil)];
    [notice show];
}

@end
