//
//  HFHudNode.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/6/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFHudNode.h"
#import "HFUtilities.h"

@implementation HFHudNode

+(instancetype)hudAtPostions:(CGPoint)position inFrame:(CGRect)frame
{
    HFHudNode *hud = [self node];
    hud.position = position;
    hud.name = @"HUD";
    hud.zPosition = 10;

    SKSpriteNode *livesImage = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(50, 50)];
    livesImage.position = CGPointMake(30, -10);
    [hud addChild:livesImage];

    hud.lives = HFMaxLives;

    SKSpriteNode *lastLifeBar;

    for(int i = 0; i < hud.lives; i++)
    {
        SKSpriteNode *lifeNode = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(15, 15)];
        lifeNode.name = [NSString stringWithFormat:@"Life%d", i + 1];
        [hud addChild:lifeNode];

        if(lastLifeBar == nil)
        {
            lifeNode.position = CGPointMake(livesImage.position.x + 30, livesImage.position.y);
        }else {
            lifeNode.position = CGPointMake(lastLifeBar.position.x + 10, lastLifeBar.position.y);
        }

        lastLifeBar = lifeNode;
    }

    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    scoreLabel.name = @"Score";
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 24;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(frame.size.width - 20, -10);
    [hud addChild:scoreLabel];
    
    return hud;
}

-(void)addPoint:(NSInteger)points
{
    self.score += points;

    SKLabelNode *scoreLabel = (SKLabelNode*)[self childNodeWithName:@"Score"];
    scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
}

-(BOOL)loseLife
{
    if(self.lives > 0)
    {
        NSString *lifeString = [NSString stringWithFormat:@"Life%ld", (long)self.lives];
        SKNode *lifeToRemove = (SKNode*)[self childNodeWithName:lifeString];
        [lifeToRemove removeFromParent];
        self.lives--;
    }

    return self.lives == 0;
}

@end
