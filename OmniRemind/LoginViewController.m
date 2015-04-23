//
//  LoginViewController.m
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        _userName.text = currentUser.username;
        [glb_user setUser:currentUser];
        [SVProgressHUD showWithStatus:@"Loading User Information..."];
        [glb_user setUser:currentUser];
        [glb_reminderList setUsername:currentUser[@"username"]];
        [glb_reminderList setFamilyname:currentUser[@"familyname"]];
        PFQuery *query1 = [PFQuery queryWithClassName:@"Reminder"];
        [query1 whereKey:@"username" equalTo:currentUser[@"username"]];
        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error" message:@"Network Error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                for (PFObject *ob in objects){
                    [glb_reminderList addReminder:ob];
                }
                [SVProgressHUD dismiss];
                //ReminderListViewController *pReminderListController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"ReminderList"];
                //[self.navigationController pushViewController:pReminderListController animated:YES];
                [self performSegueWithIdentifier:@"toListView" sender:self];
            }
            
        }];
    // Do any additional setup after loading the view from its nib.
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isSignPossible
{
    if (_userName.text.length == 0 || _userPassword.text.length == 0) {
        return NO;
    }
    
    return YES;
}

- (IBAction)signIn:(id)sender {
    if ([self isSignPossible]) {
        [SVProgressHUD showWithStatus:@"Logging in ..."
                             maskType:SVProgressHUDMaskTypeNone];
        [PFUser logInWithUsernameInBackground:_userName.text password:_userPassword.text target:self selector:@selector(handleUserLogin:error:)];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please check information again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)signUp:(id)sender {
    CreateAccountViewController *pCreateAccountView = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"CreateAccount"];
    [self.navigationController pushViewController:pCreateAccountView animated:YES];
}


- (void)handleUserLogin:(PFUser *)user error:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    if (error.code == 101) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"You must enter the correct login & password to register or login, try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }else if (error.code == 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Network error, would you like to work offline?"
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
        
        [alert show];
    }
    else if (!error)
    {
        if (user) {
            [SVProgressHUD showWithStatus:@"Loading User Informations.."];
            PFUser *pfuser = [PFUser currentUser];
            [glb_user setUser:pfuser];
            [glb_reminderList setUsername:pfuser[@"username"]];
            [glb_reminderList setFamilyname:pfuser[@"familyname"]];
            PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
            [query whereKey:@"username" equalTo:pfuser[@"username"]];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Error" message:@"Network Error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    for (PFObject *ob in objects) {
                        [glb_reminderList addReminder:ob];
                    }
                    [SVProgressHUD dismiss];
                    [self performSegueWithIdentifier:@"toListView" sender:self];
                    //ReminderListViewController *pReminderListController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"ReminderList"];
                    //[self.navigationController pushViewController:pReminderListController animated:YES];
                }
            }];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"Incorrect user name and Password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toListView"]){
        ReminderListViewController *transferViewController = segue.destinationViewController;
        transferViewController.user = _user;
        transferViewController.list = _reminderlist;
    }
}
*/


@end
