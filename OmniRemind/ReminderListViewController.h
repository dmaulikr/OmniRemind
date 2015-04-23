//
//  ReminderListViewController.h
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Reminder.h"
#import "ReminderList.h"
#import "AddReminderViewController.h"
#import "ReminderMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Common.h"

@interface ReminderListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate, UIGestureRecognizerDelegate>



//@property (strong, nonatomic) User *user;
//@property (strong, nonatomic) ReminderList *list;
@property (strong, nonatomic) IBOutlet UILabel *topBar;
@property (strong, nonatomic) IBOutlet UITableView *reminderListTable;
@property (strong, nonatomic) CLLocationManager *locationManager;



- (void)timeButtonPressed:(id)sender;
- (void)locationButtonPressed:(id)sender;
- (BOOL)addTimeNotificationAtDate:(NSDate *)date withContent:(NSString *)content;
- (BOOL)removeTimeNotificationAtDate:(NSDate *)date withContent:(NSString *)content;
- (BOOL)addLocationNotificationAtLocation:(CLLocationCoordinate2D)location withContent:(NSString *)content;
- (BOOL)removeLocationNotificationAtLocation:(CLLocationCoordinate2D)location withContent:(NSString *)content;
- (void)startLocationService;
- (BOOL)deleteReminderAtIndexPath:(NSIndexPath *)indexPath;
- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer;
- (void)startTimer;
- (void)cancelTimer;
- (void)refreshUI;
@end
