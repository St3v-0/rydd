//
//  RootBaseVC.h
//  Dectar
//
//  Created by Aravind Natarajan on 10/9/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFMInfoBanner.h"
#import "HDNotificationView.h"
#import "UIView+Toast.h"
#import "LanguageHandler.h"
#import "CNPPopupController.h"
@interface RootBaseVC : UIViewController<CNPPopupControllerDelegate>

@property (nonatomic, strong) CNPPopupController *popupController;
-(void)Toast:(NSString *)msg;
-(void)applicationLanguageChangeNotification:(NSNotification*)notification;

@end
