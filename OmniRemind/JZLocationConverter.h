//
//  JZLocationConverter.h
//  OmniRemind
//
//  Created by Chubin OU on 3/15/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface JZLocationConverter : NSObject
+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location;
+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location;
+ (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location;
+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location;
+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location;
+ (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location;


@end
