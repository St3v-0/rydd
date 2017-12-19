//
//  PaymentMethodRecord.h
//  Dectar
//
//  Created by iOS on 08/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentMethodRecord : NSObject
@property(strong,nonatomic)NSString * card_id;
@property(strong,nonatomic)NSString * card_number;
@property(strong,nonatomic)NSString * CardExpiryDate;
@property(strong,nonatomic)NSString * card_type;
@property(strong,nonatomic)NSString * cardName;

//@property(strong,nonatomic)NSString * card_type;
//@property(strong,nonatomic)NSString * card_type;
//@property(strong,nonatomic)NSString * card_type;

@property(assign,nonatomic)BOOL isDefault;

@property(strong,nonatomic)NSString * cardStatus;
@end
