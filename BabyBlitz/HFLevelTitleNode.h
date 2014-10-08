//
//  HFLevelTitleNode.h
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/8/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HFLevelTitleNode : SKNode

+(instancetype)levelTitleAtPosition:(CGPoint)position levelNumber:(NSInteger)level;
-(void)performAnimation;

@end
