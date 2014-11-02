//
//  Level.m
//  Lem
//
//  Created by Justin Fletcher on 7/7/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "Level.h"


#import "Lem.h"

#import "LemExit.h"
#import "LemStart.h"

#import "JobButtons.h"
#import "PauseButton.h"
#import "PauseLayer.h"

#import "LevelStats.h"




static NSMutableArray *_timeTravelersRestart;


@implementation Level

@synthesize _lemsToRemove;
@synthesize blendModeCutOut, blendModeAdd;
@synthesize mask, digMask, buildMask;
@synthesize maskFileName;


-(id)initWithTileMapFile:(NSString *)tmf CollisionMapFile:(NSString *)cmf {
    self = [super init];
    
    
    directorContentScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
    
    ///////// I N I T I A L I Z E . T H E . T I L E M A P
    tileMap = [CCTiledMap tiledMapWithFile:tmf];
    self.contentSize = tileMap.contentSize;
    
    //[self addChild:tileMap z:kZTileMap];
    
    
    CCTiledMapObjectGroup *mapInfo = [tileMap objectGroupNamed:@"info"];
    int startLem = [[mapInfo.properties valueForKey:@"startingLems"] intValue];
    int maxLem = [[mapInfo.properties valueForKey:@"maxLems"] intValue];
    int lemNeeded = [[mapInfo.properties valueForKey:@"lemsNeededToWin"] intValue];
    int num = [[mapInfo.properties valueForKey:@"levelNumber"] intValue];
    NSString *jobs = [mapInfo.properties valueForKey:@"jobs"];
    
    
    levelNum = num;
    
    
    
    ///////// I N I T I A L I Z E . L E M . V A L U E S
    startingLems = startLem;
    maxLems = maxLem;
    lemsNeededToWin = lemNeeded;
    curNumLems = 0;
    lemsThatReachedExit = 0;
    lemTime = 0.001;
    lemTimer = 0.0;
    
    _lemsToRemove = [[NSMutableArray alloc] init];
    
    ////jobs array from comma separated string from tilemap.
    _jobsArray = [[NSArray alloc] init];
    _jobsArray = [jobs componentsSeparatedByString:@","];
    
    
    ///////time travelers from one array to another.
    //int numTimeTravelers = (int)[_timeTravelersRestart count];
    //NSLog(@"num time travelers = %d", numTimeTravelers);
    
    if (!_timeTravelersRestart) _timeTravelersRestart = [[NSMutableArray alloc] init];
    
    if ([_timeTravelersRestart count] > 0) {
    
        for (Lem *l in _timeTravelersRestart) {
            
            ///create a copy based off the time traveler.
            Lem *newLem = [Lem lem];
            [newLem changeJobTo:kJobTimeTraveler];
            newLem.position = l.position;
            [self addChild:newLem z:kZPlayer];
            
            ///destroy the original time traveler.
            [l destroyJSprite];
            
        }
    
    }
    [_timeTravelersRestart removeAllObjects]; ////remove them all after copying.
    
    
    
    
    
    ////////////// C A M E R A
    
    shouldMoveCamera = YES; //// so there is an initial camera position being set.
    
    id cp = [mapInfo.objects objectAtIndex:0];
    int x = [[cp valueForKey:@"x"] intValue];
    int y = [[cp valueForKey:@"y"] intValue];
    
    cameraTracker = [CCSprite spriteWithImageNamed:@"pplayerWhite.png"];
    cameraTracker.position = ccp(x, y);
    [self addChild:cameraTracker];
    cameraTrackerVel = CGPointZero;
    cameraTrackerTouchPosition_Prev = cameraTrackerTouchPosition = CGPointZero;
    
    maxScale = 3.0f;
    self.scale = maxScale;
    
    
    
    
    
    //////////////-------------------------------   S P A W N P O I N T
    CCTiledMapObjectGroup *tileSpawn = [tileMap objectGroupNamed:@"spawn"];
    id sp = [tileSpawn.objects objectAtIndex:0];
    int width = [[sp valueForKey:@"width"] intValue];
    int height = [[sp valueForKey:@"height"] intValue];
    x = [[sp valueForKey:@"x"] intValue];
    y = [[sp valueForKey:@"y"] intValue];
    
    CGPoint pos = ccp(x + width/2, y + height/2);
    
    lemStart = [LemStart StartWithGameName:@"lemStart.png"];
    lemStart.position = pos;
    [self addChild:lemStart z:kZPlayer-1];
    
    
    
    
    //////////////-------------------------------   E X I T P O I N T
    CCTiledMapObjectGroup *tileExit = [tileMap objectGroupNamed:@"exit"];
    id ep = [tileExit.objects objectAtIndex:0];
    width = [[ep valueForKey:@"width"] intValue];
    height = [[ep valueForKey:@"height"] intValue];
    x = [[ep valueForKey:@"x"] intValue];
    y = [[ep valueForKey:@"y"] intValue];
    
    pos = ccp(x + width/2, y + height/2);
    
    lemExit = [LemExit ExitWithGameName:@"lemExit.png"];
    lemExit.position = pos;
    [self addChild:lemExit z:kZPlayer-1];
    
    
    
    
    
    
    
    //////////// -------------- C O L L I S I O N . M A P
    
    collisionMapFile = cmf;
    [self createCollisionMapFromUIImage:[UIImage imageNamed:collisionMapFile]];
    
    
    ////////  M A K I N G . T H E . B A C K G R O U N D . A N D . T H E . D I G G I N G . M A S K S
    maskFileName = @"digMask.png";
    mask = [CCSprite spriteWithImageNamed:@"digMask.png"];
    digMask = [CCSprite spriteWithImageNamed:@"digMask.png"];
    buildMask = [CCSprite spriteWithImageNamed:@"stairPiece.png"];
    //mask.anchorPoint = ccp(0,0);
    mask.position = ccp(0, 0);
    digMask.position =  ccp(0, 0);
    
    CCSprite *bg = [CCSprite spriteWithImageNamed:collisionMapFile];
    bg.position = ccp(bg.contentSize.width/2, gs.winSize.height/2);
    //[self addChild:bg z:kZBackground];
    
    
    
    blendModeCutOut = [CCBlendMode blendModeWithOptions:@{CCBlendFuncSrcColor: @(GL_ZERO), CCBlendFuncDstColor: @(GL_ONE_MINUS_SRC_ALPHA)}];
    blendModeAdd = [CCBlendMode blendModeWithOptions:@{CCBlendFuncSrcColor: @(GL_ONE), CCBlendFuncDstColor: @(GL_ONE_MINUS_SRC_ALPHA)}];
    
    
    ///////// I N I T I A L I Z E . T H E . B A C K G R O U N D . R E N D E R E R
    
    backGroundRenderer = [CCRenderTexture renderTextureWithWidth:bg.contentSize.width height:bg.contentSize.height];
    [backGroundRenderer begin];
    [bg visit];
    [backGroundRenderer end];
    
    
    if (levelNum == 999) { ///// level 999 is the level editor.
        
        backgroundRendererEditor = [CCRenderTexture renderTextureWithWidth:bg.contentSize.width height:bg.contentSize.height];
        [backgroundRendererEditor begin];
        [bg visit];
        [backgroundRendererEditor end];
        
    }
    
    
    CCSprite *s = [CCSprite spriteWithTexture:backGroundRenderer.sprite.texture];
    s.position = ccp(bg.contentSize.width/2, gs.winSize.height/2);
    [self addChild:s z:kZBackground];
    
    
    //[self addChild:mask z:kZPlayer];
    
    
    
    
    
    
    
    
    //////////// H U D . I T E M S
    
    [self addJobButtons];
    PauseButton *pauseButton = [PauseButton spriteWithImageNamed:@"pauseButton.png"];
    pauseButton.position = ccp(gs.winSize.width - pauseButton.contentSize.width/2 - 20, gs.winSize.height - pauseButton.contentSize.height/2 - 20);
    [[JHud getHud] addChild:pauseButton];
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////   the pause effect when a time traveler starts.
    
    
    activateTimeTravel = NO;
    timeTravelActive = NO;
    timeTravelRestartTimer = 0;
    
    
    /////The other variable activateFlashlight will be set to yes if you include the flashlight job....
    flashLightActive = NO;
    
    
    
    
    
    
    
    
    
    
    
    _touches = [[NSMutableArray alloc] init];
    
    
    
    
    
    
    
    
    
    
    
    
    /////// E D I T I N G
    
    isEditing = NO;
    
    
    
    
    
    
    
    
    return self;
    
    
    
    
}







-(void)createCollisionMapFromUIImage:(UIImage *)collisionImage {
    // Load the image:
    //UIImage *collisionImage = [UIImage imageNamed:collisionMapFile];
    
    // Get the image size:
    collisionMapWidth = (int)collisionImage.size.width; //* [[CCDirector sharedDirector] contentScaleFactor];
    collisionMapHeight = (int)collisionImage.size.height; //* [[CCDirector sharedDirector] contentScaleFactor];
    
    collisionMapSize = collisionMapWidth * collisionMapHeight;
    
    // Allocate our array for quick lookups and clear it:
    collisionMap = (unsigned char *)malloc( collisionMapSize );
    memset( collisionMap, 0, collisionMapSize );  ///////////////---- set all values to 0.
    
    
    //// level 999 is map editor.
    if (levelNum == 999) {
        
        //// and the map to copy...
        collisionMapToCopy = (unsigned char*)malloc(collisionMapSize);
        memset( collisionMapToCopy, 0, collisionMapSize);
        
    }
        
    
    NSLog(@"%d pixels in the collision map", (collisionMapSize));
    
    // Get access to the raw bits of the image
    CFDataRef imageData = CGDataProviderCopyData( CGImageGetDataProvider ( collisionImage.CGImage ) );
    const UInt32 *pixels = (const UInt32*)CFDataGetBytePtr( imageData );
    
    // Build our collision map
    int j;
    for( j = 0; j < (collisionMapSize); j++ ) {
        
        UInt32 alpha = pixels[j] & 0xff000000; /// mask the colors so you only get the alpha. by ANDing them with 0s
        UInt8 b = (UInt8) ( (pixels[j] & 0x00ff0000) >> 16 ); ////mask colors and shift everything over til only blue is left.
        UInt8 g = (UInt8) ( (pixels[j] & 0x0000ff00) >> 8 ); ///mask and shift over so only green
        UInt8 r = (UInt8)   (pixels[j] & 0x000000ff);
        
        //if ( alpha == 0) {  ////// alpha 0 means see through.
        collisionMap[j] |= kCollisionColorAlphaZero;
        //}
        //else {
        if (alpha != 0) {
            if (r == 0 && g == 0 && b == 0) ////// it's black bitch.
                collisionMap[j] = kCollisionColorBlack;
            else if (g == 0 && b == 0) ///no blue or green. must be red.
                collisionMap[j] = kCollisionColorRed;
            else if (r == 0 && b == 0) ///no red or blue must be greeen.
                collisionMap[j] = kCollisionColorGreen;
            else if (r == 0 && g == 0) ///no red or green must be blue.
                collisionMap[j] = kCollisionColorBlue;
            else { /////////////////// collision color is any random color..
                collisionMap[j] = kCollisionColorOther;
            }
        }
        
        
        if (levelNum == 999) { /////// level 999 is map editor.
            /////// make the map to copy.
            collisionMapToCopy[j] = collisionMap[j];
        }
        
    }
    
    
    // release what we don't need
    CFRelease( imageData );
    
    
    
    
    
    ////// THE CODE BELOW DRAWS A PORTION OF THE COLLISION MAP INTO THE CONSOLE
    /*
     for (int i = 0; i < collisionMapHeight; i++) {
     
     NSString *s = [NSString stringWithFormat:@"%3d - ", i];
     
     for (int j = 0; j < 100; j++) {
     
     int pos = (i * collisionMapWidth) + j;
     
     s = [s stringByAppendingString:[NSString stringWithFormat:@"%d", collisionMap[pos]]];
     
     }
     
     NSLog(s);
     
     }
     */
    
    
    
    
}







-(unsigned char*)colorMapFromUIImage:(UIImage*)image {
    
    unsigned char* map;
    
    int mapWidth = (int)image.size.width;
    int mapHeight = (int)image.size.height;
    
    int mapSize = mapWidth * mapHeight;
    
    map = (unsigned char*)malloc(mapSize);
    memset(map, 0, mapSize);
    
    
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt32 *pixels = (const UInt32*)CFDataGetBytePtr(imageData);
    
    
    int i;
    
    for (i = 0; i < (mapSize); i++) {
        
        UInt32 alpha = pixels[i] & 0xff000000;
        
        
        UInt8 b = (UInt8) ( (pixels[i] & 0x00ff0000) >> 16 ); ////mask colors and shift everything over til only blue is left.
        UInt8 g = (UInt8) ( (pixels[i] & 0x0000ff00) >> 8 ); ///mask and shift over so only green
        UInt8 r = (UInt8)   (pixels[i] & 0x000000ff);

        
        map[i] |= kCollisionColorAlphaZero;
        
        if (alpha != 0) {
            if (r == 0 && g == 0 && b == 0) ////// it's black bitch.
                map[i] = kCollisionColorBlack;
            else if (g == 0 && b == 0) ///no blue or green. must be red.
                map[i] = kCollisionColorRed;
            else if (r == 0 && b == 0) ///no red or blue must be greeen.
                map[i] = kCollisionColorGreen;
            else if (r == 0 && g == 0) ///no red or green must be blue.
                map[i] = kCollisionColorBlue;
            else { /////////////////// collision color is any random color..
                map[i] = kCollisionColorOther;
            }
        }
        
        //NSLog(@"map color = %d", map[i]);
        
    }
    
    
    
    CFRelease(imageData);
    
    return map;
}









-(void)editCollisionMap:(CGPoint)pos Value:(int)val {
    
    //NSLog(@"edit usable map");
    
    int max = collisionMapSize;
    int min = 0;
    
    int x = pos.x;
    int y = collisionMapHeight - pos.y;
    
    int collisionIndex = (y * collisionMapWidth) + x;
    
    if (collisionIndex > max || collisionIndex < min) {
        return;
    }
    
    collisionMap[collisionIndex] = val;
    
}

-(void)editCollisionMapToCopy:(CGPoint)pos Value:(int)val {
    
    //NSLog(@"edit map to copy");
    
    int max = collisionMapSize;
    int min = 0;
    
    int x = pos.x;
    int y = collisionMapHeight - pos.y;
    
    int collisionIndex = (y * collisionMapWidth) + x;
    
    if (collisionIndex > max || collisionIndex < min) {
        return;
    }
    
    collisionMapToCopy[collisionIndex] = val;
    
}






-(void)addMaskToBackgroundWithSprite:(CCSprite*)s Position:(CGPoint)p BlendMode:(CCBlendMode *)b Erase:(BOOL)e {
    
    
    
    CCSprite *m = s;
    
    
    
    [backGroundRenderer begin];
    
    m.position = p;
    ///set the blend mode so that it renders transparent.
    m.blendMode = b;
    
    /// visit m so that it renders togeher with the background... leaving a hole.
    [m visit];
    
    
    [backGroundRenderer end];
    
    
    
    
    if (m == mask) { ////render into the editor renderer as well but only if the mask used was by your finger and not the digger job.
        
        [backgroundRendererEditor begin];
        
        [m visit];
        
        [backgroundRendererEditor end];
        
    }
    
    
    
    
    
    
    
    ////////// GET THE COLOR MAP OF THE SPRITE YOUR USING AS A MASK.....
    
    UIImage *image = [UIImage imageNamed:maskFileName];
    unsigned char* colorMap = [self colorMapFromUIImage:image];

    

    ///get the x and y coordinate from i and j.
    for (int i = 0; i < m.contentSize.height; i++) {
        
        int curY = m.position.y + m.contentSize.height/2 - i;
        
        for (int j = 0; j < m.contentSize.width; j++) {
            
            int maskMapPosition = (i * m.contentSize.width) + j;
            int colorVal = colorMap[maskMapPosition];
            //NSLog(@"color val = %d", colorVal);
            
            int curX = m.position.x - m.contentSize.width/2 + j;
            
            
            if (e) {
                if (colorVal != kCollisionColorAlphaZero) { //////you wan't to remove from the main map. anywhere on the mask that is not transparent since it's cutting that out.
                    [self editCollisionMap:CGPointMake(curX, curY) Value:kCollisionColorAlphaZero];
                    
                    if (m == mask) { /////// if you're using the mask in the editor... make changes to the collisionmap that will be copied.... since you don't want editing due to digging.
                        [self editCollisionMapToCopy:CGPointMake(curX, curY) Value:kCollisionColorAlphaZero];
                    }
                }
            }
            
            else { ///// you're not erasing..... then edit all values.
                if (colorVal != kCollisionColorAlphaZero) { //////you wan't to remove from the main map. anywhere on the mask that is not transparent since it's cutting that out.
                    [self editCollisionMap:CGPointMake(curX, curY) Value:colorVal];
                    
                    if (m == mask) { /////// if you're using the mask in the editor... make changes to the collisionmap that will be copied.... since you don't want editing due to digging.
                        [self editCollisionMapToCopy:CGPointMake(curX, curY) Value:colorVal];
                    }
                }
            }
        
            
        }
    }


    
    
}






-(int)collisionForPoint:(CGPoint)point
{
    
    int max = collisionMapSize;
    int min = 0;
    
    
    int x = point.x * directorContentScaleFactor;
    int y = collisionMapHeight - (  point.y * directorContentScaleFactor  );
    
    int colIndex = (y * collisionMapWidth) + x;
    
    if (colIndex > max || colIndex < min) return 0;
    
    
    int col = collisionMap[colIndex];
	
    //if (col == 1) {
    //    NSLog(@"collided at x = %d, y = %d", x, y);
    //}
    
	return col;
}










-(void)resetGameStateLevelVars {
    [gs._lems removeAllObjects];
}





-(void)pauseLevel {
    [super pauseLevel];
    
    
    PauseLayer *pauseLayer = [PauseLayer node];
    
    [gs.gameScene addChild:pauseLayer z:kzHud+1 name:@"pauseLayer"];
    
}


-(void)unpauseLevel {
    [super unpauseLevel];
    
    [gs.gameScene removeChildByName:@"pauseLayer" cleanup:YES];
    
}



-(void)restartLevel {
    [self unpauseLevel];
    NSString *className = NSStringFromClass([self class]);
    [[CCDirector sharedDirector] replaceScene:[NSClassFromString(className) sceneWithHudNoPad]];
}




-(void)restartWithTimeTravelers {
    
    for (Lem *l in gs._lems) {
        
        if (l.curJob == kJobTimeTraveler) {
            
            [_timeTravelersRestart addObject:l];
            
        }
        
    }
    
    
    //// restart the scene.
    [self restartLevel];
    
}




//////////////// ------------------- A D D I N G . J O B . B U T T O N S.


-(void)addJobButtons {
    
    BOOL parachute = NO;
    BOOL blocker = NO;
    BOOL digger = NO;
    BOOL timeTraveler = NO;
    BOOL climber = NO;
    BOOL diggerDown = NO;
    BOOL builder = NO;
    BOOL flashLight = NO;
    BOOL bomber = NO;
    
    
    for (NSString *s in _jobsArray) {
        
        
        if ([s isEqualToString:@"all"]) {
            
            parachute = YES;
            blocker = YES;
            digger = YES;
            timeTraveler = YES;
            climber = YES;
            diggerDown = YES;
            builder = YES;
            flashLight = YES;
            bomber = YES;
            
            break;
            
        }
        
        
        
        
        if ([s isEqualToString:@"parachute"]) {
            parachute = YES;
        }
        
        else if ([s isEqualToString:@"blocker"]) {
            blocker = YES;
        }
        
        else if ([s isEqualToString:@"digger"]) {
            digger = YES;
        }
        
        else if ([s isEqualToString:@"diggerDown"]) {
            diggerDown = YES;
        }
        
        else if ([s isEqualToString:@"timetraveler"]) {
            timeTraveler = YES;
        }
        
        else if ([s isEqualToString:@"climber"]) {
            climber = YES;
        }
        
        else if ([s isEqualToString:@"builder"]) {
            builder = YES;
        }
        
        else if ([s isEqualToString:@"flashlight"]) {
            flashLight = YES;
        }
        
        
        else if ([s isEqualToString:@"bomber"]) {
            bomber = YES;
        }
    }
    
    
    
    NSMutableArray *jobs = [[NSMutableArray alloc] init];
    
    
    //// passive jobs
    
    if (parachute) {
        [jobs addObject:[NSNumber numberWithInt:kJobPassiveParachute]];
    }
    
    if (climber) {
        [jobs addObject:[NSNumber numberWithInt:kJobPassiveClimber]];
    }
    
    
    //// active jobs
    if (flashLight) {
        [jobs addObject:[NSNumber numberWithInt:kJobFlashLight]];
        activateFlashLight = YES; ////this will make the level dark automatically.
    }
    
    if (blocker) {
        [jobs addObject:[NSNumber numberWithInt:kJobBlocker]];
    }
    
    if (digger) {
        [jobs addObject:[NSNumber numberWithInt:kJobDigger]];
    }
    
    if (diggerDown) {
        [jobs addObject:[NSNumber numberWithInt:kJobDiggerDown]];
    }
    
    if (builder) {
        [jobs addObject:[NSNumber numberWithInt:kJobBuilder]];
    }
    
    if (timeTraveler) {
        [jobs addObject:[NSNumber numberWithInt:kJobTimeTraveler]];
    }
    
    if (bomber) {
        [jobs addObject:[NSNumber numberWithInt:kJobBomber]];
    }
    
    [JobButtons jobButtonsWithButtons:jobs];
    
}
















-(void)addLem {
    
    ////create a new lem at the spawnpoint and add it to the lems array
    Lem *l = [Lem lem];
    l.position = lemStart.position;
    [self addChild:l z:kZPlayer];
    
}


-(void)lemReachedExit:(Lem*)lem {
    [_lemsToRemove addObject:lem];
    lem.destroyNextFrame = YES;
    lemsThatReachedExit++;
    
}




-(void)beatLevel {
    
    int nextLevelNum = levelNum + 1;
    
    if (levelNum == 999) ////// level 999 is map editor.
        nextLevelNum = 999;
    
    LevelStats *levelStats = [LevelStats levelStatsWithNextLevelNum:nextLevelNum];
    [self addChild:levelStats];
    [levelStats startNextLevel];
    
}

















-(void)activateTimeTraveler {
    
    activateTimeTravel = NO;
    timeTravelActive = YES;
    
    
    
    
    //// initialize the render texture and put stuff in it for the first time.
    
    pauseRenderTexture = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
    
    pes = [CCSprite spriteWithImageNamed:@"pauseEffectRGBStrip.png"];
    pes.scaleX = 0.5;
    pes.opacity = 0.5;
    pes.position = ccp(pes.contentSize.width/2, pes.contentSize.height/2);
    
    
    [pauseRenderTexture begin];
    
    [self visit];
    
    [pes visit];
    pes.position = ccp(gs.winSize.width - pes.contentSize.width/2, pes.contentSize.height/2);
    [pes visit];
    
    [pauseRenderTexture end];
    
    
    ///// create the sprite from that texture.
    
    pauseRenderSprite = [CCSprite spriteWithTexture:pauseRenderTexture.sprite.texture];
    pauseRenderSprite.position = ccp(pauseRenderSprite.contentSize.width/2, pauseRenderSprite.contentSize.height/2);
    
    //// set shader to sprite.
    pauseRenderSprite.shaderUniforms[@"pauseEffectMask"] = [CCTexture textureWithFile:@"pauseEffectMask.png"];
    pauseRenderSprite.shader = [CCShader shaderNamed:@"pauseEffectShader"];
    
    
    //// add that sprite to the outlayer so its on top of the game layer.
    
    pauseRenderTexture.position = ccp(pauseRenderTexture.contentSize.width/2, pauseRenderTexture.contentSize.height/2);
    [gs.gameScene.outerLayer addChild:pauseRenderSprite z:2];
    
    
}





-(void)activateFlashLight {
    
    
    activateFlashLight = NO;
    flashLightActive = YES;
    
    flashLightRenderTexture = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
    [flashLightRenderTexture begin];
    [self visit];
    [flashLightRenderTexture end];
    
    flashLightRenderSprite = [CCSprite spriteWithTexture:flashLightRenderTexture.sprite.texture];
    flashLightRenderSprite.position = ccp(flashLightRenderSprite.contentSize.width/2, flashLightRenderSprite.contentSize.height/2);
    
    ////add shader.
    
    CGPoint flashLightWorld = [self convertToWorldSpace:flashLightLem.position]; /////since the flash light is on a separate layer.
    flashLightRenderSprite.shaderUniforms[@"lightPos"] = [NSValue valueWithCGPoint:flashLightWorld];
    flashLightRenderSprite.shaderUniforms[@"lightDirection"] = @(flashLightLem.scaleX);
    flashLightRenderSprite.shaderUniforms[@"levelZoom"] = @(self.scale);
    flashLightRenderSprite.shaderUniforms[@"levelSize"] = [NSValue valueWithCGSize:self.contentSize];
    flashLightRenderSprite.shader = [CCShader shaderNamed:@"flashLightShader"];

    flashLightRenderTexture.position = ccp(flashLightRenderTexture.contentSize.width/2, flashLightRenderTexture.contentSize.height/2);
    [gs.gameScene.outerLayer addChild:flashLightRenderSprite z:1];
    
    
}










///////////////// --------------------   L E V E L . U P D A T E



-(void)update:(CCTime)delta {
    
   
    
    
    /////////// --------------- I N I T I A T E . T I M E . T R A V E L . A N I M A T I O N
    
    if (activateTimeTravel) {
        
        [self activateTimeTraveler];
        
    }
    
    
    /////////////////////// ---- time traveler is active.
    
    if (timeTravelActive) {
        
        timeTravelRestartTimer += delta;
        
        if (timeTravelRestartTimer >= 2) {
            [self restartWithTimeTravelers];
        }
        
        
        /// pause the lemmings.
        
        for (Lem *l in gs._lems) {
            
            if (!l.paused) {
                
                l.paused = YES;
                
            }
            
            
        }
        
        
        [pauseRenderTexture beginWithClear:0 g:0 b:0 a:1];
        
        [self visit];
        
        pes.position = ccp(pes.contentSize.width/2, pes.contentSize.height/2);
        [pes visit];
        pes.position = ccp(gs.winSize.width - pes.contentSize.width/2, pes.contentSize.height/2);
        [pes visit];
        
        [pauseRenderTexture end];
    
    }
    
    
    
    
    
    
    
    /////////// --------------- I N I T I A T E . F L A S H . L I G H T . A N I M A T I O N
    
    
    if (flashLightActive) {
        
        
        [flashLightRenderTexture beginWithClear:0 g:0 b:0 a:1];
        [self visit];
        [flashLightRenderTexture end];
        
        CGPoint flashLightWorld = [self convertToWorldSpace:flashLightLem.position]; /////since the flash light is on a separate layer.
        flashLightRenderSprite.shaderUniforms[@"lightPos"] = [NSValue valueWithCGPoint:flashLightWorld];
        flashLightRenderSprite.shaderUniforms[@"lightDirection"] = @(flashLightLem.scaleX);
        flashLightRenderSprite.shaderUniforms[@"levelZoom"] = @(self.scale);
        //NSLog(@"level x = %0.2f zoom = %0.2f", self.position.x, self.scale);
        
    }
    
    
    if (activateFlashLight) {
        
        [self activateFlashLight];
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    if (!isEditing) { ////do none of this in editing mode.  //// includes lems being updated which you can see below.
    
        
        
        
        
        for (Lem *l in _lemsToRemove) {
            [gs._lems removeObject:l];
        }
        
        [_lemsToRemove removeAllObjects];
        
        
        
        
        int numberOfLemsRemaining = 0;
        
        
        ///////------------ K E E P . P L A Y E R . A N D . E N E M I E S . O N . T H E . G R O U N D.
    
        for (Lem *l in gs._lems) {
        
            
            ////update the lem here since this is looping through them already they should all loop their own update methods.
            
            [l updateLem:delta];
            
            
            
            
            ///// have they reached the exit?
            
            if (l.reachedExit) {
                [self lemReachedExit:l];
            }
            
            BOOL isJobException = (l.curJob == kJobBlocker || l.curJob == kJobTimeTraveler);
            if (!isJobException) {
                numberOfLemsRemaining += 1;
            }
            
            
            
            
            
            
            if (!isJobException) {  ///// don't do any checks if you're a job that doesn't do anything........
            
                
                
                
                ////---------------------------------------------- C H E C K I N G . S E N S O R S
                ////
                
                
                ///// ---- A D V I S E D  ...   IF STATEMENTS ORGANIZED IN ORDER OF IMPORTANCE.
                
                
                [l updateClimbingAndWalkingSharedSensors]; ////checks which sensors to update as well depending on if you're climbing or walking.
                
                int bottomFront = [self collisionForPoint:l.frontFoot];
                int topFront = [self collisionForPoint:l.frontHead];
                
                
                
                ////////// -----------   L E M . I S . N O T . C L I M B I N G
                
                if (!l.isClimbing) { //////////////////////////  dont lock lem to the ground if it's climbing a wall....
                
                    
                    
                    ///////////// --------  lem is either walking or falling.
                    
                    
                    
                    int bottomMid = [self collisionForPoint:l.midFoot];
                    int frontMid = [self collisionForPoint:l.frontSensor];
                    //int bottomBack = [self collisionForPoint:l.backFoot];
                    
                    
                    
                    BOOL shouldSkipVelFootCheck = NO; ///see wether the velocity loop after this big if statement should even run this frame or not.
                    
                    
                    
                    //// ------- checking if you hit a wall.... will be different if it's a 90 degree wall or not.... only if not hitting stairs.
                    if (bottomFront != kCollisionColorStairs) {
                        
                        if ( bottomFront != kCollisionColorAlphaZero ) { //if the front foot collides... check the others.
                            
                            if ( bottomMid == kCollisionColorAlphaZero ) { /////mid foot not colliding (if it is you're dead or climbing a slope... so check if wall is too steep.
                                
                                ///is the middle of the front body colliding or just the front head sensor?
                                BOOL justTop = topFront != kCollisionColorAlphaZero;
                                BOOL topAndMid = justTop && frontMid != kCollisionColorAlphaZero;
                                
                                if (topAndMid || justTop) {
                                    
                                    if (topFront == kCollisionColorRed || bottomFront == kCollisionColorRed || topFront == kCollisionColorRed) {
                                        [l die];
                                        continue;
                                    }
                                    ////// passed the death check above.... great. now hit a wall.
                                    
                                    if (!topAndMid) { ////they didnt both hit so its on only the front head that hit a wall. ......
                                        
                                        ////extend out form front mid to see if a wall is relatively close... if so you hit a wall.
                                        if ([self collisionForPoint:ccp(l.frontSensor.x + 5, l.frontSensor.y)] != kCollisionColorAlphaZero) {
                                            
                                            [l hitWallWithType:topFront];
                                            
                                        }
                                        
                                        else { //// you def just hit with head sensor NOW!
                                            [l hitWallJustTopWithType:topFront];
                                        }
                                        
                                    }
                                    
                                    else { ///// both head and middle body hit a wall.
                                        
                                        [l hitWallWithType:frontMid];
                                        
                                    }
                                
                                } /// --- end if HEAD or HEAD and FRONT BODY hit wall
                                
                            } //// ---- end if MID FOOT is not colliding.
                            else { ///mid foot colliding so skip the velocity test.... right?
                            
                                shouldSkipVelFootCheck = YES;
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    
                    ////make line of points with length of players max velocity, each point checking a collision with the ground so see if the player should collide... or just step down. Sort of a floor dampener.
                    
                    
                    int vel;
                    
                    if (bottomMid == kCollisionColorAlphaZero)
                        vel = abs((int)l.maxVelocity.y) + 2;
                    else
                        vel = abs((int)l.velocity.y) + 1;
                    
                    
                    BOOL shouldHitGround = NO;
                    BOOL shouldHitDeath = NO; //// ---- gets checked below in the isOnFloor statement.
                    CGPoint groundColSensor;
                    
                    if (!shouldSkipVelFootCheck) { ////code above determined if this code should be skipped this frame.....
                    
                        for (int i = 0; i <= vel; i++) {
                            
                            int newY = vel - i;
                            groundColSensor = CGPointMake(l.midFoot.x, l.midFoot.y - newY);
                            shouldHitDeath = NO; ///reset to no... so if the last one checked is red... you're on red... die.
                            
                            //NSLog(@"ground sensor = %f", groundColSensor.y);
                            
                            int colColor = [self collisionForPoint:groundColSensor];
                            
                            if (colColor != 0) { ////if there's a collision... continue looping until no collision if found.
                                
                                shouldHitGround = YES;
                                
                                if (colColor == kCollisionColorRed) { ////keep checking for red every iteration just make sure you're def not touching red.
                                    shouldHitDeath = YES;
                                }
                                
                            }
                            
                            else {
                                
                                if (shouldHitGround) { ///if before this position is check... a collision was found to happen... set this first position not colliding to be the new position the player should have.
                                    
                                    [l landOnFloor];
                                    l.position = ccp(groundColSensor.x, groundColSensor.y + l.contentSize.height/2);
                                    
                                    break; ///end the FOR loop loop at this point.
                                    
                                }
                                
                            }
                            
                            ///run the for loop again.
                            ///to check the next y pos.
                        }
                        
                    }
                    
                    
                    if (!shouldHitGround) {
                        
                        //[l stepDown];
                        
                        //// only check to make it fall off floor if it shouldnt hit the ground. DUH!.
                        //// if no feet touch the ground... fall.
                        int OneBelowBottomMid = [self collisionForPoint:ccp(l.midFoot.x, l.midFoot.y-1)];
                        int OneBelowBottomFront = [self collisionForPoint:ccp(l.frontFoot.x, l.frontFoot.y-1)];
                        int OneBelowBottomBack = [self collisionForPoint:ccp(l.backFoot.x, l.backFoot.y-1)];
                        
                        if ( OneBelowBottomBack == kCollisionColorAlphaZero && OneBelowBottomMid == kCollisionColorAlphaZero && OneBelowBottomFront == kCollisionColorAlphaZero ) {
                            if (l.isOnFloor) {
                                [l fallOffFloor]; ///there's just no other choice.
                            }
                        }
                    }
                    
                    
                    
                    ////////////   --------- push the sprite up slopes. relative to the midfoot sensor.
                    
                    if (l.isOnFloor) { /////// T H E . L E M . I S . O N . T H E . F L O O R ... M E A N S . I T S . W A L KI N G . A N D . N O T . F A L LI N G ....
                        
                        
                        ///// check death....
                        //// --- since walking forward all the time... only check front sensors for death.
                        
                        if (frontMid == kCollisionColorRed || topFront == kCollisionColorRed || bottomFront == kCollisionColorRed || shouldHitDeath) {
                            [l die];
                            continue; //// --- move on to the next lem.
                        }
                        
                        
                        
                        if (bottomMid != kCollisionColorBlocker) {  //// ------ dont push the sprite up if they're touching a blocker.
                            
                            //// have to call collidion for point method since it the while loop is in ONE update.
                            
                            while ( [self collisionForPoint:l.midFoot] != kCollisionColorAlphaZero) { ////keep adusting the players position until it's out of the collision zone.
                                
                                [l updateMidFoot]; //// update the midfoot, since you're in this while loop the game loop cant update it.
                                
                                l.position = ccp(l.position.x, l.position.y + 1); ///move up.
                                
                            }
                        }
                    }
                
                
                } ///// ------- E N D . I F . N O T . C L I M B I N G
                
                
                
                else { /////////// --------------------------- I S . C L I M B I N G
                    
                    
                    
                    int topMid = [self collisionForPoint:l.midHead];
                    int topBack = [self collisionForPoint:l.backHead];
                    
                    
                    //// check death..
                    ///--- since you're going up the top sensors are the only ones who will first hit red.
                    if (topBack == kCollisionColorRed || topMid == kCollisionColorRed || topFront == kCollisionColorRed) {
                        [l die];
                        continue; //// --- jump to the next lem in the loop.
                    }
                    
                    
                    
                    if ( bottomFront == kCollisionColorAlphaZero ) { ///// foot touched nothing... stop climbing.
                        if (topFront == kCollisionColorAlphaZero) //// then make sure the head is also touching nothing.
                            l.isClimbing = NO;
                    }
                    else { ////// -------- keep on climbing.
                        
                        ///// if you hit your head on somthing. while climbing.
                        if ( topFront != kCollisionColorAlphaZero && topMid != kCollisionColorAlphaZero && topBack != kCollisionColorAlphaZero ) {
                            [l hitCeiling];
                        }
                        
                    }
                    
                }
                
                
                
                
            } /////// end if !blocker ..............
            
                
                
            
            
        
        }  ///////////    END OF LEM LOOP ...
        
        
        
        
        
        
        ////create new lems as long as the number of lems is less that the starting number.
        
        if (curNumLems < startingLems) {
        
            if (lemTimer >= lemTime) {
                
                lemTimer = 0;
                
                [self addLem];
                
                curNumLems ++;
                
            }
            else {
                lemTimer += delta;
            }
            
        }
        
        
        if (numberOfLemsRemaining == 0 && (lemsThatReachedExit >= lemsNeededToWin)) {
            
            [self beatLevel];
            
        }
        
        
        //NSLog(@"num lems remaining = %d", numberOfLemsRemaining);
    
    
        
        
        
    }
    
        
        
        
        
    
    /////////////// ------------------------------------- Z O O O M I N G . A N D . M O V I N G . T H E . C A M E R A
    
    if ([_touches count] == 2) {
        
        shouldMoveCamera = YES;
        
        UITouch *touch1 = [_touches objectAtIndex:0];
        UITouch *touch2 = [_touches objectAtIndex:1];
        
        CGPoint loc1 = [touch1 locationInNode:gs.gameScene.outerLayer];
        CGPoint loc2 = [touch2 locationInNode:gs.gameScene.outerLayer];
        
        CGPoint dloc = ccpSub(loc1, loc2);
        
        int distance = sqrt((dloc.x * dloc.x) + (dloc.y * dloc.y));
        
        if (cameraZoomDistance > distance) { ///// fingers moved together. ///zoom out
            self.scale -= 0.02;
        }
        
        else if (cameraZoomDistance < distance) { ///// fingers moved apart. ///zoom in.
            self.scale += 0.02;
        }
        
        if (self.scale >= maxScale) {
            self.scale = maxScale;
        }
        
        else if (self.scale <= 1) {
            self.scale = 1;
        }
        
        
        cameraZoomDistance = distance; ///reset for next frame.
        
        
    }

    
    
    
    
    if ([_touches count] == 1) {
    
        ////// Moving the Layer around when a touch is moved.
        
        shouldMoveCamera = YES;
        
        CGPoint touchPosAdjusted = ccpMult(cameraTrackerTouchPosition, 1/self.scale);
        CGPoint touchPos_PrevAdjusted = ccpMult(cameraTrackerTouchPosition_Prev, 1/self.scale);
        CGPoint dCameraTouchPosition = ccpSub(touchPosAdjusted, touchPos_PrevAdjusted);
        
        if (dCameraTouchPosition.x != 0 || dCameraTouchPosition.y != 0) {
            
            cameraTrackerVel = ccp(-dCameraTouchPosition.x, -dCameraTouchPosition.y);
            //NSLog(@"velocity x = %0.2f, y = %0.2f", cameraTrackerVel.x, cameraTrackerVel.y);
            
            if (dCameraTouchPosition.x != 0)
                cameraTracker.position = ccp(cameraTracker.position.x + cameraTrackerVel.x, cameraTracker.position.y);
            
            if (dCameraTouchPosition.y !=0)
                cameraTracker.position = ccp(cameraTracker.position.x, cameraTracker.position.y + cameraTrackerVel.y);
                
            
            
            
            cameraTrackerTouchPosition_Prev = cameraTrackerTouchPosition;
        }
        
    }
    
    
    
    
    
    if (shouldMoveCamera) {
        shouldMoveCamera = NO;
        
        [self cameraTrackerInBounds:cameraTracker]; ////keep it in bounds.
        
        [self scrollMapToPosition:cameraTracker.position]; ///scroll the map based on the camera tracker node position
    }
    
    
    
    
}


-(CGPoint)scrollMapToPosition:(CGPoint)position {
    
    CGSize viewSize = CGSizeMake(gs.winSize.width, gs.winSize.height);
    
    ///multiply position and mapsize by the scale of the level.
    CGPoint pos = ccpMult(position, self.scale);
    CGSize mapSize = CGSizeMake(tileMap.contentSize.width * self.scale, tileMap.contentSize.height * self.scale);
    
    int x = MAX(pos.x, viewSize.width/2);
    int y = MAX(pos.y, viewSize.height/2);
    x = MIN(x, mapSize.width - viewSize.width / 2);
    y = MIN(y, mapSize.height - viewSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(viewSize.width/2, viewSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.position = viewPoint;
    
    
    return self.position;
    
}


-(void)cameraTrackerInBounds:(CCNode*)tracker {
    
    CGPoint centerOfLevel = ccp(gs.winSize.width/2, gs.winSize.height/2);
    CGPoint minPos = ccpMult(centerOfLevel, 1/self.scale);
    CGPoint maxPos = CGPointMake( (tileMap.contentSize.width) - minPos.x, (tileMap.contentSize.height) - minPos.y);
    
    tracker.position = ccpClamp(tracker.position, minPos, maxPos);
    
}














///////////////// -----------------------   T O U C H E S







-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!gs.paused) {
    
        [_touches addObject:touch];
        
        
        if ([_touches count] == 1) {
        
        
            CGPoint location = [touch locationInNode:self];
            
            
            CGPoint cameraLocation = [touch locationInNode:gs.gameScene.outerLayer];
            cameraTrackerTouchPosition = cameraTrackerTouchPosition_Prev = ccp((int)cameraLocation.x, (int)cameraLocation.y);
            
            //NSLog(@"touch position x = %0.2f, y = %0.2f", cameraTrackerTouchPosition.x, cameraTrackerTouchPosition.y);
            
            int touchSize = 100;
            int touchSizeHalf = touchSize/2;
            touchRect = CGRectMake(location.x - touchSizeHalf , location.y - touchSizeHalf, touchSize, touchSize);
            
            if ([JobButtons getJobButtons].selectedJob != kJobNone) { ///so a job is selected......
            
                for (Lem *l in gs._lems) {
                    
                    ///check if lem already has job.
                    if (l.curJob == kJobNone) {
                    
                        if (CGRectIntersectsRect(touchRect, l.collisionRect)) {
                            
                            [l changeJobTo:[JobButtons getJobButtons].selectedJob];
                            
                            
                            ///// if you've now made him a time traveler... restart with time travelers.
                            
                            if (l.curJob == kJobTimeTraveler) {
                                activateTimeTravel = YES;
                            }
                            else if (l.curJob == kJobFlashLight) {
                                flashLightLem = l; ///////////////// will let the renderer know theres a flashlight lem... that will tell the shader.
                            }
                            
                            break; //// so you can only choose 1 lem... the first one you touch in the array of lems.
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
            
            
            
        } ////end if touches count == 1
        
        
        
        
    } ////end if paused.
    
    
    
}




-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    ///// move the camera tracker inverse to the touchmovement.
    
    if (!gs.paused) {
        
        if ([_touches count] == 1) {
        
        
            CGPoint cameraLocation = [touch locationInNode:gs.gameScene.outerLayer];
            cameraTrackerTouchPosition = ccp((int)cameraLocation.x, (int)cameraLocation.y);
        
        }
        
        //NSLog(@"touch moved to x = %0.2f, y = %0.2f", cameraTrackerTouchPosition.x, cameraTrackerTouchPosition.y);
        
    }
    
    
}






-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!gs.paused) {
    
    
        if ([_touches count] == 1) { ////before a touch is removed
            
            
            
        }
        
        
        
        
        [_touches removeObject:touch];
        
        
        
        
        
        if ([_touches count] == 1) { ////after a touch was removed
         
            ///this touch should be the touch that moves.   ... reset the camera tracker to follow this touch from now on.
            UITouch *t = [_touches objectAtIndex:0];
            CGPoint loc = [t locationInNode:gs.gameScene.outerLayer];
            
            cameraTrackerTouchPosition = cameraTrackerTouchPosition_Prev = loc;
            
        }
        
        
    }
    
    
    //cameraVel = CGPointZero;
}



@end
