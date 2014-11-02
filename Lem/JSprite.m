//
//  JSprite.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/27/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

//#import "cocos2d.h"
#import "JSprite.h"


#import "GameState.h"

#import "CCAnimation.h"


static NSMutableArray *spriteArray;

@implementation JSprite

@synthesize velocity, initVelocity, maxVelocity;
@synthesize maxH, startH, curH;
@synthesize destroyNextFrame, shouldCheckCollisions, canCollide, isColliding;
@synthesize collisionRect;

@synthesize idleAction;


+(void)addToSpriteArray:(JSprite*)sprite {
    if (sprite)
        [[GameState sharedGameState]._jSprites addObject:sprite];
}
+(void)removeFromSpriteArray:(JSprite*)sprite {
    if (sprite)
        if ([[GameState sharedGameState]._jSprites containsObject:sprite])
            [[GameState sharedGameState]._jSprites removeObject:sprite];
}








+(id)sprite {
    return [[self alloc] init];
}


-(id)init {
    return [super init]; ///ccsprite init calls initwithtexture:nil rect:cgrectzero
}


+(id)spriteWithSpriteFrame:(CCSpriteFrame *)spriteFrame {
    return [[self alloc] initWithSpriteFrame:spriteFrame];
}


-(id)initWithSpriteFrame:(CCSpriteFrame *)spriteFrame {
    
    
    if (spriteFrame != NULL) {
        self = [super initWithSpriteFrame:spriteFrame];
    }
    else {
        self = [super init];
    }
    
    if (self) {
    
        gs = [GameState sharedGameState];
        
        
        [self.texture setAntialiased:false]; ///keeps textures pixelated
        
        
        
        width = self.contentSize.width;
        height = self.contentSize.height;
        widthHalf = width/2;
        heightHalf = height/2;
        
        
        
        
        initVelocity = CGPointMake(0, 0);
        velocity = initVelocity;
        maxVelocity = CGPointMake(10000, 10000);
        acceleration = CGPointMake(0, 0);
        
        
        shouldCheckCollisions = YES;
        canCollide = YES;
        isColliding = NO;
        
        alive = YES;
        afterLife = NO;
        maxH = 1;
        startH = maxH;
        curH = startH;
        
        
        destroyNextFrame = NO; ////set to yes at anytime, and the next frame the jsprite will be destroyed.
        
        
        
        [self initJSprite]; ////a subclass init method that should be overrided for any subclass needing an init method with no perameters.
        
        
        
        [self schedule:@selector(updateJSprite:) interval:gs.gameDelta];
        
        
        [gs._jSprites addObject:self];
        //NSLog(@"%d jsprites", spriteArray.count);
    }
    
    return self;
}

-(void)initJSprite {
    ///override.
}

-(void)setStartingHealth:(float)h {
    curH = maxH = startH = h;
}

-(void)setInitVelocity:(CGPoint)v {
    initVelocity = maxVelocity = velocity = v;
}
-(void)resetVelocityToInit {
    [self setInitVelocity:initVelocity];
}





//////////////--------------------------   ANIMATIONS  -------------


-(void)setAnimationWithFrameName:(NSString *)f fromFrame:(int)from toFrame:(int)to withReverse:(BOOL)r andRepeat:(BOOL)rp andDelay:(float)delay andTag:(int)tag {
    [self stopAllActions];
    
    NSMutableArray *baseFrames = [gs framesWithFrameName:f fromFrame:from toFrame:to andReverse:r andAntiAlias:NO];
    CCAnimation *baseAnimation = [CCAnimation animationWithSpriteFrames:baseFrames delay:delay];
    
    
    [self setAnimation:baseAnimation repeat:rp tag:tag];
}

-(void)setAnimation:(CCAnimation *)anim repeat :(BOOL)rp tag:(int)tag {
    CCActionAnimate *finalAction = [CCActionAnimate actionWithAnimation:anim];
    finalAction.tag = tag;
    currentAnimationTag = finalAction.tag;
    
    if (rp)
        [self runAction:[CCActionRepeatForever actionWithAction:finalAction]];
    else
        [self runAction:finalAction];
    
}


-(void)setDisplayFrameWithSpriteFrameName:(NSString *)name {
    [self stopAllActions];
    [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
}


////////// GETS THE FRAME INDEX OF THE CURRENT RUNNING ANIMATION.... RETURNS -1 IF NO ANIMATION IS RUNNING OR IF AND ANIMATION IS NESTED WITHIN CCREPEAT, OR SEQUENCE.

-(long)getCurrentAnimationFrameIndex {
    CCActionAnimate *currentAnimation = (CCActionAnimate*)[self getActionByTag:currentAnimationTag];
    return currentAnimation._nextFrame - 1;
}






//////////////--------------------------   U P D A T E  -------------


-(void)updateJSprite:(CCTime)dt {
    
    /*
    if (curH <= 0) {
        curH = 0;
        
        if (alive) { ///you're hp is 0, if you're still alive, kill you.
            [self aliveOff];
        }
        
    }
     */
    
    
    if (destroyNextFrame)
        [self destroyJSprite];
    
    
    
    
    if (alive || afterLife) { ////after life is for things that can still function after alive is set to no.
    
        
        
        
        //////#######****  COLLISION STUFF
        
        //////////////////// THIS CODE UPDATES THE POSITION INFORMATION FOR THE PHYSICS BODY.
        
        if (canCollide) {
            
            collisionRect = [self newCollisionRect];
            
            if (shouldCheckCollisions) [self checkCollisions]; //// starts all the steps for collision checks.
        }
        
    
    } ////end if alive || afterlife
    
    
    
    
    
}




//////////////--------------------------   D A M A G E . A N D . D E S T R U C T I O N  -------------


-(void)takeDamage:(float)damage {
    curH = curH - damage;
}


-(void)aliveOff {
    alive = NO;
}
-(void)aliveOn {
    alive = YES;
}
-(void)afterLifeOff {
    afterLife = NO;
}
-(void)afterLifeOn {
    [self aliveOff];
    afterLife = YES;
}
-(void)destroyJSprite {
    
    //[spriteArray removeObject:self]; ///this is why it doesn't collide any more. collisions are checked with sprites in the sprite array.
    [gs._jSprites removeObject:self];
    [self removeFromParentAndCleanup:YES];
}





-(void)updateCollisionRect { ///should be called if you need to set the collision rect manually... like when you first create a jsprite it wont update the rect until the next frame.
    collisionRect = [self newCollisionRect];
}

-(CGRect)newCollisionRect {
    return CGRectMake(self.position.x - widthHalf, self.position.y - heightHalf, width, height);
}



/////////////////// OVERRIDE THIS IF YOU DONT WANT TO CHECK COLLISIONS WITH EVERY JSPRITE (check the bullet class of ShootEmUp game)
-(void)checkCollisions {
    
    isColliding = NO;
    
    
    [self collisionInit];
    
    //for (JSprite *sprite in [JSprite getSpriteArray]) {
    for (JSprite *sprite in gs._jSprites) {
        if (sprite) {
            if (sprite != self) {
                if (sprite.canCollide) {
                    if ([self checkCollidedWith:sprite]) {
                        isColliding = YES;
                    }
                }
            }
        }
    }
    
    if (!isColliding) {
        [self noCollisions];
    }
}

//////////// -- Method to initialize collision variables. Called before any known collisions.
-(void)collisionInit {
    
}


/////////// -- Called for every sprite that can check collisions
-(BOOL)checkCollidedWith:(JSprite *)sprite {
    BOOL col = CGRectIntersectsRect(collisionRect, sprite.collisionRect);
    
    if (col) [self didCollideWith:sprite];
    
    return col;
}




////// IF COLLISIONS HAPPENED THESE METHODS WILL BE CALLED ---- override them, but make sure to call [super didCollideWith:sprite];
-(void)didCollideWith:(JSprite *)sprite {
    int side;
    
    
    ////// check sides of collisions........
    
    
    if (side == kCollisionSideTop)
        [self didCollideWithTopOf:sprite];
    else if (side == kCollisionSideBottom)
        [self didCollideWithBottomOf:sprite];
    else if (side == kCollisionSideLeft)
        [self didCollideWithLeftOf:sprite];
    else if (side == kCollisionSideRight)
        [self didCollideWithRightOf:sprite];
}


/////////////////// OVERRIDE THESE METHODS FOR EACH SPRITE THAT NEEDS TO CHECK THEM.
-(void)didCollideWithTopOf:(JSprite *)sprite {}
/////////////////// OVERRIDE THESE METHODS FOR EACH SPRITE THAT NEEDS TO CHECK THEM.
-(void)didCollideWithBottomOf:(JSprite *)sprite {}
/////////////////// OVERRIDE THESE METHODS FOR EACH SPRITE THAT NEEDS TO CHECK THEM.
-(void)didCollideWithLeftOf:(JSprite *)sprite {}
/////////////////// OVERRIDE THESE METHODS FOR EACH SPRITE THAT NEEDS TO CHECK THEM.
-(void)didCollideWithRightOf:(JSprite *)sprite {}

/////// -- sprite collided with nothing this frame.
-(void)noCollisions {}










//////////////// OVERRIDED CCSPRITE METHODS GO HERE ----------------------




@end
