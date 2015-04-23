//
//  LoginViewController.h
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "CreateAccountViewController.h"
#import <Parse/Parse.h>
#import "Reminder.h"
#import "ReminderList.h"
#import "User.h"
#import "ReminderListViewController.h"
#import "Common.h"


@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;
//@property (strong, nonatomic) ReminderList *reminderlist;
//@property (strong ,nonatomic) User *user;
- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;


@end
