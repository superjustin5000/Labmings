//
//  JLevel.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 6/28/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#import "JLevel.h"


/////////////////
////////////////########===========----------   JLEVEL  ------------

@implementation JLevel


+(JScene*)scene {
    return [self sceneWithHud:NULL];
}

+(JScene*)sceneWithHud {
    JHud *hud = [JHud hudWithPad:YES];
    return [self sceneWithHud:hud];
}

+(JScene*)sceneWithHudNoPad {
    JHud *hud = [JHud hudWithPad:NO];
    return [self sceneWithHud:hud];
}

+(JScene*)sceneWithHud:(JHud*)hud {
    
    JLevel *level = [[self alloc] init];
    JScene *scene = [JScene sceneWithLevel:level];
    
    if (hud)
        [scene addChild:hud z:kzHud name:@"1000"];
    
    return scene;
}









-(id)init {
    if ((self = [super init])) {

        gs = [GameState sharedGameState];
        hud = [JHud getHud];
        
        
        
        
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        
        self.exclusiveTouch = NO;
        self.claimsUserInteraction = NO;
        
        
        ////RESET GAMESTATE STUFF WHEN LEVEL STARTS.
        [gs._jSprites removeAllObjects];
        
        [self resetGameStateLevelVars];
        
        
        allowRotation = YES;
        scrollSpeed = CGPointMake(0, 0);
        
        /////////////// DRAWING THE BOUNDING BOXES OF SPRITES FOR PHYSICS
        //enableDebugDraw = YES;
        drawNode = [CCDrawNode node]; ///// node used for drawing lines and polys.
        [drawNode setContentSize:gs.winSize];
        //[self addChild:drawNode z:kZForground];
        
        
        
        //[self schedule:@selector(updateJLevel:) interval:gs.gameDelta];
        
        
        gs.gameLevel = self;
        
    }
    return self;
}


-(void)resetGameStateLevelVars {
    ////override with level vars in subclass.
}


-(void)pauseLevel {
    gs.paused = YES;
    [[CCDirector sharedDirector] pause];
}
-(void)unpauseLevel {
    gs.paused = NO;
    [[CCDirector sharedDirector] resume];
}
-(void)restartLevel {
    ////implement in subclass...
}


-(void)updateJLevel:(CCTime)dt {
    
    
    
    
    
    //////////////  CHECK IF NEED TO DRAW BOUNDING BOXES OF SPRITES.
    
    if (enableDebugDraw) {
    
        [drawNode clear];
        
        /*
        
        for (JPhysicsBody* b in gs._physBodies) {
        
            if (b.drawRects) {
                
                CCColor *c = [CCColor colorWithRed:0 green:1 blue:0 alpha:0.2];
                
                if (b.canCollide) c = [CCColor colorWithRed:0 green:1 blue:0 alpha:1];
                if (b.isColliding) c = [CCColor colorWithRed:1 green:0 blue:0];
                
                if (b.shape == JPhysicsShapeRect) {
                    //glLineWidth(0.5f);
                    //NSLog(@"current scale x = %0.2f", self.scaleX);
                    
                    float width = b.collisionRect.size.width;
                    float height = b.collisionRect.size.height;
                    
                    float x = (b.collisionRect.origin.x);
                    float y = (b.collisionRect.origin.y);
                    //x = spriteRect.size.width/2 - width/2 + x;
                    //y = spriteRect.size.height/2 - height/2 + y;
                    
                    CGPoint verts[4] = {
                        ccp(x,y),
                        ccp(x + width, y),
                        ccp(x + width, y + height),
                        ccp(x, y + height)
                    };
                    
                    [drawNode drawPolyWithVerts:verts count:4 fillColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0] borderWidth:1 borderColor:c];
                
                } ///end if it's a rect.
                
                
            } ///end if you should draw rects.
            
        }/// end for physbodies
            
        */
    }
}



@end










/////////////////
////////////////########===========----------   JSCENE  ------------




@implementation JScene

@synthesize curLevel, outerLayer;


+(id)sceneWithLevel:(JLevel *)lvl {
    return [[self alloc] initWithLevel:lvl];
}

-(id)initWithLevel:(JLevel*)lvl {
    if ((self = [super init])) {
        gs = [GameState sharedGameState];
        
        outerLayer = [CCNode node];
        [outerLayer addChild:lvl z:0];
        
        [self addChild:outerLayer];
        
        curLevel = lvl;
        
        gs.gameScene = self;
    }
    return self;
}


-(void)screenShake {
    outerLayer.position = ccp(0,0);///reset pos so multiple shakes wont make it go up permanently
    id shake = [CCActionJumpBy actionWithDuration:0.2 position:ccp(0,0) height:10 jumps:3];
    [outerLayer runAction:shake];
}



@end
