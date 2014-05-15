//
//  RunKeeperPathPoint.m
//  RunKeeper-iOS
//
//  Created by Reid van Melle on 11-09-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RunKeeperPathPoint.h"


@implementation RunKeeperPathPoint

@synthesize location, pointType, time, timeStamp;

- (id)initWithLocation:(CLLocation*)loc ofType:(RunKeeperPathPointType)t
{
    self = [super init];
    if (self) {
        self.location = loc;
        self.pointType = t;
        self.time = [NSDate date];
    }
    return self;
}

- (id)initInPathWithJSONDict:(NSDictionary *)dict forPathStartingAt:(NSDate *)start
{
    if (!(self = [super init]))
    {
        return nil;
    }

    self.pointType = [self pointTypeForTypeString:[dict objectForKey:@"type"]];

    NSTimeInterval timeStampFromDict = [[dict objectForKey:@"timestamp"] doubleValue];
    self.timeStamp = timeStampFromDict;

    NSDate *timeFromDict = [NSDate dateWithTimeInterval:timeStampFromDict sinceDate:start];
    self.time = timeFromDict;

    CLLocationDegrees latitude = [[dict objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude = [[dict objectForKey:@"longitude"] doubleValue];
    CLLocationDistance altitude =  [[dict objectForKey:@"altitude"] doubleValue];

    self.location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:altitude horizontalAccuracy:0.0 verticalAccuracy:0.0 timestamp:timeFromDict];

    return self;
}

- (NSString*)typeStringForPointType
{
    // "start", "end", "gps", "pause", "resume", "manual"
    switch (pointType) {
        case kRKPausePoint: return @"pause";
        case kRKEndPoint: return @"end";
        case kRKStartPoint: return @"start";
        case kRKResumePoint: return @"resume";
        case kRKGPSPoint: return @"gps";
        case kRKManualPoint: return @"manual";
    }
    return nil;
}

- (RunKeeperPathPointType)pointTypeForTypeString:(NSString *)string
{
    if ([string isEqualToString:@"pause"])
    {
        return kRKPausePoint;
    }
    else if ([string isEqualToString:@"end"])
    {
        return kRKEndPoint;
    }
    else if ([string isEqualToString:@"start"])
    {
        return kRKStartPoint;
    }
    else if ([string isEqualToString:@"resume"])
    {
        return kRKResumePoint;
    }
    else if ([string isEqualToString:@"gps"])
    {
        return kRKGPSPoint;
    }
    else if ([string isEqualToString:@"manual"])
    {
        return kRKManualPoint;
    }
    return nil;
}

- (id)proxyForJson {
    //NSLog(@"proxyForJSON: %g %g %g %g", self.timeStamp, self.location.altitude, self.location.coordinate.latitude,
    //      self.location.coordinate.longitude);
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:self.timeStamp], @"timestamp",
            [NSNumber numberWithDouble:self.location.altitude], @"altitude",
            [NSNumber numberWithDouble:self.location.coordinate.latitude], @"latitude",
            [NSNumber numberWithDouble:self.location.coordinate.longitude], @"longitude",
            [self typeStringForPointType], @"type",
            nil];
}

@end
