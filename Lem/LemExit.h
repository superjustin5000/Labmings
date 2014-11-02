//
//  lemExit.h
//  Lem
//
//  Created by Justin Fletcher on 7/15/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LemExit : JSprite {
    
}

+(id)ExitWithGameName:(NSString*)gameName;
-(id)initWithGameName:(NSString*)gameName;

@end
