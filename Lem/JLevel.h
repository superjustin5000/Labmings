//
//  JLevel.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 6/28/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#ifndef __JLEVEL_H__
#define __JLEVEL_H__


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameState;
@class JHud;

@class JScene;


@interface JLevel : CCNode {
    GameState *gs;
    JHud *hud;
    
    BOOL scrollingX;
    BOOL scrollingY;
    CGPoint scrollSpeed;
    float scrollM;
    
    BOOL allowRotation;
    
    BOOL enableDebugDraw;
    CCDrawNode *drawNode;
    
}


-(void)resetGameStateLevelVars;
-(void)pauseLevel;
-(void)unpauseLevel;
-(void)restartLevel;


+(JScene*)scene;
+(JScene*)sceneWithHud;
+(JScene*)sceneWithHudNoPad;
+(JScene*)sceneWithHud:(JHud*)hud;

@end







@interface JScene : CCScene {
    GameState *gs;
    CCNode *outerLayer;
    JLevel *curLevel;
}
@property(nonatomic,retain)JLevel* curLevel;
@property(nonatomic,retain)CCNode* outerLayer;
+(id)sceneWithLevel:(JLevel*)lvl;
-(id)initWithLevel:(JLevel*)lvl;
-(void)screenShake;
@end

#endif
