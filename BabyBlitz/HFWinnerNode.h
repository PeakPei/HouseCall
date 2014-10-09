//
//  HFWinnerNode.h
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/8/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HFWinnerNode : SKNode

+(instancetype)winConditionAtPosition:(CGPoint)position;
-(void)performAnimation;

@end
