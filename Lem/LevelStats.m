//
//  LevelStats.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 12/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "LevelStats.h"

#import "Level1.h"
#import "Level2.h"
#import "LevelEditor.h"


@implementation LevelStats

+(id)levelStatsWithNextLevelNum:(int)ln {
    return [[self alloc] initStatsWithNextLevelNum:ln];
}


-(id)initStatsWithNextLevelNum:(int)ln {
    if ((self = [super init])) {
        nextLevelNum = ln;
    }
    return self;
}





-(void)startNextLevel {
    
    switch (nextLevelNum) {
        case 1:
            nextLevelScene = [Level1 sceneWithHudNoPad];
            break;
        case 2:
            nextLevelScene = [Level2 sceneWithHudNoPad];
            break;
            
            /*
        case 3:
            nextLevelScene = [Level3 sceneWithHud];
            break;
        case 4:
            nextLevelScene = [Level4 sceneWithHud];
            break;
        case 5:
            nextLevelScene = [Level5 sceneWithHud];
            break;
        case 6:
            nextLevelScene = [Level6 sceneWithHud];
            break;
        case 7:
            nextLevelScene = [Level7 sceneWithHud];
            break;
        default:
            break;
             
             
             */
            
            
            
        case 999:
            nextLevelScene = [LevelEditor sceneWithHudNoPad];
            break;
            
    }
    
    [[CCDirector sharedDirector] replaceScene:nextLevelScene];
    
}


@end
