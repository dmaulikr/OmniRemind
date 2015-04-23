//
//  User.m
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "User.h"

@implementation User


- (NSString *)getFamilyName{
    return _familyname;
}

- (NSString *)getUserName{
    return _username;
}

- (PFUser *)getPFUser{
    return _pfuser;
}

- (void) setUser:(PFUser *)pfuser{
    _username = pfuser[@"username"];
    _familyname = pfuser[@"familyname"];
}


@end
