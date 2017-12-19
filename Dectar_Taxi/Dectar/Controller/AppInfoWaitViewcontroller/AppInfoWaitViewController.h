//
//  AppInfoWaitViewController.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 27/04/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Themes.h"
#import "JJLocationManager.h"
#import "UIImage+GIF.h"


@interface AppInfoWaitViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *initialLoadingImageView;
@property (strong, nonatomic) IBOutlet UILabel *headerlbl;
@property (strong, nonatomic) IBOutlet UILabel *subheaderLbl;
@property (weak, nonatomic) IBOutlet UIButton *proceedBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
- (IBAction)didClickProceedBtn:(id)sender;

@end
