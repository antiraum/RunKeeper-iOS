//
//  RunKeeperFitnessActivity.m
//  RunKeeper-iOS
//
//  Created by Falko Buttler on 5/2/13.
//  Copyright 2013 BlueBamboo.de Apps (www.bluebamboo.de). All rights reserved.
//

#import "RunKeeperFitnessActivity.h"
#import "RunKeeper.h"
#import "RunKeeperPathPoint.h"
#import "NSDate+JSON.h"

@implementation RunKeeperFitnessActivity

- (id)initFromFeedDict:(NSDictionary*)itemDict
{
	if (!(self = [super init]))
	{
		return nil;
	}

    self.activityType = [RunKeeper activityType:[itemDict objectForKey:@"type"]];
    self.startTime = [NSDate dateFromJSONDate:[itemDict objectForKey:@"start_time"]];
    self.totalDistanceInMeters = [itemDict objectForKey:@"total_distance"];
    self.durationInSeconds = [itemDict objectForKey:@"duration"];
    self.source = [itemDict objectForKey:@"source"];
    self.entryMode = [itemDict objectForKey:@"entry_mode"];
    self.hasPath = [[itemDict objectForKey:@"has_path"] boolValue] || ([itemDict objectForKey:@"path"] != nil);
    self.uri = [itemDict objectForKey:@"uri"];

    return self;
}

- (id)initFromSummaryDict:(NSDictionary*)itemDict
{
	if (!(self = [self initFromFeedDict:itemDict]))
	{
		return nil;
	}

    self.userID = [itemDict objectForKey:@"userID"];
    self.secondaryType = [itemDict objectForKey:@"secondary_type"];
    self.equipment = [itemDict objectForKey:@"equipment"];
    self.averageHeartRate = [itemDict objectForKey:@"average_heart_rate"];
    self.totalCalories = [itemDict objectForKey:@"total_calories"];
    self.climbInMeters = [itemDict objectForKey:@"climb"];
    self.notes = [itemDict objectForKey:@"notes"];
    self.isLive = [[itemDict objectForKey:@"is_live"] boolValue];
    self.share = [itemDict objectForKey:@"share"];
    self.shareMap = [itemDict objectForKey:@"share_map"];
    self.publicURI = [itemDict objectForKey:@"activity"];

	return self;
}

- (id)initFromDetailedDict:(NSDictionary*)itemDict
{
	if (!(self = [self initFromSummaryDict:itemDict]))
	{
		return nil;
	}

    if (self.hasPath)
    {
        NSDate *startTime = self.startTime;
        NSArray *pathDict = [itemDict objectForKey:@"path"];
        NSMutableArray *path = [NSMutableArray new];
        for (NSDictionary *pointDict in pathDict)
        {
            [path addObject:[[RunKeeperPathPoint alloc] initInPathWithJSONDict:pointDict forPathStartingAt:startTime]];
        }
        self.path = path;
    }

    // TODO: other details (only path and start time are important at the moment)

	return self;
}

// For debugging purposes
- (NSString*)description
{
    return [NSString stringWithFormat:@"Date: %@, type: %@, distance: %.2f, duration: %.2f, calories: %@, cal/h: %.0f, uri: %@",
            _startTime,
            [RunKeeper activityString:_activityType],
            _totalDistanceInMeters.doubleValue / 1000.0,
            _durationInSeconds.doubleValue / 60.0,
            _totalCalories,
            _totalCalories.doubleValue / (_durationInSeconds.doubleValue / 60.0) * 60.0,
            _uri];
}

@end
