//
//  HFGameOverNode.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/6/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFGameOverNode.h"
#import "HFMainGameScene.h"
#import "HFRootViewController.h"

@implementation HFGameOverNode

+(instancetype)gameOverAtPosition:(CGPoint)position
{
    HFGameOverNode *gameOver = [self node];

    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    gameOverLabel.name = @"GameOver";
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontSize = 48;
    gameOverLabel.position = position;

    [gameOver addChild:gameOverLabel];

    return gameOver;
}

-(void)performAnimation
{
    SKLabelNode *labelNode = (SKLabelNode*)[self childNodeWithName:@"GameOver"];
    labelNode.xScale = 0;
    labelNode.yScale = 0;

    SKAction *scaleUp = [SKAction scaleTo:1.2 duration:.75];
    SKAction *scaleDown = [SKAction scaleTo:0.9 duration:.25];
    SKAction *run = [SKAction runBlock:^
    {
        SKLabelNode *touchToRestart = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        touchToRestart.text = @"Touch to Continue";
        touchToRestart.name = @"Restart";
        touchToRestart.fontSize = 24;
        touchToRestart.position = CGPointMake(labelNode.position.x, labelNode.position.y - 40);
        [self addChild:touchToRestart];
    }];
    SKAction *scaleSequence = [SKAction sequence:@[scaleUp, scaleDown, run]];

    [labelNode runAction:scaleSequence];
}

@end
