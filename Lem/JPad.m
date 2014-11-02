//
//  JPad.m
//  MiningForPrincess
//
//  Created by Justin Fletcher on 6/29/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#import "JPad.h"

static JPad *pad;

@implementation JPad

@synthesize dpad;
@synthesize dpadStart;
@synthesize dpadRect, aButtonRect, bButtonRect;
@synthesize touchUp, touchDown, touchLeft, touchRight, touchA, touchB;
@synthesize dpadAngle;
@synthesize dpadHypotenuse;


+(JPad*)getPad {
    if (!pad)
        return NULL;
    return pad;
}


+(id)pad {
    return [[self alloc] initWithDirections:kdpadDirection8];
}

+(id)padWithDirections:(int)directions {
    return [[self alloc] initWithDirections:directions];
}

-(id)initWithDirections:(int)directions {
    if ((self = [super init])) {
        
        directional = directions;
        
        buttonOpacity = 0.5;
        
        dpad = [CCSprite spriteWithImageNamed:@"dpad.png"];
        dpad.position = ccp(10 + dpad.contentSize.width/2, 10 + dpad.contentSize.height/2);
        dpadStart = dpad.position;
        dpad.opacity = buttonOpacity;
        [self addChild:dpad];
        dpadRect = CGRectMake(dpad.position.x - dpad.contentSize.width/2 - 25, dpad.position.y - dpad.contentSize.height/2 - 25, dpad.contentSize.width + 50, dpad.contentSize.height + 50);
        
        
        int width = [[CCDirector sharedDirector] viewSize].width;
        
        aButton = [CCSprite spriteWithImageNamed:@"aButton.png"];
        aButton.position = ccp(width - 20 - aButton.contentSize.width/2, aButton.contentSize.height/2 + 20);
        aButton.opacity = buttonOpacity;
        [self addChild:aButton];
        aButtonRect = CGRectMake(aButton.position.x - aButton.contentSize.width/2 - 10, aButton.position.y - aButton.contentSize.height/2 - 10, aButton.contentSize.width + 20, aButton.contentSize.height + 20);
        
        bButton = [CCSprite spriteWithImageNamed:@"bButton.png"];
        bButton.position = ccp(aButton.position.x - aButton.contentSize.width/2 - 40 - bButton.contentSize.width/2, aButton.position.y);
        bButton.opacity = buttonOpacity;
        [self addChild:bButton];
        bButtonRect = CGRectMake(bButton.position.x - bButton.contentSize.width/2 - 10, bButton.position.y - bButton.contentSize.height/2 - 10, bButton.contentSize.width + 20, bButton.contentSize.height + 20);

        
        
        [self schedule:@selector(updatePositions:) interval:1/60.0];
        
        
        pad = self;
        
        
    }
    return self;
}




-(void)updatePositions:(CCTime)delta {
    
    int width = [[CCDirector sharedDirector] viewSize].width;
    int height = [[CCDirector sharedDirector] viewSize].height;
    
    if (!rotatedToPortrait) {
        
        dpad.opacity = buttonOpacity;
        dpadRect = CGRectMake(dpad.position.x - dpad.contentSize.width/2 - 25, dpad.position.y - dpad.contentSize.height/2 - 25, dpad.contentSize.width + 50, dpad.contentSize.height + 50);
        
        aButton.position = ccp(width - 20 - aButton.contentSize.width/2, aButton.contentSize.height/2 + 20);
        aButton.opacity = buttonOpacity;
        aButtonRect = CGRectMake(aButton.position.x - aButton.contentSize.width/2 - 10, aButton.position.y - aButton.contentSize.height/2 - 10, aButton.contentSize.width + 20, aButton.contentSize.height + 20);
        
        bButton.position = ccp(aButton.position.x - aButton.contentSize.width/2 - 40 - bButton.contentSize.width/2, aButton.position.y);
        bButton.opacity = buttonOpacity;
        bButtonRect = CGRectMake(bButton.position.x - bButton.contentSize.width/2 - 10, bButton.position.y - bButton.contentSize.height/2 - 10, bButton.contentSize.width + 20, bButton.contentSize.height + 20);
    }
    
    else {
        
        ///////////////// How to position the dpad and buttons if the level is vertical.
        
        if (!rotatedDpadStart) {
            dpadStart = dpad.position;
            rotatedDpadStart = YES;
        }
        
        dpad.opacity = buttonOpacity;
        dpadRect = CGRectMake(dpad.position.x - dpad.contentSize.width/2 - 25, dpad.position.y - dpad.contentSize.height/2 - 25, dpad.contentSize.width + 50, dpad.contentSize.height + 50);

        
        aButton.position = ccp(width - 20 - aButton.contentSize.width/2, height - aButton.contentSize.height/2 - 40);
        aButton.opacity = buttonOpacity;
        aButtonRect = CGRectMake(aButton.position.x - aButton.contentSize.width/2 - 10, aButton.position.y - aButton.contentSize.height/2 - 10, aButton.contentSize.width + 20, aButton.contentSize.height + 20);
        aButton.rotation = -90;
        
        bButton.position = ccp(aButton.position.x - aButton.contentSize.width/2 - 30 - bButton.contentSize.width/2, aButton.position.y + 20);
        bButton.opacity = buttonOpacity;
        bButtonRect = CGRectMake(bButton.position.x - bButton.contentSize.width/2 - 10, bButton.position.y - bButton.contentSize.height/2 - 10, bButton.contentSize.width + 20, bButton.contentSize.height + 20);
        bButton.rotation = aButton.rotation;
        
    }
    
}

-(void)rotatePadToPortrait {
    rotatedToPortrait = YES;
    ////set dpad position here so the dpad start position gets reset, and the dpad position is not set every from in the updatePositions method since the dpad moves a bit when you move your finger across it.
    int width = [[CCDirector sharedDirector] viewSize].width;
    dpad.position = ccp(width - dpad.contentSize.width/2 - 10, 10 + dpad.contentSize.height/2);
}





-(int)touchesDpad:(CGPoint)touch { ///returns either 0, the touch of 4 direction pad, or the touch of omni direction pad.
    
    self.position = ccp(0, 0);
    
    CGPoint center = CGPointMake(dpad.position.x, dpad.position.y);
    float x = touch.x - center.x;
    float y = touch.y - center.y;
    
    dpadHypotenuse = sqrt(x*x + y*y);
    
    if (dpadHypotenuse >= 15) { ///only work if distance from center is at least 15.
        
        switch (directional) {
            case kdpadDirection4:
                return [self touches4Pad:CGPointMake(x, y)];
                break;
            case kdpadDirection8:
                return [self touches8Pad:CGPointMake(x, y)];
            case kdpadDirectionOmni:
                [self touchesOPad:CGPointMake(x, y)];
                
            default:
                break;
        }

    }

    return 0;

}


-(int)touches4Pad:(CGPoint)touch { //// 4 directional pad. //touch is actually the xy coordinate of actual touch relative to the dpad.
    
    float angle = atan2f(touch.y, touch.x); if (angle < 0) { angle = -angle; angle = 3.14 + (3.14 - angle); } ///getting the radians right
    angle = angle * 180 / 3.14; ////turning it into degrees.
    angle = angle + 45; if (angle > 360) { angle = 0 + (angle - 360); } ///// rotating the angles by 45 degrees clockwise.
    
    int touching;
    
    if (angle >= 0 && angle < 90) { ///touching right
        touching = kdpadRight;
    }
    else if (angle >= 90 && angle < 180) { ///touching top
        touching = kdpadUp;
    }
    else if (angle >= 180 && angle < 270) { ///touching left
        touching = kdpadLeft;
    }
    else if (angle >= 270 && angle <= 360) { ///touching down
        touching = kdpadDown;
    }
    else {
        touching = 0;
    }
    
    return touching;
    
}

-(int)touches8Pad:(CGPoint)touch {
    float angle = atan2f(touch.y, touch.x); if (angle < 0) { angle = -angle; angle = 3.14 + (3.14 - angle); } ///getting the radians right
    angle = angle * 180 / 3.14; ////turning it into degrees.
    angle = angle + 45; if (angle > 360) { angle = 0 + (angle - 360); } ///// rotating the angles by 45 degrees clockwise.
    
    int touching;
    
    if (angle >= 15 && angle < 75) { ///touching right
        touching = kdpadRight;
    }
    else if (angle >= 75 && angle < 105) { ///touching upright
        touching = kdpadUpRight;
    }
    else if (angle >= 105 && angle < 165) { ///touching up
        touching = kdpadUp;
    }
    else if (angle >= 165 && angle < 195) { ///touching upleft
        touching = kdpadUpLeft;
    }
    else if (angle >= 195 && angle < 255) { ///touching left
        touching = kdpadLeft;
    }
    else if (angle >= 255 && angle < 285) { ///touching downleft
        touching = kdpadDownLeft;
    }
    else if (angle >= 285 && angle <= 345) { ///touching down
        touching = kdpadDown;
    }
    else if ((angle >= 345 && angle <= 360) || (angle >= 0 && angle <= 15)) { ///touching downright
        touching = kdpadDownRight;
    }
    else {
        touching = 0;
    }
    
    return touching;
}


-(void)touchesOPad:(CGPoint)touch { //// omni directional pad.
    
    dpadAngle = atan2f(touch.y, touch.x); if (dpadAngle < 0) { dpadAngle = -dpadAngle; dpadAngle = 3.14 + (3.14 - dpadAngle); } ///getting the radians right
    //dpadAngle = (short)floor(angle * 180 / 3.14); ////turning it into degrees.
    
}


-(void)touchBegan:(CGPoint)location {
    int touching = [self touchesDpad:location];
    if (touching == kdpadUp) {
        touchLeft = NO;
        touchRight = NO;
        touchDown = NO;
        touchUp = YES;
        dpad.position = ccp(dpadStart.x, dpadStart.y + 10);
    }
    else if (touching == kdpadDown) {
        touchLeft = NO;
        touchRight = NO;
        touchUp = NO;
        touchDown = YES;
        dpad.position = ccp(dpadStart.x, dpadStart.y - 10);
    }
    else if (touching == kdpadLeft) {
        touchRight = NO;
        touchUp = NO;
        touchDown = NO;
        touchLeft = YES;
        dpad.position = ccp(dpadStart.x - 10, dpadStart.y);
    }
    else if (touching == kdpadRight) {
        touchLeft = NO;
        touchUp = NO;
        touchDown = NO;
        touchRight = YES;
        dpad.position = ccp(dpadStart.x + 10, dpadStart.y);
    }
    else if (touching == kdpadUpLeft) {
        touchLeft = YES;
        touchUp = YES;
        touchDown = NO;
        touchRight = NO;
        dpad.position = ccp(dpadStart.x - 10, dpadStart.y + 10);
    }
    else if (touching == kdpadUpRight) {
        touchLeft = NO;
        touchUp = YES;
        touchDown = NO;
        touchRight = YES;
        dpad.position = ccp(dpadStart.x + 10, dpadStart.y + 10);
    }
    else if (touching == kdpadDownLeft) {
        touchLeft = YES;
        touchUp = NO;
        touchDown = YES;
        touchRight = NO;
        dpad.position = ccp(dpadStart.x - 10, dpadStart.y - 10);
    }
    else if (touching == kdpadDownRight) {
        touchLeft = NO;
        touchUp = NO;
        touchDown = YES;
        touchRight = YES;
        dpad.position = ccp(dpadStart.x + 10, dpadStart.y - 10);
    }
}

-(void)touchMoved:(CGPoint)location {
    
    
    dpadHypotenuse = 0;
    //dpadAngle = 0;
    
    int touching = [self touchesDpad:location];
    if (touching == kdpadUp) {
        touchLeft = NO;
        touchRight = NO;
        touchDown = NO;
        touchUp = YES;
        dpad.position = ccp(dpadStart.x, dpadStart.y + 10);
    }
    else if (touching == kdpadDown) {
        touchLeft = NO;
        touchRight = NO;
        touchUp = NO;
        touchDown = YES;
        dpad.position = ccp(dpadStart.x, dpadStart.y - 10);
    }
    else if (touching == kdpadLeft) {
        touchRight = NO;
        touchUp = NO;
        touchDown = NO;
        touchLeft = YES;
        dpad.position = ccp(dpadStart.x - 10, dpadStart.y);
    }
    else if (touching == kdpadRight) {
        touchLeft = NO;
        touchUp = NO;
        touchDown = NO;
        touchRight = YES;
        dpad.position = ccp(dpadStart.x + 10, dpadStart.y);
    }
    else if (touching == kdpadUpLeft) {
        touchLeft = YES;
        touchUp = YES;
        touchDown = NO;
        touchRight = NO;
        dpad.position = ccp(dpadStart.x - 10, dpadStart.y + 10);
    }
    else if (touching == kdpadUpRight) {
        touchLeft = NO;
        touchUp = YES;
        touchDown = NO;
        touchRight = YES;
        dpad.position = ccp(dpadStart.x + 10, dpadStart.y + 10);
    }
    else if (touching == kdpadDownLeft) {
        touchLeft = YES;
        touchUp = NO;
        touchDown = YES;
        touchRight = NO;
        dpad.position = ccp(dpadStart.x - 10, dpadStart.y - 10);
    }
    else if (touching == kdpadDownRight) {
        touchLeft = NO;
        touchUp = NO;
        touchDown = YES;
        touchRight = YES;
        dpad.position = ccp(dpadStart.x + 10, dpadStart.y - 10);
    }
    else {
        touchLeft = NO;
        touchRight = NO;
        touchUp = NO;
        touchDown = NO;
    }
}

-(void)touchEnded:(CGPoint)location {
    dpad.position = dpadStart;
    dpadHypotenuse = 0;
    dpadAngle = 0;
}


@end
