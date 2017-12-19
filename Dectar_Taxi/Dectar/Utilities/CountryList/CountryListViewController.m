//
//  CountryListViewController.m
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import "CountryListViewController.h"
#import "CountryListDataSource.h"
#import "CountryCell.h"
#import "LanguageHandler.h"
#import "Themes.h"



@interface CountryListViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataRows;
@property (strong, nonatomic) NSIndexPath *path;


@property (strong, nonatomic) NSMutableArray *DummyDataRows;

@end

@implementation CountryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil delegate:(id)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];
    _DummyDataRows=[[NSMutableArray alloc]
                   init];
    _DummyDataRows=[_dataRows mutableCopy];
    
    [_tableView reloadData];
    [_done_btn setEnabled:NO];
    [_done_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _SelectCountry_Header.text=JJLocalizedString(@"Select_Country_Code", nil);
    [_done_btn setTitle:JJLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    
    _CountrySearch.delegate=self;
    
    [_CountrySearch setPlaceholder:JJLocalizedString(@"Enter_Search", nil)];
    [self setReturnKeyBoard];
}
-(void)setReturnKeyBoard{
    for (UIView *subview in _CountrySearch.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                [textField setKeyboardAppearance: UIKeyboardAppearanceDefault];
                textField.returnKeyType = UIReturnKeyDone;
                textField.enablesReturnKeyAutomatically=NO;
                break;
            }
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CountryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [Themes checkNullValue:[[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryName]];
    cell.detailTextLabel.text = [Themes checkNullValue:[[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode]];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _path =indexPath;
    [_done_btn setEnabled:YES];
    [_done_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

}

#pragma mark -
#pragma mark Actions

- (IBAction)done:(id)sender
{
    NSLog(@"%@",[_dataRows objectAtIndex:_path.row]);
    
       if ([_delegate respondsToSelector:@selector(didSelectCountry:)])
       {
            [self.delegate didSelectCountry:[_dataRows objectAtIndex:_path.row]];
            [self.navigationController popViewControllerAnimated:YES];
       }

}

#pragma mark - Search Bar Delegates

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText isEqualToString:@""]){
        _dataRows=[_DummyDataRows mutableCopy];
        [searchBar resignFirstResponder];
    }else{
        NSPredicate *searchSearch = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@", searchText];
        NSArray *searchResults = [_DummyDataRows filteredArrayUsingPredicate:searchSearch];
        _dataRows=[searchResults mutableCopy];
    }
    [_tableView reloadData];
    
}

@end
