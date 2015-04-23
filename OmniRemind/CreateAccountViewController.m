//
//  CreateAccountViewController.m
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "CreateAccountViewController.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SignupSuccess = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isPossibleCreateAccount
{
    if (_userName.text.length == 0 || _userPassword.text.length == 0 || _userFamily.text.length == 0
        || _userRetypePassword.text.length == 0 || _userEmail.text.length == 0) {
        return NO;
    }
    
    if (![_userPassword.text isEqualToString:_userRetypePassword.text]) {
        return NO;
    }
    
    return YES;
}



- (IBAction)onCreateAccount:(id)sender {
    if ([self isPossibleCreateAccount]) {
        [SVProgressHUD showWithStatus:@"Creating Account.."];
        [self registerUserToParse];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"Please check informations!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

-(void)registerUserToParse
{
    PFUser *user = [PFUser user];
    user.username = _userName.text;
    user.email = _userEmail.text;
    user.password = _userPassword.text;
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            user[@"familyname"] = _userFamily.text;
            [self performSelectorOnMainThread:@selector(signup_success) withObject:nil waitUntilDone:NO];
        } else {
            if (error.code == 100) { // network error
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Network error, would you like to work offline?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Yes"
                                                      otherButtonTitles:@"No", nil];
                [alert show];
                
            } else if ((error.code == 202) || (error.code == 203)) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You The email address is already taken by other user." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Sorry, unknown error. Try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        [SVProgressHUD dismiss];
    }];
}

- (void)signup_success
{
    PFUser *pfuser = [PFUser currentUser];
    
    [pfuser save];
    
    SignupSuccess = YES;
    
    [SVProgressHUD dismiss];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"Register Success!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if (SignupSuccess && [title isEqualToString:@"Ok"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)isSamePassword
{
    if (_userPassword.text.length != 0 && [_userPassword.text isEqualToString:_userRetypePassword.text]) {
        return YES;
    }
    return NO;
}


@end
