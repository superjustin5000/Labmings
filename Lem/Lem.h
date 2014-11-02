//
//  Lem.h
//  Lem
//
//  Created by Justin Fletcher on 7/7/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Floor;
@class Wall;

@interface Lem : JSprite {
    
    CGPoint frontFoot;
    CGPoint backFoot;
    CGPoint midFoot; ///not literally a foot, but between the two in the middle of the sheep.
    CGPoint frontSensor;
    CGPoint backSensor;
    CGPoint frontHead;
    CGPoint backHead;
    CGPoint midHead;
    CGPoint maxAngleSensor;
    
    
    BOOL isGravity;
    float gravity;
    
    int fallingHeight;
    int deathHeight;
    
    BOOL isOnFloor;
    
    
    ///----PARACHUTE
    float parachuteVelocity;
    BOOL parachuteActive;
    
    ///----CLIMBER
    BOOL isClimbing;
    float climbingVelocity;
    
    ///----DIGGER
    BOOL isDiggingTunnel;
    float digTimer;
    
    ///----BUILDER
    BOOL isBuildingStairs;
    float buildtimer;
    int numStairs;
    
    
    ///----BOMBER
    float bombTimer;
    int bomberLastSecond;////so label isn't updated everyframe.
    CCLabelTTF *bomberTimerLabel;
    
    
    int curJob;
    int curPassiveJob;
    
    
    
    BOOL reachedExit;
    
    BOOL changeColor;
    float animTimer;
    
    
}

@property(nonatomic)CGPoint frontFoot, backFoot, midFoot, frontSensor, backSensor, maxAngleSensor, frontHead, backHead, midHead;
@property(nonatomic)float gravity;
@property(nonatomic)BOOL isGravity, isOnFloor, isDiggingTunnel, isClimbing, reachedExit;
@property(nonatomic)int curJob;


+(id)lem;

-(void)updateMidFoot;
-(void)updateClimbingAndWalkingSharedSensors;
-(void)updateLem:(CCTime)delta;

-(void)changeJobTo:(int)type;
-(void)landOnFloor;
-(void)fallOffFloor;
-(void)die;
-(void)stepDown;
-(void)hitWallWithType:(int)type;
-(void)hitWallJustTopWithType:(int)type;
-(void)hitWallNinetyDegreesWithType:(int)type;
-(void)hitCeiling;

@end
