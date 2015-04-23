//
//  ReminderList.m
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "ReminderList.h"

@implementation ReminderList

-(id)init
{
    self = [super init];
    if(self)
    {
        self.listitem =[NSMutableArray array];
    }
    return self;
}

- (NSString *) getFamilyName{
    return _familyname;
}

- (NSMutableArray *)getList{
    return _listitem;
}


- (void) addReminder:(PFObject *)pfreminder{
    Reminder *reminder = [[Reminder alloc]init];
    reminder.username = pfreminder[@"username"];
    reminder.duedate = pfreminder[@"duedate"];
    reminder.familyname = pfreminder[@"familyname"];
    reminder.content = pfreminder[@"content"];
    reminder.pushstatus = pfreminder[@"pushed"];
    reminder.pfobject = pfreminder;
    [reminder setLocationX:pfreminder[@"locationx"] Y:pfreminder[@"locationy"]];
    if ([pfreminder[@"timestatus"]  isEqual: @"YES"]){
        [reminder setTimeActivated];
    } else {
        [reminder setTimeDeactivated];
    }
    if ([pfreminder[@"locationstatus"]  isEqual: @"YES"]){
        [reminder setLocationActivated];
    } else {
        [reminder setLocationDeactivated];
    }
    [_listitem addObject:reminder];
}

- (void) removeReminder:(PFObject *)pfreminder{
    for (Reminder *ob in [_listitem copy]){
        if (ob.pfobject == pfreminder){
            [_listitem removeObject:ob];
        }
    }
}

- (Reminder *)getReminderAtIndex:(NSInteger)index{
    return [_listitem objectAtIndex:index];
}

- (NSString *)getUserName{
    return self.username;
}

- (void)fetchFromParse{
    if (self.username != nil){
        PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
        [query whereKey:@"username" equalTo:self.username];
        [query whereKey:@"pushed" equalTo:@"NO"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                
            }
            else{
                for (PFObject *ob in objects){
                    ob[@"pushed"] = @"YES";
                    [ob saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [self addReminder:ob];
                    }];
                }
            }
        }];
    }
}
@end
