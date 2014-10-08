//
//  HFGameOverNode.h
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/6/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HFGameOverNode : SKNode

+(instancetype)gameOverAtPosition:(CGPoint)position;
-(void)performAnimation;

@end
