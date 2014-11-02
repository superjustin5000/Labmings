//
//  GameSave.m
//
//  Created by Justin Fletcher on 6/27/12.
//  Copyright 2012 Justin Fletcher. All rights reserved.
//

#import "GameSave.h"


@interface GameSave (Private)
-(void)save;
-(void)load;
@end



@implementation GameSave

@synthesize _keys;


-(id)init {
    if ((self = [super init])) {
        
        rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        archivePath = [rootPath stringByAppendingPathComponent:@"GameSave.archive"];
        
        stateInfo = [NSMutableData data];
        archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:stateInfo];
        
        _keys = [[NSMutableArray alloc] init];
        
    }
    return self;
}




-(void)saveGame {
    for (GameSaveKey *k in _keys) {
        [self saveForKey:k.name];
    }
}

-(void)loadGame {
    for (GameSaveKey *k in _keys) {
        [self loadForKey:k.name];
    }
}

-(void)eraseGame {
    for (GameSaveKey *k in _keys) {
        [k resetValues];
    }
}


-(void)saveForKey:(NSString*)key {
    GameSaveKey *k = [self getKeyWithName:key];
    [archiver encodeObject:k forKey:k.name];
    [self save];
}

-(void)loadForKey:(NSString *)key {
    NSData *theData = [NSData dataWithContentsOfFile:archivePath];
    unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
	
    [unArchiver decodeObjectForKey:key];
    
    
    [self load];
}

-(void)eraseForKey:(NSString *)key {
    GameSaveKey *k = [self getKeyWithName:key];
    [k resetValues];
}



-(void)save {
    
	[archiver finishEncoding];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
		[[NSFileManager defaultManager] createFileAtPath:archivePath contents:stateInfo attributes:nil];
	}
	else {
		[stateInfo writeToFile:archivePath atomically:YES];
	}
	NSLog(@" GAME SAVED ...");
    
}

-(void)load {
    [unArchiver finishDecoding];
	//////////// anything else that needs to happen onLoad
	NSLog(@" GAME LOADED ...");
}







-(BOOL)keyExists:(NSString *)keyName {
    int keysLike = 0;
    for (GameSaveKey *k in _keys) {
        if ([k.name isEqualToString:keyName]) {
            keysLike += 1;
            break;
        }
    }
    
    return keysLike > 0;
}
-(GameSaveKey*)getKeyWithName:(NSString *)keyName {
    for (GameSaveKey *k in _keys) {
        if ([k.name isEqualToString:keyName]) {
            return k;
        }
    }
    return nil;
}






@end


