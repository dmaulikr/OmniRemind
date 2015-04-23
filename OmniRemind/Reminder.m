//
//  Reminder.m
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

- (NSString *)getPushStatus{
    return _pushstatus;
}

- (NSString *)getUserName{
    return _username;
}

- (NSString *)getFamilyName{
    return _familyname;
}

- (NSString *)getContent{
    return _content;
}

- (NSDate *)getDueDate{
    return _duedate;
}

- (PFObject *)getPFObject{
    return _pfobject;
}

- (CLLocationCoordinate2D)getLocation{
    return location;
}

- (void)setLocationX:(NSString *)x Y:(NSString *)y{
    location.longitude = x.doubleValue;
    location.latitude = y.doubleValue;
}

- (void)setTimeActivated{
    isTimeActivated = YES;
}

- (void)setTimeDeactivated{
    isTimeActivated = NO;
}

- (void)setLocationActivated{
    isLocationActivated = YES;
}

- (void)setLocationDeactivated{
    isLocationActivated = NO;
}

- (BOOL)getTimeStatus{
    return isTimeActivated;
}

- (BOOL)getLocationStatus{
    return isLocationActivated;
}
@end
