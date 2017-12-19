//
//  Blurview.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/21/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "Blurview.h"
#import "BookARideVC.h"

@implementation Blurview
@synthesize isNeed;
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
    
    UITapGestureRecognizer *tapgesr = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(tapped)];
    tapgesr.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapgesr];
    
}
-(void)tapped{
    
    if (isNeed==YES)
    {
        [self removeFromSuperview];
        
        

    }
    else if(isNeed==NO)
    {
        
    }
    //[self removeFromSuperview];
    
    [self.delegate CloseBlurView];
}

@end
