//
//  HFMainGameScene.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/1/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFMainGameScene.h"
#import "HFCar.h"
#import "HFBabyMonitor.h"
#import "HFGroundNode.h"
#import "HFUtilities.h"
#import "HFHudNode.h"
#import "HFGameOverNode.h"
#import "HFLevel2.h"
#import "HFRootViewController.h"
#import "HFLevelTitleNode.h"

#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

#define carSize CGSizeMake(35, 25)

@interface HFMainGameScene () <SKPhysicsContactDelegate>

@property BOOL gameSceneLoaded;

@property (strong) CMMotionManager *motionManager;

@property HFBabyMonitor *monitorCollisionBody;
@property HFGroundNode *groundCollisionBody;
@property HFCar *carCollisionBody;
@property HFLevelTitleNode *levelTitle;

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceMonitorAdded;

@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSTimeInterval monitorSpawnTimeInterval;

@property BOOL gameOver;
@property BOOL restart;
@property BOOL gameOverDisplayed;

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
        self.physicsWorld.contactDelegate = self;

        //intialize timer properties
        self.lastUpdateTimeInterval = 0;
        self.timeSinceMonitorAdded = 0;

        self.monitorSpawnTimeInterval = 1.5;
        self.totalGameTime = 0;

        self.gameOver = NO;
        self.restart = NO;
        self.gameOverDisplayed = NO;

        self.levelTitle = [HFLevelTitleNode levelTitleAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) levelNumber:1];
        [self addChild:self.levelTitle];
        [self.levelTitle performAnimation];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    //touch to destroy baby monitor
    if ([node.name isEqualToString:@"BabyMonitor"])
    {
        [self addPoints:HFPointsPerMonitorDestroyed];
        [node removeFromParent];
    }

    if (self.restart)
    {
        for (SKNode *node in self.children)
        {
            [node removeFromParent];
        }

        HFMainGameScene *mainGameRestart = [HFMainGameScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:mainGameRestart];
    }
    
//    HFGameOverNode *gameOverNode = (HFGameOverNode*)[self childNodeWithName:@"GameOver"];
//    NSString *gameOverNodeName = (NSString*)[gameOverNode childNodeWithName:@"MainMenu"];
//    NSString *restartNodeName = (NSString*)[gameOverNode childNodeWithName:@"Restart"];
//    
//
//    if ([node.name isEqualToString:gameOverNodeName])
//    {
//        UIViewController *rootVC = self.view.window.rootViewController;
//        [rootVC dismissViewControllerAnimated:YES completion:nil];
//    }
//    else if ([node.name isEqualToString:restartNodeName])
//    {
//        HFMainGameScene *mainGameRestart = [HFMainGameScene sceneWithSize:self.view.bounds.size];
//        [self.view presentScene:mainGameRestart];
//    }
}

-(void)performGameOver
{
    HFGameOverNode *gameOver = [HFGameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self addChild: gameOver];
    self.restart = YES;
    self.gameOverDisplayed = YES;
    [gameOver performAnimation];

    //back button
    SKSpriteNode *menuButton = [SKSpriteNode spriteNodeWithImageNamed: @"BackButton"];
    menuButton.position = CGPointMake(CGRectGetMidX(self.frame) - 140, CGRectGetMidY(self.frame) - 225);
    menuButton.size = CGSizeMake(25, 65);
    [menuButton setName:@"backButtonNode"];
    [self addChild:menuButton];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    //NSArray *contactNodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];

    //monitor hitting the ground
    if ((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryMonitor | CollisionCategoryGround))
    {
        if (contact.bodyA.categoryBitMask == CollisionCategoryMonitor)
        {
            self.monitorCollisionBody = (HFBabyMonitor*)contact.bodyA.node;
            self.groundCollisionBody = (HFGroundNode*)contact.bodyB.node;
        }else
        {
            self.monitorCollisionBody = (HFBabyMonitor*)contact.bodyB.node;
            self.groundCollisionBody = (HFGroundNode*)contact.bodyA.node;
        }

        //remove monitor node from scene
        [self.monitorCollisionBody removeFromParent];

        //adjust lives --;
        [self loseLife];
    }
    //monitor hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryMonitor | CollisionCategoryCar))
    {
        if (contact.bodyA.categoryBitMask == CollisionCategoryMonitor)
        {
            self.monitorCollisionBody = (HFBabyMonitor*)contact.bodyA.node;
            self.carCollisionBody = (HFCar*)contact.bodyB.node;
        }else
        {
            self.monitorCollisionBody = (HFBabyMonitor*)contact.bodyB.node;
            self.carCollisionBody = (HFCar*)contact.bodyA.node;
        }

        //remove monitor node from scene
        [self.monitorCollisionBody removeFromParent];

        //adjust lives --;
        [self loseLife];

    }
    //coffee hitting the ground
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryCoffeCup | CollisionCategoryGround))
    {

    }
    //coffee hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryCoffeCup | CollisionCategoryCar))
    {
        [self addPoints: HFPointsPerCoffeeHit];
    }
    //donut hitting the ground
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryDonut | CollisionCategoryGround))
    {

    }
    //donut hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryDonut | CollisionCategoryCar))
    {
        [self addPoints:HFPointsPerDonutHit];
    }
    //baby hitting the ground
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryBaby | CollisionCategoryGround))
    {

    }
    //baby hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryBaby | CollisionCategoryCar))
    {
        [self addPoints:HFPointsPerBabyHit];
    }
}

#pragma - Scene Update

-(void)update:(NSTimeInterval)currentTime
{
    //checking for phone tilt every 1/60 secs
    [self userMotionForUpdate:currentTime];

    //checking timer interval for monitor spawn
    if (self.lastUpdateTimeInterval)
    {
        self.timeSinceMonitorAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }

    if (self.timeSinceMonitorAdded > self.monitorSpawnTimeInterval && !self.gameOver)
    {
        [self initializeBabyMonitor];
        self.timeSinceMonitorAdded = 0;
    }

    if (self.totalGameTime > 2.5)
    {
        [self.levelTitle removeFromParent];
    }

    //difficulty settings
    self.lastUpdateTimeInterval = currentTime;

    if (self.totalGameTime > 60)
    {
        self.monitorSpawnTimeInterval = 0.5;
    }
    else if(self.totalGameTime > 30)
    {
        self.monitorSpawnTimeInterval = 0.65;
    }
    else if(self.totalGameTime > 20)
    {
        self.monitorSpawnTimeInterval = 0.75;
    }
    else if(self.totalGameTime > 10)
    {
        self.monitorSpawnTimeInterval = 1;
    }

    if(self.gameOver && !self.gameOverDisplayed)
    {
        [self performGameOver];
    }

    HFHudNode *hud = (HFHudNode *)[self childNodeWithName:@"HUD"];
    if (hud.score > 300)
    {
        [self advanceToNextLevel];
    }
}

-(void)loadSceneContent
{
    [self initializeCar];
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
    //choosing baby monitor type
    NSInteger randomBabyMonitor = [HFUtilities randomWithMin:0 max:2];

    //generate the random monitor
    HFBabyMonitor *monitor = [HFBabyMonitor babyMonitorOfType:randomBabyMonitor];
    float deltaY = [HFUtilities randomWithMin:HFBabyMonitorMinSpeed max:HFBabyMonitorMaxSpeed];
    monitor.physicsBody.velocity = CGVectorMake(0, deltaY);

    //range of spawn position
    float yCoordinate = self.frame.size.height + monitor.size.height;
    float xCoordinate = [HFUtilities randomWithMin:monitor.size.width + 10 max:self.frame.size.width - monitor.size.width - 10];
    monitor.position = CGPointMake(xCoordinate, yCoordinate);
    monitor.name = @"BabyMonitor";
    [self addChild:monitor];
}

-(void)initializeHUD
{
    HFHudNode *hud = [HFHudNode hudAtPostions:CGPointMake(0, self.frame.size.height - 20) inFrame:self.frame];
    [self addChild:hud];
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

-(void)addPoints:(NSInteger)points
{
    HFHudNode *hud = (HFHudNode *)[self childNodeWithName:@"HUD"];
    [hud addPoint:points];
}

-(void)loseLife
{
    HFHudNode *hud = (HFHudNode *)[self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
}

-(void)advanceToNextLevel
{
    HFLevel2 *level2 = [HFLevel2 sceneWithSize:self.view.bounds.size];
    [self.view presentScene:level2];
}

@end
