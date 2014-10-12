//
//  HFGameOverScene.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/8/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFGameOverScene.h"
#import "HFStartScene.h"

@implementation HFGameOverScene

-(void)didMoveToView:(SKView *)view
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"EndgameScreen"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [self addChild:background];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    HFStartScene *start = [HFStartScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:start transition:transition];
}

@end
