//
//  TimeView.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/9/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "TimeView.h"
#import "Constant.h"
#import "Themes.h"
#import "UrlHandler.h"
#import "AppDelegate.h"


@implementation TimeView
@synthesize labl_timimg,seconds,timer,TimgBG,Timing,hintView,closereq;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseClassInit];
    }
    return self;
}

- (void)baseClassInit {
    
    Timing.center=self.center;
    closereq.center=self.center;
    [hintView setText:JJLocalizedString(@"We_are_searching_be_relax", nil)];
    

    
}
-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* result = [super hitTest:point withEvent:event];
    if (result)
        return result;
    for (UIView* sub in [self.subviews reverseObjectEnumerator]) {
        CGPoint pt = [self convertPoint:point toView:sub];
        result = [sub hitTest:pt withEvent:event];
        if (result)
            return result;
    }
    return nil;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}
- (void)updateCountdowning
{
    int  secondsleft;
    secondsleft = (seconds %3600) % 60;
    labl_timimg.text = [NSString stringWithFormat:@"00:%02d", seconds-1];
    seconds--;
    
    if (seconds==0)
    {
        [timer invalidate];
    }
}
- (void)setRecordObj:(BookingRecord *)recordObj
{
    [hintView setText:JJLocalizedString(@"We_are_searching_be_relax", nil)];
    _ID=recordObj.Booking_ID;
    seconds = [recordObj.timinrloading doubleValue];
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self   selector:@selector(updateCountdowning) userInfo:nil repeats: YES];
    [self bringSubviewToFront:self.Timing];
   
    [closereq setUserInteractionEnabled:YES];
    hintView.layer.cornerRadius = 5;
    hintView.layer.masksToBounds = YES;
    [hintView.layer setShadowColor:[UIColor blackColor].CGColor];
    [hintView.layer setShadowOpacity:0.8];
    [hintView.layer setShadowRadius:3.0];
    [hintView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [labl_timimg.layer setShadowColor:[UIColor blackColor].CGColor];
    [labl_timimg.layer setShadowOpacity:0.8];
    [labl_timimg.layer setShadowRadius:3.0];
    [labl_timimg.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

    [Timing.layer setShadowColor:[UIColor blackColor].CGColor];
    [Timing.layer setShadowOpacity:1.0];
    [Timing.layer setShadowRadius:3.0];
    [Timing.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [closereq.layer setShadowOpacity:1.0];
    [closereq.layer setShadowRadius:3.0];
    [closereq.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    Timing.delegate = self;
    [Timing startWithSeconds:[recordObj.timinrloading doubleValue]];

    self.userInteractionEnabled=YES;
    
    
    
}

-(void) pauseTimer:(NSTimer *)timering {
    
    pauseStart = [NSDate dateWithTimeIntervalSinceNow:0] ;
    
    previousFireDate = [timering fireDate] ;
    
    [timering setFireDate:[NSDate distantFuture]];
}

-(void) resumeTimer:(NSTimer *)timering {
    
    float pauseTime = -1*[pauseStart timeIntervalSinceNow];
    
    [timering setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    
}
- (void)circleCounterTimeDidExpire:(JWGCircleCounter *)circleCounter {
    
    [self removeFromSuperview];
}
- (IBAction)cancelReq_action:(id)sender {

    [closereq setUserInteractionEnabled:NO];
    [self pauseTimer:timer];
     [Timing stop];
    NSDictionary *parameters=@{@"user_id":[Themes getUserID],
                               @"ride_id":_ID};
    UrlHandler *web = [UrlHandler UrlsharedHandler];
    [Themes StartView:self];
    [web Bookingcancel:parameters success:^(NSMutableDictionary *responseDictionary)
     {
         NSLog(@"%@",responseDictionary);
         [Themes StopView:self];
         
         if ([responseDictionary count]>0)
         {
             responseDictionary=[Themes writableValue:responseDictionary];
             
             [Themes StopView:self];
             
             UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:JJLocalizedString(@"success", nil) message:JJLocalizedString(@"Booking_Request_Cancelled", nil) delegate:nil cancelButtonTitle:JJLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
             [Alert show];
             [self removeFromSuperview];
             [timer invalidate];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"removeView" object:nil];

         }
         else
         {
             [closereq setUserInteractionEnabled:YES];
             [self resumeTimer:timer];

         }
         

         
         
     }
               failure:^(NSError *error)
     {
         [Themes StopView:self];
         [Timing resume];
         [closereq setUserInteractionEnabled:YES];
         [self resumeTimer:timer];


     }];
}
@end
