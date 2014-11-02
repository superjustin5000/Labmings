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
#import <FacebookSDK/FacebookSDK.h>



@implementation Menu

+(CCScene*)scene {
    CCScene *scene = [CCScene node];
    Menu *m = [Menu node];
    
    
    
    //yata!!
    
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

-(void)update:(CCTime)delta{
    
    
   /*
    
    ////fix this facebook bullshti.
    
    FBSession *session = [FBSession activeSession];
    BOOL checkIfLogged = (session.state == FBSessionStateOpen);
    
    //NSLog(@"state = %d", session.state);
    if(checkIfLogged){
        NSLog(@"LOGGED IN FFUCKEERRR");
    }
    */
}


-(void)pressedStart {
    [[CCDirector sharedDirector] replaceScene:[TestLevel sceneWithHudNoPad]];
}


-(void)pressedEdit {
    [[CCDirector sharedDirector] replaceScene:[LevelEditor sceneWithHudNoPad]];
}

-(void) onEnter
{
    [super onEnter];
    UIView *view = [[CCDirector sharedDirector] view];
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = CGPointMake(view.frame.size.width  - (loginView.frame.size.width/2), view.frame.size.height- (loginView.frame.size.height/2));
   
    [view addSubview:loginView];
}

-(void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    UIView *view = [[CCDirector sharedDirector] view];
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = CGPointMake(view.frame.size.width  - (loginView.frame.size.width/2), view.frame.size.height- (loginView.frame.size.height/2));
    
    [view addSubview:loginView];
}


@end
