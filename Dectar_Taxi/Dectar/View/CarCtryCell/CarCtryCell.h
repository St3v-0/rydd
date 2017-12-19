//
//  CarCtryCell.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/18/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingRecord.h"

@protocol ButtonProtocolName

- (void)buttonWasPressed:(NSIndexPath *)SelectedIndexPath;

@end

@interface CarCtryCell : UICollectionViewCell


@property (nonatomic, assign) id <ButtonProtocolName> delegate;

@property (strong , nonatomic) IBOutlet UILabel * TimeLable;
@property (strong , nonatomic)IBOutlet UILabel * nameLable;
@property(strong , nonatomic) IBOutlet UIButton * carButton;
@property(strong , nonatomic) BookingRecord * objBookingRecord;
@property (strong, nonatomic) IBOutlet UIImageView *cabImageView;
@property(strong , nonatomic) NSIndexPath * selectiveIndexpath;
-(void)setDatasToCategoryCell:(BookingRecord *)objBookingRec;

@end
