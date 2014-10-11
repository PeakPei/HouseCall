//
//  HFDoctorSelectScene.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/8/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFDoctorSelectScene.h"
#import "HFTutorialScene1.h"
#import "HFStartScene.h"
#import "HFHudNode.h"

@interface HFDoctorSelectScene ()

@property NSArray *nodeArray;
@property SKSpriteNode *doctorImage1;
@property SKSpriteNode *doctorImage2;
@property SKSpriteNode *doctorImage3;
@property SKSpriteNode *doctorImage4;
@property SKSpriteNode *doctorImage5;
@property NSString *savedImageName;

@end

@implementation HFDoctorSelectScene

-(void)didMoveToView:(SKView *)view
{
    SKLabelNode *placeholderText = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    placeholderText.position = CGPointMake(self.size.width/2, self.size.height/2 + 115);
    placeholderText.text = @"Doctor Select";
    placeholderText.fontColor = [UIColor whiteColor];
    placeholderText.fontSize = 26;
    [self addChild:placeholderText];

    self.doctorImage1 = [SKSpriteNode spriteNodeWithImageNamed:@"afro"];
    self.doctorImage1.size = CGSizeMake(90, 90);
    self.doctorImage1.name = @"doc1";
    self.doctorImage1.position = CGPointMake(self.size.width/2 - 150, self.size.height/2 + 40);
    [self addChild:self.doctorImage1];

    self.doctorImage2 = [SKSpriteNode spriteNodeWithImageNamed:@"claymore"];
    self.doctorImage2.position = CGPointMake(self.doctorImage1.position.x + 150, self.size.height/2 + 40);
    self.doctorImage2.size = CGSizeMake(90, 90);
    self.doctorImage2.name = @"doc2";
    [self addChild:self.doctorImage2];

    self.doctorImage3 = [SKSpriteNode spriteNodeWithImageNamed:@""];
    self.doctorImage3.size = CGSizeMake(90, 90);
    self.doctorImage3.name = @"doc3";
    self.doctorImage3.position = CGPointMake(self.doctorImage2.position.x + 150, self.size.height/2 + 40);
    [self addChild:self.doctorImage3];

    self.doctorImage4 = [SKSpriteNode spriteNodeWithImageNamed:@""];
    self.doctorImage4.size = CGSizeMake(90, 90);
    self.doctorImage4.name = @"doc4";
    self.doctorImage4.position = CGPointMake(self.doctorImage1.position.x + 75, self.size.height/2 - 65);
    [self addChild:self.doctorImage4];

    self.doctorImage5 = [SKSpriteNode spriteNodeWithImageNamed:@""];
    self.doctorImage5.size = CGSizeMake(90, 90);
    self.doctorImage5.name = @"doc5";
    self.doctorImage5.position = CGPointMake(self.doctorImage2.position.x + 75, self.size.height/2 - 65);
    [self addChild:self.doctorImage5];

    self.nodeArray = @[self.doctorImage1, self.doctorImage2, self.doctorImage3, self.doctorImage4, self.doctorImage5];

    SKLabelNode *backButton = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    backButton.position = CGPointMake(25, 25);
    backButton.text = @"Back";
    backButton.name = @"Back";
    backButton.fontColor = [UIColor whiteColor];
    backButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    backButton.fontSize = 26;
    [self addChild:backButton];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    if ([node isKindOfClass:[SKSpriteNode class]])
    {
        HFTutorialScene1 *tutorial1 = [HFTutorialScene1 sceneWithSize:self.frame.size];
        SKTransition *transition = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:tutorial1 transition:transition];
    }

    if ([node.name isEqualToString:@"Back"])
    {
        HFStartScene *start = [HFStartScene sceneWithSize:self.frame.size];
        SKTransition *transition = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:start transition:transition];
    }

    if([node.name isEqualToString:@"doc1"])
    {
        self.savedImageName = @"afro";

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.savedImageName forKey:@"savedImage"];
        [defaults synchronize];
    }
    else if([node.name isEqualToString:@"doc2"])
    {
        self.savedImageName = @"claymore";

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.savedImageName forKey:@"savedImage"];
        [defaults synchronize];
    }
}

@end
