//
//  CustomSegmentView.m
//  Dectar
//
//  Created by iOS on 2/18/16.
//  Copyright © 2016 CasperonTechnologies. All rights reserved.
//

#import "CustomSegmentView.h"
#import "Constant.h"


@implementation CustomSegmentView

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
    
    //initialize all ivars and properties
    self.tintColor=BGCOLOR;
}

@end
