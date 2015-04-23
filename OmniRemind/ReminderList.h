//
//  ReminderList.h
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"
#import <Parse/Parse.h>

@interface ReminderList : NSObject

@property (strong, nonatomic) NSString *familyname;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSMutableArray *listitem;

- (NSString *)getUserName;
- (NSString *)getFamilyName;
- (NSMutableArray *)getList;
- (void)addReminder:(PFObject *)pfreminder;
- (void)removeReminder:(PFObject *)pfreminder;
- (Reminder *)getReminderAtIndex:(NSInteger)index;
- (void)fetchFromParse;
@end
