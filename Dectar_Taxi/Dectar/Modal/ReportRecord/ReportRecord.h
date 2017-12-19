//
//  ReportRecord.h
//  Dectar
//
//  Created by iOS on 19/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportRecord : NSObject
@property(strong,nonatomic)NSString * reason;
@property(strong,nonatomic)NSString * reason_text;
@property(strong,nonatomic)NSString * custom;
@property(strong,nonatomic)NSString * issue;
@property(strong,nonatomic)NSString * type;
@property(strong,nonatomic)NSString * report_date;
@property(strong,nonatomic)NSString * report_time;
@property(strong,nonatomic)NSString * ride_id;

@property(assign,nonatomic)BOOL isSelected;
@end
