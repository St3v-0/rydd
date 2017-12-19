//
//  RatingCell.m
//  Dectar
//
//  Created by Aravind Natarajan on 9/3/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "RatingCell.h"

@implementation RatingCell
@synthesize Rating_label,Rating_view,selectiveIndexpath,objReviewRecord,lblSelectCategory;



- (void)awakeFromNib {
    // Initialization code
  
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setObjReviewRecord:(ReviewRecord *)_objReviewRecord
{
   // objReviewRecord=_objReviewRecord;
    Rating_label.text=_objReviewRecord.Review_title;
    [self setRateValue:_objReviewRecord.Review_Rating];
}
-(void)setRateValue:(NSString *)value{
    Rating_view.delegate = self;
    Rating_view.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    Rating_view.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
    Rating_view.contentMode = UIViewContentModeScaleAspectFill;
    Rating_view.maxRating = 5;
    Rating_view.minRating = 0;
    Rating_view.rating = [value floatValue];
    Rating_view.editable = YES;
    Rating_view.halfRatings = NO;
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{
      [self.delegate RatingGiven:selectiveIndexpath withValue:rating];
}
-(void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating
{
    [self.delegate RatingGiven:selectiveIndexpath withValue:rating];
    
}
@end
