//
//  LaunchViewController.h
//  codetest
//
//  Created by Nikolai Tarasov on 9/12/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) UITextField *emailField;
@property (retain, nonatomic) UITextField *passwordField;

@end
