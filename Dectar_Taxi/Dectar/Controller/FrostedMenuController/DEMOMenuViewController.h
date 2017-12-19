//
//  DEMOMenuViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "UIImageView+WebCache.h"
#import "AppInfoRecords.h"
@interface DEMOMenuViewController : UITableViewController
@property (strong,nonatomic)NSMutableArray * titleArray;
@property (strong,nonatomic)NSMutableArray * ImgArray;
@property (strong,nonatomic)AppInfoRecords * appInfoRec;

@end
