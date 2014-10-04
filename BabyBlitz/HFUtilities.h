//
//  HFUtilities.h
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/2/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import <Foundation/Foundation.h>

//constant variables
static const int HFBabyMonitorMinSpeed = -200;
static const int HFBabyMonitorMaxSpeed = -100;

//contact bit masks
typedef NS_OPTIONS(uint32_t, CollisionCategory)
{
    CollisionCategoryCar        = 1 << 0,
    CollisionCategoryMonitor    = 1 << 1,
    CollisionCategoryDonut      = 1 << 2,
    CollisionCategoryCoffeCup   = 1 << 3,
    CollisionCategoryBaby       = 1 << 4,
    CollisionCategoryEdgeScene  = 1 << 5,
    CollisionCategoryGround     = 1 << 6,
};

@interface HFUtilities : NSObject

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
