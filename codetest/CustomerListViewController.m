//
//  CustomerListViewController.m
//  codetest
//
//  Created by Nikolai Tarasov on 9/12/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import "CustomerListViewController.h"
#import "LaunchViewController.h"
#import "AddNewCustomerTableViewController.h"
#import "FirebaseDatabaseManager.h"
#import "Customer.h"
#import "SearchResultsTableViewController.h"

@import Firebase;

@interface CustomerListViewController ()

@end

@implementation CustomerListViewController

FIRDatabaseReference* databaseRef;

NSArray *originalData;
NSMutableArray *searchData;
UISearchBar *searchBar;
UISearchController *searchController;

- (id) init {
    self = [super init];
    if (self) {
        originalData = self.customers;
        searchData = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // init database reference
    databaseRef = [FirebaseDatabaseManager sharedReference];
    
    if (self.customers != nil) {
        return;
    }
    
    // init results array
    self.customers = [[NSMutableArray alloc] init];
    
    // get all data from Firebase
    [[databaseRef child:@"customers"] observeSingleEventOfType:FIRDataEventTypeValue
                                                     withBlock:^(FIRDataSnapshot * snapshot) {
        
        [self.tableView beginUpdates];
        
        for (FIRDataSnapshot* child in snapshot.children) {
            
            Customer* customer = [[Customer alloc] initWithCustomerKey:child.key andDictionary: child.value];
            [self.customers addObject:customer];
            
            [self.tableView insertRowsAtIndexPaths:
                                @[[NSIndexPath indexPathForRow:self.customers.count-1 inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.tableView endUpdates];
    } withCancelBlock:^(NSError * error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // get current firebase user
    FIRUser *user = [FIRAuth auth].currentUser;
    
    // add title label
    UILabel *emailTitleLabel = [[UILabel alloc] init];
    emailTitleLabel.text = user.email;
    emailTitleLabel.text = [NSString stringWithFormat:@"Logged user: %@", user.email];
    emailTitleLabel.textColor = [UIColor whiteColor];
    emailTitleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    emailTitleLabel.textAlignment = NSTextAlignmentCenter;
    [emailTitleLabel sizeToFit];
    self.navigationItem.titleView = emailTitleLabel;
    
    // add search functionality
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavigationController"];
    searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    searchController.searchResultsUpdater = self;
    //searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
    searchController.searchBar.barTintColor = [UIColor colorWithRed:(45.0/255.0) green:(152.0/255.0) blue:(231.0/255.0) alpha:1.0];
    self.tableView.tableHeaderView = searchController.searchBar;

    
    // add UIBarButton items
    UIBarButtonItem* addNewCustomerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                                                            UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(addNewCustomerAction:)];
    
    UIBarButtonItem* logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                    style: UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(logoutAction:)];
    
    self.navigationItem.rightBarButtonItem = addNewCustomerButton;
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    self.navigationItem.hidesBackButton = YES;
    
    // check for updates in table view
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkUpdates:) name:@"Added new customer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkUpdates:) name:@"Edited existing customer" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customers.count == 0 ? 0 : self.customers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (self.customers.count != 0) {
        [self configureCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Customer* customer = [self.customers objectAtIndex:indexPath.row];
        NSString* key = customer.customerKey;
        
        // Remove data from database
        [[[databaseRef child:@"customers"] child:key] removeValue];
        
        // Remove the row from data array
        [self.customers removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // play sound effect
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"Clean_Paper_Rip" ofType:@"mp3"];
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        SystemSoundID audioEffect;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
        
        // Request table view to reload
        [tableView reloadData];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Customer* customer = [self.customers objectAtIndex:indexPath.row];
    
    NSString* firstName = customer.firstName;
    NSString* lastName = customer.lastName;
    NSString* dateOfBirth = customer.dateOfBirth;
    NSString* zipcode = customer.zipcode;
    NSString* key = customer.customerKey;
    
    NSString* fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    AddNewCustomerTableViewController* vc = [[AddNewCustomerTableViewController alloc] initWithFirstName:firstName lastName:lastName dateOfBirth:dateOfBirth zipcode:zipcode key:key title:fullName];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = searchController.searchBar.text;
    
    [self updateFilteredContentForSearchText:searchString];
    
    if (searchController.searchResultsController) {
        
        UINavigationController *navController = (UINavigationController *)searchController.searchResultsController;
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        vc.searchResults = searchData;
        [vc.tableView reloadData];
    }
}


#pragma mark - Private methods

- (AddNewCustomerTableViewController*) addNewCustomerAction:(UIBarButtonItem*) button {
    AddNewCustomerTableViewController* vc = [[AddNewCustomerTableViewController alloc] initWithFirstName:nil lastName:nil dateOfBirth:nil zipcode:nil key:nil title:nil];
    [self.navigationController pushViewController:vc animated:YES];
    return vc;
}


-(void)logoutAction:(id) sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {

        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }

}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Customer* customer = [self.customers objectAtIndex:indexPath.row];
    NSString* firstName = customer.firstName;
    NSString* lastName = customer.lastName;
    NSString* fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    cell.textLabel.text = fullName;
}

-(void) checkUpdates:(NSNotification *)notification {
    // init results array
    self.customers = [[NSMutableArray alloc] init];
    
    [[databaseRef child:@"customers"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        
        for (FIRDataSnapshot* child in snapshot.children) {
            
            Customer* customer = [[Customer alloc] initWithCustomerKey:child.key andDictionary: child.value];
            
            [self.customers addObject:customer];
            
        }
        if ([[notification name] isEqualToString:@"Added new customer"]) {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:
             @[[NSIndexPath indexPathForRow:self.customers.count-1 inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        [self.tableView reloadData];
    } withCancelBlock:^(NSError * error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}


- (void)updateFilteredContentForSearchText:(NSString *)searchText {
    
    if (searchText == nil) {
        
        searchData = [self.customers mutableCopy];
        
    } else {
        
        NSMutableArray *searchResults = [[NSMutableArray alloc] init];
        
        for (Customer* customer in self.customers) {
            NSString* firstName = customer.firstName;
            NSString* lastName = customer.lastName;
            NSString* fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            if ([fullName containsString:searchText]) {
                [searchResults addObject:fullName];
            }
            searchData = searchResults;
        }
    }
}

@end
