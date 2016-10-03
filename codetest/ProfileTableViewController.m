//
//  ProfileTableViewController.m
//  codetest
//
//  Created by Nikolai Tarasov on 9/28/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "LaunchViewController.h"

@import Firebase;

@interface ProfileTableViewController ()
@property(strong, nonatomic) NSMutableArray* UIElements;
@property(weak, nonatomic) UIFont* defaultFont;
@end

@implementation ProfileTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"3view = %@", self.navigationController);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.UIElements = [[NSMutableArray alloc] init];
    self.UIElements = [self createNameFields];
    
    // fill email field
    FIRUser *user = [FIRAuth auth].currentUser;
    self.emailField.text = user.email;
    
    // add title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"My Profile";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                    target:self
                                                                    action:@selector(saveUpdatesAction:)];
    
    UIBarButtonItem* logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                     style: UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(logoutAction:)];
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    _defaultFont = [UIFont fontWithName:@"Helvetica" size:16];
    self.saveButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.UIElements.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* title = @"User information";
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Italic" size:18];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITextField *tf = (UITextField*)cell.accessoryView;
            tf = [self.UIElements objectAtIndex:0];
            cell.textLabel.text = @"Email address";
            cell.accessoryView = cell.editingAccessoryView = tf;
        } else if (indexPath.row == 1) {
            UITextField *tf = (UITextField*)cell.accessoryView;
            tf = [self.UIElements objectAtIndex:1];
            cell.textLabel.text = @"Update password";
            cell.accessoryView = cell.editingAccessoryView = tf;
        } else if (indexPath.row == 2) {
            UITextField *tf = (UITextField*)cell.accessoryView;
            tf = [self.UIElements objectAtIndex:2];
            cell.textLabel.text = @"Retype new password";
            cell.accessoryView = cell.editingAccessoryView = tf;
        }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.emailField]) {
        [self.passwordField becomeFirstResponder];
        [self.emailField resignFirstResponder];
    } else if ([textField isEqual:self.passwordField]) {
        [self.retypePasswordField becomeFirstResponder];
        [self.passwordField resignFirstResponder];
    } else {
        [self.retypePasswordField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.saveButton.enabled = YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.saveButton.enabled = YES;
    if ([textField isEqual:self.retypePasswordField]) {
        if (self.retypePasswordField.text.length > 0) {
            if (![self.passwordField.text isEqualToString:self.retypePasswordField.text]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:@"Passwords do not match!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                [alert addAction:actionOk];
                [self presentViewController:alert animated:YES completion:nil];
                
                self.saveButton.enabled = NO;
            }
        }
    }
}



# pragma mark - Private methods

- (NSMutableArray*) createNameFields {
    
    CGRect frame = CGRectMake(0, 0, self.tableView.bounds.size.width/2, 40);
    
    // email field
    self.emailField = [[UITextField alloc] initWithFrame:frame];
    self.emailField.font = _defaultFont;
    self.emailField.backgroundColor =[UIColor whiteColor];
    self.emailField.textAlignment = NSTextAlignmentLeft;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.returnKeyType = UIReturnKeyDone;
    self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailField.delegate = self;
    self.emailField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    
    // password field
    self.passwordField = [[UITextField alloc] initWithFrame:frame];
    self.passwordField.font = _defaultFont;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.textAlignment = NSTextAlignmentLeft;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.delegate = self;
    self.passwordField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.placeholder = @"Enter new password";
    
    // retype password field
    self.retypePasswordField = [[UITextField alloc] initWithFrame:frame];
    self.retypePasswordField.font = _defaultFont;
    self.retypePasswordField.backgroundColor = [UIColor whiteColor];
    self.retypePasswordField.textAlignment = NSTextAlignmentLeft;
    self.retypePasswordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.retypePasswordField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.retypePasswordField.returnKeyType = UIReturnKeyDone;
    self.retypePasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.retypePasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.retypePasswordField.delegate = self;
    self.retypePasswordField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.retypePasswordField.secureTextEntry = YES;
    self.retypePasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.retypePasswordField.borderStyle = UITextBorderStyleRoundedRect;
    self.retypePasswordField.placeholder = @"Retype new password";
    
    // create an array with all fields
    self.UIElements = [NSMutableArray arrayWithObjects:self.emailField, self.passwordField, self.retypePasswordField, nil];
    
    return self.UIElements;
}

-(void)logoutAction:(id) sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        UINavigationController* navController = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavigationController"];
        [self.navigationController presentViewController:navController animated:YES completion:nil];
    }
    
}

- (void)saveUpdatesAction:(id) sender {
    FIRUser *user = [FIRAuth auth].currentUser;
    
    NSString* email = self.emailField.text;
    [user updateEmail:email completion:^(NSError *_Nullable error) {
        if (error) {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Failed"
                                        message:[error localizedDescription]
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!"
                                                                           message:@"Your account information is updated"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    if (self.passwordField.text.length > 0) {
        NSString* password = self.passwordField.text;
        [user updatePassword:password completion:^(NSError *_Nullable error) {
            if (error) {
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Failed"
                                            message:[error localizedDescription]
                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                [alert addAction:actionOk];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    self.saveButton.enabled = NO;
    self.passwordField.text = @"";
    self.retypePasswordField.text = @"";
}

@end
