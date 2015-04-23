//
//  LocationPickerViewController.m
//  OmniRemind
//
//  Created by Chubin OU on 3/12/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "LocationPickerViewController.h"

@interface LocationPickerViewController ()

@end

@implementation LocationPickerViewController {
    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager requestAlwaysAuthorization];
    _userPickLocationX = [NSString stringWithFormat:@"%f",0.0];
    _userPickLocationY = [NSString stringWithFormat:@"%f",0.0];
    _userSearchBar.delegate = self;
    _userMap.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.userSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:self.userSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error){
            for (CLPlacemark *placemark in placemarks){
                MKCoordinateRegion region;
                CLLocationCoordinate2D newLocation = [placemark.location coordinate];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                [annotation setCoordinate:newLocation];
                [annotation setTitle:self.userSearchBar.text];
                [self.userMap addAnnotation:annotation];
                region.center = [placemark.location coordinate];
                [self.userMap setRegion:region animated:YES];
            }
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    _userPickLocationX = [NSString stringWithFormat:@"%f",view.annotation.coordinate.longitude];
    _userPickLocationY = [NSString stringWithFormat:@"%f",view.annotation.coordinate.latitude];
}

- (IBAction)onBack:(id)sender {
    [self performSegueWithIdentifier:@"backToAddReminderView" sender:self];
}

- (IBAction)onCurrentLocation:(id)sender {
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (IBAction)onPick:(id)sender {
    [self performSegueWithIdentifier:@"pickToAddReminderView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"backToAddReminderView"]){
        LocationPickerViewController *transferViewController = segue.destinationViewController;
        transferViewController.userPickLocationX = _userPickLocationX;
        transferViewController.userPickLocationY = _userPickLocationY;
        transferViewController.userInputContent = _userInputContent;
        transferViewController.userInputDate = _userInputDate;
        //transferViewController.user = _user;
        //transferViewController.list = _list;
    }
    if ([segue.identifier isEqualToString:@"pickToAddReminderView"]){
        LocationPickerViewController *transferViewController = segue.destinationViewController;
        transferViewController.userPickLocationX = _userPickLocationX;
        transferViewController.userPickLocationY = _userPickLocationY;
        transferViewController.userInputContent = _userInputContent;
        transferViewController.userInputDate = _userInputDate;
        //transferViewController.user = _user;
        //transferViewController.list = _list;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        CLLocationCoordinate2D mapcoord = currentLocation.coordinate;
        /*if (![WGS84TOGCJ02 isLocationOutOfChina:[currentLocation coordinate]]){
            mapcoord = [WGS84TOGCJ02 transformFromWGSToGCJ:[currentLocation coordinate]];
        }*/
        mapcoord = currentLocation.coordinate;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapcoord, 100, 100);
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        [annotation setCoordinate:mapcoord];
        [annotation setTitle:@"My Location"];
        [_userMap addAnnotation:annotation];
        [self.userMap setRegion:region animated:YES];
        [locationManager stopUpdatingLocation];
        
    }
}


@end
