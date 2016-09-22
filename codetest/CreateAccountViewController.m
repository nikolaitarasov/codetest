//
//  CreateAccountViewController.m
//  codetest
//
//  Created by Nikolai Tarasov on 9/12/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "CustomerListViewController.h"

@interface CreateAccountViewController ()
@property(strong, nonatomic) NSMutableArray* UIElements;
@property(weak, nonatomic) UIFont* defaultFont;

@end

@import Firebase;

@implementation CreateAccountViewController

static NSString* namePlaceholder = @"Enter full name";
static NSString* emailPlaceholder = @"Enter email address";
static NSString* passwordPlaceholder = @"Enter password";
static NSString* retypePasswordPlaceholder = @"Retype password";

@synthesize createKey = _createKey;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Create new account";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.tableView.delegate = self;
    
    self.UIElements = [[NSMutableArray alloc] init];
    self.UIElements = [self createNameFields];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(doneAction:)];

    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.doneButton.enabled = NO;
    
    _defaultFont = [UIFont fontWithName:@"Helvetica" size:16];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) doneAction:(UIButton*) button {
    
    if (self.nameField.text.length <= 0
        || self.emailField.text.length <= 0
        || self.passwordField.text.length <= 0
        || self.retypePasswordField.text.length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"All fields are required!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:actionOk];
        [self presentViewController:alert animated:YES completion:nil];
        self.doneButton.enabled = NO;
        return;
    }
    
    // create ui activity indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityIndicator];
    
    // Create new user
    [[FIRAuth auth] createUserWithEmail:self.emailField.text
                           password:self.passwordField.text
                         completion:^(FIRUser *user, NSError *error) {
                             
        [activityIndicator startAnimating];
        
        if (!error) {
            [activityIndicator stopAnimating];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!"
                                                                           message:@"Your account is created"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action){
            CustomerListViewController* vc = [[CustomerListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];}];
            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [activityIndicator stopAnimating];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITextField *tf = (UITextField*)cell.accessoryView;
            tf = [self.UIElements objectAtIndex:0];
            cell.textLabel.text = @"Full name";
            cell.accessoryView = cell.editingAccessoryView = tf;
        } else if (indexPath.row == 1) {
            UITextField *tf = (UITextField*)cell.accessoryView;
            tf = [self.UIElements objectAtIndex:1];
            cell.textLabel.text = @"Email address";
            cell.accessoryView = cell.editingAccessoryView = tf;
        } else if (indexPath.row == 2) {
            UITextField *tf = (UITextField*)cell.accessoryView;
            tf = [self.UIElements objectAtIndex:2];
            cell.textLabel.text = @"Password";
            cell.accessoryView = cell.editingAccessoryView = tf;
        } else if (indexPath.row == 3) {
            UITextField *tf = (UITextField*)cell.accessoryView;
            tf = [self.UIElements objectAtIndex:3];
            cell.textLabel.text = @"Retype password";
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
    if ([textField isEqual:self.nameField]) {
        [self.emailField becomeFirstResponder];
        [self.nameField resignFirstResponder];
    } else if ([textField isEqual:self.emailField]) {
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
    textField.placeholder = @"";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    self.doneButton.enabled = NO;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.doneButton.enabled = YES;
    textField.borderStyle = UITextBorderStyleNone;
    NSString* name = self.nameField.text;
    self.title = self.nameField.text.length > 0 ? name : @"Create new account";
    if (textField.text.length <= 0) {
        if ([textField isEqual:self.nameField]) {
            textField.placeholder = namePlaceholder;
        } else if ([textField isEqual:self.emailField]) {
            textField.placeholder = emailPlaceholder;
        } else if ([textField isEqual:self.passwordField]) {
            textField.placeholder = passwordPlaceholder;
        } else {
            textField.placeholder = retypePasswordPlaceholder;
        }
    }
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
            
                self.doneButton.enabled = NO;
            }
        }
    }
}


#pragma mark - Private methods

- (NSMutableArray*) createNameFields {
    
    CGRect frame = CGRectMake(0, 0, self.tableView.bounds.size.width/2, 40);
    
    // full name field
    self.nameField = [[UITextField alloc] initWithFrame:frame];
    self.nameField.font = _defaultFont;
    self.nameField.backgroundColor=[UIColor whiteColor];
    self.nameField.placeholder = namePlaceholder;
    self.nameField.textAlignment = NSTextAlignmentLeft;
    self.nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.nameField.returnKeyType = UIReturnKeyDone;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameField.delegate = self;
    self.nameField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    // email field
    self.emailField = [[UITextField alloc] initWithFrame:frame];
    self.emailField.font = _defaultFont;
    self.emailField.backgroundColor =[UIColor whiteColor];
    self.emailField.placeholder = emailPlaceholder;
    self.emailField.textAlignment = NSTextAlignmentLeft;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.returnKeyType = UIReturnKeyDone;
    self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailField.delegate = self;
    self.emailField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // password field
    self.passwordField = [[UITextField alloc] initWithFrame:frame];
    self.passwordField.font = _defaultFont;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.placeholder = passwordPlaceholder;
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
    
    // retype password field
    self.retypePasswordField = [[UITextField alloc] initWithFrame:frame];
    self.retypePasswordField.font = _defaultFont;
    self.retypePasswordField.backgroundColor = [UIColor whiteColor];
    self.retypePasswordField.placeholder = retypePasswordPlaceholder;
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
    
    // create an array with all fields
    self.UIElements = [NSMutableArray arrayWithObjects:self.nameField, self.emailField, self.passwordField, self.retypePasswordField, nil];
    
    return self.UIElements;
}


@end
