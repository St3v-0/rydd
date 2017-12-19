//
//  CountryListViewController.h
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryListViewDelegate <NSObject>
@required
- (void)didSelectCountry:(NSDictionary *)country;
@end

@interface CountryListViewController : UIViewController

@property (nonatomic, assign) id<CountryListViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *done_btn;

@property (weak, nonatomic) IBOutlet UILabel *SelectCountry_Header;
@property (weak, nonatomic) IBOutlet UIButton *Done_btn;
@property (strong, nonatomic) IBOutlet UISearchBar *CountrySearch;

- (id)initWithNibName:(NSString *)nibNameOrNil delegate:(id)delegate;
@end
