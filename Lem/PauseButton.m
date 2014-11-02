//
//  PauseButton.m
//  Lem
//
//  Created by Justin Fletcher on 7/13/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "PauseButton.h"

@implementation PauseButton

-(id)init {
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    
    self.exclusiveTouch = NO;
    self.claimsUserInteraction = NO;
    
    
    
    return self;
}


-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (![GameState sharedGameState].paused) {
    
        if (![GameState sharedGameState].paused) {
            [[GameState sharedGameState].gameLevel pauseLevel];
        }
        
    }
}

@end
