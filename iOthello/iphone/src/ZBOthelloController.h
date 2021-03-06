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
#import "ZBOthelloBoard.h"


@interface ZBOthelloController : NSObject 
{
    Owner context;
    Owner computer;
    ZBOthelloBoard *board;
    NSTimer *timer;
    UIView *view;
}

- (void)cellClicked: (ZBOthelloCell *)cell inView: (UIView *)v;
- (int)validMove: (ZBOthelloCell *)cell Mark:(BOOL)mark;
- (bool)anyMoves;

- (void)setBoard:(ZBOthelloBoard *)newBoard;

- (void)switchContext;

- (void)doAi;

//AI
- (void)othelloAI;
- (void)calcFlipCounts;
- (int)rate:(ZBOthelloCell *)cell;


@end
