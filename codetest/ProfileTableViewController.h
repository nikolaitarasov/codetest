//
//  ProfileTableViewController.h
//  codetest
//
//  Created by Nikolai Tarasov on 9/28/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>

@property(retain, nonatomic) UIBarButtonItem* saveButton;

@property (retain, nonatomic) UITextField *emailField;
@property (retain, nonatomic) UITextField *passwordField;
@property (retain, nonatomic) UITextField *retypePasswordField;

@end
