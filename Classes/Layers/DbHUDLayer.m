/*
 * This file is part of Deblock.
 *
 *  Deblock is open software: you can use or modify it under the
 *  terms of the Java Research License or optionally a more
 *  permissive Commercial License.
 *
 *  Deblock is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 *  You should have received a copy of the Java Research License
 *  along with Deblock in the file named 'COPYING'.
 *  If not, see <http://stuff.lhunath.com/COPYING>.
 */

//
//  DbHUDLayer.m
//  Deblock
//
//  Created by Maarten Billemont on 04/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "DbHUDLayer.h"


@interface DbHUDLayer ()

@property (readwrite, retain) CCLabelAtlas        *levelScoreCount;
@property (readwrite, retain) CCLabelAtlas        *levelPenaltyCount;

@end


@implementation DbHUDLayer

@synthesize levelScoreCount = _levelScoreCount, levelPenaltyCount = _levelPenaltyCount;

- (id)init {
    
    if (!(self = [super init]))
        return nil;
    
    self.levelScoreCount             = [CCLabelAtlas labelWithString:@""
                                                         charMapFile:@"bonk.png" itemWidth:13 itemHeight:26 startCharMap:' '];
    self.levelScoreCount.color       = ccc3(0x99, 0xFF, 0x99);
    [self addChild:self.levelScoreCount];
    
    self.levelPenaltyCount           = [CCLabelAtlas labelWithString:@""
                                                         charMapFile:@"bonk.png" itemWidth:13 itemHeight:26 startCharMap:' '];
    self.levelPenaltyCount.color     = ccc3(0xFF, 0x99, 0x99);
    [self addChild:self.levelPenaltyCount];
    
    self.visible = ![[DeblockConfig get].kidsMode boolValue];
    
    return self;
}

-(void) updateHudWasGood:(BOOL)wasGood {
    
    NSInteger playerScore = [Player currentPlayer].score;
    [self.scoreCount setString:[NSString stringWithFormat:@"%04d", playerScore]];
    [super updateHudWasGood:wasGood];
    
    NSString *gameScore         = [NSString stringWithFormat:@"%04d", playerScore];
    NSString *levelScore        = [NSString stringWithFormat:@"%+04d", [[DeblockConfig get].levelScore intValue]];
    NSString *levelPenalty      = [NSString stringWithFormat:@"%+04d", [[DeblockConfig get].levelPenalty intValue]];
    
    self.levelScoreCount.position    = ccp(self.scoreCount.position.x + 13 * gameScore.length, self.scoreCount.position.y);
    [self.levelScoreCount setString:levelScore];
    
    self.levelPenaltyCount.visible = [Player currentPlayer].mode == DbModeTimed;
    if (self.levelPenaltyCount.visible) {
        self.levelPenaltyCount.position  = ccp(self.scoreCount.position.x + 13 * (gameScore.length + levelScore.length), self.scoreCount.position.y);
        [self.levelPenaltyCount setString:levelPenalty];
    }
}

- (void)dealloc {

    self.levelScoreCount = nil;
    self.levelPenaltyCount = nil;

    [super dealloc];
}

@end
