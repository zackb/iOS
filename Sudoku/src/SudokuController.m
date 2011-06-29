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


#import "Sudoku.h"
#import "ZBBoardView.h"

@implementation SudokuController

- (id)initWithRect:(CGRect)rect
{
    self = [super init];
    _rect = rect;

    currentPuzzlePos = 1;
    /* Check for saved game data */
    if ( [self gameDataExists] )
    {
        [self loadDataFromDisk];
    }
    else
    {
        [self initCells];
        [self loadBoardAndCells];
    }

    return self;
}

- (void)initCells
{
    int i = 0;
    int j = 0;
    ZBCell *current = nil;
    CGRect cellRect;
    float cellWidth = _rect.size.width/DIMENSION;
    float cellHeight = (_rect.size.height - NAVBAR_HEIGHT)/DIMENSION;

    float x = _rect.origin.x;
    float y = _rect.origin.y + NAVBAR_HEIGHT;

    if ( _cells )   {
        [_cells release];
        _cells = nil;
    }

    _cells = [[NSMutableArray alloc] init];

    for ( i = 0; i < DIMENSION; i++ )   {
        for ( j = 0; j < DIMENSION; j++ )   {
            cellRect = CGRectMake(x + (j*cellWidth), y + (i*cellHeight), cellWidth, cellHeight);

            cellRect.origin.x       += 3;
            cellRect.origin.y       += 3;
            cellRect.size.width     -= 6;
            cellRect.size.height    -= 6;

            current = [[ZBCell alloc] initWithRect: cellRect];
            [_cells addObject: current];
        }
    }
}

- (ZBCell *)cellAtPoint:(CGPoint)point  {
    int i;
    ZBCell *current;

    for ( i = 0; i < [_cells count]; i++ )  {
        current = [_cells objectAtIndex: i];
        if ( CGRectContainsPoint([current rect], point) )   {
            return current;
        }
    }
    return nil;
}

- (void)loadBoardAndCells
{
    int i, j;
    int pos = 0;

    ZBCell *current;
    NSBundle *b = [NSBundle mainBundle];
    NSString *path = [b bundlePath];
    path = [path stringByAppendingPathComponent: PUZZLE_DIR];

    //Find a puzzle
    NSString *curObject;
    NSDirectoryEnumerator *enumerator  = [[NSFileManager defaultManager] enumeratorAtPath:  path];
    for ( i = 0; i < currentPuzzlePos; i++ )
    {
        curObject = [enumerator nextObject];
        if (curObject == nil)   {
            currentPuzzlePos = 1;
            enumerator  = [[NSFileManager defaultManager] enumeratorAtPath:  path];
            curObject = [enumerator nextObject];
            //Messy
            continue;
        }
    }
    currentPuzzlePos++;
    path = [path stringByAppendingPathComponent: curObject];

    if ( board == NULL )
    {
        [self init_board];
    }

    [self load: [path cStringUsingEncoding: NSASCIIStringEncoding]];

    for ( i = 0; i < DIMENSION; i++ )
    {
        for ( j = 0; j < DIMENSION; j++ )
        {
            current = [_cells objectAtIndex: pos++];
            [current setNumber: board[i][j]];

            if ( board[i][j] != 0 )
            {
                [current setEditable: NO];
            }
            else
            {
                [current setEditable: YES];
            }
        }
    }
}

- (NSMutableArray *)cells   
{
    return _cells;
}

- (void)init_board
{
    int i;
    board = malloc(DIMENSION * sizeof(int*));
    for ( i = 0; i < DIMENSION; i++ )
    {
        board[i] = malloc(DIMENSION * sizeof(int));
    }

}

- (void)load:(const char *)file
{
    int i, j;
    int pos = 0;
    int bytes_read = 0;
    int buf_siz = 1024;
    char buf[buf_siz];
    memset(buf, '\0', buf_siz);

    FILE *fp = fopen(file, "r");
    if ( !fp )    {
        perror("Failed to open puzzle: ");
    }

    bytes_read = fread(buf, sizeof(char), buf_siz, fp);
    
    for ( i = 0; i < DIMENSION; i++ )
    {
        for ( j = 0; j < DIMENSION; j++ )
        {
            while(!isdigit(buf[pos++])) 
            {
                if (buf[pos - 1] == '.')    {
                    buf[pos - 1] = '0';
                    break;
                }
            }
            board[i][j] = atoi(&buf[pos - 1]);
        }
    }

    fclose(fp);
}

- (BOOL)is_solved
{
    int i, j;
    int tmp = 0;
    int range[DIMENSION] = { 0 };
    
    [self cells_to_board];

    /* check horizontal */
    for ( i = 0; i < DIMENSION; i++ )
    {
        memset(range, 0, DIMENSION * sizeof(int));
        for ( j = 0; j < DIMENSION; j++ )
        {
            tmp = board[i][j];           

            if ( tmp < 1 || tmp > DIMENSION )
            {
                return NO;
            }

            if ( range[tmp-1] != 0 )
            {
                return NO;
            }
            
            range[tmp-1] = 1;
        }

        tmp = 0;
        for ( j = 0; j < DIMENSION; j++ )
        {
            tmp += range[j];
        }

        if ( tmp != 9 )
        {
            return NO;
        }
    }

    tmp = 0;
    for ( i = 0; i < DIMENSION; i++ )
        range[i] = 0;

    /* check vertical */
    for ( i = 0; i < DIMENSION; i++ )
    {
        memset(range, 0, DIMENSION * sizeof(int));
        for ( j = 0; j < DIMENSION; j++ )
        {
            tmp = board[j][i];

            if ( tmp < 1 || tmp > DIMENSION )
            {
                return NO;
            }

            if ( range[tmp-1] != 0 )
            {
                return NO;
            }

            range[tmp-1] = 1;
        }

        tmp = 0;
        for ( j = 0; j < DIMENSION; j++ )
        {
            tmp += range[j];
        }

        if ( tmp != 9 )
        {
            return NO;
        }
    }

    tmp = 0;

    /* check 3x3 squares */

    return YES;

}

- (void)print_board
{
    int i, j;
    for ( i = 0; i < DIMENSION; i++ )
    {
        for ( j = 0; j < DIMENSION; j++ )
        {
            printf("%d ", board[i][j]);
        }
        printf("\n");
    }
}

- (void)cells_to_board
{
    int i, j;
    int pos = 0;
    ZBCell *current = nil;

    if ( board == NULL )
    {
        [self init_board];
    }

    for ( i = 0; i < DIMENSION; i++ )
    {
        for ( j = 0; j < DIMENSION; j++ )
        {
            current = [_cells objectAtIndex: pos++];
            board[i][j] = [current number];
        }
    }
}

- (void)free_board
{
    int i;
    for ( i = 0; i < DIMENSION; i++ )
    {
        free(board[i]);
    }
    free(board);
    board = NULL;
}

- (void)dealloc
{
    [self free_board];
    [super dealloc];
}

- (void) loadDataFromDisk
{
    if ( _cells)    {
        [_cells autorelease];
    }

    NSDictionary *root = [NSKeyedUnarchiver unarchiveObjectWithFile: [self pathToDataFile]];
    _cells = [[NSMutableArray alloc] initWithArray: [root valueForKey: @"board"]];
}

- (void) saveDataToDisk
{
    NSMutableDictionary *root = [NSMutableDictionary dictionary];

    [root setValue: _cells forKey: @"board"];
    [NSKeyedArchiver archiveRootObject: root toFile: [self pathToDataFile]];
}

- (BOOL)gameDataExists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self pathToDataFile]];
}

- (NSString *)pathToDataFile
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    return [path stringByAppendingPathComponent: GAME_DAT];
}

@end
