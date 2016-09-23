//
//  AddNewCustomerTableViewController.m
//  codetest
//
//  Created by Nikolai Tarasov on 9/12/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AddNewCustomerTableViewController.h"
#import "CustomerListViewController.h"
#import "FirebaseDatabaseManager.h"


@interface AddNewCustomerTableViewController ()
@end

@implementation AddNewCustomerTableViewController


-(id) initWithFirstName:(NSString*) firstName lastName:(NSString*) lastName dateOfBirth:(NSString*) dateOfBirth zipcode:(NSString*) zipcode key:(NSString*) key title:(NSString*) title {
    self = [super init];
    
    if (self) {
        self.UIElements = [[NSMutableArray alloc] init];
        self.UIElements = [self createNameFields];
        
        self.editingCustomerInfo = NO;
        
        if ([firstName length] > 0) {
            self.firstNameField.text = firstName;
            self.lastNameField.text = lastName;
            self.dateOfBirthField.text = dateOfBirth;
            self.zipcodeField.text = zipcode;
            
            self.customerKey = key;
            
            self.editingCustomerInfo = YES;
        }
        self.title = [title length] == 0 ? @"Add new customer" : title;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    _tvc = [[CustomerListViewController alloc] init];
    
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                           target:self
                                                                           action:@selector(saveAction:)];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancelAction:)];
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
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
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* title = @"Customer information";
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
    
    NSArray * cellText = @[@"First name", @"Last name", @"Date of Birth", @"Zipcode"];
    
    for (int i = 0; i < 4; i++) {
        if (indexPath.row == i) {
            UITextField *tf = (UITextField*)cell.accessoryView;
            tf = [self.UIElements objectAtIndex:i];
            cell.textLabel.text = [cellText objectAtIndex:i];
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
    if ([textField isEqual:self.firstNameField]) {
        [self.lastNameField becomeFirstResponder];
        [self.firstNameField resignFirstResponder];
    } else if ([textField isEqual:self.lastNameField]) {
        [self.dateOfBirthField becomeFirstResponder];
        [self.lastNameField resignFirstResponder];
    } else if ([textField isEqual:self.dateOfBirthField]) {
        [self.zipcodeField becomeFirstResponder];
        [self.dateOfBirthField resignFirstResponder];
    } else {
        [self.zipcodeField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = @"";
    self.saveButton.enabled = NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    int textSize;
    if ([textField isEqual:self.zipcodeField]) {
        textSize = 5;
    } else if ([textField isEqual:self.dateOfBirthField]) {
        textSize = 10;
    } else {
        return YES;
    }
    if (textField.text.length < textSize) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString* firstName = self.firstNameField.text;
    NSString* lastName = self.lastNameField.text;
    self.title = [firstName stringByAppendingString:[@" " stringByAppendingString: lastName]];
    if (self.firstNameField.text.length <= 0
        && self.lastNameField.text.length <= 0) {
        self.title = @"Add new customer";
    }
    if (self.firstNameField.text.length > 0
        && self.lastNameField.text.length > 0
        && self.dateOfBirthField.text.length > 0
        && self.zipcodeField.text.length > 0) {
        self.saveButton.enabled = YES;
    } else {
        self.saveButton.enabled = NO;
    }
    if (textField.text.length <= 0) {
        if ([textField isEqual:self.dateOfBirthField]) {
            textField.placeholder = @"Ex. mm-dd-yyyy";
        } else if ([textField isEqual:self.zipcodeField]) {
            textField.placeholder = @"Ex. 12345";
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    int textSize = 16; // by default
    
    if ([textField isEqual:self.zipcodeField]) {
        textSize = 5;
        NSCharacterSet *validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSRange r = [string rangeOfCharacterFromSet:validationSet];
        if (r.location != NSNotFound) {
            NSLog(@"the string contains illegal characters");
            return NO;
        }
    }
    
    if ([textField isEqual:self.dateOfBirthField]) {
        textSize = 10;
        NSCharacterSet *validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSRange r = [string rangeOfCharacterFromSet:validationSet];
        if (r.location != NSNotFound) {
            NSLog(@"the string contains illegal characters");
            return NO;
        }
        if (range.location == 2 || range.location == 5) {
            NSString *str  = [NSString stringWithFormat:@"%@-",textField.text];
            textField.text = str;
        }
    }
    
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    return newLength <= textSize;
}


#pragma mark - Private methods

- (NSMutableArray*) createNameFields {
    
    CGRect frame = CGRectMake(0, 0, self.tableView.bounds.size.width/2, 35);
    
    // first name field
    self.firstNameField = [[UITextField alloc] initWithFrame:frame];
    self.firstNameField.font = [UIFont fontWithName:@"Italic" size:14];
    self.firstNameField.backgroundColor=[UIColor whiteColor];
    self.firstNameField.textAlignment = NSTextAlignmentCenter;
    self.firstNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstNameField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.firstNameField.returnKeyType = UIReturnKeyDone;
    self.firstNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.firstNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.firstNameField.delegate = self;
    self.firstNameField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.firstNameField.borderStyle = UITextBorderStyleRoundedRect;
    
    
    // last name field
    self.lastNameField = [[UITextField alloc] initWithFrame:frame];
    self.lastNameField.font = [UIFont fontWithName:@"Italic" size:14];
    self.lastNameField.backgroundColor =[UIColor whiteColor];
    self.lastNameField.textAlignment = NSTextAlignmentCenter;
    self.lastNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastNameField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.lastNameField.returnKeyType = UIReturnKeyDone;
    self.lastNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.lastNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.lastNameField.delegate = self;
    self.lastNameField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.lastNameField.borderStyle = UITextBorderStyleRoundedRect;
    
    // date of birth field
    self.dateOfBirthField = [[UITextField alloc] initWithFrame:frame];
    self.dateOfBirthField.font = [UIFont fontWithName:@"Italic" size:14];
    self.dateOfBirthField.backgroundColor =[UIColor whiteColor];
    self.dateOfBirthField.placeholder = @"Ex. mm-dd-yyyy";
    self.dateOfBirthField.textAlignment = NSTextAlignmentCenter;
    self.dateOfBirthField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.dateOfBirthField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.dateOfBirthField.returnKeyType = UIReturnKeyDone;
    self.dateOfBirthField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.dateOfBirthField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.dateOfBirthField.delegate = self;
    self.dateOfBirthField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.dateOfBirthField.borderStyle = UITextBorderStyleRoundedRect;
    
    // zipcode field
    self.zipcodeField = [[UITextField alloc] initWithFrame:frame];
    self.zipcodeField.font = [UIFont fontWithName:@"Italic" size:14];
    self.zipcodeField.backgroundColor =[UIColor whiteColor];
    self.zipcodeField.placeholder = @"Ex. 12345";
    self.zipcodeField.textAlignment = NSTextAlignmentCenter;
    self.zipcodeField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.zipcodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.zipcodeField.returnKeyType = UIReturnKeyDone;
    self.zipcodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.zipcodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.zipcodeField.delegate = self;
    self.zipcodeField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.zipcodeField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.UIElements = [NSMutableArray arrayWithObjects:self.firstNameField, self.lastNameField,
                       self.dateOfBirthField, self.zipcodeField, nil];
    
    return self.UIElements;
}


- (void) saveAction:(UIButton*) button {
    
    NSString* firstName = self.firstNameField.text;
    NSString* lastName = self.lastNameField.text;
    NSString* dateOfBirth = self.dateOfBirthField.text;
    NSString* zipcode = self.zipcodeField.text;
    
    FIRDatabaseReference* childRef;
    
    if (self.editingCustomerInfo) {
        childRef = [[[FirebaseDatabaseManager sharedReference] child:@"customers"] child:self.customerKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited existing customer" object:self];
    } else {
        childRef = [[[FirebaseDatabaseManager sharedReference] child:@"customers"] childByAutoId];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Added new customer" object:self];
    }
    
    // save data in DB
    [[childRef child:@"firstName"] setValue:firstName];
    [[childRef child:@"lastName"] setValue:lastName];
    [[childRef child:@"dateOfBirth"] setValue:dateOfBirth];
    [[childRef child:@"zipcode"] setValue:zipcode];
    
    // play sound effect
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"glass_ping" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath: path];
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    
    // switch to view with list of customers
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 1] animated:YES];
}

- (void) cancelAction:(UIButton*) button {
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 1] animated:YES];
}


@end
