//
//  LevelEditor.h
//  Lem
//
//  Created by Justin Fletcher on 7/27/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Level.h"

@class CCButton;


@interface Brush : NSObject {
}
@property(nonatomic)BOOL isEraser;
@property(nonatomic)CGPoint position;
@property(nonatomic, retain)NSString *fileName;
+(id)brushWithFileName:(NSString*)f Position:(CGPoint)p isEraser:(BOOL)e;
-(id)initWithFileName:(NSString*)f Position:(CGPoint)p isEraser:(BOOL)e;
@end


@interface LevelEditor : Level {
    BOOL editMode;
    CGPoint lastTouch;
    NSString *brushSize;
    NSString *brushColor;
    NSString *brushFile;
    int bitToSetInCollisionMap;
    BOOL isEraser;
    
    CCButton *colorButton;
    CCButton *sizeButton;
    CCButton *eraserButton;
    CCButton *modeButton;
    
    CGRect touchRectEditor;
    BOOL touchingExit;
    BOOL touchingStart;
}


@end
