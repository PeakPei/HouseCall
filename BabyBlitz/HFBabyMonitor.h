//
//  HFBabyMonitorSmall.h
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/3/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, HFBabyMonitorType)
{
    HFBabyMonitorLarge,
    HFBabyMonitorSmall,
};

@interface HFBabyMonitor : SKSpriteNode

+(instancetype) babyMonitorOfType:(HFBabyMonitorType)monitorType;

@end
