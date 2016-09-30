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

@import Firebase;

@interface CustomerListViewController ()

@end

@implementation CustomerListViewController

FIRDatabaseReference* databaseRef;


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
    
    // add title
    UILabel *emailTitleLabel = [[UILabel alloc] init];
    emailTitleLabel.text = user.email;
    emailTitleLabel.text = [NSString stringWithFormat:@"Logged user: %@", user.email];
    emailTitleLabel.textColor = [UIColor whiteColor];
    emailTitleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    emailTitleLabel.textAlignment = NSTextAlignmentCenter;
    [emailTitleLabel sizeToFit];
    self.tabBarController.navigationItem.titleView = emailTitleLabel;
    
    // add UIBarButton items
    UIBarButtonItem* addNewCustomerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                                                            UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(addNewCustomerAction:)];
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                        style: UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(editAction:)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = addNewCustomerButton;
    self.tabBarController.navigationItem.leftBarButtonItem = editButton;
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    [vc.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    vc.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private methods

- (AddNewCustomerTableViewController*) addNewCustomerAction:(UIBarButtonItem*) button {
    AddNewCustomerTableViewController* vc = [[AddNewCustomerTableViewController alloc] initWithFirstName:nil lastName:nil dateOfBirth:nil zipcode:nil key:nil title:nil];
    
    UINavigationController* navController = [[UINavigationController alloc]
                                                 initWithRootViewController:vc];
    [navController.navigationBar
        setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    
    //now present this navigation controller modally
    [self presentViewController:navController animated:YES completion:nil];
    return vc;
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


- (void) editAction:(UIBarButtonItem*) button {
    if (self.tableView.editing) {
        self.tableView.editing = NO;
        button.title = @"Edit";
    } else {
        self.tableView.editing = YES;
        button.title = @"Done";
    }
}


@end
