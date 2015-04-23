//
//  ReminderMapViewController.m
//  OmniRemind
//
//  Created by Chubin OU on 3/10/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "ReminderMapViewController.h"


@interface ReminderMapViewController ()

@end

@implementation ReminderMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topBar.text = [NSString stringWithFormat:@"%@ in %@'s Family",glb_user.username,glb_user.familyname];
    [self loadAnnotations];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self startLocationService];
    
    // Do any additional setup after loading the view.
}

- (void)loadAnnotations{
    for (Reminder *tmp in glb_reminderList.listitem){
        MKPointAnnotation *reminderAnnotation = [[MKPointAnnotation alloc]init];
        reminderAnnotation.coordinate = tmp.getLocation;
        reminderAnnotation.title = tmp.content;
        reminderAnnotation.subtitle = [NSString stringWithFormat:@"dropped by %@",tmp.username];
        [self.reminderMap addAnnotation:reminderAnnotation];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onList:(id)sender {
    [self performSegueWithIdentifier:@"toListView" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toListView"]){
        ReminderListViewController *transferViewController = segue.destinationViewController;
        //transferViewController.user = _user;
        //transferViewController.list = _list;
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

@end
