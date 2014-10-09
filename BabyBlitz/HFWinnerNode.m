//
//  HFWinnerNode.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/8/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFWinnerNode.h"

@implementation HFWinnerNode

+(instancetype)winConditionAtPosition:(CGPoint)position
{
    HFWinnerNode *winConditionNode = [self node];

    SKLabelNode *winLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    winLabel.name = @"Winner!";
    winLabel.text = @"Win";
    winLabel.fontSize = 48;
    winLabel.position = position;

    [winConditionNode addChild:winLabel];

    return winConditionNode;
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
                         touchToRestart.text = @"Touch to Restart";
                         touchToRestart.name = @"Restart";
                         touchToRestart.fontSize = 24;
                         touchToRestart.position = CGPointMake(labelNode.position.x, labelNode.position.y - 40);
                         [self addChild:touchToRestart];
                     }];
    SKAction *scaleSequence = [SKAction sequence:@[scaleUp, scaleDown, run]];
    
    [labelNode runAction:scaleSequence];
}

@end
