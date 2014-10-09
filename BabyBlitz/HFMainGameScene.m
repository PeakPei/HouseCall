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
#import "HFStartScene.h"
#import "HFDonutNode.h"
#import "HFCoffeeNode.h"
#import "HFBabyNode.h"

#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

#define carSize CGSizeMake(35, 25)

@interface HFMainGameScene () <SKPhysicsContactDelegate>

@property BOOL gameSceneLoaded;

@property (strong) CMMotionManager *motionManager;

@property HFBabyMonitor *monitorCollisionBody;
@property HFGroundNode *groundCollisionBody;
@property HFCar *carCollisionBody;
@property HFDonutNode *donutCollisionBody;
@property HFCoffeeNode *coffeCollisionBody;
@property HFBabyNode *babyCollisionBody;
@property HFLevelTitleNode *levelTitle;

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceMonitorAdded;

@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSTimeInterval monitorSpawnTimeInterval;
@property (nonatomic) NSTimeInterval donutSpawnTimeInterval;
@property (nonatomic) NSTimeInterval coffeeSpawnTimeInterval;
@property (nonatomic) NSTimeInterval babySpawnTimeInterval;

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
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        [self addChild:background];

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

        self.monitorSpawnTimeInterval = 2;
        self.donutSpawnTimeInterval = 2.5;
        self.coffeeSpawnTimeInterval = 2.75;
        self.babySpawnTimeInterval = 3;

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

        HFStartScene *reset = [HFStartScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:reset];
    }
}

-(void)performGameOver
{
    HFGameOverNode *gameOver = [HFGameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self addChild: gameOver];
    self.restart = YES;
    self.gameOverDisplayed = YES;
    [gameOver performAnimation];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
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
        if (contact.bodyA.categoryBitMask == CollisionCategoryCoffeCup)
        {
            self.coffeCollisionBody = (HFCoffeeNode*)contact.bodyA.node;
            self.groundCollisionBody = (HFGroundNode*)contact.bodyB.node;
        }else
        {
            self.coffeCollisionBody = (HFCoffeeNode*)contact.bodyB.node;
            self.groundCollisionBody = (HFGroundNode*)contact.bodyA.node;
        }

        [self.coffeCollisionBody removeFromParent];
    }
    //coffee hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryCoffeCup | CollisionCategoryCar))
    {
        if (contact.bodyA.categoryBitMask == CollisionCategoryCoffeCup)
        {
            self.coffeCollisionBody = (HFCoffeeNode*)contact.bodyA.node;
            self.carCollisionBody = (HFCar*)contact.bodyB.node;
        }else
        {
            self.coffeCollisionBody = (HFCoffeeNode*)contact.bodyB.node;
            self.carCollisionBody = (HFCar*)contact.bodyA.node;
        }

        [self addPoints: HFPointsPerCoffeeHit];
        [self.coffeCollisionBody removeFromParent];
    }
    //donut hitting the ground
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryDonut | CollisionCategoryGround))
    {
        if (contact.bodyA.categoryBitMask == CollisionCategoryDonut)
        {
            self.donutCollisionBody = (HFDonutNode*)contact.bodyA.node;
            self.groundCollisionBody = (HFGroundNode*)contact.bodyB.node;
        }else
        {
            self.donutCollisionBody = (HFDonutNode*)contact.bodyB.node;
            self.groundCollisionBody = (HFGroundNode*)contact.bodyA.node;
        }

        [self.donutCollisionBody removeFromParent];
    }
    //donut hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryDonut | CollisionCategoryCar))
    {
        if (contact.bodyA.categoryBitMask == CollisionCategoryDonut)
        {
            self.donutCollisionBody = (HFDonutNode*)contact.bodyA.node;
            self.carCollisionBody = (HFCar*)contact.bodyB.node;
        }else
        {
            self.donutCollisionBody = (HFDonutNode*)contact.bodyB.node;
            self.carCollisionBody = (HFCar*)contact.bodyA.node;
        }

        [self addPoints:HFPointsPerDonutHit];
        [self.donutCollisionBody removeFromParent];
    }
    //baby hitting the ground
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryBaby | CollisionCategoryGround))
    {
        if (contact.bodyA.categoryBitMask == CollisionCategoryBaby)
        {
            self.babyCollisionBody = (HFBabyNode*)contact.bodyA.node;
            self.groundCollisionBody = (HFGroundNode*)contact.bodyB.node;
        }else
        {
            self.babyCollisionBody = (HFBabyNode*)contact.bodyB.node;
            self.groundCollisionBody = (HFGroundNode*)contact.bodyA.node;
        }

        [self loseLife];
        [self.babyCollisionBody removeFromParent];
    }
    //baby hitting the car
    else if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (CollisionCategoryBaby | CollisionCategoryCar))
    {
        if (contact.bodyA.categoryBitMask == CollisionCategoryBaby)
        {
            self.babyCollisionBody = (HFBabyNode*)contact.bodyA.node;
            self.carCollisionBody = (HFCar*)contact.bodyB.node;
        }else
        {
            self.babyCollisionBody = (HFBabyNode*)contact.bodyB.node;
            self.carCollisionBody = (HFCar*)contact.bodyA.node;
        }

        [self addPoints:HFPointsPerBabyHit];
        [self.babyCollisionBody removeFromParent];
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

    if (self.timeSinceMonitorAdded > self.monitorSpawnTimeInterval && self.timeSinceMonitorAdded > self.donutSpawnTimeInterval && self.timeSinceMonitorAdded > self.coffeeSpawnTimeInterval && self.timeSinceMonitorAdded > self.babySpawnTimeInterval && !self.gameOver)
    {
        [self initializeBabyMonitor];
        [self initializeDonuts];
        [self initializeCoffee];
        [self initializeBaby];
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
        self.monitorSpawnTimeInterval = 1;
        self.donutSpawnTimeInterval = 1.5;
        self.coffeeSpawnTimeInterval = 1.75;
        self.babySpawnTimeInterval = 2;
    }
    else if(self.totalGameTime > 30)
    {
        self.monitorSpawnTimeInterval = 1.25;
        self.donutSpawnTimeInterval = 1.75;
        self.coffeeSpawnTimeInterval = 2;
        self.babySpawnTimeInterval = 2.25;
    }
    else if(self.totalGameTime > 20)
    {
        self.monitorSpawnTimeInterval = 1.5;
        self.donutSpawnTimeInterval = 2;
        self.coffeeSpawnTimeInterval = 2.25;
        self.babySpawnTimeInterval = 2.5;
    }
    else if(self.totalGameTime > 10)
    {
        self.monitorSpawnTimeInterval = 1.75;
        self.donutSpawnTimeInterval = 2.25;
        self.coffeeSpawnTimeInterval = 2.5;
        self.babySpawnTimeInterval = 2.75;
    }

    if(self.gameOver && !self.gameOverDisplayed)
    {
        [self performGameOver];
    }

    HFHudNode *hud = (HFHudNode *)[self childNodeWithName:@"HUD"];
    if (hud.score > 1000)
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
    HFCar *carNode = [HFCar initWithPosition:CGPointMake(self.size.width / 2, (carSize.height / 2) + 40)];
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

-(void)initializeDonuts
{
    HFDonutNode *donut = [HFDonutNode generateDonuts];
    float deltaY = [HFUtilities randomWithMin:HFBabyMonitorMinSpeed max:HFBabyMonitorMaxSpeed];
    donut.physicsBody.velocity = CGVectorMake(0, deltaY);

    //range of spawn position
    float yCoordinate = self.frame.size.height + donut.size.height;
    float xCoordinate = [HFUtilities randomWithMin:donut.size.width + 10 max:self.frame.size.width - donut.size.width - 10];
    donut.position = CGPointMake(xCoordinate, yCoordinate);
    donut.name = @"Donut";
    [self addChild:donut];
}

-(void)initializeCoffee
{
    HFCoffeeNode *coffee = [HFCoffeeNode generateCoffee];
    float deltaY = [HFUtilities randomWithMin:HFBabyMonitorMinSpeed max:HFBabyMonitorMaxSpeed];
    coffee.physicsBody.velocity = CGVectorMake(0, deltaY);

    //range of spawn position
    float yCoordinate = self.frame.size.height + coffee.size.height;
    float xCoordinate = [HFUtilities randomWithMin:coffee.size.width + 10 max:self.frame.size.width - coffee.size.width - 10];
    coffee.position = CGPointMake(xCoordinate, yCoordinate);
    coffee.name = @"Donut";
    [self addChild:coffee];
}

-(void)initializeBaby
{
    HFCoffeeNode *coffee = [HFCoffeeNode generateCoffee];
    float deltaY = [HFUtilities randomWithMin:HFBabyMonitorMinSpeed max:HFBabyMonitorMaxSpeed];
    coffee.physicsBody.velocity = CGVectorMake(0, deltaY);

    //range of spawn position
    float yCoordinate = self.frame.size.height + coffee.size.height;
    float xCoordinate = [HFUtilities randomWithMin:coffee.size.width + 10 max:self.frame.size.width - coffee.size.width - 10];
    coffee.position = CGPointMake(xCoordinate, yCoordinate);
    coffee.name = @"Donut";
    [self addChild:coffee];
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
        [carNode.physicsBody applyForce:CGVectorMake(65 * accelerationData.acceleration.y, 0)];
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
