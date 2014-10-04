//
//  HFUtilities.m
//  BabyBlitz
//
//  Created by Harrison Ferrone on 10/2/14.
//  Copyright (c) 2014 nexTIER Games. All rights reserved.
//

#import "HFUtilities.h"

@implementation HFUtilities

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max
{
    return arc4random()%(max - min) + min;
}

@end
