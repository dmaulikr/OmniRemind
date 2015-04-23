//
//  AddReminderViewController.h
//  OmniRemind
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Reminder.h"
#import "ReminderList.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "LocationPickerViewController.h"
#import "ReminderListViewController.h"
#import "Common.h"


@interface AddReminderViewController : UIViewController <UITextFieldDelegate>
- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;
- (IBAction)onPickUpLocation:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *topBar;
//@property (strong, nonatomic) User *user;
//@property (strong, nonatomic) ReminderList *list;
@property (strong, nonatomic) NSString *userPickLocationX;
@property (strong ,nonatomic) NSString *userPickLocationY;
@property (strong ,nonatomic) NSString *userInputContent;
@property (strong ,nonatomic) NSDate *userInputDate;
@property (strong, nonatomic) IBOutlet UITextField *userContent;
@property (strong, nonatomic) IBOutlet UIDatePicker *userDueDate;
@property (strong, nonatomic) IBOutlet UILabel *locationCoordinate;

@end
