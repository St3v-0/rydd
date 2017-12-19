//
//  PaymentMethodCell.h
//  Dectar
//
//  Created by iOS on 08/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonProtocolName

- (void)buttonPressedForDelete:(NSIndexPath *)SelectedIndexPath;

@end

@interface PaymentMethodCell : UITableViewCell

@property (nonatomic, assign) id <ButtonProtocolName> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCardType;
@property (weak, nonatomic) IBOutlet UILabel *lblCardName;
@property (weak, nonatomic) IBOutlet UILabel *lblDefault;
- (IBAction)didClickDeleteBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property(strong , nonatomic) NSIndexPath * selectiveIndexpath;

@end
