//
//  WGS84TOGCJ02.h
//  OmniRemind
//
//  Created by Chubin OU on 3/14/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGS84TOGCJ02 : NSObject
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
