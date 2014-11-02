//
//  macros.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/4/12.
//  Copyright (c) 2012 Justin Fletcher. All rights reserved.
//


#ifndef __MACROS_H__
#define __MACROS_H__

///// jEngine macros.

#define kdpadDirection4 1
#define kdpadDirection8 2
#define kdpadDirectionOmni 3
#define kdpadUp 1
#define kdpadDown 2
#define kdpadLeft 3
#define kdpadRight 4
#define kdpadUpLeft 5
#define kdpadUpRight 6
#define kdpadDownLeft 7
#define kdpadDownRight 8

#define kdirectionUp 1
#define kdirectionDown 2
#define kdirectionLeft 3
#define kdirectionRight 4


#define kzHud 1000




///// current game macros.

#define kJobNone 0

#define kJobBlocker 2
#define kJobDigger 3
#define kJobDiggerDown 4
#define kJobTimeTraveler 5
#define kJobBuilder 6
#define kJobBomber 7
#define kJobFlashLight 8

#define kJobPassiveParachute 100
#define kJobPassiveClimber 101
#define kJobPassiveParachuteAndClimber 102



#define kCollisionColorAlphaZero 0
#define kCollisionColorBlack 1
#define kCollisionColorRed 2
#define kCollisionColorGreen 3
#define kCollisionColorBlue 4
#define kCollisionColorOther 5
#define kCollisionColorStairs 100
#define kCollisionColorBlocker 101


#define kCollisionSideTop 0
#define kCollisionSideRight 1
#define kCollisionSideBottom 2
#define kCollisionSideLeft 3








///collectable types.
#define kCollectableTest @"collectable_test"



///bullet types and damage stuff
#define kbulletTypePlayer 1
#define kbulletTypeEnemy 2
#define kbulletTypeWalkingPlayer 3
#define kbulletTypeWalkingEnemy 4
#define kbulletTypePowerup 5 ////shot from power up node
#define kbulletTypeWalkingPowerup 6 ///walking power up node




//////------------- Z . I N D E X E S


#define kZBackground 0
#define kZBackground10 10////makes room for things to be between backgrounds.
#define kZBackground20 20
#define kZBackground30 30
#define kZBackground40 40
#define kZBackground50 50



#define kZWater 78 //just behind the map.

#define kZTileMap 80 ///// where to put the tile map.

#define kZGameLayer 100

//#define kZShips 500 ///// ships are behind most things except the background.
//#define kZPlayerShip 600 //// the players ship is over other ships.
//#define kZPowerup 700 /// almost as important to see as player, but behind.

#define kZPlayer 700 //have to be able to see the player especially when he's jumping.

#define kZEnemies 800 ////enemies right behind player.

#define kZExplode 898 ///explosions happen on top of everything.... except bullets and collectables.
#define kZCollectables 899 ///only behind bullets.

#define kZBullets 900 // in front of everything other than forground stuff. ///bullets should always be visible.
#define kZWalkingBullets 901 ///same as above but these are even more important.
#define kZForground 998 /// bottom forground stuff.
#define kZForground2 999 /// big stuf in very forground.

#define kZCloudBack 1 /////the back layer of clouds is behind everything, except the background.
#define kZCloudFront 1000 ///the clouds at the top. should be infront of everything.
#define kZScreen 2000 //////for anything that has to be directly on the screen.















/*
 
 
 ////////////////  ------- SUPER SKY HERO MACROS
 
 
 ////////// hud faces
 #define kHudFaceStatic 0
 #define kHudFacePilot1 1
 #define kHudFaceRoxie1 10
 
 
 
 ///enemy ship types for ship groups
 #define kShipTypeKami 1
 #define kShipTypeKami2 2
 #define kShipTypeFighter 3
 #define kShipTypeFighter2 4
 #define kShipTypeMech 5
 #define kShipTypeTurret 6
 #define kShipTypeTrooper 7
 #define kShipTypeAttacker 8
 #define kShipTypeBomber 9
 
 ///enemy movement types for ship groups
 #define kMoveTypeRightToLeft 1
 #define kMoveTypeLeftToRight 2
 #define kMoveTypeSin 3
 #define kMoveTypeSinLTR 4
 #define kMoveTypeCosLTR 5
 #define kMoveTypeCos 6
 #define kMoveTypeRoot 7
 #define kMoveTypeCornerToCorner13 8
 #define kMoveTypeCornerToCorner31 9
 #define kMoveTypeCornerToCorner24 10
 #define kMoveTypeCornerToCorner42 11
 #define kMoveTypeSemiCircleTop 12
 #define kMoveTypeSemiCircleBottom 13
 #define kMoveTypeEnterFromRightAndStop 14
 #define kMoveTypeEnterFromTopLeftAndDown 15
 #define kMoveTypeEnterFromBottomLeftAndUp 16
 #define kMoveTypeEnterAndLeave 17
 #define kMoveTypeEnterSemiCircleExit 18
 #define kMoveTypeFollowPlayer 19
 #define kMoveTypeStepUp 20
 #define kMoveTypeStepDown 21
 #define kMoveTypeSplitDiagonalUp 22
 #define kMoveTypeSplitDiagonalDown 23
 
 ///ship speeds.
 #define kShipSpeedNone 0
 #define kShipSpeedNormal 1
 #define kShipSpeedNormalAndAHalf 1.5
 #define kShipSpeedDouble 2
 
 ///different engine flames
 #define kengineFlameSmallBlue 1
 #define kengineFlameSmallRed 2
 
 
 
 
 ////// enemy types for when walking
 #define kEnemyTypeTest 0
 #define kEnemyTypeSoldier1 1
 #define kEnemyTypeGoldRobo 2
 #define kEnemyTypeFlyingDroid 3
 #define kEnemyTypeFlyingDroid2 4
 
 
 
 
 
 #define kbulletDirectionNormal 0
 #define kbulletDirectionNegativeX 1
 #define kbulletDirectionNegativeY 2
 #define kbulletDirectionNegativeXandY 3
 #define kbulletDirectionZero 4 ////direction that has 0 x velocity. so when you're just shooting up.
 
 #define kbulletMoveStraight 0
 #define kbulletMoveHoming 1 //homing is a direction not a type.
 #define kbulletMoveLaser 2 //laser doesn't move just takes up the length of the screen.
 
 #define kdamageBlinkingStrength 10 ///the amount of damage necassary to cause you to blink and become invincible for a short time.
 
 
 ///// power up types.
 #define kPowerupNone 0
 #define kPowerupHoming 1
 #define kPowerupLaser 2
 #define kPowerupStrongShot 3
 #define kPowerupTempSuperLaser
 #define kPowerupTempSheild
 #define kPowerupLimitBomb
 
 ////// parts types.
 #define kPartsLevel1 1
 #define kPartsLevel2 2
 #define kPartsLevel3 5
 #define kPartsLevel4 20
 #define kPartsLevel5 100
 
 ////// rescue types
 #define krescue_male1 0
 #define krescue_female1 1
 
 
 ///diffent explosion types.
 #define kExplodePlayerNormal 0 ///blue energy
 #define kExplode1 1            ///orange fire.
 #define kExplode2 2            ///orange energy
 #define kExplode3 3            ///orange fire 2.
 #define kExplodeBlueEnergy 4   ///blue energy wipe
 #define kExplodeWalkingEnemyBurst 5 ///small yellow burst
 #define kExplodeFigthingPilotHitBurst 6 /////// for when the pilot gets hit by the player.
 #define kExplodeBlood1 7 ////for a small blood splatter.
 
 
 
 
 
 
 */












#endif
