
//
//  GameSave.h
//
//  Created by Justin Fletcher on 6/27/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//
#ifndef __GAMESAVE_H__
#define __GAMESAVE_H__

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameSaveKey.h"

@interface GameSave : NSObject {
	
	////variables for saving game
	NSKeyedUnarchiver	*unArchiver;
	NSKeyedArchiver		*archiver;
	
	NSString			*rootPath;
	NSString			*archivePath;
	
	NSMutableData		*stateInfo;
    
    NSMutableArray      *_keys;
}

@property(nonatomic, readonly)NSMutableArray *_keys;

-(void)saveGame;
-(void)loadGame;

-(void)saveForKey:(NSString*)key;
-(void)loadForKey:(NSString*)key;

-(BOOL)keyExists:(NSString*)keyName;
-(GameSaveKey*)getKeyWithName:(NSString*)keyName;

@end



#endif
