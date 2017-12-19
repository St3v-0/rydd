//
//  PaymentMethodCell.m
//  Dectar
//
//  Created by iOS on 08/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import "PaymentMethodCell.h"

@implementation PaymentMethodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickDeleteBtn:(id)sender {
    
     [self.delegate buttonPressedForDelete:_selectiveIndexpath];
}
@end
