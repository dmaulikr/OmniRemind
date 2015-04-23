//
//  AddReminderViewController.m
//  OmniRemind
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _topBar.text = [NSString stringWithFormat:@"%@'s New Reminder",glb_user.username];
    _userContent.delegate = self;
    _locationCoordinate.text = [NSString stringWithFormat:@"(%@,%@)",_userPickLocationX,_userPickLocationY];
    _userContent.text = _userInputContent;
    _userDueDate.date = _userInputDate;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onBack:(id)sender {
    [self performSegueWithIdentifier:@"toReminderListView" sender:self];
}

- (IBAction)onDone:(id)sender {
    if (_userPickLocationY != nil && _userPickLocationX != nil){
        [SVProgressHUD showWithStatus:@"Saving..."];
        PFObject *newreminder = [PFObject objectWithClassName:@"Reminder"];
        newreminder[@"username"] = glb_user.username;
        newreminder[@"familyname"] = glb_user.familyname;
        newreminder[@"content"] = _userContent.text;
        newreminder[@"duedate"] = _userDueDate.date;
        newreminder[@"locationx"] = _userPickLocationX;
        newreminder[@"locationy"] = _userPickLocationY;
        newreminder[@"timestatus"] = @"NO";
        newreminder[@"locationstatus"] = @"NO";
        newreminder[@"pushed"] = @"YES";
        [newreminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded){
                [glb_reminderList addReminder:newreminder];
                [SVProgressHUD dismiss];
                
                
                [self performSegueWithIdentifier:@"toReminderListView" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Network Error!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Pick A Location!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (IBAction)onPickUpLocation:(id)sender {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toLocationPickerView"]){
        LocationPickerViewController *transferViewController = segue.destinationViewController;
        transferViewController.userPickLocationX = _userPickLocationX;
        transferViewController.userPickLocationY = _userPickLocationY;
        transferViewController.userInputContent = _userContent.text;
        transferViewController.userInputDate = _userDueDate.date;
        //transferViewController.user = _user;
        //transferViewController.list = _list;
    }
    if ([segue.identifier isEqualToString:@"toReminderListView"]){
        ReminderListViewController *transferViewController = segue.destinationViewController;
        //transferViewController.user = _user;
        //transferViewController.list = _list;
    }
}

@end
