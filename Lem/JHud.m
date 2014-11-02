//
//  hud.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/31/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#import "JHud.h"

static JHud *hud;

@implementation JHud

+(JHud*)getHud {
    return hud;
}


+(id)hudWithPad:(BOOL)withPad {
    JPad *pad;
    if (withPad) { pad = [JPad pad]; } else { pad = nil; }
    return [self hudWithPad:withPad thisPad:pad];
}

+(id)hudWithPad:(BOOL)withPad thisPad:(JPad *)thisPad {
    return [[self alloc] initWithPad:withPad thisPad:thisPad];
}

-(id)initWithPad:(BOOL)withPad thisPad:(JPad *)thisPad {
    if ((self = [super init])) {
        
        //[self setContentSize:[GameState sharedGameState].winSize];
        
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        
        self.exclusiveTouch = NO;
        self.claimsUserInteraction = NO;
        
        isPadEnabled = withPad;
        
        if (isPadEnabled) {
            pad = thisPad;
            [self addChild:pad];
        }
        
        hud = self;
        
    }
    
    return self;
    
}








-(void)enablePad {
    isPadEnabled = YES;
}
-(void)disablePad {
    isPadEnabled = NO;
    pad.touchA = NO;
    pad.touchB = NO;
    pad.touchDown = NO;
    pad.touchLeft = NO;
    pad.touchRight = NO;
    pad.touchUp = NO;
}
-(BOOL)isPadEnabled {
    return isPadEnabled;
}





-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //for (UITouch *touch in touches) {
    
    if (![GameState sharedGameState].paused) {
        
        CGPoint location = [touch locationInNode:self];
    
        int touchSize = 10;
        CGRect touchRect = CGRectMake(location.x - touchSize/2, location.y - touchSize/2, touchSize, touchSize);
        
        if (isPadEnabled) {
            if (CGRectIntersectsRect(touchRect, pad.dpadRect)) {
                if (dpadTouch != touch && bButtonTouch != touch && aButtonTouch != touch) {
                    dpadTouch = touch; ////if it intersects the dpad, this is now the dpad touch.
                }
                [pad touchBegan:location];
            }
            else if (CGRectIntersectsRect(touchRect, pad.bButtonRect)) {
                if (bButtonTouch != touch && dpadTouch != touch && aButtonTouch != touch) {
                    bButtonTouch = touch;
                }
                pad.touchB = YES;
            }
            else if (CGRectIntersectsRect(touchRect, pad.aButtonRect)) {
                if (aButtonTouch != touch && dpadTouch != touch && bButtonTouch != touch) {
                    aButtonTouch = touch;
                }
                pad.touchA = YES;
            }
        }

    }
        
    //}
}


-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    //for (UITouch *touch in touches) {
    
    if (![GameState sharedGameState].paused) {
    
        CGPoint location = [touch locationInNode:self];
        int touchSize = 10;
        CGRect touchRect = CGRectMake(location.x, location.y, touchSize, touchSize);
        
        if (isPadEnabled) {
            if (dpadTouch == touch) {/////dont do anything unless it's the dpad touch.
                if (CGRectIntersectsRect(touchRect, pad.dpadRect)) { [pad touchMoved:location]; }
            }        
            else if (bButtonTouch == touch) {
                if (CGRectIntersectsRect(touchRect, pad.bButtonRect)) { pad.touchB = YES; }
                else { if (pad.touchB) pad.touchB = NO; }
            }
            else if (aButtonTouch == touch) {
                if (CGRectIntersectsRect(touchRect, pad.aButtonRect)) { pad.touchA = YES; }
                else { if (pad.touchA) pad.touchA = NO; }
                
            }
        }
        
    }
    
    //}
}


-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //for (UITouch *touch in touches) {
    
    if (![GameState sharedGameState].paused) {
    
        CGPoint location = [touch locationInNode:self];
    
        if (isPadEnabled) {
            if (dpadTouch == touch) {
                pad.touchUp = NO;
                pad.touchDown = NO;
                pad.touchLeft = NO;
                pad.touchRight = NO;
                dpadTouch = nil; //// so that it can be a new touch when touches begin again.
                [pad touchEnded:location];
            }
            else if (bButtonTouch == touch) {
                pad.touchB = NO;
                bButtonTouch = nil;
            }
            else if (aButtonTouch == touch) {
                pad.touchA = NO;
                aButtonTouch = nil;
            }
        }
   // }
    
    }

}


@end
