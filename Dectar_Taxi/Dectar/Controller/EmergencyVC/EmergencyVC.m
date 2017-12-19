//
//  EmergencyVC.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/28/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "EmergencyVC.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "EmergencyRecord.h"
#import "Constant.h"
#import "REFrostedViewController.h"
#import "LanguageHandler.h"

@interface EmergencyVC ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    EmergencyRecord*objrecd;
    UIPickerView * CountryPicker;
    UIToolbar *mypickerToolbar;
     JJLocationManager * jjLocManager;
}

@end

@implementation EmergencyVC
@synthesize menu,savebtn,name_fld,mbl_fld,Edit_btn,email_fld,Panic_Btn,longitude,latitude,Country_fld,Countrycode_Array,CountryName_Array;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if(jjLocManager==nil){
        jjLocManager=[JJLocationManager sharedManager];
        [[JJLocationManager sharedManager]updateLocationToServerManually];
    }
    // Do any additional setup after loading the view.
    
    CountryName_Array=[NSArray new];
    Countrycode_Array=[NSArray new];
    
    CountryName_Array=@[@"Afghanistan(+93)", @"Albania(+355)",@"Algeria(+213)",@"American Samoa(+1684)",@"Andorra(+376)",@"Angola(+244)",@"Anguilla(+1264)",@"Antarctica(+672)",@"Antigua and Barbuda(+1268)",@"Argentina(+54)",@"Armenia(+374)",@"Aruba(+297)",@"Australia(+61)",@"Austria(+43)",@"Azerbaijan(+994)",@"Bahamas(+1242)",@"Bahrain(+973)",@"Bangladesh(+880)",@"Barbados(+1246)",@"Belarus(+375)",@"Belgium(+32)",@"Belize(+501)",@"Benin(+229)",@"Bermuda(+1441)",@"Bhutan(+975)",@"Bolivia(+591)",@"Bosnia and Herzegovina(+387)",@"Botswana(+267)",@"Brazil(+55)",@"British Virgin Islands(+1284)",@"Brunei(+673)",@"Bulgaria(+359)",@"Burkina Faso(+226)",@"Burma (Myanmar)(+95)",@"Burundi(+257)",@"Cambodia(+855)",@"Cameroon(+237)",@"Canada(+1)",@"Cape Verde(+238)",@"Cayman Islands(+1345)",@"Central African Republic(+236)",@"Chad(+235)",@"Chile(+56)",@"China(+86)",@"Christmas Island(+61)",@"Cocos (Keeling) Islands(+61)",@"Colombia(+57)",@"Comoros(+269)",@"Cook Islands(+682)",@"Costa Rica(+506)",@"Croatia(+385)",@"Cuba(+53)",@"Cyprus(+357)",@"Czech Republic(+420)",@"Democratic Republic of the Congo(+243)",@"Denmark(+45)",@"Djibouti(+253)",@"Dominica(+1767)",@"Dominican Republic(+1809)",@"Ecuador(+593)",@"Egypt(+20)",@"El Salvador(+503)",@"Equatorial Guinea(+240)",@"Eritrea(+291)",@"Estonia(+372)",@"Ethiopia(+251)",@"Falkland Islands(+500)",@"Faroe Islands(+298)",@"Fiji(+679)",@"Finland(+358)",@"France (+33)",@"French Polynesia(+689)",@"Gabon(+241)",@"Gambia(+220)",@"Gaza Strip(+970)",@"Georgia(+995)",@"Germany(+49)",@"Ghana(+233)",@"Gibraltar(+350)",@"Greece(+30)",@"Greenland(+299)",@"Grenada(+1473)",@"Guam(+1671)",@"Guatemala(+502)",@"Guinea(+224)",@"Guinea-Bissau(+245)",@"Guyana(+592)",@"Haiti(+509)",@"Holy See (Vatican City)(+39)",@"Honduras(+504)",@"Hong Kong(+852)",@"Hungary(+36)",@"Iceland(+354)",@"India(+91)",@"Indonesia(+62)",@"Iran(+98)",@"Iraq(+964)",@"Ireland(+353)",@"Isle of Man(+44)",@"Israel(+972)",@"Italy(+39)",@"Ivory Coast(+225)",@"Jamaica(+1876)",@"Japan(+81)",@"Jordan(+962)",@"Kazakhstan(+7)",@"Kenya(+254)",@"Kiribati(+686)",@"Kosovo(+381)",@"Kuwait(+965)",@"Kyrgyzstan(+996)",@"Laos(+856)",@"Latvia(+371)",@"Lebanon(+961)",@"Lesotho(+266)",@"Liberia(+231)",@"Libya(+218)",@"Liechtenstein(+423)",@"Lithuania(+370)",@"Luxembourg(+352)",@"Macau(+853)",@"Macedonia(+389)",@"Madagascar(+261)",@"Malawi(+265)",@"Malaysia(+60)",@"Maldives(+960)",@"Mali(+223)",@"Malta(+356)",@"MarshallIslands(+692)",@"Mauritania(+222)",@"Mauritius(+230)",@"Mayotte(+262)",@"Mexico(+52)",@"Micronesia(+691)",@"Moldova(+373)",@"Monaco(+377)",@"Mongolia(+976)",@"Montenegro(+382)",@"Montserrat(+1664)",@"Morocco(+212)",@"Mozambique(+258)",@"Namibia(+264)",@"Nauru(+674)",@"Nepal(+977)",@"Netherlands(+31)",@"Netherlands Antilles(+599)",@"New Caledonia(+687)",@"New Zealand(+64)",@"Nicaragua(+505)",@"Niger(+227)",@"Nigeria(+234)",@"Niue(+683)",@"Norfolk Island(+672)",@"North Korea (+850)",@"Northern Mariana Islands(+1670)",@"Norway(+47)",@"Oman(+968)",@"Pakistan(+92)",@"Palau(+680)",@"Panama(+507)",@"Papua New Guinea(+675)",@"Paraguay(+595)",@"Peru(+51)",@"Philippines(+63)",@"Pitcairn Islands(+870)",@"Poland(+48)",@"Portugal(+351)",@"Puerto Rico(+1)",@"Qatar(+974)",@"Republic of the Congo(+242)",@"Romania(+40)",@"Russia(+7)",@"Rwanda(+250)",@"Saint Barthelemy(+590)",@"Saint Helena(+290)",@"Saint Kitts and Nevis(+1869)",@"Saint Lucia(+1758)",@"Saint Martin(+1599)",@"Saint Pierre and Miquelon(+508)",@"Saint Vincent and the Grenadines(+1784)",@"Samoa(+685)",@"San Marino(+378)",@"Sao Tome and Principe(+239)",@"Saudi Arabia(+966)",@"Senegal(+221)",@"Serbia(+381)",@"Seychelles(+248)",@"Sierra Leone(+232)",@"Singapore(+65)",@"Slovakia(+421)",@"Slovenia(+386)",@"Solomon Islands(+677)",@"Somalia(+252)",@"South Africa(+27)",@"South Korea(+82)",@"Spain(+34)",@"Sri Lanka(+94)",@"Sudan(+249)",@"Suriname(+597)",@"Swaziland(+268)",@"Sweden(+46)",@"Switzerland(+41)",@"Syria(+963)",@"Taiwan(+886)",@"Tajikistan(+992)",@"Tanzania(+255)",@"Thailand(+66)",@"Timor-Leste(+670)",@"Togo(+228)",@"Tokelau(+690)",@"Tonga(+676)",@"Trinidad and Tobago(+1868)",@"Tunisia(+216)",@"Turkey(+90)",@"Turkmenistan(+993)",@"Turks and Caicos Islands(+1649)",@"Tuvalu(+688)",@"Uganda(+256)",@"Ukraine(+380)",@"United Arab Emirates(+971)",@"United Kingdom(+44)",@"United States(+1)",@"Uruguay(+598)",@"US Virgin Islands(+1340)",@"Uzbekistan(+998)",@"Vanuatu(+678)",@"Venezuela(+58)",@"Vietnam(+84)",@"Wallis and Futuna(+681)",@"West Bank(970)",@"Yemen(+967)",@"Zambia(+260)",@"Zimbabwe(+263)"];
    
    Countrycode_Array=@[@"+93",@"+355",@"+213",@"+1684",@"+376",@"+244",@"+1264",@"+672",@"+1268",@"+54",@"+374",@"+297",@"+61",@"+43",@"+994",@"+1242",@"+973",@"+880",@"+1246",@"+375",@"+32",@"+501",@"+229",@"+1441",@"+975",@"+591",@"+387",@"+267",@"+55",@"+1284",@"+673",@"+359",@"+226",@"+95",@"+257",@"+855",@"+237",@"+1",@"+238",@"+1345",@"+236",@"+235",@"+56",@"+86",@"+61",@"+61",@"+57",@"+269",@"+682",@"+506",@"+385",@"+53",@"+357",@"+420",@"+243",@"+45",@"+253",@"+1767",@"+1809",@"+593",@"+20",@"+503",@"+240",@"+291",@"+372",@"+251",@"+500",@"+298",@"+679",@"+358",@"+33",@"+689",@"+241",@"+220",@"+970",@"+995",@"+49",@"+233",@"+350",@"+30",@"+299",@"+1473",@"+1671",@"+502",@"+224",@"+245",@"+592",@"+509",@"+39",@"+504",@"+852",@"+36",@"+354",@"+91",@"+62",@"+98",@"+964",@"+353",@"+44",@"+972",@"+39",@"+225",@"+1876",@"+81",@"+962",@"+7",@"+254",@"+686",@"+381",@"+965",@"+996",@"+856",@"+371",@"+961",@"+266",@"+231",@"+218",@"+423",@"+370",@"+352",@"+853",@"+389",@"+261",@"+265",@"+60",@"+960",@"+223",@"+356",@"+692",@"+222",@"+230",@"+262",@"+52",@"+691",@"+373",@"+377",@"+976",@"+382",@"+1664",@"+212",@"+258",@"+264",@"+674",@"+977",@"+31",@"+599",@"+687",@"+64",@"+505",@"+227",@"+234",@"+683",@"+672",@"+850",@"+1670",@"+47",@"+968",@"+92",@"+680",@"+507",@"+675",@"+595",@"+51",@"+63",@"+870",@"+48",@"+351",@"+1",@"+974",@"+242",@"+40",@"+7",@"+250",@"+590",@"+290",@"+1869",@"+1758",@"+1599",@"+508",@"+1784",@"+685",@"+378",@"+239",@"+966",@"+221",@"+381",@"+248",@"+232",@"+65",@"+421",@"+386",@"+677",@"+252",@"+27",@"+82",@"+34",@"+94",@"+249",@"+597",@"+268",@"+46",@"+41",@"+963",@"+886",@"+992",@"+255",@"+66",@"+670",@"+228",@"+690",@"+676",@"+1868",@"+216",@"+90",@"+993",@"+1649",@"+688",@"+256",@"+380",@"+971",@"+44",@"+1",@"+598",@"+1340",@"+998",@"+678",@"+58",@"+84",@"+681",@"+970",@"+967",@"+260",@"+263"];
    

    
  
    latitude =jjLocManager.currentLocation.coordinate.latitude;
    longitude =jjLocManager.currentLocation.coordinate.longitude;
    
    Panic_Btn.layer.shadowColor = [UIColor blackColor].CGColor;
    Panic_Btn.layer.shadowOpacity = 0.5;
    Panic_Btn.layer.shadowRadius = 2;
    Panic_Btn.layer.shadowOffset = CGSizeMake(7.5f,7.5f);
    
    Country_fld.delegate=self;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:JJLocalizedString(@"Remove_Contact", nil)
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                          NSUnderlineColorAttributeName: BGCOLOR,NSForegroundColorAttributeName:BGCOLOR}]];
    [_Remove_btn setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    [self textfieldleftpadding:name_fld];
    [self textfieldleftpadding:mbl_fld];
    [self textfieldleftpadding:email_fld];
    [self textfieldleftpadding:Country_fld];

    
    UITapGestureRecognizer * estimate=[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(SaveButton)];
    estimate.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:estimate];

    [self shownContact];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)textfieldleftpadding:(UITextField*)feld
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    feld.leftView = paddingView;
    feld.leftViewMode = UITextFieldViewModeAlways;
    feld.layer.borderColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    feld.layer.borderWidth=0.8f;
    feld.layer.cornerRadius=5.0f;
    feld.layer.masksToBounds=YES;

}
-(void)applicationLanguageChangeNotification:(NSNotification *)notification
{
    [_Heading setText:JJLocalizedString(@"Emergency_Contact", nil)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:JJLocalizedString(@"Remove_Contact", nil)
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                          NSUnderlineColorAttributeName: BGCOLOR,NSForegroundColorAttributeName:BGCOLOR}]];
    [_Remove_btn setAttributedTitle:attributedString forState:UIControlStateNormal];

    [name_fld setPlaceholder:JJLocalizedString(@"Enter_name", nil)];
    [mbl_fld setPlaceholder:JJLocalizedString(@"Enter_Mobile_Number", nil)];
    [email_fld setPlaceholder:JJLocalizedString(@"Enter_Email_id", nil)];
    [savebtn setTitle:JJLocalizedString(@"save", nil) forState:UIControlStateNormal];
    [_hint setText:JJLocalizedString(@"List_youremergency", nil)];
    [_note setText:JJLocalizedString(@"Note_Your_Contact_can", nil)];
    
    
}
- (IBAction)didClickMenuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)SaveButton
{
    [self.view endEditing:YES];
    [mbl_fld resignFirstResponder];
    [name_fld resignFirstResponder];
    [email_fld resignFirstResponder];
    [Country_fld resignFirstResponder];

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField==Country_fld) {
      //  [self.view endEditing:YES];
        [Country_fld resignFirstResponder];
       
        [self performSelector:@selector(moveToCountryList) withObject:self afterDelay:1];
    }
    
    return YES;
}
-(void)moveToCountryList{
    CountryListViewController*objStoreDetailVC=[[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
    [self.navigationController pushViewController:objStoreDetailVC animated:YES];
}

- (void)didSelectCountry:(NSDictionary *)country;
{
    if ([country count]>0) {
        [self.view endEditing:YES];
        [Country_fld resignFirstResponder];
        Country_fld.text=[country objectForKey:@"dial_code"];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    savebtn.hidden=NO;
}


- (IBAction)EditOption:(id)sender {
    
    [self textFieldDidBeginEditing:name_fld];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text length] ==0 && [string isEqualToString:@" "] ){
        return NO;
    }
    if (textField==mbl_fld)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= MaximumDigit;
    }
   else if (textField==Country_fld)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 4;
    }
  else if (textField==email_fld)
    {
        NSString *resultingString = [email_fld.text stringByReplacingCharactersInRange: range withString: string];
        NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
        if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound)
        {
            return YES;
        }  else  {
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

     if (textField==email_fld)
    {
        if (![self validateEmail:email_fld.text])
        {
            NSString *titleStr = JJLocalizedString(@"Oops", nil);
            UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:JJLocalizedString(@"Please_Enter_Valid_Email", nil)  delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [Alert show];
            [textField becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
        }
    }
    else if(textField==mbl_fld)
    {
        if([textField.text length]<=0)
        {
            
        }
    }
    
    return YES;
}
- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (IBAction)SaveOption:(id)sender {
    
   
    /*if (![name_fld.text isEqualToString:@"" ] && ![mbl_fld.text isEqualToString:@""] && ![email_fld.text isEqualToString:@""] && ![Country_fld.text isEqualToString:@""] && ! ([mbl_fld.text length]<10) )*/
    
    if ([self validateTextfield])

    {
        NSDictionary*paramets=@{@"user_id":[Themes checkNullValue:[Themes getUserID]],
                                @"em_name":[Themes convertHTMLToText:name_fld.text],
                                @"em_email":[Themes convertHTMLToText:email_fld.text],
                                @"em_mobile_code":[Themes convertHTMLToText:Country_fld.text],
                                @"em_mobile":[Themes convertHTMLToText:mbl_fld.text]
                                };
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [web saveEmergency:paramets success:^(NSMutableDictionary *responseDictionary)
        {
            [Themes StopView:self.view];

            if ([responseDictionary count]>0)
            {
                responseDictionary=[Themes writableValue:responseDictionary];
                
                NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                NSString * alert=[responseDictionary valueForKey:@"response"];
                [Themes StopView:self.view];
                if ([comfiramtion isEqualToString:@"1"])
                {
                    objrecd=[[EmergencyRecord alloc]init];
                    objrecd.numeber=mbl_fld.text;
                    objrecd.name=name_fld.text;
                    objrecd.email=email_fld.text;
                    
                    _Remove_btn.hidden=NO;
                    [mbl_fld resignFirstResponder];
                    [name_fld resignFirstResponder];
                    [email_fld resignFirstResponder];
                    [Country_fld resignFirstResponder];
                    
                    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                    [Alert show];
                    Panic_Btn.hidden=NO;

                    
                }
                
                else
                {
                    NSString *titleStr = JJLocalizedString(@"Oops", nil);
                    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                    [Alert show];
                }
            }
           
        } failure:^(NSError *error) {
            [Themes StopView:self.view];
            
        }];
        
    }
    /*else
    {
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error\xF0\x9F\x9A\xAB" message:@"PLEASE ENTER FIELDS" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];

    }*/
    
   
}
- (IBAction)removeOptions:(id)sender {
    
    
    NSDictionary*paramets=@{@"user_id":[Themes checkNullValue:[Themes getUserID]]
                            };
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web RemoveEmergency:paramets success:^(NSMutableDictionary *responseDictionary)
    {
        [Themes StopView:self.view];

        if ([responseDictionary count]>0)
        {
            responseDictionary=[Themes writableValue:responseDictionary];
            
            NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
            NSString * alert=[responseDictionary valueForKey:@"response"];
            [Themes StopView:self.view];
            
            if ([comfiramtion isEqualToString:@"1"])
            {
                mbl_fld.text=@"";
                name_fld.text=@"";
                email_fld.text=@"";
                Country_fld.text=@"";
                _Remove_btn.hidden=YES;
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                [Alert show];
                savebtn.hidden=YES;
                Panic_Btn.hidden=YES;

                
                
            }
            
            else
            {
                NSString *titleStr = JJLocalizedString(@"Oops", nil);
                UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                [Alert show];
            }
        }
        
    } failure:^(NSError *error) {
       
        [Themes StopView:self.view];
    }];
    
    
}
-(void)shownContact
{
    NSDictionary*paramets=@{@"user_id":[Themes getUserID]};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web ShowEmergency:paramets success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];

        if ([responseDictionary count]>0)
        {
            responseDictionary=[Themes writableValue:responseDictionary];
            
            NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
           // NSString * alert=[responseDictionary valueForKey:@"response"];
            [Themes StopView:self.view];
            
            if ([comfiramtion isEqualToString:@"1"])
            {
                name_fld.text=[[responseDictionary valueForKey:@"emergency_contact"]valueForKey:@"name"];
                mbl_fld.text=[[responseDictionary valueForKey:@"emergency_contact"]valueForKey:@"mobile"];
                email_fld.text=[[responseDictionary valueForKey:@"emergency_contact"]valueForKey:@"email"];
                Country_fld.text=[[responseDictionary valueForKey:@"emergency_contact"]valueForKey:@"code"];
                _Remove_btn.hidden=NO;
                Panic_Btn.hidden=NO;
                /*UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Success\xF0\x9F\x91\x8D" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [Alert show];*/
                
            }
            
            else
            {
                /* UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Error\xF0\x9F\x9A\xAB" message:alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [Alert show];*/
            }

        }
    }
               failure:^(NSError *error) {
       [Themes StopView:self.view];
        
    }];
    
}
- (IBAction)press_panic:(id)sender {
    
    NSString*PicklatitudeStr=[NSString stringWithFormat:@"%f",latitude];
    NSString*PicklongitudeStr=[NSString stringWithFormat:@"%f",longitude];
    
    NSDictionary*paramets=@{@"user_id":[Themes checkNullValue:[Themes getUserID]],
                            @"latitude":PicklatitudeStr,
                            @"longitude":PicklongitudeStr};
    
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self.view];
    [web AlertEmergency:paramets success:^(NSMutableDictionary *responseDictionary)
     {
         [Themes StopView:self.view];
         
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             
             NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
             NSString * alert=[responseDictionary valueForKey:@"response"];
             [Themes StopView:self.view];
             
             if ([comfiramtion isEqualToString:@"1"])
             {
                  UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"Be_Relax", nil)  message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                  [Alert show];
                 Panic_Btn.hidden=NO;
                 
             }
             
             else
             {
                 NSString *titleStr = JJLocalizedString(@"Oops", nil);
                 UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                  [Alert show];
             }
             
         }
     }
               failure:^(NSError *error) {
                   [Themes StopView:self.view];
                   
               }];
    
}
-(BOOL)validateTextfield
{
 
   name_fld.text= [Themes convertHTMLToText:name_fld.text];
    email_fld.text=[Themes convertHTMLToText:email_fld.text];
    Country_fld.text=[Themes convertHTMLToText:Country_fld.text];
    mbl_fld.text=[Themes convertHTMLToText:mbl_fld.text];
    if(name_fld.text.length==0){
        [self showAlert:JJLocalizedString(@"Name_is_mandatory", nil)];
        [name_fld becomeFirstResponder];
        return NO;
    }else if(Country_fld.text.length==0){
        [self showAlert:JJLocalizedString(@"Country_is_mandatory", nil)];
   
        return NO;
    }
    else if(mbl_fld.text.length==0){
        [self showAlert:JJLocalizedString(@"Mobile_Number_is_mandatory", nil)];
        [mbl_fld becomeFirstResponder];
        return NO;
    }
    else if(mbl_fld.text.length<MinimumDigit){
        [self showAlert:JJLocalizedString(@"enter_valid_mobile", nil)];
        [mbl_fld becomeFirstResponder];
        return NO;
    }
    else if(email_fld.text.length==0){
        [self showAlert:JJLocalizedString(@"Email_is_mandatory", nil)];
        [email_fld becomeFirstResponder];
        return NO;
    }else if(![Themes NSStringIsValidEmail:email_fld.text]){
            [self showAlert:JJLocalizedString(@"Please_Enter_Valid_Email", nil)];
        [email_fld becomeFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)showAlert:(NSString *)errorStr{
    NSString *titleStr = JJLocalizedString(@"Oops", nil);
    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:errorStr delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [Alert show];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [CountryName_Array count];
}

// The data to return for the row and component (column) that's being passed in


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    
    return [CountryName_Array objectAtIndex:row];
    
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    
    Country_fld.text = [Countrycode_Array objectAtIndex:row];
    
    savebtn.hidden=NO;
    
}

- (IBAction)didClickCountryBtn:(id)sender {
    [self moveToCountryList];
}
@end
