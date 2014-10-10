//
//  HFGameOverScene.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/8/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFGameOverScene.h"
#import "HFMainGameScene.h"

@implementation HFGameOverScene

-(void)didMoveToView:(SKView *)view
{
    SKLabelNode *placeholderText = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    placeholderText.position = CGPointMake(self.size.width/2, self.size.height/2);
    placeholderText.text = @"After Action Report";
    placeholderText.fontColor = [UIColor whiteColor];
    placeholderText.fontSize = 26;
    [self addChild:placeholderText];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    HFMainGameScene *mainGame = [HFMainGameScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:mainGame transition:transition];
}

@end
