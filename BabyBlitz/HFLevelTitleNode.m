//
//  HFLevelTitleNode.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/8/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFLevelTitleNode.h"

@implementation HFLevelTitleNode

+(instancetype)levelTitleAtPosition:(CGPoint)position levelNumber:(NSInteger)level
{
    HFLevelTitleNode *levelTitle = [self node];

    SKLabelNode *levelTitleLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    levelTitleLabel.name = @"Level";
    levelTitleLabel.text = [NSString stringWithFormat:@"Level %d", level];
    levelTitleLabel.fontSize = 48;
    levelTitleLabel.position = position;

    [levelTitle addChild:levelTitleLabel];

    return levelTitle;
}

-(void)performAnimation
{
    SKLabelNode *labelNode = (SKLabelNode*)[self childNodeWithName:@"Level"];
    labelNode.xScale = 0;
    labelNode.yScale = 0;

    SKAction *scaleUp = [SKAction scaleTo:1.2 duration:.75];
    SKAction *scaleDown = [SKAction scaleTo:0.9 duration:.25];
    SKAction *scaleSequence = [SKAction sequence:@[scaleUp, scaleDown]];
    
    [labelNode runAction:scaleSequence];
}

@end
