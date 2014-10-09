//
//  HFCar.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/1/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFCar.h"
#import "HFUtilities.h"

#define carSize CGSizeMake(75, 35)

@implementation HFCar

+(instancetype)initWithPosition:(CGPoint)position
{
    HFCar *carNode = [HFCar spriteNodeWithImageNamed:@"fiat"];
    carNode.size = CGSizeMake(125, 100);
    carNode.position = position;
    carNode.name = @"CarNode";
    [carNode initializePhysicsBody];

    return carNode;
}

-(void)initializePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.mass = 0.02;
    self.physicsBody.categoryBitMask = CollisionCategoryCar;
    self.physicsBody.collisionBitMask = CollisionCategoryEdgeScene;
    self.physicsBody.contactTestBitMask = CollisionCategoryMonitor | CollisionCategoryBaby | CollisionCategoryCoffeCup | CollisionCategoryDonut;
}

@end
