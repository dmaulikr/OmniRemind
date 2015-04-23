//
//  Reminder.h
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Reminder : NSObject {
    CLLocationCoordinate2D location;
    BOOL isTimeActivated;
    BOOL isLocationActivated;
}

@property (strong, nonatomic) NSDate *duedate;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *familyname;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) PFObject *pfobject;
@property (strong, nonatomic) NSString *pushstatus;


- (NSString *)getUserName;
- (NSString *)getFamilyName;
- (NSDate *)getDueDate;
- (NSString *)getContent;
- (PFObject *)getPFObject;
- (CLLocationCoordinate2D)getLocation;
- (void)setLocationX:(NSString *)x Y:(NSString *)y;
- (void)setTimeActivated;
- (void)setTimeDeactivated;
- (void)setLocationActivated;
- (void)setLocationDeactivated;
- (BOOL)getTimeStatus;
- (BOOL)getLocationStatus;
- (NSString *)getPushStatus;


@end
