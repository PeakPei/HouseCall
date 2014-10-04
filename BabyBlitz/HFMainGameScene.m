//
//  HFMainGameScene.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/1/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFMainGameScene.h"
#import "HFTitleScene.h"
#import "HFCar.h"
#import "HFBabyMonitor.h"
#import "HFGroundNode.h"
#import "HFUtilities.h"

#import <CoreMotion/CoreMotion.h>

#define carSize CGSizeMake(35, 25)

@interface HFMainGameScene () <SKPhysicsContactDelegate>

@property BOOL gameSceneLoaded;

@property (strong) CMMotionManager *motionManager;

@end

@implementation HFMainGameScene

#pragma Scene setup
- (void)didMoveToView:(SKView *)view
{
    if (!self.gameSceneLoaded)
    {
        [self loadSceneContent];
        self.gameSceneLoaded = YES;

        //initializing and starting motion manager
        self.motionManager = [CMMotionManager new];
        [self.motionManager startAccelerometerUpdates];

        //establishing frame boundaries for car to stay within
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];

        //establish physics engine and gravity
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    //back button segue
    if ([node.name isEqualToString:@"backButtonNode"])
    {
        HFTitleScene *titleScene = [HFTitleScene sceneWithSize:self.frame.size];
        SKTransition *transition = [SKTransition fadeWithDuration:1.0];
        [self.view presentScene:titleScene transition:transition];
    }

    //touch to destroy baby monitor
    if ([node.name isEqualToString:@"BabyMonitor"])
    {
        [node removeFromParent];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    //monitor hitting the ground
    if ((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryMonitor | CollisionCategoryGround))
    {

    }
    //monitor hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryMonitor | CollisionCategoryCar))
    {

    }
    //coffee hitting the ground
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryCoffeCup | CollisionCategoryGround))
    {

    }
    //coffee hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryCoffeCup | CollisionCategoryCar))
    {

    }
    //donut hitting the ground
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryDonut | CollisionCategoryGround))
    {

    }
    //donut hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryDonut | CollisionCategoryCar))
    {

    }
}

#pragma - Scene Update

-(void)update:(NSTimeInterval)currentTime
{
    //checking for phone tilt every 1/60 secs
    [self userMotionForUpdate:currentTime];
}

-(void)loadSceneContent
{
    [self initializeCar];
    [self initializeBabyMonitor];
    [self initializeHUD];
}

#pragma - Car setup
-(void)initializeCar
{
    HFCar *carNode = [HFCar initWithPosition:CGPointMake(self.size.width / 2, (carSize.height / 2) + 50)];
    carNode.name = @"Car";
    [self addChild:carNode];
    
    HFGroundNode *groundNode = [HFGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 25)];
    [self addChild:groundNode];
}

-(void)initializeBabyMonitor
{
    HFBabyMonitor *babyMonitorA = [HFBabyMonitor babyMonitorOfType:HFBabyMonitorLarge];
    babyMonitorA.name = @"BabyMonitor";
    babyMonitorA.position = CGPointMake(100, 300);
    [self addChild:babyMonitorA];

    HFBabyMonitor *babyMonitorB = [HFBabyMonitor babyMonitorOfType:HFBabyMonitorSmall];
    babyMonitorB.name = @"BabyMonitor";
    babyMonitorB.position = CGPointMake(200, 300);
    [self addChild:babyMonitorB];
}

-(void)initializeHUD
{
    //score label
    SKLabelNode* scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    scoreLabel.name = @"Score Label";
    scoreLabel.fontSize = 15;
    scoreLabel.fontColor = [SKColor greenColor];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %04u", 0];
    scoreLabel.position = CGPointMake(self.size.width/2 + 180, self.size.height - (40 + scoreLabel.frame.size.height/2));
    [self addChild:scoreLabel];

    //health label
    SKLabelNode* healthLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    healthLabel.name = @"Health Label";
    healthLabel.fontSize = 15;
    healthLabel.fontColor = [SKColor redColor];
    healthLabel.text = [NSString stringWithFormat:@"Health: %.1f%%", 100.0f];
    healthLabel.position = CGPointMake(self.size.width/2 + 165, self.size.height - (20 + healthLabel.frame.size.height/2));
    [self addChild:healthLabel];

    //back button
    SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed: @"BackButton"];
    backButton.position = CGPointMake(self.size.width/2 - 200, self.size.height - (30 + healthLabel.frame.size.height/2));
    backButton.size = CGSizeMake(45, 45);
    [backButton setName:@"backButtonNode"];
    [self addChild:backButton];
}

-(void)userMotionForUpdate:(NSTimeInterval)currentTime
{
    //get car from scene so we can move it
    HFCar *carNode = (HFCar*)[self childNodeWithName:@"Car"];

    //get the acceleromater data
    CMAccelerometerData *accelerationData = self.motionManager.accelerometerData;

    //moving the ship based on degree of tilt detected
    if (fabs(accelerationData.acceleration.y) > 0.2)
    {
        [carNode.physicsBody applyForce:CGVectorMake(40 * accelerationData.acceleration.y, 0)];
    }
}

@end
