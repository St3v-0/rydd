//
//  CarCtryCell.m
//  Dectar
//
//  Created by Aravind Natarajan on 8/18/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import "CarCtryCell.h"
#import "UIImageView+Network.h"
#import "UIImageView+WebCache.h"


@implementation CarCtryCell
@synthesize objBookingRecord,selectiveIndexpath,carButton,TimeLable,nameLable,cabImageView;

-(IBAction)SelectButton:(id)sender
{
    [self.delegate buttonWasPressed:selectiveIndexpath];
}
-(void)setDatasToCategoryCell:(BookingRecord *)objBookingRec{
    cabImageView.layer.cornerRadius=cabImageView.frame.size.width/2;
    cabImageView.layer.masksToBounds=YES;
    TimeLable.text=objBookingRec.categoryETA;
    nameLable.text=objBookingRec.categoryName;
    
    if(objBookingRec.isSelected==YES){
    
        //        [cabImageView loadImageFromURL:[NSURL URLWithString:objBookingRec.Active_Image] placeholderImage:[UIImage imageNamed:@""] cachingKey:cacheStr];
       /* [cabImageView sd_setImageWithURL:[NSURL URLWithString:objBookingRec.Active_Image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];*/
        
        [cabImageView sd_setImageWithURL:[NSURL URLWithString:objBookingRec.Active_Image] placeholderImage:[UIImage imageNamed:@"CabPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        
    }else{
       
        //        [cabImageView loadImageFromURL:[NSURL URLWithString:objBookingRec.Normal_image] placeholderImage:[UIImage imageNamed:@""] cachingKey:cacheStr];
        
       /* [cabImageView sd_setImageWithURL:[NSURL URLWithString:objBookingRec.Normal_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];*/
        
        [cabImageView sd_setImageWithURL:[NSURL URLWithString:objBookingRec.Normal_image] placeholderImage:[UIImage imageNamed:@"CabPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
    }
    
    
}
@end