//
//  JHudNode.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/30/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "JHud.h"

@interface JHudNode : CCNode {
    JHud *hud;
    GameState *gs;
}

-(void)centerNodeToScreen;

@end
