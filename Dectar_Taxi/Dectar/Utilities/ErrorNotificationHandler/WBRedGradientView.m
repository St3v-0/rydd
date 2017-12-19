//
//  WBRedGradientView.m
//  GradientView
//
//  Created by Tito Ciuro on 6/3/12.
//  Copyright (c) 2012 Webbo, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Constant.h"
#import "WBRedGradientView.h"

@implementation WBRedGradientView

- (void)drawRect:(CGRect)rect
{
    
    UIColor *redTop = BGCOLOR ;//[UIColor colorWithRed:167/255.0f green:26/255.0f blue:20/255.0f alpha:1.0];
    UIColor *redBot =BGCOLOR;// [UIColor colorWithRed:134/255.0f green:9/255.0f blue:7/255.0f alpha:1.0];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)redTop.CGColor,     
                       (id)redBot.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.7],
                          nil];
    
    [self.layer insertSublayer:gradient atIndex:0];
    self.layer.needsDisplayOnBoundsChange = YES;
    
    UIView *firstTopPinkLine = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 1.0)];
    firstTopPinkLine.backgroundColor = BGCOLOR;
    [self addSubview:firstTopPinkLine];
    
    UIView *secondTopRedLine = [[UIView alloc]initWithFrame:CGRectMake(0.0, 1.0, self.bounds.size.width, 1.0)];
    secondTopRedLine.backgroundColor =BGCOLOR;
    [self addSubview:secondTopRedLine];
    
    UIView *firstBotRedLine = [[UIView alloc]initWithFrame:CGRectMake(0.0, self.bounds.size.height - 1, self.frame.size.width, 1.0)];
    firstBotRedLine.backgroundColor = BGCOLOR;
    [self addSubview:firstBotRedLine];
    
    UIView *secondBotDarkLine = [[UIView alloc]initWithFrame:CGRectMake(0.0, self.bounds.size.height, self.frame.size.width, 1.0)];
    secondBotDarkLine.backgroundColor = BGCOLOR;
    [self addSubview:secondBotDarkLine];
}

@end
