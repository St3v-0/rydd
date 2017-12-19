//
//  MenuTableViewCell.h
//  DectarDriver
//
//  Created by Aravind Natarajan on 09/01/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *IconImgView;
@property (weak, nonatomic) IBOutlet UILabel *walletLbl;

@end
