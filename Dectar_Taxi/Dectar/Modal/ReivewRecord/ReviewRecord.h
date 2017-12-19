//
//  ReviewRecord.h
//  Dectar
//
//  Created by Aravind Natarajan on 9/3/15.
//  Copyright (c) 2015 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewRecord : NSObject
@property (strong , nonatomic) NSString * Review_title;
@property (strong , nonatomic) NSString * Review_ID;
@property (strong , nonatomic) NSString * Review_Rating;
@property(assign,nonatomic)BOOL isSelectBtn;
@property (strong , nonatomic) NSString * ReasonStatus;

@end
