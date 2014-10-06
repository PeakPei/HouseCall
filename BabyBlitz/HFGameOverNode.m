//
//  HFGameOverNode.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/6/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFGameOverNode.h"

@implementation HFGameOverNode

+(instancetype)gameOverAtPosition:(CGPoint)position
{
    HFGameOverNode *gameOver = [self node];

    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    gameOverLabel.name = @"GameOver";
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontSize = 48;
    gameOverLabel.position = position;

    [gameOver addChild:gameOverLabel];

    return gameOver;
}

@end
