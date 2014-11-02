//
//  lemExit.m
//  Lem
//
//  Created by Justin Fletcher on 7/15/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "LemExit.h"

@implementation LemExit

+(id)ExitWithGameName:(NSString *)gameName {
    return [[self alloc] initWithGameName:gameName];
}

-(id)initWithGameName:(NSString *)gameName {
    
    CCSpriteFrame *s = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:gameName];
    
    self = [super initWithSpriteFrame:s];
    
    shouldCheckCollisions = NO;
    
    
    return self;
}

@end
