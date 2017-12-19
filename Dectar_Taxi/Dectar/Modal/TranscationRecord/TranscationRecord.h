//
//  TranscationRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 8/28/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranscationRecord : NSObject

@property (strong, nonatomic) NSString * Currentbalance;
@property (strong,nonatomic) NSString * time;
@property (strong ,nonatomic) NSString * title;
@property(strong,nonatomic) NSString * updatebalance;
@property(strong,nonatomic)NSString*type;


@end
