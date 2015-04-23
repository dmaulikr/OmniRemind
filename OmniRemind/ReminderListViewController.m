//
//  ReminderListViewController.m
//  RemindMe
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "ReminderListViewController.h"

@interface ReminderListViewController ()

@end

@implementation ReminderListViewController{
    CLLocationManager *locationManager;
    dispatch_source_t _timer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self startLocationService];
    [self startTimer];
    _topBar.text = [NSString stringWithFormat:@"%@ in %@'s Family",glb_user.username,glb_user.familyname];
    _reminderListTable.delegate = self;
    _reminderListTable.dataSource = self;
    UITapGestureRecognizer *taprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleDoubleTap:)];
    [taprecognizer setNumberOfTapsRequired:2];
    taprecognizer.delegate = self;
    [self.reminderListTable addGestureRecognizer:taprecognizer];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [glb_reminderList.listitem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableIdentifier = @"ReminderItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableIdentifier];
    }
    Reminder *tmp = [glb_reminderList.listitem objectAtIndex:indexPath.row];
    [cell.textLabel setText:tmp.content];
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    timeButton.frame = CGRectMake(200.0f,6.0f,50.0f,30.0f);
    if (tmp.getTimeStatus){
        [timeButton setBackgroundColor:[UIColor greenColor]];
    } else {
        [timeButton setBackgroundColor:[UIColor grayColor]];
    }
    [timeButton setTitle:@"Time" forState:UIControlStateNormal];
    [timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    timeButton.layer.cornerRadius = 5;
    timeButton.layer.masksToBounds = YES;
    [timeButton addTarget:self action:@selector(timeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:timeButton];
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    locationButton.frame = CGRectMake(260.0f, 6.0f, 50.0f, 30.0f);
    if (tmp.getLocationStatus){
        [locationButton setBackgroundColor:[UIColor greenColor]];
    } else {
        [locationButton setBackgroundColor:[UIColor grayColor]];
    }
    [locationButton setTitle:@"Locale" forState:UIControlStateNormal];
    [locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    locationButton.layer.cornerRadius = 5;
    locationButton.layer.masksToBounds = YES;
    [locationButton addTarget:self action:@selector(locationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:locationButton];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Tapped at %ld",(long)indexPath.row);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timeButtonPressed:(id)sender{
    if ([sender backgroundColor] == [UIColor grayColor]){
        [sender setBackgroundColor:[UIColor greenColor]];
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.reminderListTable];
        NSIndexPath *indexPath = [self.reminderListTable indexPathForRowAtPoint:buttonPosition];
        NSInteger index = indexPath.row;
        if (indexPath!=nil){
            NSLog(@"timeButtonActivated at %ld",(long)indexPath.row);
            [[glb_reminderList getReminderAtIndex:index] setTimeActivated];
            PFObject *tmppfreminder = [[glb_reminderList getReminderAtIndex:index] getPFObject];
            tmppfreminder[@"timestatus"] = @"YES";
            [tmppfreminder saveInBackground];
            if([self addTimeNotificationAtDate:[[glb_reminderList getReminderAtIndex:index] getDueDate] withContent:[[glb_reminderList getReminderAtIndex:index] getContent]]){
                NSLog(@"TimeNotification added");
            };
        } else {
            NSLog(@"timeButtonPressed Failed");
        }
    }
    else {
        [sender setBackgroundColor:[UIColor grayColor]];
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.reminderListTable];
        NSIndexPath *indexPath = [self.reminderListTable indexPathForRowAtPoint:buttonPosition];
        NSInteger index = indexPath.row;
        if (indexPath!=nil){
            NSLog(@"timeButtonActivated at %ld",(long)indexPath.row);
            [[glb_reminderList getReminderAtIndex:index] setTimeDeactivated];
            PFObject *tmppfreminder = [[glb_reminderList getReminderAtIndex:index] getPFObject];
            tmppfreminder[@"timestatus"] = @"NO";
            [tmppfreminder saveInBackground];
            if ([self removeTimeNotificationAtDate:[[glb_reminderList getReminderAtIndex:index] getDueDate] withContent:[[glb_reminderList getReminderAtIndex:index] getContent]]){
                NSLog(@"TimeNotification removed");
            }
        } else {
            NSLog(@"timeButtonPressed Failed");
        }
    }
}

- (void)locationButtonPressed:(id)sender{
    if ([sender backgroundColor] == [UIColor grayColor]){
        [sender setBackgroundColor:[UIColor greenColor]];
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.reminderListTable];
        NSIndexPath *indexPath = [self.reminderListTable indexPathForRowAtPoint:buttonPosition];
        NSInteger index = indexPath.row;
        if (indexPath!=nil){
            NSLog(@"locationButtonActivated at %ld",(long)indexPath.row);
            [[glb_reminderList getReminderAtIndex:index] setLocationActivated];
            PFObject *tmppfreminder = [[glb_reminderList getReminderAtIndex:index] getPFObject];
            tmppfreminder[@"locationstatus"] = @"YES";
            [tmppfreminder saveInBackground];
            if ([self addLocationNotificationAtLocation:[[glb_reminderList getReminderAtIndex:index] getLocation] withContent:[[glb_reminderList getReminderAtIndex:index] getContent]]){
                NSLog(@"LocationNotification added");
            }
        } else {
            NSLog(@"locationButtonPressed Failed");
        }
    }
    else {
        [sender setBackgroundColor:[UIColor grayColor]];
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.reminderListTable];
        NSIndexPath *indexPath = [self.reminderListTable indexPathForRowAtPoint:buttonPosition];
        NSInteger index = indexPath.row;
        if (indexPath!=nil){
            NSLog(@"locationButtonActivated at %ld",(long)indexPath.row);
            [[glb_reminderList getReminderAtIndex:index] setLocationDeactivated];
            PFObject *tmppfreminder = [[glb_reminderList getReminderAtIndex:index] getPFObject];
            tmppfreminder[@"locationstatus"] = @"NO";
            [tmppfreminder saveInBackground];
            if ([self removeLocationNotificationAtLocation:[[glb_reminderList getReminderAtIndex:index] getLocation] withContent:[[glb_reminderList getReminderAtIndex:index] getContent]]){
                NSLog(@"LocationNotification removed");
            }
        } else {
            NSLog(@"locationButtonPressed Failed");
        }
    }    
}

-(BOOL)deleteReminderAtIndexPath:(NSIndexPath *)indexPath{
    [self cancelTimer];
    PFObject *tmppfReminder = [[glb_reminderList.listitem objectAtIndex:indexPath.row] getPFObject];
    [glb_reminderList removeReminder:tmppfReminder];
    [tmppfReminder deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            [self startTimer];
        } else {
            
        }
    }];
    NSArray *selectedReminder = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.reminderListTable deleteRowsAtIndexPaths:selectedReminder withRowAnimation:UITableViewRowAnimationFade];
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toAddReminderView"]){
        AddReminderViewController *transferViewController = segue.destinationViewController;
        //transferViewController.user = _user;
        //transferViewController.list = _list;
        transferViewController.userInputContent = @"Please drop your note here...";
        transferViewController.userInputDate = [NSDate date];
    }
    if ([segue.identifier isEqualToString:@"toMapView"]){
        ReminderMapViewController *transferViewController = segue.destinationViewController;
        //transferViewController.user = _user;
        //transferViewController.list = _list;
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    /*
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
     */
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"update: %@", newLocation);
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    NSLog(@"didEnterTapHandle");
    CGPoint taplocation = [gestureRecognizer locationInView:self.reminderListTable];
    NSIndexPath *indexPath = [self.reminderListTable indexPathForRowAtPoint:taplocation];
    if(indexPath)
    {
        if ([self deleteReminderAtIndexPath:indexPath]){
            NSLog(@"@Delete Row %ld",(long)indexPath.row);
        }
    }
}


- (BOOL)addTimeNotificationAtDate:(NSDate *)date withContent:(NSString *)content{
    UILocalNotification *localTimeNotification = [[UILocalNotification alloc] init];
    localTimeNotification.fireDate = date;
    localTimeNotification.alertBody = content;
    localTimeNotification.soundName = UILocalNotificationDefaultSoundName;
    localTimeNotification.applicationIconBadgeNumber = 1;
    if ([[[UIApplication sharedApplication] scheduledLocalNotifications]containsObject:localTimeNotification]){
        return NO;
    }
    else {
    [[UIApplication sharedApplication] scheduleLocalNotification:localTimeNotification];
    return YES;
    }
}

- (BOOL)removeTimeNotificationAtDate:(NSDate *)date withContent:(NSString *)content{
    UILocalNotification *localTimeNotification = [[UILocalNotification alloc] init];
    localTimeNotification.fireDate = date;
    localTimeNotification.alertBody = content;
    localTimeNotification.soundName = UILocalNotificationDefaultSoundName;
    localTimeNotification.applicationIconBadgeNumber = 1;
    if ([[[UIApplication sharedApplication] scheduledLocalNotifications]containsObject:localTimeNotification]){
        [[UIApplication sharedApplication] cancelLocalNotification:localTimeNotification];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)addLocationNotificationAtLocation:(CLLocationCoordinate2D)location withContent:(NSString *)content{
    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:location radius:100.0f identifier:content];
    if (![self.locationManager.monitoredRegions containsObject:region]){
        [self.locationManager startMonitoringForRegion:region];
        NSLog(@"%@",[locationManager monitoredRegions]);
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)removeLocationNotificationAtLocation:(CLLocationCoordinate2D)location withContent:(NSString *)content{
    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:location radius:100.0f identifier:content];
    if ([self.locationManager.monitoredRegions containsObject:region]){
        [self.locationManager stopMonitoringForRegion:region];
        NSLog(@"%@",[locationManager monitoredRegions]);
        return YES;
    } else {
        return NO;
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    UILocalNotification *localRegionNotification = [[UILocalNotification alloc] init];
    localRegionNotification.fireDate = [NSDate date];
    localRegionNotification.alertBody = [NSString stringWithFormat:@"Enter: %@",region.identifier];
    localRegionNotification.soundName = UILocalNotificationDefaultSoundName;
    localRegionNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localRegionNotification];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    UILocalNotification *localRegionNotification = [[UILocalNotification alloc] init];
    localRegionNotification.fireDate = [NSDate date];
    localRegionNotification.alertBody = [NSString stringWithFormat:@"Exit: %@",region.identifier];
    localRegionNotification.soundName = UILocalNotificationDefaultSoundName;
    localRegionNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localRegionNotification];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"did start monitoring %@",region);
}

- (void)startLocationService{
    if ([CLLocationManager locationServicesEnabled]){
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        for (Reminder *reminder in glb_reminderList.listitem){
            if ([reminder getLocationStatus]){
                CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:[reminder getLocation] radius:100.0f identifier:[reminder getContent]];
                [self.locationManager startMonitoringForRegion:region];
            }
        }
    }
}

#pragma Periodically Fetch From Parse
dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}
- (void)startTimer
{
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double secondsToFire = 30.0f;
    
    _timer = CreateDispatchTimer(secondsToFire, dispatch_get_main_queue(), ^{
        // Do something
        [glb_reminderList fetchFromParse];
        [self.reminderListTable reloadData];
    });
}

- (void)cancelTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        // Remove this if you are on a Deployment Target of iOS6 or OSX 10.8 and above
        _timer = nil;
    }
}

- (void)refreshUI{
    dispatch_async(dispatch_get_main_queue(),^{
        [self.reminderListTable reloadData];
    });
}



@end
