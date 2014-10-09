//
//  HFCoffeeNode.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/9/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFCoffeeNode.h"
#import "HFUtilities.h"

@implementation HFCoffeeNode

+(instancetype)generateCoffee
{
    HFCoffeeNode *coffee = [HFCoffeeNode spriteNodeWithImageNamed:@"coffeecup"];
    coffee.size = CGSizeMake(50, 65);
    coffee.physicsBody.mass = 2.5;
    [coffee initializePhysicsBody];

    SKAction *monitorRotation = [SKAction rotateByAngle:3 * M_PI duration:5];
    SKAction *rotationRepeat = [SKAction repeatActionForever:monitorRotation];
    [coffee runAction:rotationRepeat];
    [coffee initializePhysicsBody];

    return coffee;
}

-(void)initializePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.mass = 0.02;
    self.physicsBody.categoryBitMask = CollisionCategoryCoffeCup;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryGround | CollisionCategoryCar;
}

@end
