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
    SKLabelNode *placeholderText = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    placeholderText.position = CGPointMake(self.size.width/2, self.size.height/2);
    placeholderText.text = @"Start";
    placeholderText.fontColor = [UIColor whiteColor];
    placeholderText.fontSize = 26;
    [self addChild:placeholderText];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    HFDoctorSelectScene *doctorSelect = [HFDoctorSelectScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:doctorSelect transition:transition];
}

@end
