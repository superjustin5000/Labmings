#ifndef __GAMESTATE_H__
#define __GAMESTATE_H__
//
//  GameState.h
//
//  Created by Justin Fletcher on 6/27/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "macros.h"

@class JSprite;
@class JScene;
@class JLevel;

@interface GameState : NSObject {
    
    
    
    ////// PUT VARIABLES HERE THAT ARE SHARED THROUGHOUT THE GAME
    JScene *gameScene;
    JLevel *gameLevel;
	
	////// SAVED - things that need to be remembered if the app is quit
    
	
	
	////// NOT SAVED - things that only matter while the app is running
    NSString *gameFont;
    CGSize winSize;
    float FPSwanted;
    CCTime gameDelta; ////use this when you want stuff to happen slower when the frame rate drops.
    float gameSpeed;
    BOOL paused;
    
    
    
    JSprite *player;
    CGPoint playerPos;
    CGRect playerRect;
    
    NSMutableArray *_jSprites;
    NSMutableArray *_bullets, *_attacks, *_enemies, *_otherShooters;
    NSMutableArray *_lems;
    
    
}


/////// properties
@property(nonatomic, retain)JScene *gameScene;
@property(nonatomic, retain)JLevel *gameLevel;

//////////////////// SAVED




//////////////////// NOT SAVED
@property(nonatomic, retain)NSString *gameFont;
@property(nonatomic, readonly)CGSize winSize;
@property(nonatomic)float FPSwanted;
@property(nonatomic)CCTime gameDelta;
@property(nonatomic)float gameSpeed;
@property(nonatomic)BOOL paused;


@property(nonatomic, retain)JSprite *player;
@property(nonatomic)CGPoint playerPos;
@property(nonatomic)CGRect playerRect;

@property(nonatomic, retain)NSMutableArray *_jSprites;
@property(nonatomic, retain)NSMutableArray *_bullets, *_attacks, *_enemies, *_otherShooters;
@property(nonatomic, retain)NSMutableArray *_lems;



/////////////////// METHODS

+(GameState *)sharedGameState;






-(int)randomNumberFrom:(int)from To:(int)to;
-(float)random0to1withDeviation:(float)deviation;

-(CGRect)rectByFlippingRect:(CGRect)r OverXAxis:(int)x;

-(NSMutableArray *)framesWithFrameName:(NSString *)framename fromFrame:(int)fromF toFrame:(int)toF;  //reverse is NO
-(NSMutableArray *)framesWithFrameName:(NSString *)framename fromFrame:(int)fromF toFrame:(int)toF andAntiAlias:(BOOL)antialias; /// antialias is NO
-(NSMutableArray *)framesWithFrameName:(NSString *)framename fromFrame:(int)fromF toFrame:(int)toF andReverse:(BOOL)reverse andAntiAlias:(BOOL)antialias; //able to say whether to add reverse frames after the original frames.

-(NSMutableArray *)framesWithFrameName:(NSString *)framename fromFrame:(int)fromF toFrame:(int)toF andReverse:(BOOL)reverse andAntiAlias:(BOOL)antialias andAppendedString:(NSString*)appended; //able to say whether to add reverse frames after the original frames.


@end

#endif
