//
//  JSprite.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/27/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#ifndef __JSPRITE_H__
#define __JSPRITE_H__



#import <Foundation/Foundation.h>

#import "cocos2d.h"



@class GameState;


@interface JSprite : CCSprite {
    
    //GameState *gs;
    GameState *gs;

    
    BOOL shouldCheckCollisions;
    BOOL canCollide;
    BOOL isColliding;
    CGRect collisionRect;
    
    float width, height, widthHalf, heightHalf;
    
    
    CGPoint velocity;
    CGPoint initVelocity;
    CGPoint maxVelocity;
    CGPoint acceleration;
    
    
    float maxH;
    float startH;
    float curH;
    
    BOOL alive;
    BOOL afterLife;
    BOOL visible;
    BOOL scroll;
    
    BOOL destroyNextFrame;
    
    long currentAnimationTag;
    
}

@property(nonatomic)CGPoint velocity, initVelocity, maxVelocity;
@property(nonatomic)float maxH, startH, curH;
@property(nonatomic)BOOL destroyNextFrame, shouldCheckCollisions, canCollide, isColliding;
@property(nonatomic)CGRect collisionRect;

@property(nonatomic,strong)id idleAction;



+(void)addToSpriteArray:(JSprite*)sprite;
+(void)removeFromSpriteArray:(JSprite*)sprite;


+(id)sprite;
+(id)spriteWithSpriteFrame:(CCSpriteFrame *)spriteFrame;
-(id)initWithSpriteFrame:(CCSpriteFrame *)spriteFrame;

-(void)initJSprite;
-(void)setStartingHealth:(float)h;
-(void)setInitVelocity:(CGPoint)v;
-(void)resetVelocityToInit;

-(void)setAnimationWithFrameName:(NSString*)f fromFrame:(int)from toFrame:(int)to withReverse:(BOOL)r andRepeat:(BOOL)rp andDelay:(float)delay andTag:(int)tag;
-(void)setAnimation:(CCAnimation*)anim repeat:(BOOL)rp tag:(int)tag;
-(void)setDisplayFrameWithSpriteFrameName:(NSString*)name;
-(long)getCurrentAnimationFrameIndex;

-(void)updateJSprite:(CCTime)dt;
-(void)takeDamage:(float)damage;
-(void)aliveOff;
-(void)aliveOn;
-(void)afterLifeOff;
-(void)afterLifeOn;
-(void)destroyJSprite;


-(void)updateCollisionRect;
-(CGRect)newCollisionRect;

-(void)checkCollisions;
-(void)collisionInit;
-(BOOL)checkCollidedWith:(JSprite *)sprite;
-(void)didCollideWith:(JSprite*)sprite;
-(void)didCollideWithTopOf:(JSprite*)sprite;
-(void)didCollideWithBottomOf:(JSprite*)sprite;
-(void)didCollideWithLeftOf:(JSprite*)sprite;
-(void)didCollideWithRightOf:(JSprite*)sprite;
-(void)noCollisions;

@end


#endif
