//
//  LocationPickerViewController.h
//  OmniRemind
//
//  Created by Chubin OU on 3/12/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Reminder.h"
#import "ReminderList.h"
#import <MapKit/MapKit.h>
#import "AddReminderViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Common.h"


@interface LocationPickerViewController : UIViewController <MKMapViewDelegate, MKAnnotation, UISearchBarDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) NSString *userPickLocationX;
@property (strong ,nonatomic) NSString *userPickLocationY;
@property (strong ,nonatomic) NSString *userInputContent;
@property (strong ,nonatomic) NSDate *userInputDate;
//@property (strong, nonatomic) User *user;
//@property (strong, nonatomic) ReminderList *list;

@property (strong, nonatomic) IBOutlet UISearchBar *userSearchBar;
@property (strong, nonatomic) IBOutlet MKMapView *userMap;
- (IBAction)onBack:(id)sender;
- (IBAction)onCurrentLocation:(id)sender;
- (IBAction)onPick:(id)sender;


@end
