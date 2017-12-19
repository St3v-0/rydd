//
//  Themes.m
//  Dectar
//
//  Created by Suresh J on 08/07/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "Themes.h"
#import "Constant.h"
#import <AVFoundation/AVAudioPlayer.h>

static DGActivityIndicatorView *activityIndicatorView=nil;
static SMBInternetConnectionIndicator * banner=nil;

@implementation Themes

+(id)writableValue:(id)value
{
  
    if ([value isKindOfClass:[NSNull class]] || value==nil)
    {
        value = @"";
    }
  
    
    return value;
}
+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
+(id)checkNullValue:(id)value
{
    
    
    if ([value isKindOfClass:[NSNull class]] || value==nil)
    {
        value = @"";
    }
    NSString * str =[NSString stringWithFormat:@"%@",value];
    if ([str isEqualToString:@"(null)"]) {
        str=@"";
    }
    
    return str;
}
+(NSString *)convertHTMLToText:(NSString *)html {
    html=[self checkNullValue:html];
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    html =[html stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return html;
}


+(void)saveUserID:(NSString*)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getUserID
{
   return  [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
}
+(void)saveMobileID:(NSString*)mobileId
{
    [[NSUserDefaults standardUserDefaults] setObject:mobileId forKey:@"mobileId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)GetMobileId
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileId"];
}

+(void)SaveCouponDetails:(NSString*)CouponDetails
{
    [[NSUserDefaults standardUserDefaults] setObject:CouponDetails forKey:@"CouponDetails"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)GetCouponDetails
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"CouponDetails"];
}
+(void)SaveUserImage:(NSString*)userImgStr
{
    [[NSUserDefaults standardUserDefaults] setObject:userImgStr forKey:@"saveUserImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)fatechUserImage
{
    NSString * userImg=[Themes checkNullValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"saveUserImage"]];
    return userImg;
}
+(void)UserImageSave:(NSString*)userImg
{
    [[NSUserDefaults standardUserDefaults] setObject:userImg forKey:@"driverImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)FetchUserImage
{
    NSString * userImg=[Themes checkNullValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"driverImage"]];
    return userImg;
}

+(void)SaveCountryCode:(NSString*)CountryCode
{
    [[NSUserDefaults standardUserDefaults] setObject:CountryCode forKey:@"CountryCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)GetCountryCode
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"CountryCode"];

}
+(void)SaveMobileNumber:(NSString*)mobileNumber
{
    [[NSUserDefaults standardUserDefaults] setObject:mobileNumber forKey:@"mobilenumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getmobileNumber
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"mobilenumber"];
}


+(void)saveUserName:(NSString*)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"Username"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSString*)getUserName
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];

}


+(void)SaveuserDP:(NSString*)Displaypicture
{
    [[NSUserDefaults standardUserDefaults] setObject:Displaypicture forKey:@"UserDP"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSString*)getUserDp
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDP"];
}


+(void)SaveCategoryString:(NSString*)CategoryString
{
    [[NSUserDefaults standardUserDefaults] setObject:CategoryString forKey:@"categorystring"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getCategoryString
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"categorystring"];
}



+(void)SaveuserEmail:(NSString*)userMail
{
    [[NSUserDefaults standardUserDefaults] setObject:userMail forKey:@"useremail"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSString*)getuserMail
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"useremail"];
}


+(void)SaveCoupon:(NSString*)Pickup
{
    [[NSUserDefaults standardUserDefaults] setObject:Pickup forKey:@"coupon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)GetCoupon
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"coupon"];

}


+(void)SaveDeviceToken:(NSString*)Pickup
{
    [[NSUserDefaults standardUserDefaults] setObject:Pickup forKey:@"devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)GetDeviceToken
{
    NSString *savedValue =[[NSUserDefaults standardUserDefaults]stringForKey:@"devicetoken"];
    if(savedValue==nil||[savedValue isEqualToString:@""]){
        savedValue=@"32131243124234235235245245245245";
    }
    return savedValue;

}
+(void)StartView:(UIView*)view
{
    NSArray *activityTypes = @[@(DGActivityIndicatorAnimationTypeDoubleBounce)];
    NSArray *sizes = @[@(100.0)];
    for (int i = 0; i < activityTypes.count; i++) {
        activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[activityTypes[i] integerValue] tintColor:BGCOLOR size:[sizes[i] floatValue]];
        
      //  CGFloat width = view.bounds.size.width / 4.0f;
       // CGFloat height = self.view.bounds.size.height / 4.0f;
       // activityIndicatorView.frame = CGRectMake(view.center.x, view.center.y, 100, 100);//CGRectMake(width * (i % 10), height * (int)(i / 40), width, height);
        activityIndicatorView.center = CGPointMake(view.center.x-20,view.center.y);
        
        //activityIndicatorView.center=view.center;

        [view addSubview:activityIndicatorView];
        
        [activityIndicatorView startAnimating];
        view.userInteractionEnabled=NO;
        
    }
}
+(void)StopView:(UIView*)view
{
    [activityIndicatorView stopAnimating];
    view.userInteractionEnabled=YES;

}

+(void)SaveWallet:(NSString*)Amount
{
    [[NSUserDefaults standardUserDefaults] setObject:Amount forKey:@"walletamount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)GetWallet
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"walletamount"];
    
}

+(void)SaveCurrency:(NSString*)Currency
{
    [[NSUserDefaults standardUserDefaults] setObject:Currency forKey:@"currency"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)GetCurrency
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"currency"];
    
}
+(void)SaveFullWallet:(NSString*)FullWallet
{
    [[NSUserDefaults standardUserDefaults] setObject:FullWallet forKey:@"FullWallet"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)GetFullWallet
{
    
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"FullWallet"];
    
}

+ (NSString *)findCurrencySymbolByCode:(NSString *)_currencyCode
{
    _currencyCode=[Themes checkNullValue:_currencyCode];
    NSNumberFormatter *fmtr = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [self findLocaleByCurrencyCode:_currencyCode];
    NSString *currencySymbol;
    if (locale)
        [fmtr setLocale:locale];
    [fmtr setNumberStyle:NSNumberFormatterCurrencyStyle];
    currencySymbol = [fmtr currencySymbol];
    
    if (currencySymbol.length > 1)
        currencySymbol = [currencySymbol substringToIndex:1];
    return currencySymbol;
}
+(NSLocale *) findLocaleByCurrencyCode:(NSString *)_currencyCode
{
    NSArray *locales = [NSLocale availableLocaleIdentifiers];
    NSLocale *locale = nil;
    
    for (NSString *localeId in locales) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeId];
        NSString *code = [locale objectForKey:NSLocaleCurrencyCode];
        if ([code isEqualToString:_currencyCode])
            break;
        else
            locale = nil;
    }
    return locale;
}
+(void)banner:(UIView*)view
{
    CGRect screenRect= CGRectMake(0, 0, view.bounds.size.width, 64);
    banner = [[SMBInternetConnectionIndicator alloc] initWithFrame:screenRect];
    [banner setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin)];
    [view addSubview:banner];
    [view bringSubviewToFront:banner];

}
+(void)statusbarColor:(UIView*)view
{
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 22)];
    statusBarView.backgroundColor  =  STATUSCOLOR;
    [view addSubview:statusBarView];
}
/// xmpp
+(void)saveXmppUserCredentials:(NSString *)str{
    
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"xmppusercredentialsdectar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSString*)getXmppUserCredentials
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"xmppusercredentialsdectar"];
}
+(NSDictionary *)getCountryList{
 NSDictionary * dict =   [NSDictionary dictionaryWithObjectsAndKeys:
     @[@"Afghanistan",@"93"],@"AF",
     @[@"Aland Islands",@"358"],@"AX",
     @[@"Albania",@"355"],@"AL",
     @[@"Algeria",@"213"],@"DZ",
     @[@"American Samoa",@"1"],@"AS",
     @[@"Andorra",@"376"],@"AD",
     @[@"Angola",@"244"],@"AO",
     @[@"Anguilla",@"1"],@"AI",
     @[@"Antarctica",@"672"],@"AQ",
     @[@"Antigua and Barbuda",@"1"],@"AG",
     @[@"Argentina",@"54"],@"AR",
     @[@"Armenia",@"374"],@"AM",
     @[@"Aruba",@"297"],@"AW",
     @[@"Australia",@"61"],@"AU",
     @[@"Austria",@"43"],@"AT",
     @[@"Azerbaijan",@"994"],@"AZ",
     @[@"Bahamas",@"1"],@"BS",
     @[@"Bahrain",@"973"],@"BH",
     @[@"Bangladesh",@"880"],@"BD",
     @[@"Barbados",@"1"],@"BB",
     @[@"Belarus",@"375"],@"BY",
     @[@"Belgium",@"32"],@"BE",
     @[@"Belize",@"501"],@"BZ",
     @[@"Benin",@"229"],@"BJ",
     @[@"Bermuda",@"1"],@"BM",
     @[@"Bhutan",@"975"],@"BT",
     @[@"Bolivia",@"591"],@"BO",
     @[@"Bosnia and Herzegovina",@"387"],@"BA",
     @[@"Botswana",@"267"],@"BW",
     @[@"Bouvet Island",@"47"],@"BV",
     @[@"BQ",@"599"],@"BQ",
     @[@"Brazil",@"55"],@"BR",
     @[@"British Indian Ocean Territory",@"246"],@"IO",
     @[@"British Virgin Islands",@"1"],@"VG",
     @[@"Brunei Darussalam",@"673"],@"BN",
     @[@"Bulgaria",@"359"],@"BG",
     @[@"Burkina Faso",@"226"],@"BF",
     @[@"Burundi",@"257"],@"BI",
     @[@"Cambodia",@"855"],@"KH",
     @[@"Cameroon",@"237"],@"CM",
     @[@"Canada",@"1"],@"CA",
     @[@"Cape Verde",@"238"],@"CV",
     @[@"Cayman Islands",@"345"],@"KY",
     @[@"Central African Republic",@"236"],@"CF",
     @[@"Chad",@"235"],@"TD",
     @[@"Chile",@"56"],@"CL",
     @[@"China",@"86"],@"CN",
     @[@"Christmas Island",@"61"],@"CX",
     @[@"Cocos (Keeling) Islands",@"61"],@"CC",
     @[@"Colombia",@"57"],@"CO",
     @[@"Comoros",@"269"],@"KM",
     @[@"Congo (Brazzaville)",@"242"],@"CG",
     @[@"Congo, Democratic Republic of the",@"243"],@"CD",
     @[@"Cook Islands",@"682"],@"CK",
     @[@"Costa Rica",@"506"],@"CR",
     @[@"Côte d'Ivoire",@"225"],@"CI",
     @[@"Croatia",@"385"],@"HR",
     @[@"Cuba",@"53"],@"CU",
     @[@"Curacao",@"599"],@"CW",
     @[@"Cyprus",@"537"],@"CY",
     @[@"Czech Republic",@"420"],@"CZ",
     @[@"Denmark",@"45"],@"DK",
     @[@"Djibouti",@"253"],@"DJ",
     @[@"Dominica",@"1"],@"DM",
     @[@"Dominican Republic",@"1"],@"DO",
     @[@"Ecuador",@"593"],@"EC",
     @[@"Egypt",@"20"],@"EG",
     @[@"El Salvador",@"503"],@"SV",
     @[@"Equatorial Guinea",@"240"],@"GQ",
     @[@"Eritrea",@"291"],@"ER",
     @[@"Estonia",@"372"],@"EE",
     @[@"Ethiopia",@"251"],@"ET",
     @[@"Falkland Islands (Malvinas)",@"500"],@"FK",
     @[@"Faroe Islands",@"298"],@"FO",
     @[@"Fiji",@"679"],@"FJ",
     @[@"Finland",@"358"],@"FI",
     @[@"France",@"33"],@"FR",
     @[@"French Guiana",@"594"],@"GF",
     @[@"French Polynesia",@"689"],@"PF",
     @[@"French Southern Territories",@"689"],@"TF",
     @[@"Gabon",@"241"],@"GA",
     @[@"Gambia",@"220"],@"GM",
     @[@"Georgia",@"995"],@"GE",
     @[@"Germany",@"49"],@"DE",
     @[@"Ghana",@"233"],@"GH",
     @[@"Gibraltar",@"350"],@"GI",
     @[@"Greece",@"30"],@"GR",
     @[@"Greenland",@"299"],@"GL",
     @[@"Grenada",@"1"],@"GD",
     @[@"Guadeloupe",@"590"],@"GP",
     @[@"Guam",@"1"],@"GU",
     @[@"Guatemala",@"502"],@"GT",
     @[@"Guernsey",@"44"],@"GG",
     @[@"Guinea",@"224"],@"GN",
     @[@"Guinea-Bissau",@"245"],@"GW",
     @[@"Guyana",@"595"],@"GY",
     @[@"Haiti",@"509"],@"HT",
     @[@"Holy See (Vatican City State)",@"379"],@"VA",
     @[@"Honduras",@"504"],@"HN",
     @[@"Hong Kong, Special Administrative Region of China",@"852"],@"HK",
     @[@"Hungary",@"36"],@"HU",
     @[@"Iceland",@"354"],@"IS",
     @[@"India",@"91"],@"IN",
     @[@"Indonesia",@"62"],@"ID",
     @[@"Iran, Islamic Republic of",@"98"],@"IR",
     @[@"Iraq",@"964"],@"IQ",
     @[@"Ireland",@"353"],@"IE",
     @[@"Isle of Man",@"44"],@"IM",
     @[@"Israel",@"972"],@"IL",
     @[@"Italy",@"39"],@"IT",
     @[@"Jamaica",@"1"],@"JM",
     @[@"Japan",@"81"],@"JP",
     @[@"Jersey",@"44"],@"JE",
     @[@"Jordan",@"962"],@"JO",
     @[@"Kazakhstan",@"77"],@"KZ",
     @[@"Kenya",@"254"],@"KE",
     @[@"Kiribati",@"686"],@"KI",
     @[@"Korea, Democratic People's Republic of",@"850"],@"KP",
     @[@"Korea, Republic of",@"82"],@"KR",
     @[@"Kuwait",@"965"],@"KW",
     @[@"Kyrgyzstan",@"996"],@"KG",
     @[@"Lao PDR",@"856"],@"LA",
     @[@"Latvia",@"371"],@"LV",
     @[@"Lebanon",@"961"],@"LB",
     @[@"Lesotho",@"266"],@"LS",
     @[@"Liberia",@"231"],@"LR",
     @[@"Libya",@"218"],@"LY",
     @[@"Liechtenstein",@"423"],@"LI",
     @[@"Lithuania",@"370"],@"LT",
     @[@"Luxembourg",@"352"],@"LU",
     @[@"Macao, Special Administrative Region of China",@"853"],@"MO",
     @[@"Macedonia, Republic of",@"389"],@"MK",
     @[@"Madagascar",@"261"],@"MG",
     @[@"Malawi",@"265"],@"MW",
     @[@"Malaysia",@"60"],@"MY",
     @[@"Maldives",@"960"],@"MV",
     @[@"Mali",@"223"],@"ML",
     @[@"Malta",@"356"],@"MT",
     @[@"Marshall Islands",@"692"],@"MH",
     @[@"Martinique",@"596"],@"MQ",
     @[@"Mauritania",@"222"],@"MR",
     @[@"Mauritius",@"230"],@"MU",
     @[@"Mayotte",@"262"],@"YT",
     @[@"Mexico",@"52"],@"MX",
     @[@"Micronesia, Federated States of",@"691"],@"FM",
     @[@"Moldova",@"373"],@"MD",
     @[@"Monaco",@"377"],@"MC",
     @[@"Mongolia",@"976"],@"MN",
     @[@"Montenegro",@"382"],@"ME",
     @[@"Montserrat",@"1"],@"MS",
     @[@"Morocco",@"212"],@"MA",
     @[@"Mozambique",@"258"],@"MZ",
     @[@"Myanmar",@"95"],@"MM",
     @[@"Namibia",@"264"],@"NA",
     @[@"Nauru",@"674"],@"NR",
     @[@"Nepal",@"977"],@"NP",
     @[@"Netherlands",@"31"],@"NL",
     @[@"Netherlands Antilles",@"599"],@"AN",
     @[@"New Caledonia",@"687"],@"NC",
     @[@"New Zealand",@"64"],@"NZ",
     @[@"Nicaragua",@"505"],@"NI",
     @[@"Niger",@"227"],@"NE",
     @[@"Nigeria",@"234"],@"NG",
     @[@"Niue",@"683"],@"NU",
     @[@"Norfolk Island",@"672"],@"NF",
     @[@"Northern Mariana Islands",@"1"],@"MP",
     @[@"Norway",@"47"],@"NO",
     @[@"Oman",@"968"],@"OM",
     @[@"Pakistan",@"92"],@"PK",
     @[@"Palau",@"680"],@"PW",
     @[@"Palestinian Territory, Occupied",@"970"],@"PS",
     @[@"Panama",@"507"],@"PA",
     @[@"Papua New Guinea",@"675"],@"PG",
     @[@"Paraguay",@"595"],@"PY",
     @[@"Peru",@"51"],@"PE",
     @[@"Philippines",@"63"],@"PH",
     @[@"Pitcairn",@"872"],@"PN",
     @[@"Poland",@"48"],@"PL",
     @[@"Portugal",@"351"],@"PT",
     @[@"Puerto Rico",@"1"],@"PR",
     @[@"Qatar",@"974"],@"QA",
     @[@"Réunion",@"262"],@"RE",
     @[@"Romania",@"40"],@"RO",
     @[@"Russian Federation",@"7"],@"RU",
     @[@"Rwanda",@"250"],@"RW",
     @[@"Saint Helena",@"290"],@"SH",
     @[@"Saint Kitts and Nevis",@"1"],@"KN",
     @[@"Saint Lucia",@"1"],@"LC",
     @[@"Saint Pierre and Miquelon",@"508"],@"PM",
     @[@"Saint Vincent and Grenadines",@"1"],@"VC",
     @[@"Saint-Barthélemy",@"590"],@"BL",
     @[@"Saint-Martin (French part)",@"590"],@"MF",
     @[@"Samoa",@"685"],@"WS",
     @[@"San Marino",@"378"],@"SM",
     @[@"Sao Tome and Principe",@"239"],@"ST",
     @[@"Saudi Arabia",@"966"],@"SA",
     @[@"Senegal",@"221"],@"SN",
     @[@"Serbia",@"381"],@"RS",
     @[@"Seychelles",@"248"],@"SC",
     @[@"Sierra Leone",@"232"],@"SL",
     @[@"Singapore",@"65"],@"SG",
     @[@"Sint Maarten",@"1"],@"SX",
     @[@"Slovakia",@"421"],@"SK",
     @[@"Slovenia",@"386"],@"SI",
     @[@"Solomon Islands",@"677"],@"SB",
     @[@"Somalia",@"252"],@"SO",
     @[@"South Africa",@"27"],@"ZA",
     @[@"South Georgia and the South Sandwich Islands",@"500"],@"GS",
     @[@"South Sudan",@"211"],@"SS​",
     @[@"Spain",@"34"],@"ES",
     @[@"Sri Lanka",@"94"],@"LK",
     @[@"Sudan",@"249"],@"SD",
     @[@"Suriname",@"597"],@"SR",
     @[@"Svalbard and Jan Mayen Islands",@"47"],@"SJ",
     @[@"Swaziland",@"268"],@"SZ",
     @[@"Sweden",@"46"],@"SE",
     @[@"Switzerland",@"41"],@"CH",
     @[@"Syrian Arab Republic (Syria)",@"963"],@"SY",
     @[@"Taiwan, Republic of China",@"886"],@"TW",
     @[@"Tajikistan",@"992"],@"TJ",
     @[@"Tanzania, United Republic of",@"255"],@"TZ",
     @[@"Thailand",@"66"],@"TH",
     @[@"Timor-Leste",@"670"],@"TL",
     @[@"Togo",@"228"],@"TG",
     @[@"Tokelau",@"690"],@"TK",
     @[@"Tonga",@"676"],@"TO",
     @[@"Trinidad and Tobago",@"1"],@"TT",
     @[@"Tunisia",@"216"],@"TN",
     @[@"Turkey",@"90"],@"TR",
     @[@"Turkmenistan",@"993"],@"TM",
     @[@"Turks and Caicos Islands",@"1"],@"TC",
     @[@"Tuvalu",@"688"],@"TV",
     @[@"Uganda",@"256"],@"UG",
     @[@"Ukraine",@"380"],@"UA",
     @[@"United Arab Emirates",@"971"],@"AE",
     @[@"United Kingdom",@"44"],@"GB",
     @[@"United States of America",@"1"],@"US",
     @[@"Uruguay",@"598"],@"UY",
     @[@"Uzbekistan",@"998"],@"UZ",
     @[@"Vanuatu",@"678"],@"VU",
     @[@"Venezuela (Bolivarian Republic of)",@"58"],@"VE",
     @[@"Viet Nam",@"84"],@"VN",
     @[@"Virgin Islands, US",@"1"],@"VI",
     @[@"Wallis and Futuna Islands",@"681"],@"WF",
     @[@"Western Sahara",@"212"],@"EH",
     @[@"Yemen",@"967"],@"YE",
     @[@"Zambia",@"260"],@"ZM",
     @[@"Zimbabwe",@"263"],@"ZW", nil];
    return dict;
}
+(NSString *)getAppName{
    NSString * appnameStr=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    return appnameStr;
}
+(void)ClearUserInfo
{
    [Themes saveUserID:nil];
    [Themes SaveCoupon:nil];
    [Themes SaveMobileNumber:nil];
    [Themes SaveuserDP:nil];
    [Themes SaveuserEmail:nil];
    [Themes saveUserName:nil];
    [Themes SaveWallet:nil];
    [Themes SaveCategoryString:nil];
    [Themes SaveFullWallet:nil];
    [Themes SaveCurrency:nil];
    [Themes SaveCouponDetails:nil];
    
}
+(void)saveLanguage:(NSString *)str{
    if([str isEqualToString:@"es"]){
        str=@"es";
    }else if ([str isEqualToString:@"ta"]){
        str=@"ta";
    }else{
        str=@"en";
    }
    NSString *valueToSave = str;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"LanguageNameVoiceem"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSString*)getCurrentLanguage
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"LanguageNameVoiceem"];
}

+(NSString*)ChangeToLanguage{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"LanguageNameVoiceem"];
    if([savedValue isEqualToString:@"es"]){
        return EnglishUSLanguageShortName;
    }else{
        return SpanishLanguageShortName;
    }
}

+(void)SetLanguageToApp{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"LanguageNameVoiceem"];
    if([savedValue isEqualToString:@"es"]){
        setApplicationLanguage(SpanishLanguageShortName);
    }else  if([savedValue isEqualToString:@"ta"]){
        setApplicationLanguage(TamilLanguageShortName);
    }else{
        setApplicationLanguage(EnglishUSLanguageShortName);
    }
    
    
}
+(void)saveAppDetails:(AppInfoRecords*)appInforec{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:[self recordsToAppDict:appInforec]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAppInfo];
}

+(NSDictionary *)recordsToAppDict:(AppInfoRecords *)appInforec{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setObject:appInforec.serviceContactEmail forKey:@"site_contact_mail"];
    [dict setObject:appInforec.serviceNumber forKey:@"customer_service_number"];
    [dict setObject:appInforec.serviceSiteUrl forKey:@"site_url"];
    [dict setObject:appInforec.serviceXmppHost forKey:@"xmpp_host_url"];
    [dict setObject:appInforec.serviceXmppPort forKey:@"xmpp_host_name"];
    [dict setObject:appInforec.serviceFacebookAppId forKey:@"facebook_id"];
    [dict setObject:appInforec.serviceGooglePlusId forKey:@"google_plus_app_id"];
    [dict setObject:appInforec.servicePhoneMaskingStatus forKey:@"phone_masking_status"];
    [dict setObject:appInforec.hasPendingRide forKey:@"ongoing_ride"];
    [dict setObject:appInforec.pendingRideID forKey:@"ongoing_ride_id"];
    [dict setObject:appInforec.hasPendingRating forKey:@"rating_pending"];
    [dict setObject:appInforec.pendingRateId forKey:@"rating_pending_ride_id"];
     [dict setObject:appInforec.appUserAgentName forKey:@"app_identity_name"];
      [dict setObject:appInforec.aboutusTxt forKey:@"about_content"];
    [dict setObject:appInforec.ryddwalletRecharge forKey:@"rydd_wallet_recharge"];
    [dict setObject:appInforec.userEmergencyPage forKey:@"user_emergency_page"];
    [dict setObject:appInforec.operatingsHours forKey:@"operating_hours"];
    
    return dict;
}

+(NSDictionary *)retrieveAppData{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kAppInfo];
    NSDictionary* myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return myDictionary;
}
+(void)ClearAppDetails{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAppInfo];
}
+(NSDictionary *)AppAllInfoDatas{
  
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kAppInfo];
        NSDictionary* myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return myDictionary;
}
+(BOOL)hasAppDetails{
    if ([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys containsObject:kAppInfo]){
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kAppInfo];
        NSDictionary* myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(myDictionary!=nil){
            return YES;
        }
    }
    return NO;
}
+(NSString *)getAppVersionAndBundle{
    NSString * appVersionString =[self checkNullValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] ;
    NSString * appBuildString = [self checkNullValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    NSString * versionBuildString = [NSString stringWithFormat:@"v%@(%@)", appVersionString, appBuildString];
    return versionBuildString;
}
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
+(NSString *)getRandomNumberString:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    
    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    
    return returnString;
}

//dhiravida
- (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}
//dhiravida
+(NSArray *)GetMonthList
{
    NSArray  *MonthArray=@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    return MonthArray;
}

+(void)SaveCarCatimage:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:KCarCatImage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)GetCarCatimage{
    NSString *savedValue =[[NSUserDefaults standardUserDefaults]stringForKey:KCarCatImage];
    return savedValue;
    
}

@end
