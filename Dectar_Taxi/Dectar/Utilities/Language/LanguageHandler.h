//
//  LanguageHandler.h
//  VoiceEM
//
//  Created by Casperon Technologies on 6/25/15.
//  Copyright (c) 2015 Casperon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Notification
FOUNDATION_EXPORT NSString *const ApplicationLanguageDidChangeNotification;

#pragma mark - Constants
FOUNDATION_EXPORT NSString *const EnglishGBLanguageShortName;
FOUNDATION_EXPORT NSString *const EnglishUSLanguageShortName;
FOUNDATION_EXPORT NSString *const FrenchLanguageShortName;
FOUNDATION_EXPORT NSString *const SpanishLanguageShortName;
FOUNDATION_EXPORT NSString *const ItalianLanguageShortName;
FOUNDATION_EXPORT NSString *const JapaneseLanguageShortName;
FOUNDATION_EXPORT NSString *const KoreanLanguageShortName;
FOUNDATION_EXPORT NSString *const ChineseLanguageShortName;
FOUNDATION_EXPORT NSString *const TurkishLanguageShortName;
FOUNDATION_EXPORT NSString *const PolishLanguageShortName;
FOUNDATION_EXPORT NSString *const TamilLanguageShortName;


FOUNDATION_EXPORT NSString *const EnglishGBLanguageLongName;
FOUNDATION_EXPORT NSString *const EnglishUSLanguageLongName;
FOUNDATION_EXPORT NSString *const FrenchLanguageLongName;
FOUNDATION_EXPORT NSString *const SpanishLanguageLongName;
FOUNDATION_EXPORT NSString *const ItalianLanguageLongName;
FOUNDATION_EXPORT NSString *const JapaneseLanguageLongName;
FOUNDATION_EXPORT NSString *const KoreanLanguageLongName;
FOUNDATION_EXPORT NSString *const ChineseLanguageLongName;
FOUNDATION_EXPORT NSString *const TurkishLanguageLongName;
FOUNDATION_EXPORT NSString *const PolishLanguageLongName;
FOUNDATION_EXPORT NSString *const TamilLanguageLongName;

#pragma mark - Language
FOUNDATION_EXPORT NSArray *applicationLanguagesLong(void);
FOUNDATION_EXPORT NSString *applicationLanguageLong(void);

FOUNDATION_EXPORT NSString *shortLanguageToLong(NSString *shortLanguage);


FOUNDATION_EXPORT NSString *applicationLanguage(void);
FOUNDATION_EXPORT void setApplicationLanguage(NSString* language);


#pragma mark - LocalizedString
FOUNDATION_EXPORT NSString *JJLocalizedString(NSString *key, NSString *comment);