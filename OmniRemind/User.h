//
//  User.h
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *familyname;
@property (strong, nonatomic) PFUser *pfuser;

- (NSString *)getUserName;
- (NSString *)getFamilyName;
- (PFUser *)getPFUser;
- (void) setUser:(PFUser *)pfuser;

@end
