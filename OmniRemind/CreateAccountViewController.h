//
//  CreateAccountViewController.h
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "SVProgressHUD.h"

@interface CreateAccountViewController : UIViewController <UITextFieldDelegate> {
    BOOL SignupSuccess;
}
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;
@property (strong, nonatomic) IBOutlet UITextField *userRetypePassword;
@property (strong, nonatomic) IBOutlet UITextField *userFamily;
@property (strong, nonatomic) IBOutlet UITextField *userEmail;

- (IBAction)onCreateAccount:(id)sender;
- (IBAction)onCancel:(id)sender;

@end
