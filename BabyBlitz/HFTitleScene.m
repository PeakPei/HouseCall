//
//  HFTitleScene.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/2/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFTitleScene.h"
#import "HFMainGameScene.h"
#import "HFRootViewController.h"

@implementation HFTitleScene

-(void)didMoveToView:(SKView *)view
{
    SKLabelNode *placeholderText = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    placeholderText.position = CGPointMake(self.size.width/2, self.size.height/2);
    placeholderText.text = @"Touch Anywhere to Continue";
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
