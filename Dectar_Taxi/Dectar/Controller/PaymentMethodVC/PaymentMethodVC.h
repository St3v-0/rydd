//
//  PaymentMethodVC.h
//  Dectar
//
//  Created by iOS on 08/06/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentMethodRecord.h"
#import "RootBaseVC.h"
#import "AddCardRecord.h"

@interface PaymentMethodVC : RootBaseVC
- (IBAction)didClickBackBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableNames;
@property(assign,nonatomic)NSInteger errorCount;

//@property (strong, nonatomic) PaymentMethodRecord *cardObjRec;

@end
