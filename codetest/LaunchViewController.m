//
//  LaunchViewController.m
//  codetest
//
//  Created by Nikolai Tarasov on 9/12/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import "LaunchViewController.h"
#import "CreateAccountViewController.h"
#import "CustomerListViewController.h"
#import "AppDelegate.h"

@import Firebase;

@interface LaunchViewController ()
@end

@implementation LaunchViewController

static NSString* emailPlaceholder = @" Email";
static NSString* passwordPlaceholder = @" Password";


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prefersStatusBarHidden];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    
    // set background image
    UIImage *image = [UIImage imageNamed:@"launch_image.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y,
                                 image.size.width, image.size.height);
    imageView.frame = self.view.bounds;
    [imageView setUserInteractionEnabled:YES];
    [self.view addSubview:imageView];
    
    // create title label
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(
                                            self.view.center.x-140, self.view.center.y-130, 270, 45)];
    label.text = @"Customer List";
    label.font = [UIFont fontWithName:@"AvenirNext-Bold" size:40];
    label.textColor = [UIColor whiteColor];
    [imageView addSubview:label];
    
    // create login fields
    [self createLoginFields];
    [imageView addSubview: self.emailField];
    [imageView addSubview: self.passwordField];
    [[UITextField appearance] setTintColor:[UIColor blackColor]];
    
    // create button 'Login'
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(self.view.center.x-115, self.view.center.y+120, 230, 40)];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 10;
    loginButton.clipsToBounds = YES;
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 26];
    [loginButton setTitleColor:([UIColor whiteColor]) forState:UIControlStateNormal];
    CALayer *layer = loginButton.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.cornerRadius = 8.0f;
    layer.borderWidth = 1.0f;
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.userInteractionEnabled = YES;
    [imageView addSubview:loginButton];
    
    // create button 'Create new account'
    UIButton *createAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [createAccountButton setFrame:CGRectMake(self.view.center.x-100, self.view.center.y+170, 200, 35)];
    [createAccountButton setTitle:@"Create New Account" forState:UIControlStateNormal];
    
    createAccountButton.titleLabel.font = [UIFont boldSystemFontOfSize: 16];
    [createAccountButton setTitleColor:([UIColor whiteColor]) forState:UIControlStateNormal];
    [createAccountButton titleColorForState:UIControlStateNormal];
    [createAccountButton addTarget:self action:@selector(createAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    createAccountButton.userInteractionEnabled = YES;
    [imageView addSubview:createAccountButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.emailField]) {
        [self.passwordField becomeFirstResponder];
        [self.emailField resignFirstResponder];
    } else {
        [self.passwordField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = @"";
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.title = @"Login to your account";
    if (textField.text.length <= 0) {
        if ([textField isEqual:self.emailField]) {
            textField.placeholder = emailPlaceholder;
        } else if ([textField isEqual:self.passwordField]) {
            textField.placeholder = passwordPlaceholder;
        }
    }
}



#pragma mark - Private methods

- (void) createLoginFields {
    UIFont* defaultFont = [UIFont fontWithName:@"Helvetica" size:20];
    
    // email field
    self.emailField = [[UITextField alloc] initWithFrame:
        CGRectMake(self.view.center.x-135, self.view.center.y-20, self.view.bounds.size.width/2+70, 45)];
    self.emailField.font = defaultFont;
    self.emailField.backgroundColor =[UIColor whiteColor];
    self.emailField.placeholder = emailPlaceholder;
    self.emailField.textAlignment = NSTextAlignmentLeft;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.emailField.returnKeyType = UIReturnKeyDone;
    self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailField.delegate = self;
    self.emailField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    
    // password field
    self.passwordField = [[UITextField alloc] initWithFrame:
        CGRectMake(self.view.center.x-135, self.view.center.y+35, self.view.bounds.size.width/2+70, 45)];
    self.passwordField.font = defaultFont;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.placeholder = passwordPlaceholder;
    self.passwordField.textAlignment = NSTextAlignmentLeft;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.passwordField.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.delegate = self;
    self.passwordField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
}


-(void) loginAction:(UIButton*) button {
    NSString* email = self.emailField.text;
    NSString* password = self.passwordField.text;
   
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    if (email.length <= 0 && password.length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                    message:@"Please enter your email address and password!"
                                             preferredStyle:UIAlertControllerStyleAlert];
        if (alert) {
            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else if (email <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                    message:@"Please enter your email address!"
                                             preferredStyle:UIAlertControllerStyleAlert];
        if (alert) {
            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else if (password <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                    message:@"Please enter your password!"
                                             preferredStyle:UIAlertControllerStyleAlert];
        if (alert) {
            [alert addAction:actionOk];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        
        if (email <= 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                        message:@"Please enter your email address!"
                                                 preferredStyle:UIAlertControllerStyleAlert];
            if (alert) {
                [alert addAction:actionOk];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        if (password.length < 4) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                        message:@"Password must be greater than 8 characters!"
                                                 preferredStyle:UIAlertControllerStyleAlert];
            if (alert) {
                [alert addAction:actionOk];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
        // create ui activity indicator
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.view addSubview:activityIndicator];
        
        [[FIRAuth auth] signInWithEmail:email
                               password:password
                             completion:^(FIRUser *user, NSError *error) {
                                 [activityIndicator startAnimating];
                                 
                                 if (user != nil) {
                                     dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                                         //Background Thread
                                         dispatch_async(dispatch_get_main_queue(), ^(void){
                                             UITabBarController* tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"UITabBarController"];
                                             [self.navigationController pushViewController:tabBarController animated:YES];
                                         });
                                     });
                                     
                                 } else {
                                     UIAlertController * failureAlert = nil;
                                     if (error.code == 101) {
                                         failureAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                            message:@"Invalid username/password"
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                     } else {
                                         failureAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                            message:@"Login failed"
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                     }
                                     [failureAlert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                                                      style:UIAlertActionStyleDefault
                                                                                    handler:nil]];
                                     [self presentViewController:failureAlert animated:YES completion:nil];
                                 }
                             }];
        [activityIndicator stopAnimating];
    }
}

-(void) createAccountAction:(UIButton*) button {
    CreateAccountViewController* vc =
                            [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
