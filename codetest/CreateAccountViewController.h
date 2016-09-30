//
//  CreateAccountViewController.h
//  codetest
//
//  Created by Nikolai Tarasov on 9/12/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>

@property (retain, nonatomic) UITextField *emailField;
@property (retain, nonatomic) UITextField *passwordField;
@property (retain, nonatomic) UITextField *retypePasswordField;

@property (retain, nonatomic) UIButton *createKey;

@property(retain, nonatomic) UIBarButtonItem* doneButton;

@end
