//
//  LemStart.m
//  Lem
//
//  Created by Justin Fletcher on 7/31/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "LemStart.h"

@implementation LemStart


+(id)StartWithGameName:(NSString *)gameName {
    return [[self alloc] initWithGameName:gameName];
}

-(id)initWithGameName:(NSString *)gameName {
    
    CCSpriteFrame *s = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:gameName];
    
    self = [super initWithSpriteFrame:s];
    
    shouldCheckCollisions = NO;
    
    
    
    return self;
}


@end
