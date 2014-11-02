//
//  LemStart.h
//  Lem
//
//  Created by Justin Fletcher on 7/31/14.
//  Copyright 2014 Justin Fletcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LemStart : JSprite {
    
}
+(id)StartWithGameName:(NSString*)gameName;
-(id)initWithGameName:(NSString*)gameName;
@end
