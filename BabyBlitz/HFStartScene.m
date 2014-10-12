//
//  HFStartScene.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/8/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFStartScene.h"
#import "HFDoctorSelectScene.h"

@implementation HFStartScene

-(void)didMoveToView:(SKView *)view
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"StartScreen"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [self addChild:background];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    HFDoctorSelectScene *doctorSelect = [HFDoctorSelectScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:doctorSelect transition:transition];
}

@end
