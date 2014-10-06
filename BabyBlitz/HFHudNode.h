//
//  HFHudNode.h
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/6/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HFHudNode : SKNode

+(instancetype)hudAtPostions:(CGPoint)position inFrame:(CGRect)frame;
-(void)addPoint:(NSInteger)points;
-(BOOL)loseLife;

@property NSInteger lives;
@property NSInteger score;

@end
