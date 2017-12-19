//
//  DropVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 2/13/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "DropVC.h"
#import "AFNetworking.h"
#import <AddressBook/AddressBook.h>
#import "BookARideVC.h"
#import "Themes.h"
#import "Constant.h"
#import "LanguageHandler.h"



@interface DropVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,GMSMapViewDelegate>
{
    NSMutableDictionary *SearchResponDict;
    NSMutableArray *SearchResultArray;
    JJLocationManager * jjLocManager;
    NSString * SerachBarPrevioustxt;
   
    
}
@property  CLLocationCoordinate2D center;

@property (strong, nonatomic) GMSMapView * GoogleMap;
@property (strong, nonatomic) GMSCameraPosition * Camera;
@property (strong, nonatomic)GMSMarker *DropMarker;
@end

@implementation DropVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(jjLocManager==nil){
        jjLocManager=[JJLocationManager sharedManager];
        [[JJLocationManager sharedManager]updateLocationToServerManually];
    }
    
    [_table_content_view setHidden:YES];
    [_address_search setDelegate:self];
    _DropMarker = [[GMSMarker alloc] init];
    [_done setHidden:YES];

 
    
    _filterdata=[[NSMutableArray alloc]init];

    
    _Camera = [GMSCameraPosition cameraWithLatitude:jjLocManager.currentLocation.coordinate.latitude
                                         longitude: jjLocManager.currentLocation.coordinate.longitude
                                              zoom:17];
    _GoogleMap = [GMSMapView mapWithFrame:CGRectMake(0, 0, _mapBG.frame.size.width, _mapBG.frame.size.height) camera:_Camera];
    if (MapNightMode==1) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSURL *styleUrl = [mainBundle URLForResource:@"Style" withExtension:@"json"];
        NSError *error;
        GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
        if (!style) {
            NSLog(@"The style definition could not be loaded: %@", error);
        }
        else{
            _GoogleMap.mapStyle = style;
        }
    }


    _GoogleMap.delegate = self;
    [_mapBG addSubview:_GoogleMap];
    _GoogleMap.myLocationEnabled = YES;

    // Do any additional setup after loading the view.
}

-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    if(_isFromPickUp==YES){
        [self.Header_Lbl setText:JJLocalizedString(@"pickup_address", nil)];
        [self.address_search setPlaceholder:JJLocalizedString(@"search_pickup_location", nil)];
    }else if (_isFromEstimation==YES){
        [self.Header_Lbl setText:JJLocalizedString(@"Drop_Address", nil)];
        [self.address_search setPlaceholder:JJLocalizedString(@"Search_Drop_Location", nil)];
    }else{
        [self.Header_Lbl setText:JJLocalizedString(@"Drop_Address", nil)];
        [self.address_search setPlaceholder:JJLocalizedString(@"Search_Drop_Location", nil)];
    }
  
    [self.done setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [self.Long_press_lbl setText:JJLocalizedString(@"long_press_on_the", nil)];
    
    [_Drag_lbl setText:JJLocalizedString(@"Drag_your_drop", nil)];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_table_content_view setHidden:YES];
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([searchBar.text isEqualToString:@""])
    {
        _filterdata=nil;
        [_done setHidden:YES];

        
    }
    else
    {
        NSString *text1=[searchBar.text stringByAppendingString:text];
        
        if ([text1 containsString:@"\n"])
        {
            [_address_search resignFirstResponder];
        }
        else
        {

            NSString * Lat=[NSString stringWithFormat:@"%f",jjLocManager.currentLocation.coordinate.latitude];//deepa
            NSString * Lng=[NSString stringWithFormat:@"%f",jjLocManager.currentLocation.coordinate.longitude];//deepa
            
            UrlHandler *web = [UrlHandler UrlsharedHandler];
            [web getGoogleAddress:[self setParametersfromSearchBar:text1 lat:Lat lng:Lng]
                                   success:^(NSMutableDictionary *responseDictionary)
             {
                 @try {
                     NSArray* jsonResults = [responseDictionary valueForKey:@"predictions"];
                     if([jsonResults count]>0){
                             [_table_content_view setHidden:NO];
                         //  [_done setHidden:NO];  //dhiravida
                         SearchResultArray= (NSMutableArray *) responseDictionary[@"predictions"];
                         _filterdata  = (NSMutableArray *) [SearchResultArray valueForKey:@"description"];
                         
                         [self updateTableWithFilteredData:_filterdata];
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
-(NSDictionary *)setParametersfromSearchBar:(NSString *)addr lat:(NSString *) Lat lng:(NSString *) lng //deepa
{
    
    NSDictionary *dictForuser = @{
                                  @"input":addr,
                                  @"language":@"en",
                                  @"location":[NSString stringWithFormat:@"%@,%@",Lat,lng],
                                  @"radius":Searchradius,
                                  //@"types":@"geocode",
                                  @"key":GoogleServerKey
                                  };
    return dictForuser;
}
- (void)updateTableWithFilteredData:(NSMutableArray *)filteredData
{
    _filterdata = filteredData;
    [_addres_tabel setDelegate:self];
    [_addres_tabel setDataSource:self];
    [_addres_tabel reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_filterdata count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [_filterdata objectAtIndex:indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_address_search resignFirstResponder];
    [_table_content_view setHidden:YES];
    
    _address_search.text=[_filterdata objectAtIndex:indexPath.row];
    [self getGoogleAdrressFromStr:[_filterdata objectAtIndex:indexPath.row]];
    
    
}

-(void)getGoogleAdrressFromStr:(NSString *)addrStr{
    
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
                 
                 _latitude=latitude1;
                 _longitude=longitude1;
                 [_GoogleMap animateToLocation:CLLocationCoordinate2DMake(_latitude, _longitude)];
                 [_GoogleMap animateToZoom:17.0];
                 
//                 _DropMarker.position=CLLocationCoordinate2DMake(_latitude, _longitude);
//                 _DropMarker.map = _GoogleMap;
//                 _DropMarker.title = JJLocalizedString(@"This_is_your_Drop_Location",nil);
//                 _DropMarker.snippet = _address_search.text;
//                 UIImage *mapicon=[UIImage imageNamed:@"drop_pin"];
//                 _DropMarker.icon = mapicon;
//                 _DropMarker.appearAnimation=kGMSMarkerAnimationPop;
                 _done.hidden=NO;
                 
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
/*
-(void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    [_address_search resignFirstResponder];
    
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude
                                                        longitude:coordinate.longitude];
    
    [self getGoogleAdrressFromLatLong:newLocation];
    
    
}
-(void)getGoogleAdrressFromLatLong : (CLLocation *)loc{
    
      [Themes StartView:self.view];
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [web getGoogleLatLongToAddress:[self setParameters:loc.coordinate.latitude withLon:loc.coordinate.longitude]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         @try {
             [Themes StopView:self.view];
             NSArray* jsonResults = [[responseDictionary valueForKey:@"results"]valueForKey:@"formatted_address"];
             if([jsonResults count]>0){
                 
                 _latitude=loc.coordinate.latitude;
                 _longitude=loc.coordinate.longitude;
                 _address_search.text=[Themes writableValue: [jsonResults objectAtIndex:0]];
                 [_GoogleMap animateToLocation:CLLocationCoordinate2DMake(_latitude, _longitude)];
                 [_GoogleMap animateToZoom:17.0];
                 
                 _DropMarker.position=CLLocationCoordinate2DMake(_latitude, _longitude);
                 _DropMarker.map = _GoogleMap;
                 _DropMarker.title = JJLocalizedString(@"This_is_your_Drop_Location",nil);
                 _DropMarker.snippet = _address_search.text;
                 UIImage *mapicon=[UIImage imageNamed:@"drop_pin"];
                 _DropMarker.icon = mapicon;
                 _DropMarker.appearAnimation=kGMSMarkerAnimationPop;
                 _done.hidden=NO;
                 
                 [_done setHidden:NO];
                 
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
 */



//dhiravida
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    [self getGoogleAdrressFromLatLong:_GoogleMap.camera.target.latitude lon:_GoogleMap.camera.target.longitude];
}

-(void)getGoogleAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    // [_loadingView_View startAnimation];
    [Themes StartView:self.view];
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    SerachBarPrevioustxt=_address_search.text;
    _address_search.text=@"";
    [self DoneBtnDisabled];
    [web getGoogleLatLongToAddress:[self setParameters:lat withLon:lon]
                           success:^(NSMutableDictionary *responseDictionary)
     {
         //[_loadingView_View stopAnimation];
         [Themes StopView:self.view];
         
         
         @try {
             NSArray* jsonResults = [[responseDictionary valueForKey:@"results"] valueForKey:@"formatted_address"];
             
             if([jsonResults count]>0){
                 if(jsonResults.count>=2){
                     _selLocStr=[Themes checkNullValue: [jsonResults objectAtIndex:1]];
                     [_address_search setText:_selLocStr];
//                     finalDestLocation.latitude = (CLLocationDegrees)lat;
//                     finalDestLocation.longitude = (CLLocationDegrees)lon;
                     _done.hidden=NO;
                     
                     _latitude=(CLLocationDegrees)lat;
                     _longitude=(CLLocationDegrees)lon;
                     
                     [self DoneBtnEnabled];
                     
                 }else{
                     _selLocStr=[Themes checkNullValue: [jsonResults objectAtIndex:0]];
                     [_address_search setText:_selLocStr];
//                     finalDestLocation.latitude = (CLLocationDegrees)lat;
//                     finalDestLocation.longitude = (CLLocationDegrees)lon;
                     
                     _latitude=(CLLocationDegrees)lat;
                     _longitude=(CLLocationDegrees)lon;
                     
                     _done.hidden=NO;
                     _address_search.text=SerachBarPrevioustxt;
                 }
                 
             }else{
                 [self.view makeToast:@"can't_find_address"];
             }
         }
         @catch (NSException *exception) {
             [self.view makeToast:@"can't_find_address"];
         }
         
     }
                           failure:^(NSError *error)
     {
         // [_loadingView_View stopAnimation];
         // [self stopActivityIndicator];
         [Themes StopView:self.view];
         [self.view makeToast:@"can't_find_address"];
         _address_search.text=SerachBarPrevioustxt;
         
     }];
    
}

-(void)DoneBtnDisabled
{
    [_done setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_done setUserInteractionEnabled:false];
    
}
-(void)DoneBtnEnabled
{
    [_done setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_done setUserInteractionEnabled:true];
    
    
}









-(NSDictionary *)setParameters:(float )lat withLon:(float)lon{
    
    NSDictionary *dictForuser = @{
                                  @"latlng":[NSString stringWithFormat:@"%f,%f",lat,lon],
                                  @"sensor":@"false",
                                  @"key":GoogleServerKey
                                  
                                  };
    return dictForuser;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Done_action:(id)sender {
    
    CLLocation *  objCl =[[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
    if(_isFromPickUp==YES){
        if ([_delegate respondsToSelector:@selector(passPickUpLatLong:withDropTxt:)])
        {
             [self.delegate passPickUpLatLong:objCl withDropTxt:_address_search.text];
        }
        
    }else if (_isFromEstimation==YES){
        if ([_delegate respondsToSelector:@selector(passEstimateLatLong:withDropTxt:)])
        {
             [self.delegate passEstimateLatLong:objCl withDropTxt:_address_search.text];
        }
        
    }
    else{
        if ([_delegate respondsToSelector:@selector(passDropLatLong:withDropTxt:)])
        {
               [self.delegate passDropLatLong:objCl withDropTxt:_address_search.text];
        }

        
    }
 
      [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickRefreshButton:(id)sender {
    
    [_GoogleMap animateToLocation:CLLocationCoordinate2DMake(jjLocManager.currentLocation.coordinate.latitude, jjLocManager.currentLocation.coordinate.longitude)];
    [_GoogleMap animateToZoom:16.0];
    
}
@end
