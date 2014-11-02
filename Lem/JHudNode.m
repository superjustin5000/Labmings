//
//  JHudNode.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/30/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "JHudNode.h"

@implementation JHudNode

-(id)init {
    if ((self = [super init])) {
        
        hud = [JHud getHud];
        gs = [GameState sharedGameState];
        
        [hud addChild:self];
        
    }
    return self;
}

-(void)centerNodeToScreen {
    self.contentSize = CGSizeMake(gs.winSize.width, gs.winSize.height);
    self.position = ccp(gs.winSize.width/2, gs.winSize.height/2);
    self.anchorPoint = ccp(.5,.5);
}


@end
