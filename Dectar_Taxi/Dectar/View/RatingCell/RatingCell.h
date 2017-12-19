//
//  RatingCell.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/3/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"
#import "ReviewRecord.h"

@protocol RatingViewDelegate

- (void)RatingGiven:(NSIndexPath *)SelectedIndexPath withValue:(CGFloat)value;

@end


@interface RatingCell : UITableViewCell<TPFloatRatingViewDelegate>

@property (nonatomic, assign) id <RatingViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *Rating_label;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *Rating_view;
@property(strong , nonatomic) NSIndexPath * selectiveIndexpath;
@property(strong , nonatomic) ReviewRecord * objReviewRecord;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectCategory;

@end
