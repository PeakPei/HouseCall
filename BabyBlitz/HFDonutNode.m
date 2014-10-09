//
//  HFDonutNode.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/9/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFDonutNode.h"
#import "HFUtilities.h"

@implementation HFDonutNode

+(instancetype)generateDonuts
{
    HFDonutNode *donut = [HFDonutNode spriteNodeWithImageNamed:@"donut"];
    donut.size = CGSizeMake(50, 50);
    donut.physicsBody.mass = 2;
    [donut initializePhysicsBody];

    SKAction *monitorRotation = [SKAction rotateByAngle:3 * M_PI duration:5];
    SKAction *rotationRepeat = [SKAction repeatActionForever:monitorRotation];
    [donut runAction:rotationRepeat];
    [donut initializePhysicsBody];

    return donut;
}

-(void)initializePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.mass = 0.02;
    self.physicsBody.categoryBitMask = CollisionCategoryDonut;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryGround | CollisionCategoryCar;
}

@end
