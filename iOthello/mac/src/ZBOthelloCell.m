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

#import "ZBOthelloCell.h"


@implementation ZBOthelloCell
    
- (id)initWithRect:(CGRect)r
{
    self = [super init];
    rect = r;
    owner = None;
    flipWhite = 0;
    flipBlack = 0;
    valueBlack = 0;
    valueWhite = 0;
    return self;
}

- (Owner)owner
{
    return owner;
}

- (void)setOwner: (Owner)newOwner
{
    owner = newOwner;
}

- (CGRect)rect
{
    return rect;
}

- (void)setX:(int)newX
{
    x = newX;
}

- (int)x
{
    return x;
}

- (void)setY:(int)newY
{
    y = newY;
}

- (int)y
{
    return y;
}

- (int)flipWhite
{
    return flipWhite;
}

- (void)setFlipWhite:(int)flip
{
    flipWhite = flip;
}

- (int)flipBlack
{
    return flipBlack;
}

- (void)setFlipBlack:(int)flip
{
    flipBlack = flip;
}

- (int)valueWhite
{
    return valueWhite;
}

- (void)setValueWhite:(int)white
{
    valueWhite = white;
}

- (int)valueBlack
{
    return valueBlack;
}

- (void)setValueBlack:(int)black
{
    valueBlack = black;
}

@end
