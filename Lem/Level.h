//
//  Level.h
//  Lem
//
//  Created by Justin Fletcher on 7/7/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"






@class LemExit;
@class LemStart;
@class Lem;

@interface Level : JLevel {
    int levelNum;
    
    float testTimer;
    
    
    
    //////////// all the collision map shit.
    
    NSString *collisionMapFile;
    unsigned char *collisionMap;
    int collisionMapWidth;
    int collisionMapHeight;
    int collisionMapSize;
    float directorContentScaleFactor;
    CCSprite *digMask; // mask for digging.
    CCSprite *buildMask; // mask for building stairs.
    CCRenderTexture *backGroundRenderer;
    CCBlendMode *blendModeCutOut;
    CCBlendMode *blendModeAdd;
    
    
    int startingLems;
    int maxLems;
    int lemsNeededToWin;
    int curNumLems;
    int lemsThatReachedExit;
    LemExit *lemExit;
    LemStart *lemStart;
    
    NSMutableArray *_lemsToRemove;
    
    CCTiledMap *tileMap;
    NSArray *_jobsArray;
    
    double lemTimer;
    double lemTime;
    
    
    ////// ------- touches.....
    BOOL shouldMoveCamera;
    
    CGRect touchRect; /// touch rect for touching lemmings and shit.
    NSMutableArray *_touches;
    BOOL touchShouldZoomLevel;
    BOOL touchShouldMoveLevel;
    int cameraZoomDistance;
    int cameraZoomDistance_Prev;
    float maxScale;
    
    CCNode *cameraTracker;
    CGPoint cameraTrackerVel;
    CGPoint cameraTrackerTouchPosition;
    CGPoint cameraTrackerTouchPosition_Prev;
    
    
    
    ///// ---- editor
    BOOL isEditing;
    unsigned char *collisionMapToCopy; ////for restarting in the level editor.
    CCSprite *mask; ///mask for the level editor
    NSString *maskFileName;
    CCRenderTexture *backgroundRendererEditor;
    
    
    
    
    //// time traveler stuff....
    BOOL activateTimeTravel;
    BOOL timeTravelActive;
    float timeTravelRestartTimer;
    CCRenderTexture *pauseRenderTexture;
    CCSprite *pauseRenderSprite;
    CCSprite *pes;
    
    //// flash light stuff..
    BOOL activateFlashLight;
    BOOL flashLightActive;
    CCRenderTexture *flashLightRenderTexture;
    CCSprite *flashLightRenderSprite;
    Lem *flashLightLem;
    
    int totalFrames;
    
    
}

@property(nonatomic, retain)NSMutableArray *_lemsToRemove;
@property(nonatomic, retain)CCBlendMode *blendModeCutOut, *blendModeAdd;
@property(nonatomic, retain)CCSprite *mask, *digMask, *buildMask;
@property(nonatomic, retain)NSString *maskFileName;


-(id)initWithTileMapFile:(NSString*)tmf CollisionMapFile:(NSString*)cmf;
//-(void)addMaskToBackgroundWithSprite:(CCSprite*)m;
-(void)addMaskToBackgroundWithSprite:(CCSprite*)s Position:(CGPoint)p BlendMode:(CCBlendMode*)b Erase:(BOOL)e;
-(void)createCollisionMapFromUIImage:(UIImage*)collisionImage;
-(void)restartLevel;
-(void)beatLevel;

@end
