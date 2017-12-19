//
//  FavouriteListCell.h
//  Dectar
//
//  Created by iOS on 01/09/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol categoryFavourite <NSObject>
@optional
- (void)indexpath:(NSIndexPath *)categoryIndex;
@end
@interface FavouriteListCell : UITableViewCell
@property (nonatomic, weak) id <categoryFavourite> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property(strong,nonatomic)NSIndexPath *currentIndex;

@end
