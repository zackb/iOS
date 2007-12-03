/* vim: set expandtab tabstop=4 shiftwidth=4 foldmethod=marker: */
// +------------------------------------------------------------------------+
// | Sudoku - iPhone Sudoku Game                                            |
// +------------------------------------------------------------------------+
// | Copyright (c) 2006 Zack Bartel                                         |
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

#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import "ZBCell.h"

#define PUZZLE_DIR @"puzzles"
#define GAME_DAT   @"game.dat"
#define DIMENSION 9

@interface SudokuController : NSObject {
    int **board;
    NSMutableArray *_cells;
    CGRect _rect;
    int currentPuzzlePos;
}

- (id)initWithRect:(CGRect)rect;
- (void)initCells;
- (ZBCell *)cellAtPoint:(CGPoint)point;
- (NSMutableArray *)cells;

- (void)loadBoardAndCells;

- (void)init_board;
- (void)free_board;
- (void)print_board;
- (void)load:(const char *)file;
- (void)cells_to_board;
- (BOOL)is_solved;

- (void)loadDataFromDisk;
- (void)saveDataToDisk;
- (BOOL)gameDataExists;
- (NSString *)pathToDataFile;

@end
