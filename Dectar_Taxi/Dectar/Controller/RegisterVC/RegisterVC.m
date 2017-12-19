//
//  RegisterVC.m
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "RegisterVC.h"
#import "UrlHandler.h"
#import "LoginMainVC.h"
#import "Themes.h"
#import "OTP_VC.h"
#import "Constant.h"
#import "LoginVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LanguageHandler.h"
#import "CountryListViewController.h"

@interface RegisterVC ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView * CountryPicker;
    UIToolbar *mypickerToolbar;
    OTP_VC * otpVC;
    NSString * condition;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong , nonatomic) IBOutlet UITextField * nameField;
@property (strong , nonatomic) IBOutlet UITextField * email_Field;
@property (strong , nonatomic) IBOutlet UITextField * password_field;
@property (strong , nonatomic) IBOutlet UITextField * confirm_Field;
@property (strong , nonatomic) IBOutlet UITextField * mobile_field;
@property (strong , nonatomic) IBOutlet UITextField * referl_Field;
@property (strong , nonatomic) IBOutlet UITextField * Country_field;
@property (strong, nonatomic) IBOutlet UIButton *SignUP_Btn;
@property (strong, nonatomic) IBOutlet UIButton *Facebook;
@property (strong, nonatomic) IBOutlet UILabel *title_lbl;
@property (strong, nonatomic) IBOutlet UILabel *already_lbl;
@property (strong, nonatomic) IBOutlet UIButton *sign_btn;




@property (strong , nonatomic) NSString * OTP_status;
@property (strong , nonatomic) NSString * OTP_code;
@property (strong , nonatomic) NSArray * CountryName_Array;
@property (strong , nonatomic) NSArray * Countrycode_Array;

@end

@implementation RegisterVC
@synthesize nameField,email_Field,mobile_field,password_field,confirm_Field,referl_Field,Country_field,OTP_code,OTP_status,SignUP_Btn,Countrycode_Array,CountryName_Array;
@synthesize NameFB,EmailFB,IDFB,Facebook,loginrecord;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CountryName_Array=[NSArray new];
    Countrycode_Array=[NSArray new];
    
    CountryName_Array=@[@"Afghanistan(+93)", @"Albania(+355)",@"Algeria(+213)",@"American Samoa(+1684)",@"Andorra(+376)",@"Angola(+244)",@"Anguilla(+1264)",@"Antarctica(+672)",@"Antigua and Barbuda(+1268)",@"Argentina(+54)",@"Armenia(+374)",@"Aruba(+297)",@"Australia(+61)",@"Austria(+43)",@"Azerbaijan(+994)",@"Bahamas(+1242)",@"Bahrain(+973)",@"Bangladesh(+880)",@"Barbados(+1246)",@"Belarus(+375)",@"Belgium(+32)",@"Belize(+501)",@"Benin(+229)",@"Bermuda(+1441)",@"Bhutan(+975)",@"Bolivia(+591)",@"Bosnia and Herzegovina(+387)",@"Botswana(+267)",@"Brazil(+55)",@"British Virgin Islands(+1284)",@"Brunei(+673)",@"Bulgaria(+359)",@"Burkina Faso(+226)",@"Burma (Myanmar)(+95)",@"Burundi(+257)",@"Cambodia(+855)",@"Cameroon(+237)",@"Canada(+1)",@"Cape Verde(+238)",@"Cayman Islands(+1345)",@"Central African Republic(+236)",@"Chad(+235)",@"Chile(+56)",@"China(+86)",@"Christmas Island(+61)",@"Cocos (Keeling) Islands(+61)",@"Colombia(+57)",@"Comoros(+269)",@"Cook Islands(+682)",@"Costa Rica(+506)",@"Croatia(+385)",@"Cuba(+53)",@"Cyprus(+357)",@"Czech Republic(+420)",@"Democratic Republic of the Congo(+243)",@"Denmark(+45)",@"Djibouti(+253)",@"Dominica(+1767)",@"Dominican Republic(+1809)",@"Ecuador(+593)",@"Egypt(+20)",@"El Salvador(+503)",@"Equatorial Guinea(+240)",@"Eritrea(+291)",@"Estonia(+372)",@"Ethiopia(+251)",@"Falkland Islands(+500)",@"Faroe Islands(+298)",@"Fiji(+679)",@"Finland(+358)",@"France (+33)",@"French Polynesia(+689)",@"Gabon(+241)",@"Gambia(+220)",@"Gaza Strip(+970)",@"Georgia(+995)",@"Germany(+49)",@"Ghana(+233)",@"Gibraltar(+350)",@"Greece(+30)",@"Greenland(+299)",@"Grenada(+1473)",@"Guam(+1671)",@"Guatemala(+502)",@"Guinea(+224)",@"Guinea-Bissau(+245)",@"Guyana(+592)",@"Haiti(+509)",@"Holy See (Vatican City)(+39)",@"Honduras(+504)",@"Hong Kong(+852)",@"Hungary(+36)",@"Iceland(+354)",@"India(+91)",@"Indonesia(+62)",@"Iran(+98)",@"Iraq(+964)",@"Ireland(+353)",@"Isle of Man(+44)",@"Israel(+972)",@"Italy(+39)",@"Ivory Coast(+225)",@"Jamaica(+1876)",@"Japan(+81)",@"Jordan(+962)",@"Kazakhstan(+7)",@"Kenya(+254)",@"Kiribati(+686)",@"Kosovo(+381)",@"Kuwait(+965)",@"Kyrgyzstan(+996)",@"Laos(+856)",@"Latvia(+371)",@"Lebanon(+961)",@"Lesotho(+266)",@"Liberia(+231)",@"Libya(+218)",@"Liechtenstein(+423)",@"Lithuania(+370)",@"Luxembourg(+352)",@"Macau(+853)",@"Macedonia(+389)",@"Madagascar(+261)",@"Malawi(+265)",@"Malaysia(+60)",@"Maldives(+960)",@"Mali(+223)",@"Malta(+356)",@"MarshallIslands(+692)",@"Mauritania(+222)",@"Mauritius(+230)",@"Mayotte(+262)",@"Mexico(+52)",@"Micronesia(+691)",@"Moldova(+373)",@"Monaco(+377)",@"Mongolia(+976)",@"Montenegro(+382)",@"Montserrat(+1664)",@"Morocco(+212)",@"Mozambique(+258)",@"Namibia(+264)",@"Nauru(+674)",@"Nepal(+977)",@"Netherlands(+31)",@"Netherlands Antilles(+599)",@"New Caledonia(+687)",@"New Zealand(+64)",@"Nicaragua(+505)",@"Niger(+227)",@"Nigeria(+234)",@"Niue(+683)",@"Norfolk Island(+672)",@"North Korea (+850)",@"Northern Mariana Islands(+1670)",@"Norway(+47)",@"Oman(+968)",@"Pakistan(+92)",@"Palau(+680)",@"Panama(+507)",@"Papua New Guinea(+675)",@"Paraguay(+595)",@"Peru(+51)",@"Philippines(+63)",@"Pitcairn Islands(+870)",@"Poland(+48)",@"Portugal(+351)",@"Puerto Rico(+1)",@"Qatar(+974)",@"Republic of the Congo(+242)",@"Romania(+40)",@"Russia(+7)",@"Rwanda(+250)",@"Saint Barthelemy(+590)",@"Saint Helena(+290)",@"Saint Kitts and Nevis(+1869)",@"Saint Lucia(+1758)",@"Saint Martin(+1599)",@"Saint Pierre and Miquelon(+508)",@"Saint Vincent and the Grenadines(+1784)",@"Samoa(+685)",@"San Marino(+378)",@"Sao Tome and Principe(+239)",@"Saudi Arabia(+966)",@"Senegal(+221)",@"Serbia(+381)",@"Seychelles(+248)",@"Sierra Leone(+232)",@"Singapore(+65)",@"Slovakia(+421)",@"Slovenia(+386)",@"Solomon Islands(+677)",@"Somalia(+252)",@"South Africa(+27)",@"South Korea(+82)",@"Spain(+34)",@"Sri Lanka(+94)",@"Sudan(+249)",@"Suriname(+597)",@"Swaziland(+268)",@"Sweden(+46)",@"Switzerland(+41)",@"Syria(+963)",@"Taiwan(+886)",@"Tajikistan(+992)",@"Tanzania(+255)",@"Thailand(+66)",@"Timor-Leste(+670)",@"Togo(+228)",@"Tokelau(+690)",@"Tonga(+676)",@"Trinidad and Tobago(+1868)",@"Tunisia(+216)",@"Turkey(+90)",@"Turkmenistan(+993)",@"Turks and Caicos Islands(+1649)",@"Tuvalu(+688)",@"Uganda(+256)",@"Ukraine(+380)",@"United Arab Emirates(+971)",@"United Kingdom(+44)",@"United States(+1)",@"Uruguay(+598)",@"US Virgin Islands(+1340)",@"Uzbekistan(+998)",@"Vanuatu(+678)",@"Venezuela(+58)",@"Vietnam(+84)",@"Wallis and Futuna(+681)",@"West Bank(970)",@"Yemen(+967)",@"Zambia(+260)",@"Zimbabwe(+263)"];
    
    Countrycode_Array=@[@"+93",@"+355",@"+213",@"+1684",@"+376",@"+244",@"+1264",@"+672",@"+1268",@"+54",@"+374",@"+297",@"+61",@"+43",@"+994",@"+1242",@"+973",@"+880",@"+1246",@"+375",@"+32",@"+501",@"+229",@"+1441",@"+975",@"+591",@"+387",@"+267",@"+55",@"+1284",@"+673",@"+359",@"+226",@"+95",@"+257",@"+855",@"+237",@"+1",@"+238",@"+1345",@"+236",@"+235",@"+56",@"+86",@"+61",@"+61",@"+57",@"+269",@"+682",@"+506",@"+385",@"+53",@"+357",@"+420",@"+243",@"+45",@"+253",@"+1767",@"+1809",@"+593",@"+20",@"+503",@"+240",@"+291",@"+372",@"+251",@"+500",@"+298",@"+679",@"+358",@"+33",@"+689",@"+241",@"+220",@"+970",@"+995",@"+49",@"+233",@"+350",@"+30",@"+299",@"+1473",@"+1671",@"+502",@"+224",@"+245",@"+592",@"+509",@"+39",@"+504",@"+852",@"+36",@"+354",@"+91",@"+62",@"+98",@"+964",@"+353",@"+44",@"+972",@"+39",@"+225",@"+1876",@"+81",@"+962",@"+7",@"+254",@"+686",@"+381",@"+965",@"+996",@"+856",@"+371",@"+961",@"+266",@"+231",@"+218",@"+423",@"+370",@"+352",@"+853",@"+389",@"+261",@"+265",@"+60",@"+960",@"+223",@"+356",@"+692",@"+222",@"+230",@"+262",@"+52",@"+691",@"+373",@"+377",@"+976",@"+382",@"+1664",@"+212",@"+258",@"+264",@"+674",@"+977",@"+31",@"+599",@"+687",@"+64",@"+505",@"+227",@"+234",@"+683",@"+672",@"+850",@"+1670",@"+47",@"+968",@"+92",@"+680",@"+507",@"+675",@"+595",@"+51",@"+63",@"+870",@"+48",@"+351",@"+1",@"+974",@"+242",@"+40",@"+7",@"+250",@"+590",@"+290",@"+1869",@"+1758",@"+1599",@"+508",@"+1784",@"+685",@"+378",@"+239",@"+966",@"+221",@"+381",@"+248",@"+232",@"+65",@"+421",@"+386",@"+677",@"+252",@"+27",@"+82",@"+34",@"+94",@"+249",@"+597",@"+268",@"+46",@"+41",@"+963",@"+886",@"+992",@"+255",@"+66",@"+670",@"+228",@"+690",@"+676",@"+1868",@"+216",@"+90",@"+993",@"+1649",@"+688",@"+256",@"+380",@"+971",@"+44",@"+1",@"+598",@"+1340",@"+998",@"+678",@"+58",@"+84",@"+681",@"+970",@"+967",@"+260",@"+263"];

    
    Facebook.layer.shadowColor = [UIColor blackColor].CGColor;
    Facebook.layer.shadowOpacity = 0.5;
    Facebook.layer.shadowRadius = 2;
    Facebook.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    SignUP_Btn.layer.cornerRadius = 5;
    SignUP_Btn.layer.shadowColor = [UIColor blackColor].CGColor;
    SignUP_Btn.layer.shadowOpacity = 0.5;
    SignUP_Btn.layer.shadowRadius = 2;
    SignUP_Btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);

    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, _SignIn_hint_view.frame.origin.y+_SignIn_hint_view.frame.size.height+10);
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doSingleTap)] ;
    singleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:singleTap];
    
    nameField.text=NameFB;
    email_Field.text=EmailFB;
    Country_field.text=[Themes GetCountryCode];
    
    [self Padding:nameField :@"User" :@"Astrisk" :YES];
    [self Padding:email_Field :@"email" :@"Astrisk" :YES];
    [self Padding:Country_field :@"Countr" :@"" :NO];
    [self Padding:mobile_field :@"phone" :@"Astrisk" :YES];
    [self Padding:password_field :@"Password" :@"Astrisk" :YES];
    [self Padding:confirm_Field :@"Password" :@"Astrisk" :YES];
    [self Padding:referl_Field :@"Coupon" :@"" :NO];

}
-(void)Padding:(UITextField *)Field :(NSString *)Leftimagename :(NSString *)RightImage :(BOOL)isRightView{
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    imgView.image = [UIImage imageNamed:Leftimagename];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, Field.frame.size.height)];
    imgView.center=paddingView.center;
    [paddingView addSubview:imgView];
    [Field setLeftViewMode:UITextFieldViewModeAlways];
    [Field setLeftView:paddingView];
    
    if (isRightView) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 10, 10)];
        imgView.image = [UIImage imageNamed:RightImage];
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, Field.frame.size.height)];
        [paddingView addSubview:imgView];
        [Field setRightViewMode:UITextFieldViewModeAlways];
        [Field setRightView:paddingView];

    }
    Field.layer.borderColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    Field.layer.borderWidth=1.0f;
    Field.layer.cornerRadius=5.0f;
    Field.layer.masksToBounds=YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)applicationLanguageChangeNotification:(NSNotification*)notification{
    
    NSString * bycontinue=JJLocalizedString(@"By_Continuing_I_agree", nil) ;
    NSString * Agreement=JJLocalizedString(@"User_agreement_and_Terms_of_services", nil);
    [_terms setText:[NSString stringWithFormat:@"%@ %@'s %@",bycontinue,[Themes getAppName],Agreement]];
    [_title_lbl setText:JJLocalizedString(@"REGISTER", nil)];
    [nameField setPlaceholder:JJLocalizedString(@"NAME", nil)];
    [email_Field setPlaceholder:JJLocalizedString(@"EMAIL", nil)];
    [mobile_field setPlaceholder:JJLocalizedString(@"MOBILE_NUMBER", nil)];
    [password_field setPlaceholder:JJLocalizedString(@"PASSWORD", nil)];
    [confirm_Field setPlaceholder:JJLocalizedString(@"CONFIRM_PASSWORD_Large", nil)];
    [referl_Field setPlaceholder:JJLocalizedString(@"REFERRALCODE", nil)];
    [SignUP_Btn setTitle:JJLocalizedString(@"CREATE_ACCOUNT", nil) forState:UIControlStateNormal];
    [_already_lbl setText:JJLocalizedString(@"Already_a_member", nil)];
    [_sign_btn setTitle:JJLocalizedString(@"sign_in_here", nil) forState:UIControlStateNormal];

    if(_sign_btn.titleLabel.text.length>0){
        NSDictionary * linkAttributes = @{NSForegroundColorAttributeName:_sign_btn.titleLabel.textColor, NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_sign_btn.titleLabel.text attributes:linkAttributes];
        [_sign_btn.titleLabel setAttributedText:attributedString];
    }
}

- (IBAction)didClickback:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if (textField==nameField)
//    {
//        [textField resignFirstResponder];
//        [email_Field becomeFirstResponder];
//    }
    if (textField==email_Field)
    {
        if (![self validateEmail:email_Field.text])
        {
            [self showErrorMessage:@"Please_Enter_Valid_Email"];

            [textField becomeFirstResponder];
        }
        else
        {
        [textField resignFirstResponder];
        }
    }
    else if (textField==Country_field)
    {
    }

 else if (textField==mobile_field)    {
     
        [textField resignFirstResponder];
        [password_field becomeFirstResponder];
    }

 else if (textField==password_field)    {
     
     if ([textField.text length]<passwordMininumWidth)
     {
         [textField becomeFirstResponder];
       [self showErrorMessage:[NSString stringWithFormat:@"%@ %d %@",JJLocalizedString(@"password_mimimum_check", nil),passwordMininumWidth,JJLocalizedString(@"characters", nil)]];

     }
     else
     {
         [textField resignFirstResponder];
         [confirm_Field becomeFirstResponder];
         
     }
     
    }

 else if (textField==confirm_Field)    {
        [textField resignFirstResponder];
     
     if ([password_field.text isEqualToString:confirm_Field.text])
     {
         [referl_Field becomeFirstResponder];

     }
     else
     {
       
         [self showErrorMessage:@"Password_Mismatch"];

         [textField becomeFirstResponder];
     }
}

    else if (textField==referl_Field)
    {
        [textField resignFirstResponder];

    }
    

    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField==Country_field)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 4;
    }
    else if (textField==mobile_field)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        if (textField==self.mobile_field&&range.location==0) {
            if ([string hasPrefix:@"0"]) {
                return NO;
            }
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= MaximumDigit;
        
            }
    
    

    
    
           else if (textField==email_Field)
    {
    NSString *resultingString = [email_Field.text stringByReplacingCharactersInRange: range withString: string];
    NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
    if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound)
    {
        condition=@"";
        return YES;
    }  else  {
        return NO;
    }
    }
    return YES;

}



- (IBAction)CreatAccount:(id)sender {

    [self Register];
   
}
-(void)doSingleTap
{
    [self.view endEditing:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==Country_field) {
        [self.view endEditing:YES];
        [textField resignFirstResponder];
        CountryListViewController*objStoreDetailVC=[[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
        [self.navigationController pushViewController:objStoreDetailVC animated:YES];

    }
    if (textField==mobile_field) {
//        if () {
//            <#statements#>
//        }
    }
    
    return YES;
}

- (void)didSelectCountry:(NSDictionary *)country;
{
    if ([country count]>0) {
        [self.view endEditing:YES];
        [Country_field resignFirstResponder];
        [mobile_field becomeFirstResponder];
        Country_field.text=[country objectForKey:@"dial_code"];
    }
}

-(void)Register
{
        
    if ([self validateTextfield]) {
        NSDictionary * parameters=@{@"user_name":nameField.text,
                                    @"email":email_Field.text,
                                    @"password":password_field.text,
                                    @"country_code":Country_field.text,
                                    @"phone_number":mobile_field.text,
                                    @"referal_code":referl_Field.text,
                                    @"deviceToken":[Themes writableValue:[Themes GetDeviceToken]],
                                    @"gcm_id":@""};
        parameters=[Themes writableValue:parameters];
        
        UrlHandler *web = [UrlHandler UrlsharedHandler];
        [Themes StartView:self.view];
        [SignUP_Btn setUserInteractionEnabled:NO];
        [web RgstrAccount:parameters success:^(NSMutableDictionary *responseDictionary)
         {
             [Themes StopView:self.view];

             if ([responseDictionary count]>0)
             {
                 responseDictionary=[Themes writableValue:responseDictionary];
                 
                 NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                //
                 [Themes StopView:self.view];
                 
                 if ([comfiramtion isEqualToString:@"1"])
                 {
                      otpVC= [self.storyboard instantiateViewControllerWithIdentifier:@"OTPVCID"];

                     OTP_status=[responseDictionary valueForKey:@"otp_status"];
                     OTP_code=[responseDictionary valueForKey:@"otp"];
                     
                     otpVC.OTP_Status=OTP_status;
                     otpVC.OTP_Code=OTP_code;
                     if ([condition isEqualToString:@"Facebook"])
                     {
                         otpVC.Checkking=@"Facebook";

                     }
                     else
                     {
                         otpVC.Checkking=@"Register";

                     }

                     otpVC.email_id=email_Field.text;
                     otpVC.user_name=nameField.text;
                     otpVC.mobile_number=mobile_field.text;
                     otpVC.country_code=Country_field.text;
                     otpVC.password=password_field.text;
                     otpVC.confirm_password=confirm_Field.text;
                     otpVC.refrrelcode=referl_Field.text;
                     otpVC.Media_ID=IDFB;
                    [SignUP_Btn setUserInteractionEnabled:YES];
                    [self.navigationController pushViewController:otpVC animated:YES];
                     
                 }
                 
                 else
                 {
                     NSString * alert=[responseDictionary valueForKey:@"message"];
                     [self showErrorMessage:alert];
                     [SignUP_Btn setUserInteractionEnabled:YES];

                 }
             }
             
             [SignUP_Btn setUserInteractionEnabled:YES];

             
         }
                  failure:^(NSError *error)
         {
             [Themes StopView:self.view];
             [SignUP_Btn setUserInteractionEnabled:YES];

         }];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (mobile_field) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:JJLocalizedString(@"Done", nil)
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        mobile_field.inputAccessoryView = keyboardDoneButtonView;
    }
}
- (void)doneClicked:(id)sender
{
    [mobile_field resignFirstResponder];
    [password_field becomeFirstResponder];
}
-(BOOL)validateTextfield
{
//    if(nameField.text.length==0){
//        [self showErrorMessage:@"Name_is_mandatory"];
//        [nameField becomeFirstResponder];
//        [SignUP_Btn setUserInteractionEnabled:YES];
//        return NO;
    //}
     if(email_Field.text.length==0){
        [self showErrorMessage:@"Email_is_mandatory"];
        [email_Field becomeFirstResponder];
        [SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
  else if (![Themes NSStringIsValidEmail:email_Field.text])
    {
        [self showErrorMessage:@"Please_Enter_Valid_Email"];
        [email_Field becomeFirstResponder];
        [SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
    else if(Country_field.text.length==0){
        [self showErrorMessage:@"Country_Code_is_mandatory"];
        [SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
    else if(mobile_field.text.length==0){
        [self showErrorMessage:@"Mobile_Number_is_mandatory"];
        [mobile_field becomeFirstResponder];
        [SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
    else if(mobile_field.text.length<MinimumDigit){
        [self showErrorMessage:@"enter_valid_mobile"];
        [mobile_field becomeFirstResponder];
        [SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
    else if(password_field.text.length==0){
        [self showErrorMessage:@"Please_Enter_you_password"];
        [password_field becomeFirstResponder];
        [SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
    else if(password_field.text.length<passwordMininumWidth){
    [self showErrorMessage:[NSString stringWithFormat:@"%@ %d %@",JJLocalizedString(@"password_mimimum_check", nil),passwordMininumWidth,JJLocalizedString(@"characters", nil)]];
        [password_field becomeFirstResponder];
        [SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
    else if(confirm_Field.text.length==0){
        [self showErrorMessage:@"Reenter_you_password"];
        [confirm_Field becomeFirstResponder];
        [SignUP_Btn setUserInteractionEnabled:YES];
        return NO;
    }
    else if (![password_field.text isEqualToString:confirm_Field.text])
    {
        [self showErrorMessage:@"Password_Mismatch"];
        [SignUP_Btn setUserInteractionEnabled:YES];
        return NO;

    }

    return YES;
}
-(void)showErrorMessage:(NSString *)str{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:JJLocalizedString(@"Oops", nil) message:JJLocalizedString(str,nil)];
    [notice show];
}

- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


//-(void)callAlert
//{
//    UIAlertView *alertView = [[UIAlertView alloc]
//                              initWithTitle:@"ENTER YOUR OTP"
//                              message:@""
//                              delegate:self
//                              cancelButtonTitle:@"CANCEL"
//                              otherButtonTitles:@"APPLY", nil];
//    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    OTP_field=[alertView textFieldAtIndex:0];
//    OTP_field.textAlignment=NSTextAlignmentCenter;
//    [OTP_field setBorderStyle:UITextBorderStyleNone];
//    OTP_field.autocapitalizationType=YES;
//    [alertView show];
//
//}
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
- (IBAction)PushT0:(id)sender {
    LoginVC *objLoginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVCID"];
    [self.navigationController pushViewController:objLoginVC animated:YES];
    
}
- (IBAction)Check_facebook:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                    [Themes StopView:self.view];

                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                    condition=@"";
                                    [Themes StopView:self.view];

                                } else {
                                    NSLog(@"Logged in");
                                    [self facebook_login];
                                }
                            }];
    
    
    
    
}
-(void)facebook_login

{
    condition=@"Facebook";

    if ([FBSDKAccessToken currentAccessToken])
    {
        [Themes StartView:self.view];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture, email, name, id" }]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error) {
             if (!error) {
                 NSString * User_ID=[result objectForKey:@"id"];
                 NSString * name=[result objectForKey:@"name"];
                 NSString * email=[result objectForKey:@"email"];
                 
                 if(email == nil)
                 {
                     email=@"";
                 }
                 
                 NSDictionary * parameters=@{@"media_id":User_ID,
                                             @"deviceToken":[Themes writableValue:[Themes GetDeviceToken]],@"email":email};
                 
                 parameters=[Themes writableValue:parameters];
                 
                 UrlHandler *web = [UrlHandler UrlsharedHandler];
                 
                 [Themes StartView:self.view];
                 
                 [web Check_Social:parameters success:^(NSMutableDictionary *responseDictionary)
                  {
                      //NSLog(@"%@",responseDictionary);
                      [Themes StopView:self.view];
                      
                      if ([responseDictionary count]>0)
                      {
                          responseDictionary=[Themes writableValue:responseDictionary];
                          
                          NSString * comfiramtion=[responseDictionary valueForKey:@"status"];
                          [Themes StopView:self.view];
                          
                          if ([comfiramtion isEqualToString:@"1"])                                                      //ALREADY
                          {
                            loginrecord=[[LoginRecord alloc]init];
                               loginrecord.CategoryStr=[responseDictionary valueForKey:@"category"];
                               loginrecord.UserID=[responseDictionary valueForKey:@"user_id"];
                               loginrecord.UserImage=[responseDictionary valueForKey:@"user_image"];
                               loginrecord.UserEmail=[Themes checkNullValue:[responseDictionary valueForKey:@"email"]];
                               loginrecord.UserName=[responseDictionary valueForKey:@"user_name"];
                               loginrecord.MobileNumber=[responseDictionary valueForKey:@"phone_number"];
                               loginrecord.AmountWallet=[responseDictionary valueForKey:@"wallet_amount"];
                               loginrecord.currency=[responseDictionary valueForKey:@"currency"];
                               loginrecord.countryCode=[responseDictionary valueForKey:@"country_code"];
                               
                               [Themes saveUserID:loginrecord.UserID];
                               [Themes SaveuserDP:loginrecord.UserImage];
                               [Themes SaveCategoryString:loginrecord.CategoryStr];
                               [Themes SaveuserEmail:loginrecord.UserEmail];
                               [Themes saveUserName:loginrecord.UserName];
                               [Themes SaveMobileNumber:loginrecord.MobileNumber];
                               [Themes SaveWallet:loginrecord.AmountWallet];
                               [Themes SaveCurrency:loginrecord.currency];
                               [Themes SaveCountryCode:loginrecord.countryCode];
                               
                               [Themes StopView:self.view];
                              AppDelegate*appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                              [appdelegate connectToXmpp];
                                 [appdelegate GetAppInfo];
                              [appdelegate setInitialViewController];

                               
                              
                          }
                          else if ([comfiramtion isEqualToString:@"0"])                                          //BLOCK
                              
                          {
                              NSString * alert=[responseDictionary valueForKey:@"message"];
                              
                              NSString *titleStr = JJLocalizedString(@"Oops", nil);
                              UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                              [Alert show];
                          }
                          else                                                                                           //SIGNUP
                          {
                              NSString * alert=[responseDictionary valueForKey:@"message"];
                              
                              NSString *titleStr = JJLocalizedString(@"Oops", nil);
                              UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",titleStr] message:alert delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                              [Alert show];
                              
                              nameField.text=name;
                              email_Field.text=email;
                              IDFB=User_ID;
                              [Facebook setHidden:YES];
                              
                          }
                      }
                      
                      
                  }
                  
                           failure:^(NSError *error) {
                               [Themes StopView:self.view];
                               
                               
                               
                           }];
                 
             }
         }];
        
        [Themes StopView:self.view];
        
    }
    
}
@end
