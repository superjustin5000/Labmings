//
//  Menu.m
//  Lem
//
//  Created by Justin Fletcher on 7/27/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import "Menu.h"

#import "LevelEditor.h"

#import "TestLevel.h"
#import "Level1.h"

#import "CCButton.h"


@implementation Menu

+(CCScene*)scene {
    CCScene *scene = [CCScene node];
    Menu *m = [Menu node];
    
    
    
    [scene addChild:m];
    
    return scene;
}


-(id)init {
    
    self = [super init];
    
    gs = [GameState sharedGameState];
    
    CCButton *start = [CCButton buttonWithTitle:@"Start Game"];
    CCButton *edit = [CCButton buttonWithTitle:@"Level Editor"];
    CCButton *social = [CCButton buttonWithTitle:@"Social"];
    
    
    start.position = ccp(gs.winSize.width/2, gs.winSize.height/2 + 50);
    edit.position = ccp(gs.winSize.width/2, gs.winSize.height/2 - 50);
    social.position = ccp(edit.position.x, edit.position.y - (edit.contentSize.height)*3.5);
    
    start.scale = 3;
    edit.scale = 3;
    social.scale = 3;
    
    [start setTarget:self selector:@selector(pressedStart)];
    [edit setTarget:self selector:@selector(pressedEdit)];
    
    
    [self addChild:start];
    [self addChild:edit];
    [self addChild:(social)];
    
    
    return self;
    
}


-(void)pressedStart {
    [[CCDirector sharedDirector] replaceScene:[TestLevel sceneWithHudNoPad]];
}


-(void)pressedEdit {
    [[CCDirector sharedDirector] replaceScene:[LevelEditor sceneWithHudNoPad]];
}



@end
