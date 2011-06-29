/* vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker: */
// +------------------------------------------------------------------------+
// | iOthello - Othello for Mac and iPhone                                  |
// +------------------------------------------------------------------------+
// | Copyright (c) 2007 Zack Bartel                                         |
// +------------------------------------------------------------------------+
// | This program is free software; you can redistribute it and/or          |
// | modify it under the terms of the GNU General Public License            | 
// | as published by the Free Software Foundation; either version 2         | 
// | of the License, or (at your option) any later version.                 |
// |                                                                        |
// | This program is distributed in the hope that it will be useful,        |
// | but WITHOUT ANY WARRANTY; without even the implied warranty of         |
// | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          |
// | GNU General Public License for more details.                           |
// |                                                                        |
// | You should have received a copy of the GNU General Public License      |
// | along with this program; if not, write to the Free Software            |
// | Foundation, Inc., 59 Temple Place - Suite 330,                         |
// | Boston, MA  02111-1307, USA.                                           |
// +------------------------------------------------------------------------+
// | Author: Zack Bartel <zack@bartel.com>                                  |
// +------------------------------------------------------------------------+ 

#import "ZBOthelloController.h"
#import "ZBOthelloBoard.h"


@implementation ZBOthelloController

- (id)init
{
    self = [super init];
    context = White;
    srand([[NSDate date] timeIntervalSince1970]);
    return self;
}
    
- (void)cellClicked: (ZBOthelloCell *)cell
{
    if ([cell owner] == None)
    {
        if ([self validMove: cell Mark: NO])
        {
            [self validMove: cell Mark: YES];
            [self switchContext];
            [self doAi];
        }
    }
}

- (void)doAi
{
    timer = [[NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(timerFired:)
                                   userInfo:nil
                                    repeats:NO
                ] retain];
}

- (void)timerFired:(NSTimer *)sender
{
    NSLog(@"timerFired");
    [self othelloAI];
    [self switchContext];
    [view setNeedsDisplay: YES];
}

- (void)stop
{
    if (timer != nil)
    {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)switchContext
{
    if (context == Black)
        context = White;
    else
        context = Black;

}

- (int)validMove: (ZBOthelloCell *)cell Mark:(BOOL)mark
{
    int x, y;
    int deltax, deltay;
    int posx, posy;
    int distance;
    int count = 0;
    int dimension = [board dimension];
    
    x = [cell x];
    y = [cell y];
    
    if (mark)
    {
        [cell setOwner: context];
    }
    
    for (deltay = -1; deltay <= 1; deltay++) 
    {
        for (deltax = -1; deltax <= 1; deltax++) 
        {
            for (distance = 1;; distance++) 
            {
                posx = x + (distance * deltax);
                posy = y + (distance * deltay);
                // stop if we go off the board
                if (posx < 0 || posx >= dimension || posy < 0 || posy >= dimension)
                {
                    break;
                }
                // stop when we reach an empty square
                if ([[board cellAtX:posx Y:posy] owner] == None)
                {
                    break;
                }
                // only update the flip count when we reach another of the
                // player's pieces
                if ([[board cellAtX:posx Y:posy] owner] == context) 
                {
                    if (mark)
                    {
                        for (distance--; distance > 0; distance--)
                        {
                            posx = x + (distance * deltax);
                            posy = y + (distance * deltay);
                            [[board cellAtX:posx Y:posy] setOwner: context];
                        }
                    }
                    count += distance - 1;
                    break;
                }
            }
        }
    }
    return count;
}

- (void)othelloAI
{
    int x, y;
    int best = 0, numbest = 0;
    int rating;
    int pick, count;
    
    int dimension = [board dimension];
    ZBOthelloCell *cell;
    
    [self calcFlipCounts];
    
    for (y = 0; y < dimension; y++)
    {
        for (x = 0; x < dimension; x++)
        {   
            cell = [board cellAtX: x Y: y];
            rating = [self rate: cell];
            
            if (context == Black)
                [cell setValueBlack: rating];
            else if (context == White)
                [cell setValueWhite: rating];
                
            if (rating == best)
                numbest++;
            else if (rating > best)
            {
                best = rating;
                numbest = 1;
            }
        }
    }
    
    //while (numbest > 0)
   // {
        //pick = floor(rand() * numbest);
        pick = numbest;
        count = 0;
        
        for (y = 0; y < dimension; y++)
        {
            for (x = 0; x < dimension; x++)
            {
                cell = [board cellAtX: x Y: y];
                
                if (context == Black)
                    rating = [cell valueBlack];
                else if (context == White)
                    rating = [cell valueWhite];
                
                if (rating == best)
                {
                    //if (count == pick)    {
                        [self validMove: cell Mark: YES];
                        return;
                    //}
                    //else count++;
                }
            }
       // }
    }
}

- (void)calcFlipCounts
{
    int x, y;
    int dimension = [board dimension];
    ZBOthelloCell *cell;
    
    for (y = 0; y < dimension; y++)
    {
        for (x = 0; x < dimension; x++)
        {
            cell = [board cellAtX: x Y: y];
            [cell setFlipWhite: 0];
            [cell setFlipBlack: 0];
            
            if ([cell owner] != None)
                continue;
            
            [cell setFlipWhite: [self validMove: cell Mark: NO]];
            [cell setFlipBlack: [self validMove: cell Mark: NO]];
        }
    }
}

- (int)rate:(ZBOthelloCell *)cell
{
    int rating;
    
    int dimension = [board dimension];
    int x = [cell x];
    int y = [cell y];
    
    if ([cell owner] != None)
        return 0;
    
    if (context == Black)
        rating = [cell flipBlack];
    else
        rating = [cell flipWhite];
        
    if (rating > 0)
    {
        rating += 10;
        
        if (x == 0 || x == dimension - 1) 
            rating += 4;
        if (y == 0 || y == dimension - 1)
            rating += 4;
        if (x == 1 || x == dimension -2)
            rating -= 5;
        if (y == 1 || y == dimension -2)
            rating -= 5;
            
        if (rating < 1)
            rating = 1;
    }
        return rating;
}


- (void)setBoard:(ZBOthelloBoard *)newBoard
{
    if (board)
    {
        [board release];
    }
    board = [newBoard retain];
    
}
    
@end
