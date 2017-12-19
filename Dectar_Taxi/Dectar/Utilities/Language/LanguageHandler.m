//
//  LanguageHandler.m
//  VoiceEM
//
//  Created by Casperon Technologies on 6/25/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import "LanguageHandler.h"

#pragma mark - Notification
NSString *const ApplicationLanguageDidChangeNotification = @"JapaharJoseApplicationLanguageDidChangeNotification";

#pragma mark - Constants
NSString *const EnglishGBLanguageShortName  =   @"en-GB";
NSString *const EnglishUSLanguageShortName  =   @"en";
NSString *const FrenchLanguageShortName     =   @"fr";
NSString *const SpanishLanguageShortName    =   @"es";
NSString *const ItalianLanguageShortName    =   @"it";
NSString *const JapaneseLanguageShortName   =   @"ja";
NSString *const KoreanLanguageShortName     =   @"ko";
NSString *const ChineseLanguageShortName    =   @"zh";
NSString *const TurkishLanguageShortName    =   @"tr";
NSString *const PolishLanguageShortName     =   @"pl";
NSString *const TamilLanguageShortName     =   @"ta";


NSString *const EnglishGBLanguageLongName  =   @"English(UK)";
NSString *const EnglishUSLanguageLongName  =   @"English(US)";
NSString *const FrenchLanguageLongName     =   @"French";
NSString *const SpanishLanguageLongName    =   @"Spanish";
NSString *const ItalianLanguageLongName    =   @"Italian";
NSString *const JapaneseLanguageLongName   =   @"Japenese";
NSString *const KoreanLanguageLongName     =   @"한국어";
NSString *const ChineseLanguageLongName    =   @"中国的";
NSString *const TurkishLanguageLongName    =   @"Turkish";
NSString *const PolishLanguageLongName     =   @"Polish";
NSString *const TamilLanguageLongName     =   @"Tamil";

static NSArray *_languagesLong;

#pragma mark - Bundle
NSBundle *_localizedBundle = nil;

NSBundle *localizedBundle()
{
    if (_localizedBundle == nil)
    {
        _localizedBundle = [NSBundle bundleWithPath:([[NSBundle mainBundle] pathForResource:applicationLanguage() ofType:@"lproj"])];
    }
    
    return _localizedBundle;
}

#pragma mark - Language
void setApplicationLanguage(NSString* language)
{
    NSString *oldLanguage = applicationLanguage();
    
    if ([oldLanguage isEqualToString:language] == NO)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@[language] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _localizedBundle = [NSBundle bundleWithPath:([[NSBundle mainBundle] pathForResource:applicationLanguage() ofType:@"lproj"])];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationLanguageDidChangeNotification object:nil userInfo:nil];
    }
}

NSString *applicationLanguage(void)
{
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    return [languages firstObject];
}

NSArray *applicationLanguagesLong(void)
{
    if (_languagesLong == nil)
    {
        _languagesLong = @[ChineseLanguageLongName,EnglishGBLanguageLongName,EnglishUSLanguageLongName,FrenchLanguageLongName,KoreanLanguageLongName,ItalianLanguageLongName,SpanishLanguageLongName,TurkishLanguageLongName,PolishLanguageLongName,TamilLanguageLongName];
    }
    
    return _languagesLong;
}

#pragma mark - LocalizedString

NSString *JJLocalizedString(NSString *key, NSString *comment)
{
    return [localizedBundle() localizedStringForKey:(key) value:@"" table:nil];
}


NSString *applicationLanguageLong(void)
{
    NSString *language = applicationLanguage();
    
    return shortLanguageToLong(language);
}


NSString *shortLanguageToLong(NSString *shortLanguage)
{
    if ([shortLanguage isEqualToString:EnglishGBLanguageShortName])
    {
        return EnglishGBLanguageLongName;
    }
    else if ([shortLanguage isEqualToString:EnglishUSLanguageShortName])
    {
        return EnglishUSLanguageLongName;
    }
    else if ([shortLanguage isEqualToString:TamilLanguageShortName])
    {
        return TamilLanguageLongName;
    }
    else if ([shortLanguage isEqualToString:ChineseLanguageShortName])
    {
        return ChineseLanguageLongName;
    }
    else if ([shortLanguage isEqualToString:FrenchLanguageShortName])
    {
        return FrenchLanguageLongName;
    }
    else if ([shortLanguage isEqualToString:KoreanLanguageShortName])
    {
        return KoreanLanguageLongName;
    }
    else if ([shortLanguage isEqualToString:ItalianLanguageShortName])
    {
        return ItalianLanguageLongName;
    }
    else if ([shortLanguage isEqualToString:SpanishLanguageShortName])
    {
        return SpanishLanguageLongName;
    }
    else if ([shortLanguage isEqualToString:PolishLanguageShortName])
    {
        return PolishLanguageLongName;
    }
    else
    {
        return nil;
    }
}
