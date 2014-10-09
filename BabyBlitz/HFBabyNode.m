//
//  HFBabyNode.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/9/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFBabyNode.h"
#import "HFUtilities.h"

@implementation HFBabyNode

+(instancetype)generateBaby
{
    HFBabyNode *baby = [HFBabyNode spriteNodeWithImageNamed:@"baby"];
    baby.size = CGSizeMake(50, 65);
    baby.physicsBody.mass = 3;
    [baby initializePhysicsBody];

    SKAction *monitorRotation = [SKAction rotateByAngle:3 * M_PI duration:5];
    SKAction *rotationRepeat = [SKAction repeatActionForever:monitorRotation];
    [baby runAction:rotationRepeat];
    [baby initializePhysicsBody];

    return baby;
}

-(void)initializePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.mass = 0.02;
    self.physicsBody.categoryBitMask = CollisionCategoryBaby;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryGround | CollisionCategoryCar;
}

@end
