//
//  TimeView.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/9/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWGCircleCounter.h"
#import "BookingRecord.h"
#import "BookARideVC.h"

@class BookARideVC;

@interface TimeView : UIView<JWGCircleCounterDelegate,UIGestureRecognizerDelegate>
{
    NSDate *pauseStart, *previousFireDate;
    

}
@property (strong, nonatomic) BookARideVC *Ride;

@property (strong, nonatomic) IBOutlet JWGCircleCounter *Timing;
@property (strong, nonatomic) IBOutlet UIView *TimgBG;
@property(strong , nonatomic) BookingRecord * recordObj;
@property (strong, nonatomic) IBOutlet UILabel *labl_timimg;
@property (assign ) int seconds;
@property (strong, nonatomic) IBOutlet UILabel *hintView;
@property (strong ,nonatomic) NSTimer*timer;
@property (strong ,nonatomic) NSString *ID;

@property (strong, nonatomic) IBOutlet UIButton *closereq;

@end
