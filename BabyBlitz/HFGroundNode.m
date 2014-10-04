//
//  HFGroundNode.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/3/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFGroundNode.h"
#import "HFUtilities.h"

@implementation HFGroundNode

+ (instancetype) groundWithSize:(CGSize)size {
    HFGroundNode *ground = [self spriteNodeWithColor:[SKColor greenColor] size:size];
    ground.name = @"Ground";
    ground.position = CGPointMake(size.width/2,size.height/2);
    [ground setupPhysicsBody];

    return ground;
}


- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryEdgeScene;
    self.physicsBody.contactTestBitMask = CollisionCategoryMonitor;
}

@end
