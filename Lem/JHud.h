//
//  hud.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/31/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//
#ifndef __JHUD_H__
#define __JHUD_H__


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class JPad;
@class JHudNode;

@interface JHud : CCNode {
    
    BOOL isPadEnabled;
    JPad *pad;
    
    UITouch *aButtonTouch;
    UITouch *bButtonTouch;
    UITouch *dpadTouch; ///this will be the exclusive touch of the dpad, so that it is the only touch that the dpad responds to.


}

+(JHud*)getHud;

+(id)hudWithPad:(BOOL)withPad;
+(id)hudWithPad:(BOOL)withPad thisPad:(JPad*)thisPad;
-(id)initWithPad:(BOOL)withPad thisPad:(JPad*)thisPad;

-(void)enablePad;
-(void)disablePad;
-(BOOL)isPadEnabled;






@end

#endif
