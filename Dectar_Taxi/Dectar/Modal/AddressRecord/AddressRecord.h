//
//  AddressRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/24/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface AddressRecord : NSObject



@property(strong,nonatomic) NSString * addressStr;
@property CGFloat  ADDlatitude;
@property CGFloat  ADDlongitude;
@property NSString * Klocation;


@property (strong,nonatomic) NSString * MapAddressString;
@property CGFloat MapLatitude;
@property CGFloat MapLongitude;

@end
