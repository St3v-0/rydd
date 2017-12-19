#define kLocationUpdate @"locationUpdateNotif"
#define kAppInfo @"UserAppInfokey"
#define kShutTheApp @"NotifForCloseTheApp"
#define KCarCatImage @"CarcatImage"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define kDriverAdvtInfo @"kDriverAdvtInfoNotif"

//Maximum phone digit
#define passwordMininumWidth 6
#define MinimumDigit 5
#define MaximumDigit 15
#define MapLineWidth 7
#define PanicContactNumber @"112"


#define isCabilyProduct @"dectar"
#define isHaveLanguageManagemnt 0 // If yes enter 1 else enter 0
#define MapNightMode 1 // If yes enter 1 else enter 0


#define BGCOLOR [UIColor colorWithRed:53.0/255.0 green:54.0/255.0 blue:58.0/255.0 alpha:1.0]

//#define BGCOLOR [UIColor blackColor]

#define STATUSCOLOR [UIColor colorWithRed:96.0/255.0 green:216.0/255.0 blue:255.0/255.0 alpha:1.0]

#define GoogleClientKey @"AIzaSyDAnTStliqgQg6bRXlYJAlxt6JgEeO4pls"// @"AIzaSyB8Ro0ByGwGnL3jDHI1uJDpdog39-E1rpU"//@"AIzaSyBhislNhLCUHwO-EfErTGh9wU-8WZv5AGE"
#define GoogleServerKey @"AIzaSyDAnTStliqgQg6bRXlYJAlxt6JgEeO4pls" //182.156.95.138 1.39.63.251
#define kStripeKey @"pk_test_y1g9v956mLamOybYYODFN7FK"
#define kXmppHostName @"192.168.1.150" //@"192.168.1.150" //@"67.219.149.186"
#define kXmppDomainPassword "casp83" //"casp83"  //@messaging.dectar.com "casp83"

 #define SupportMail @"info@zoplay.com"


#define kHockeyAppIdentifier @"c72389a7cd9545c1a724265070754296"
#define kHockeyCustomizationAppIdentifier @"fffd6b490d5a42e79d75dfdb56dd9d49"


//#define AppbaseUrl @"http://192.168.1.251:8081/dectar/customization/budtech/v5/"
#define AppbaseUrl @"http://budtech.net/v7/"
//#define AppbaseUrl @"http://192.168.1.251:8081/dectar/customization/budtech/v7/"

//#define AppbaseUrl @"http://project.dectar.com/fortaxi/v5/"

 #define GeoUpdate AppbaseUrl@"app/set-user-geo"
#define Map_and_Taxi_Selection AppbaseUrl @"app/get-map-view"
#define OTP AppbaseUrl @"app/register"
#define Login AppbaseUrl @"app/login"
#define mapEta AppbaseUrl @"app/get-eta"
#define applycoupon AppbaseUrl @"app/apply-coupon"
#define favouriteList AppbaseUrl @"app/favourite/display"
#define addfavourite AppbaseUrl@"app/favourite/add"
#define deleteList AppbaseUrl@"app/favourite/remove"
#define EditFavr AppbaseUrl@"app/favourite/edit"
#define ConfrimBooking AppbaseUrl@"app/book-ride"
#define deleteRide AppbaseUrl@"app/delete-ride"
#define RegisterAccount AppbaseUrl@"app/check-user"
#define MyrideList AppbaseUrl@"app/my-rides"
#define ViewRides AppbaseUrl@"app/view-ride"
#define changepassword AppbaseUrl@"app/user/change-password"
#define changename AppbaseUrl@"app/user/change-name"
#define changemobilenumber AppbaseUrl@"app/user/change-mobile"
#define invite AppbaseUrl@"app/get-invites"
#define AddEmergency AppbaseUrl@"app/user/set-emergency-contact"
#define DeleteEmergency AppbaseUrl@"app/user/delete-emergency-contact"
#define viewEmergency AppbaseUrl@"app/user/view-emergency-contact"
#define SoundEmergency AppbaseUrl@"app/user/alert-emergency-contact"
#define Mymoney AppbaseUrl@"app/get-money-page"
#define transcationList AppbaseUrl@"app/get-trans-list"
#define ReasonCancel AppbaseUrl@"app/cancellation-reason"
#define RideCancel AppbaseUrl@"app/cancel-ride"
#define ListofPayment AppbaseUrl@"app/payment-list"
#define PaymentByWallet AppbaseUrl@"app/payment/by-wallet"
#define PaymentByCash AppbaseUrl@"app/payment/by-cash"
#define paymentGetWay AppbaseUrl@"app/payment/by-gateway"
#define ReviewList AppbaseUrl@"app/review/options-list"
#define Loggout AppbaseUrl@"app/logout"
#define ReviewSubmit AppbaseUrl@"app/review/submit"
#define LocationsList AppbaseUrl@"app/get-location"
#define CategoryList AppbaseUrl@"app/get-category"
#define RateCardDetails AppbaseUrl@"app/get-ratecard"
#define AddWallet AppbaseUrl@"mobile/wallet-recharge/stripe-process"
#define Invoice AppbaseUrl@"app/mail-invoice"
#define detectiontionAuto AppbaseUrl@"app/payment/by-auto-detect"
#define Password_Reset AppbaseUrl@"app/user/reset-password"
#define Password_Update AppbaseUrl@"app/user/update-reset-password"
#define Social_Check AppbaseUrl@"app/social-check"
#define Social_login AppbaseUrl@"app/social-login"
#define Driver_Track AppbaseUrl@"api/v3/track-driver"
#define Tips_Adding AppbaseUrl@"app/apply-tips"
#define Tips_Remove AppbaseUrl@"app/remove-tips"
#define GetFare AppbaseUrl@"app/get-fare-breakup"
#define ForXMPP AppbaseUrl@"api/xmpp-status"
#define ShareETA AppbaseUrl@"api/v3/track-driver/share-my-ride"
#define getLatLongToAddressGoogle @"https://maps.googleapis.com/maps/api/geocode/json?"
#define getRouteFromGoogle @"https://maps.googleapis.com/maps/api/directions/json"
#define getAddressFromGoogle @"https://maps.googleapis.com/maps/api/place/autocomplete/json?"
#define GetAppInformation AppbaseUrl@"api/v3/get-app-info"
#define updateBaseLanguage AppbaseUrl@"api/update-primary-language"
#define updateProfileImage AppbaseUrl@"api/user-upload-image"
#define PayGatewayUrl AppbaseUrl@"api/v1/mobile/wallet-recharge/paygate-recharge/"
#define PayGatewayPaymentVCUrl AppbaseUrl@"api/v1/mobile/Paygate-payment/"
#define PopUp AppbaseUrl@"api/v1/user/show_map_popup"
#define PayGateCardDetails AppbaseUrl@"paygate/card-details"
#define AddCardDetails AppbaseUrl@"paygate/add-card"
#define MakeDefaultCard AppbaseUrl@"paygate/make-default-card"
#define DeleteCardPayGate AppbaseUrl@"paygate/delete-card"
#define PaymentPaygateMobile AppbaseUrl@"api/v1/mobile/Paygate-payment"
#define PaymentByGateWay AppbaseUrl@"api/v1/app/payment/by-gateway"
#define ReportsShow AppbaseUrl@"user/show_reports"
#define AddReports AppbaseUrl@"user/add_reports"
#define HistoryReport AppbaseUrl@"user/reports_history"
#define RetryBooking AppbaseUrl@"app/retry-ride-request"
#define TermsandConditions @"http://www.ryddhome.com/terms-and-conditions/"


#define Searchradius @"2000"
