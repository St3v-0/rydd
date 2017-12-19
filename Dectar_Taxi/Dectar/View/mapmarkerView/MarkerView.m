//
//  MarkerView.m
//  Dectar
//
//  Created by Aravind Natarajan on 11/18/15.
//  Copyright © 2015 CasperonTechnologies. All rights reserved.
//

#import "MarkerView.h"

@implementation MarkerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseClassInit];
    }
    return self;
}

- (void)baseClassInit {
    
    self.circleView.alpha = 0.5;
    self.circleView.layer.cornerRadius = 25;
    self.circleView.backgroundColor = [UIColor blueColor];
}

@end
