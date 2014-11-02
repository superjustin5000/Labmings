//
//  LevelEditor.m
//  Lem
//
//  Created by Justin Fletcher on 7/27/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "LevelEditor.h"

#import "CCButton.h"

#import "Lem.h"

#import "LemExit.h"
#import "LemStart.h"

static CCSprite *updatedBackgroundSprite;
static unsigned char *copiedCollisionMap;
static CGPoint newExitPos;
static CGPoint newStartPos;

@implementation LevelEditor

-(id)init {
    
    self = [super initWithTileMapFile:@"LevelEditor.tmx" CollisionMapFile:@"LevelEditorBG.png"];
    
    ///zoom out.
    self.scale = 1;
    
    
    
    //////recreate last changes made to the map into both background renderers.
    
    if (updatedBackgroundSprite != nil) {  /////////////// this means that there has been a restart within the level editor.
        
        [backGroundRenderer beginWithClear:0 g:0 b:0 a:0];
        
        [updatedBackgroundSprite visit];
        
        [backGroundRenderer end];
        
        
        
        [backgroundRendererEditor beginWithClear:0 g:0 b:0 a:0];
        
        [updatedBackgroundSprite visit];
        
        [backgroundRendererEditor end];
        
        
        /////copy the contents of the copied collision map into both collision maps.
        
        memcpy(collisionMap, copiedCollisionMap, backGroundRenderer.contentSize.width * backGroundRenderer.contentSize.height);
        
        collisionMapToCopy = copiedCollisionMap;
        
        
        
        
        ///move start and exit.
        lemExit.position = newExitPos;
        lemStart.position = newStartPos;
        
        
        
    }
    
    
    
    
    editMode = YES;
    isEraser = NO;
    brushSize = @"Medium";
    brushColor = @"Brown";
    brushFile = @"digMask.png";
    //mask = [CCSprite spriteWithImageNamed:brushFile];
    bitToSetInCollisionMap = kCollisionColorOther;
    
    colorButton = [CCButton buttonWithTitle:brushColor];
    sizeButton = [CCButton buttonWithTitle:brushSize];
    eraserButton = [CCButton buttonWithTitle:@"Eraser Off"];
    modeButton = [CCButton buttonWithTitle:@"Edit Mode"];
    
    [colorButton setTarget:self selector:@selector(changeColor)];
    [sizeButton setTarget:self selector:@selector(changeSize)];
    [eraserButton setTarget:self selector:@selector(changeEraser)];
    [modeButton setTarget:self selector:@selector(changeMode)];
    
    sizeButton.position = ccp(gs.winSize.width/2 - 300, gs.winSize.height - 35);
    colorButton.position = ccp(sizeButton.position.x + sizeButton.contentSize.width/2*3 + colorButton.contentSize.width/2*3 + 40, sizeButton.position.y);
    eraserButton.position = ccp(colorButton.position.x + colorButton.contentSize.width/2*3 + eraserButton.contentSize.width/2*3 + 40, sizeButton.position.y);
    modeButton.position = ccp(eraserButton.position.x + eraserButton.contentSize.width/2*3 + modeButton.contentSize.width/2*3 + 40, sizeButton.position.y);
    
    colorButton.scale = 3;
    sizeButton.scale = 3;
    eraserButton.scale = 3;
    modeButton.scale = 3;
    
    [hud addChild:colorButton];
    [hud addChild:sizeButton];
    [hud addChild:eraserButton];
    [hud addChild:modeButton];
    
    isEditing = editMode;
    
    
    
    return self;
    
}


-(void)restartLevel {
    
    /////save all previous edited level info into class variables for the next time.
    
    CCSprite *newRenderSprite = [CCSprite spriteWithTexture:backgroundRendererEditor.sprite.texture];
    newRenderSprite.position = ccp(newRenderSprite.contentSize.width/2, newRenderSprite.contentSize.height/2);
    updatedBackgroundSprite = newRenderSprite;
    
    copiedCollisionMap = collisionMapToCopy;
    
    
    //// restart as normal.
    
    [super restartLevel];
}


-(void)beatLevel {
    /////save all previous edited level info into class variables for the next time.
    
    CCSprite *newRenderSprite = [CCSprite spriteWithTexture:backgroundRendererEditor.sprite.texture];
    newRenderSprite.position = ccp(newRenderSprite.contentSize.width/2, newRenderSprite.contentSize.height/2);
    updatedBackgroundSprite = newRenderSprite;
    
    copiedCollisionMap = collisionMapToCopy;
    
    
    //// beat level as normal.
    
    [super beatLevel];
}





-(void)updateButtons {
    [colorButton setTitle:brushColor];
    [sizeButton setTitle:brushSize];
    
    
    ///update the brush as well with the right file name;
    brushFile = @"digMask";
    if (![brushColor isEqualToString:@"Brown"]) {
        brushFile = [brushFile stringByAppendingString:brushColor];
    }
    NSString *end = @".png";
    if ([brushSize isEqualToString:@"Small"]) end = @"Small.png";
    else if ([brushSize isEqualToString:@"Large"]) end = @"Big.png";
    
    brushFile = [brushFile stringByAppendingString:end];
    
    //mask = [CCSprite spriteWithImageNamed:brushFile];
    CCSpriteFrame *sf = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:brushFile];
    [mask setSpriteFrame:sf];
    
    maskFileName = brushFile;
}


-(void)changeColor {
    if ([brushColor isEqualToString:@"Brown"]) {
        brushColor = @"Red";
        bitToSetInCollisionMap = 2;
    }
    else if ([brushColor isEqualToString:@"Red"]) {
        brushColor = @"Green";
        bitToSetInCollisionMap = 3;
    }
    else if ([brushColor isEqualToString:@"Green"]) {
        brushColor = @"Blue";
        bitToSetInCollisionMap = 4;
    }
    else if ([brushColor isEqualToString:@"Blue"]) {
        brushColor = @"Brown";
        bitToSetInCollisionMap = 5;
    }
    [self updateButtons];
}

-(void)changeSize {
    if ([brushSize isEqualToString:@"Small"]) {
        brushSize = @"Medium";
    }
    else if ([brushSize isEqualToString:@"Medium"]) {
        brushSize = @"Large";
    }
    else if ([brushSize isEqualToString:@"Large"]) {
        brushSize = @"Small";
    }
    [self updateButtons];
}

-(void)changeEraser {
    if(isEraser) {
        isEraser = NO;
        [eraserButton setTitle:@"Eraser Off"];
    }
    else {
        isEraser = YES;
        [eraserButton setTitle:@"Eraser On"];
    }
}


-(void)changeMode {
    if (editMode) {
        editMode = NO;
        modeButton.title = @"Play Mode";
    }
    else {
        editMode = YES;
        modeButton.title = @"Edit Mode";
    }
}







-(void)update:(CCTime)delta {
    
    isEditing = editMode;
    
    [super update:delta];
    
}







-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!editMode) {
        
        [super touchBegan:touch withEvent:event];
        
    }
    
    
    else {
        
        
        CGPoint initTouch = [touch locationInNode:self];
        
        int touchSize = 20;
        int touchSizeHalf = touchSize/2;
        touchRectEditor = CGRectMake(initTouch.x - touchSizeHalf , initTouch.y - touchSizeHalf, touchSize, touchSize);
        
        if (CGRectIntersectsRect(touchRectEditor, lemExit.collisionRect)) {
            
            touchingExit = YES;
            
            lemExit.position = ccp(lemExit.position.x, initTouch.y + 60);
            
        }
        
        
        else if (CGRectIntersectsRect(touchRectEditor, lemStart.collisionRect)) {
            
            touchingStart = YES;
            
            lemStart.position = ccp(lemStart.position.x, initTouch.y + 60);
            
        }
        
        
        else {
        
            lastTouch = initTouch;
            
            if (isEraser) {
                [self addMaskToBackgroundWithSprite:mask Position:initTouch BlendMode:blendModeCutOut Erase:YES];
                
            }
            
            else {
                [self addMaskToBackgroundWithSprite:mask Position:initTouch BlendMode:blendModeAdd Erase:NO];
            }
        
            
        }
        
    }
    
}



-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!editMode) {
        
        [super touchMoved:touch withEvent:event];
        
    }
    
    else {
        
        
        CGPoint movTouch = [touch locationInNode:self];
        
        
        if (touchingExit) {
            
            
            lemExit.position = ccp(movTouch.x, movTouch.y + 60);
            
        }
        
        else if (touchingStart) {
            
            lemStart.position = ccp(movTouch.x, movTouch.y + 60);
            
        }
        
        else {
        
            int dist = ccpDistance(movTouch, lastTouch);
            
            if (dist >= 4) {
                
                if (isEraser) {
                    [self addMaskToBackgroundWithSprite:mask Position:movTouch BlendMode:blendModeCutOut Erase:YES];
                }
                
                else {
                    [self addMaskToBackgroundWithSprite:mask Position:movTouch BlendMode:blendModeAdd Erase:NO];
                }
                
                
                
                
            }
        
        
        }
        
        
    }
    
}



-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!editMode) {
        
        [super touchEnded:touch withEvent:event];
        
    }
    
    else {
        
        //CGPoint endTouch = [touch locationInNode:self];
        
        touchingExit = NO;
        touchingStart = NO;
        
        newExitPos = lemExit.position;
        newStartPos = lemStart.position;
        
    }
    
}



@end
