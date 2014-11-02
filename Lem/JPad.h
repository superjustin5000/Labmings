//
//  JPad.h
//  MiningForPrincess
//
//  Created by Justin Fletcher on 6/29/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//


#ifndef __JPAD_H__
#define __JPAD_H__


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface JPad : CCNode {
    
    CCSprite *dpad;
    CGPoint dpadStart;
    CGRect dpadRect;
    int directional;
    float dpadAngle;
    short dpadHypotenuse;
    
    float buttonOpacity;
    BOOL rotatedToPortrait;
    BOOL rotatedDpadStart;
    
    CCSprite *bButton;
    CGRect bButtonRect;
    
    CCSprite *aButton;
    CGRect aButtonRect;
    
    BOOL touchUp;
    BOOL touchDown;
    BOOL touchLeft;
    BOOL touchRight;
    BOOL touchB;
    BOOL touchA;
    
}

@property(nonatomic, retain)CCSprite *dpad;
@property(nonatomic)CGPoint dpadStart;
@property(nonatomic)CGRect dpadRect;
@property(nonatomic)CGRect bButtonRect;
@property(nonatomic)CGRect aButtonRect;
@property(nonatomic)BOOL touchUp, touchDown, touchLeft, touchRight, touchB, touchA;
@property(nonatomic)float dpadAngle;
@property(nonatomic)short dpadHypotenuse;


+(JPad*)getPad;
+(id)pad;
+(id)padWithDirections:(int)directions;
-(id)initWithDirections:(int)directions;

-(void)rotatePadToPortrait;

-(int)touchesDpad:(CGPoint)touch;
-(int)touches4Pad:(CGPoint)touch;
-(int)touches8Pad:(CGPoint)touch;
-(void)touchesOPad:(CGPoint)touch;
-(void)touchBegan:(CGPoint)location;
-(void)touchMoved:(CGPoint)location;
-(void)touchEnded:(CGPoint)location;



@end


#endif
