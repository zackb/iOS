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

#import <UIKit/UIKit.h>

typedef enum _Owner
{
    None = -1,
    White = 0,
    Black = 1
} Owner;

@interface ZBOthelloCell : NSObject
{
    Owner owner;
    CGRect rect;
    int x;
    int y;
    int flipWhite;
    int flipBlack;
    int valueWhite;
    int valueBlack;
}

- (id)initWithRect:(CGRect)r;

- (Owner)owner;
- (void)setOwner: (Owner)newOwner;
- (CGRect)rect;

- (int)flipWhite;
- (void)setFlipWhite:(int)flip;
- (int)flipBlack;
- (void)setFlipBlack:(int)flip;

- (int)valueWhite;
- (void)setValueWhite:(int)white;
- (int)valueBlack;
- (void)setValueBlack:(int)black;

- (void)setX:(int)newX;
- (int)x;
- (void)setY:(int)newY;
- (int)y;

@end
