//
//  Blurview.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/21/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BlurViewDeletgate

- (void)CloseBlurView;

@end
@interface Blurview : UIView

@property (nonatomic, assign) id <BlurViewDeletgate> delegate;
@property (nonatomic, assign) BOOL isNeed;
@end
