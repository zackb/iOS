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
#import "ZBOthelloBoard.h"


@implementation ZBOthelloBoard

- (id)initWithRect: (CGRect)r Dimension: (int)dim
{
    self = [super init];
    dimension = dim;
    rect = r;
    [self initCells];
    return self;
}

- (ZBOthelloCell *)cellAtX: (int)x Y:(int)y
{

    return [cells objectAtIndex: dimension*y + x];

}

- (void)reset
{
    int i, j;
    ZBOthelloCell *cell;

    for (i = 0; i < dimension; i++)
    {
        for (j = 0; j < dimension; j++)
        {
            cell = [self cellAtX: j Y: i];
            [cell setOwner: None];
        }
    }
}

- (void)initCells
{
    int i = 0;
    int j = 0;
    ZBOthelloCell *current = nil;
    CGRect cellRect;
    float cellWidth = rect.size.width/dimension;
    float cellHeight = rect.size.height/dimension;

    float x = rect.origin.x;
    float y = rect.origin.y; 

    if ( cells )   {   
        [cells release];
        cells = nil;
    }   

    cells = [[NSMutableArray alloc] init];

    for ( i = 0; i < dimension; i++ )   
    {
        for ( j = 0; j < dimension; j++ )   
        {
            cellRect = CGRectMake(x + (j*cellWidth), y + (i*cellHeight), cellWidth, cellHeight);

            current = [[ZBOthelloCell alloc] initWithRect: cellRect];
            [current setX: j];
            [current setY: i];
            [cells addObject: current];
        }   
    }   

    [[self cellAtX: dimension/2 - 1 Y: dimension/2 - 1] setOwner: White];
    [[self cellAtX: dimension/2 Y: dimension/2] setOwner: White];
    [[self cellAtX: dimension/2 Y: dimension/2 - 1] setOwner: Black];
    [[self cellAtX: dimension/2 - 1 Y: dimension/2] setOwner: Black];
//    [[cells objectAtIndex:28] setOwner: Black];
//    [[cells objectAtIndex:27] setOwner: White];
//    [[cells objectAtIndex:36] setOwner: White];
//    [[cells objectAtIndex:35] setOwner: Black];
}

- (int)dimension
{
    return dimension;
}

@end
