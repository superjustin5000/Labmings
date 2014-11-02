//
//  Lem.m
//  Lem
//
//  Created by Justin Fletcher on 7/7/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "Lem.h"

#import "Level.h"


#import "LemExit.h"

#import "JobButtons.h"

@implementation Lem

@synthesize frontFoot,backFoot,midFoot,frontSensor,backSensor,maxAngleSensor, frontHead, backHead, midHead;
@synthesize gravity;
@synthesize isGravity, isOnFloor, isDiggingTunnel, isClimbing, reachedExit;
@synthesize curJob;

+(id)lem {
    return [[self alloc] initWithGameName:@"pplayer.png"];
}

-(id)initWithGameName:(NSString*)gameName {
    CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:gameName];
    self = [super initWithSpriteFrame:spriteFrame];
    
    
    
    isGravity = YES;
    gravity = -0.3;
    
    fallingHeight = 0;
    deathHeight = 200;
    
    isOnFloor = NO;
    
    
    //// parachute
    parachuteVelocity = 1;
    parachuteActive = NO;
    
    
    //// climber
    isClimbing = NO;
    climbingVelocity = 1;
    
    
    //// digger
    isDiggingTunnel = NO;
    digTimer = 0;
    
    //// builder
    isBuildingStairs = NO;
    buildtimer = 0;
    numStairs = 0;
    
    
    curJob = kJobNone;
    curPassiveJob = curJob;
    
    
    reachedExit = NO;
    
    
    initVelocity = velocity = CGPointMake(1, 0);
    maxVelocity = CGPointMake(5, 5);
    
    
    
    [gs._lems addObject:self];
    
    [gs._jSprites removeObject:self];
    
    return self;
}



-(void)die {
    Level *level = (Level*)gs.gameLevel;
    [level._lemsToRemove addObject:self];
    destroyNextFrame = YES;
}






-(void)landOnFloor {
    
    isOnFloor = YES;
    
    isGravity =  NO;
    
    velocity = CGPointMake(initVelocity.x * self.scaleX, 0);
    
    
    
    if ((fallingHeight >= deathHeight))
        [self die];
    
    
    
    fallingHeight = 0;

}

-(void)fallOffFloor {
    isOnFloor = NO;
    velocity = CGPointMake(0, velocity.y);
}
-(void)stepDown {
    //isOnFloor = NO;
}








-(void)hitWallWithType:(int)type {
    
    if (type != kCollisionColorBlocker) { ///you're not hitting a blocker........
    
        if (curJob == kJobDigger) {
            
            BOOL facingRightCanDigOnlyRight = (self.scaleX == 1 && type == kCollisionColorBlue);
            BOOL facingLeftCanDigOnlyLeft = (self.scaleX == -1 && type == kCollisionColorGreen);
            
            if (type == kCollisionColorOther || facingLeftCanDigOnlyLeft || facingRightCanDigOnlyRight) {
            
                if (!isDiggingTunnel) {
                    
                    isDiggingTunnel = YES;
                    
                }
                
                return;
                
            }
            
        }
        
        
        else if (curPassiveJob == kJobPassiveClimber || curPassiveJob == kJobPassiveParachuteAndClimber) {
            
            if (!isClimbing) {
                isClimbing = YES;
            }
            
            return;
            
        }
    
        
    }
    
    ////// no specific job or condition met..... just turn around when you hit the wall
    
    velocity = CGPointMake(-velocity.x, velocity.y);
    self.scaleX = -self.scaleX;
    
    
}

-(void)hitWallJustTopWithType:(int)type {
    [self hitWallWithType:kCollisionColorBlocker]; ///used color blocker since it makes you turn around without without being able to dig or do anythign else.
}

-(void)hitWallNinetyDegreesWithType:(int)type { ////// --- GOTTA DO SOMETHING WITH THIS METHOD.
    [self hitWallWithType:type];
}



-(void)hitCeiling {
    
    if (isClimbing) {
        isClimbing = NO;
        
        self.scaleX = -self.scaleX;
        
        [self fallOffFloor];
    }
    
}





////////////////
/////////////// --------------------------------------  S P E C I F I C . J O B . M E T H O D S






-(void)changeJobTo:(int)type {
    
    
    ////////// C H A N G E . T H E . P A S S I V E . J O B . T Y P E
    
    if (type == kJobPassiveParachute || type == kJobPassiveClimber || type == kJobNone) {
        
        if (type == kJobPassiveParachute) {
            if (curPassiveJob == kJobPassiveClimber) {
                curPassiveJob = kJobPassiveParachuteAndClimber;
            }
            else {
                curPassiveJob = type;
            }
        }
        
        else if (type == kJobPassiveClimber) {
            if (curPassiveJob == kJobPassiveParachute) {
                curPassiveJob = kJobPassiveParachuteAndClimber;
            }
            else {
                curPassiveJob = type;
            }
        }
        
        else if (type == kJobNone) {
            
            curJob = type;
            
        }
        
        [self setDisplayFrameWithSpriteFrameName:@"pplayer.png"];
        
        //type = curNoneJob;
        
        return;
        
        //// dont have to change display frames yet when setting none jobs since giving a digger a parchute should not change him.
        //[self setDisplayFrameWithSpriteFrameName:@"pplayer.png"];
    }
    
    
    
    ////////// C H A N G E . T H E . A C T I V E . J O B . T Y P E
    
    else if (type == kJobBlocker) {
        if (!isOnFloor) {
            [self changeJobError];
            return;
        }
        else {
            Level *l = (Level*)gs.gameLevel;
            [l addMaskToBackgroundWithSprite:self Position:self.position BlendMode:l.blendModeAdd Erase:NO];
            [self setDisplayFrameWithSpriteFrameName:@"pplayerRed.png"];
        }
    }
    else if (type == kJobDigger) {
        [self setDisplayFrameWithSpriteFrameName:@"pplayerPink.png"];
    }
    else if (type == kJobDiggerDown) {
        [self setDisplayFrameWithSpriteFrameName:@"pplayerPink.png"];
    }
    else if (type == kJobBuilder) {
        if (!isOnFloor) {
            [self changeJobError];
            return;
        }
        else {
            isBuildingStairs = YES;
            [self setDisplayFrameWithSpriteFrameName:@"pplayerPurple.png"];
        }
    }
    else if (type == kJobTimeTraveler) {
        [self setDisplayFrameWithSpriteFrameName:@"pplayerWhite.png"];
    }
    else if (type == kJobFlashLight) {
        [self setDisplayFrameWithSpriteFrameName:@"pplayerYellow.png"];
        velocity = ccp(0,0);
    }
    else if (type == kJobBomber) {
        [self setDisplayFrameWithSpriteFrameName:@"pplayerOrange.png"];
        bomberLastSecond = 3;
        bomberTimerLabel = [CCLabelTTF labelWithString:@"3" fontName:nil fontSize:14];
        bomberTimerLabel.position = ccp(self.position.x, self.position.y + self.contentSize.height/2 + bomberTimerLabel.contentSize.height/2 + 5);
        bomberTimerLabel.color = [CCColor colorWithCcColor3b:ccc3(255, 255, 255)];
        [gs.gameLevel addChild:bomberTimerLabel];
    }
    
    curJob = type;
    
}



-(void)changeJobError { /////call this method if changing a job fails.....   should make the sprite glow.. or make a sound.
    
    
    
}


-(void)explodeBomber { //////make a circle hole into the level map whereever the lem currently is.  and kill the lem.
    [self die];
    Level *l = (Level*)gs.gameLevel;
    CCSprite *digCircle = [CCSprite spriteWithImageNamed:@"digMaskCircle.png"];
    l.maskFileName = @"digMaskCircle.png";
    [l addMaskToBackgroundWithSprite:digCircle Position:self.position BlendMode:l.blendModeCutOut Erase:YES];
    [bomberTimerLabel removeFromParent];
}










////////////////
/////////////// --------------------------------------  U P D A T I N G . S E N S O R S







-(void)updateMidFoot { ///// designed for mesuring the foot in a while loop within the game loop.
    midFoot = ccp(self.position.x, self.position.y - heightHalf);
}

-(void)updateClimbingAndWalkingSharedSensors { //// the three front sensors.
    float selfScaleX = self.scaleX;
    float selfPositionX = self.position.x;
    float selfPositionY = self.position.y;
    
    int frontX = selfPositionX + (selfScaleX * widthHalf);
    int backX = selfPositionX - (selfScaleX * widthHalf);
    int topY = selfPositionY + heightHalf;
    int bottomY = selfPositionY - heightHalf;
    
    frontHead = ccp(frontX, topY);
    frontFoot = ccp(frontX, bottomY);
    
    if (isClimbing) {
        
        backHead = ccp(backX, topY);
        midHead = ccp(selfPositionX, topY);
        
    }
    
    else {
        
        frontSensor = ccp(frontX, selfPositionY);
        maxAngleSensor = ccp(frontX, topY);
        backFoot = ccp(backX, bottomY);
        midFoot = ccp(selfPositionX, bottomY);
        
    }
}







////////////////
/////////////// --------------------------------------  U P D A T E / S T E P


-(void)updateLem:(CCTime)delta {
    
    
    if (curJob != kJobTimeTraveler && curJob != kJobBlocker) { //// don't do anything in update if a time travelers or a blocker
    
        
        BOOL setPositionAtEndOfUpdate = YES; //// so if certain jobs dont want it to do this call.... saves on cpu in the long run..
        
        
        /*
        
         ///// testing performace with animations
        
        if (animTimer >= 0.08) {
            animTimer = 0;
        
            if (!changeColor) {
                changeColor = YES;
                [self setDisplayFrameWithSpriteFrameName:@"pplayerRed.png"];
            }
            else {
                changeColor = NO;
                [self setDisplayFrameWithSpriteFrameName:@"pplayer.png"];
            }
        
            
        }
        else {
            animTimer += delta;
        }
        */
        
        ////// CLAMP VELOCITY ....
        
        if (velocity.x > maxVelocity.x) velocity = CGPointMake(maxVelocity.x, velocity.y);
        else if (velocity.x < -maxVelocity.x) velocity = CGPointMake(-maxVelocity.x, velocity.y);
        if (velocity.y > maxVelocity.y) velocity = CGPointMake(velocity.x, maxVelocity.y);
        else if (velocity.y < -maxVelocity.y) velocity = CGPointMake(velocity.x, -maxVelocity.y);
            
        
        
        if (!isOnFloor) { ////////////////// ------- N O T . O N . T H E . F L O O R
            
            //NSLog(@"not moving x");
            
            //NSLog(@"falling... move with y");
            velocity = CGPointMake(0, velocity.y + gravity);
            
            
            if (curPassiveJob == kJobPassiveParachute || curPassiveJob == kJobPassiveParachuteAndClimber) {
                if (fallingHeight >= 20 && !parachuteActive) {
                    parachuteActive = YES;
                    if (velocity.y < -parachuteVelocity) velocity = CGPointMake(velocity.x, -parachuteVelocity);
                }
            }
            
            else {
                fallingHeight += abs((int)velocity.y);
            }
            
            
            
            
        }
        else { ///////////////// ------------ O N . T H E . F L O O R
            
            
            velocity = CGPointMake(velocity.x, 0);
            
            float selfScaleX = self.scaleX; ///// use for direction facing calculations.
            
            
            /// check diggers first... they're pretty important.
            
            if (curJob == kJobDiggerDown) {
                if (digTimer >= 1) {
                    Level *l = (Level*)gs.gameLevel;
                    [l addMaskToBackgroundWithSprite:l.digMask Position:CGPointMake(self.position.x, self.position.y - heightHalf) BlendMode:l.blendModeCutOut Erase:YES];
                    digTimer = 0;
                }
                else {
                    digTimer += delta;
                    velocity = CGPointMake(0, 0);
                }
                
            }
            
            else if (curJob == kJobDigger) {
                
                if (isDiggingTunnel) {
                    
                    if (digTimer >= 1) {
                        digTimer = 0;
                        isDiggingTunnel = NO;
                        
                        Level *l = (Level*)gs.gameLevel;
                        [l addMaskToBackgroundWithSprite:l.digMask Position:CGPointMake(self.position.x + (selfScaleX * width), self.position.y - heightHalf + 20) BlendMode:l.blendModeCutOut Erase:YES];
                        
                        [self landOnFloor];
                    }
                    else {
                        digTimer += delta;
                        velocity = CGPointMake(0, 0);
                    }
                    
                }
                
            }
            
            
            else if (curJob == kJobBuilder) {
                
                
                if (isBuildingStairs) {
                    
                    
                    if (buildtimer >= 1) {
                        
                        buildtimer = 0;
                        
                        Level *l = (Level*)gs.gameLevel;
                        
                        float selfPosX = self.position.x; ////for multiple posx calulations here.
                        
                        CGPoint stairPos = CGPointMake(selfPosX + (selfScaleX * widthHalf) - ( 2 * selfScaleX ), self.position.y - heightHalf);
                        [l addMaskToBackgroundWithSprite:l.buildMask Position:stairPos BlendMode:l.blendModeAdd Erase:NO];
                        
                        
                        setPositionAtEndOfUpdate = NO;
                        self.position = ccp(selfPosX + (stairPos.x - selfPosX), stairPos.y + l.buildMask.contentSize.height/2 + heightHalf);
                        
                        
                        
                        numStairs += 1;
                        
                        if (numStairs >= 12) {
                            numStairs = 0;
                            isBuildingStairs = NO;
                            [self landOnFloor];
                            [self changeJobTo:kJobNone];
                        }
                        
                    }
                    
                    else {
                        buildtimer += delta;
                        velocity = CGPointMake(0, 0);
                    }
                    
                    
                }
                
                
            }
            
            
            else if (curJob == kJobBomber) {
                
                if (bombTimer >= 3) {
                    bombTimer = 0;
                    [self explodeBomber];
                    return;
                }
                else {
                    bombTimer += delta;
                    
                    int timeRemaining = (3 - floor(bombTimer));
                    
                    if (timeRemaining < bomberLastSecond) {
                        bomberLastSecond = timeRemaining;
                        [bomberTimerLabel setString:[NSString stringWithFormat:@"%d", timeRemaining]];
                    }
                    
                    bomberTimerLabel.position = ccp(self.position.x, self.position.y + self.contentSize.height/2 + bomberTimerLabel.contentSize.height/2 + 5);
                    
                }
                
            }
            
            
            else  {
                
                ///////// NO CURRENT JOB .... SO FREE TO CHECK PASSIVE JOBS.....
             
                if (curPassiveJob == kJobPassiveClimber || curPassiveJob == kJobPassiveParachuteAndClimber) {
                    
                    if (isClimbing) {
                        velocity = CGPointMake(0, climbingVelocity);
                    }
                    else {
                        velocity = CGPointMake(initVelocity.x * selfScaleX, 0);
                    }
                    
                }
                
                
            }
            
            
            
            
            
        }
        
        
        
        ////finally update the position.
        if (setPositionAtEndOfUpdate) {
            self.position = ccp(self.position.x + velocity.x, self.position.y + velocity.y);
        }
    
    }
    
}




-(void)didCollideWith:(JSprite *)sprite {
    if ([sprite isKindOfClass:[LemExit class]]) {
        reachedExit = YES;
    }
    
    else {
        [super didCollideWith:sprite];
    }
}




@end
