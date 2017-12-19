//
//  FavourRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/21/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavourRecord : NSObject

@property(strong, nonatomic) NSString * Address;
@property(assign, nonatomic) double  latitudeStr;
@property(strong, nonatomic) NSString * titleString;
@property(assign, nonatomic) double longitude;
@property(strong, nonatomic) NSString * locationkey;


@end
