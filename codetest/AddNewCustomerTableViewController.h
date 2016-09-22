//
//  AddNewCustomerTableViewController.h
//  codetest
//
//  Created by Nikolai Tarasov on 9/12/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomerListViewController.h"

@interface AddNewCustomerTableViewController : UITableViewController <UITextFieldDelegate, AVAudioPlayerDelegate>

@property(strong, nonatomic) NSMutableArray* UIElements;
@property(retain, nonatomic) UITextField* firstNameField;
@property(retain, nonatomic) UITextField* lastNameField;
@property(retain, nonatomic) UITextField* dateOfBirthField;
@property(retain, nonatomic) UITextField* zipcodeField;
@property(retain, nonatomic) UIBarButtonItem* saveButton;
@property(retain, nonatomic) UIView* cellView;
@property(retain, nonatomic) NSIndexPath* indexPathOfSelectedCell;
@property (assign, nonatomic) BOOL editingCustomerInfo;
@property(strong, nonatomic) NSString* customerKey;
@property (retain, nonatomic) CustomerListViewController* tvc;

-(id) initWithFirstName:(NSString*) firstName lastName:(NSString*) lastName dateOfBirth:(NSString*) dateOfBirth zipcode:(NSString*) zipcode key:(NSString*) key title:(NSString*) title;
- (NSMutableArray*) createNameFields;

@end
