//
//  HFBabyMonitorSmall.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/3/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFBabyMonitor.h"
#import "HFUtilities.h"

@implementation HFBabyMonitor

+(instancetype) babyMonitorOfType:(HFBabyMonitorType)monitorType
{
    HFBabyMonitor *babyMonitor;

    if (monitorType == HFBabyMonitorLarge)
    {
        babyMonitor = [self spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(75, 75)];
    }else if (monitorType == HFBabyMonitorSmall)
    {
        babyMonitor = [self spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(45, 45)];
    }

    SKAction *monitorRotation = [SKAction rotateByAngle:3 * M_PI duration:5];
    SKAction *rotationRepeat = [SKAction repeatActionForever:monitorRotation];
    [babyMonitor runAction:rotationRepeat];
    [babyMonitor initializePhysicsBody];

    return babyMonitor;
}

-(void)initializePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.velocity = CGVectorMake(0, -100);
    self.physicsBody.categoryBitMask = CollisionCategoryMonitor;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryCar | CollisionCategoryGround;
}

@end
