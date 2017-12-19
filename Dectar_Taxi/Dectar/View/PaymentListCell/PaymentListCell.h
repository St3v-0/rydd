//
//  PaymentListCell.h
//  Dectar
//
//  Created by iOS on 14/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCardNo;
@property (weak, nonatomic) IBOutlet UILabel *lblDefault;
@property (weak, nonatomic) IBOutlet UILabel *lblCardType;

@end
