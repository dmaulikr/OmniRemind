//
//  ReminderMapViewController.h
//  OmniRemind
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "User.h"
#import "Reminder.h"
#import "ReminderList.h"
#import "ReminderListViewController.h"
#import "Common.h"

@interface ReminderMapViewController : UIViewController <MKMapViewDelegate,MKAnnotation,CLLocationManagerDelegate>

//@property (strong, nonatomic) User *user;
//@property (strong, nonatomic) ReminderList *list;
@property (strong ,nonatomic) NSString *userInputContent;
@property (strong ,nonatomic) NSDate *userInputDate;
@property (strong, nonatomic) IBOutlet UILabel *topBar;
@property (strong, nonatomic) IBOutlet MKMapView *reminderMap;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)onList:(id)sender;
- (void)loadAnnotations;
- (void)startLocationService;

@end
