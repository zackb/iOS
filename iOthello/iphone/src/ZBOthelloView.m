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

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIView-Geometry.h>
#import "ZBOthelloView.h"
#import "ZBOthelloCell.h"
#import "ZBOthelloController.h"


@implementation ZBOthelloView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        board = [[ZBOthelloBoard alloc] initWithRect:CGRectMake(
                                                        frame.origin.x,
                                                        frame.origin.y,
                                                        frame.size.width,
                                                        frame.size.height)
                                        Dimension: 8];
        controller = [[ZBOthelloController alloc] init];
        [controller setBoard: board];
        [self initImages];
    }
    return self;
}

- (void)drawRect:(NSRect)r 
{
    int i;
    int j;
    CGRect rect = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height);
    float cellWidth = rect.size.width/DIMENSION;
    float cellHeight = rect.size.height/DIMENSION;
    float black[4] = {0, 0, 0, 1};
    
    CGContextRef ctx = UICurrentContext();

    CGContextDrawImage(ctx, rect, backImage);
    
    int dimension = [board dimension];
    
    for (i = 0; i < dimension; i++)
    {
        for (j = 0; j < dimension; j++)
        {
            [self renderCell: [board cellAtX: i Y:j]];
        }
    }
//Draw Board
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetFillColor(ctx, black);

    for ( i = 0; i < dimension; i++ ) 
    {
        //Vertical
        CGContextBeginPath(ctx);      
        CGContextMoveToPoint(ctx, i * cellWidth, 0);
        CGContextAddLineToPoint(ctx, i * cellWidth, rect.size.height);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        //Horizontal
        CGContextBeginPath(ctx);      
        CGContextMoveToPoint(ctx, 0, (i * cellHeight));
        CGContextAddLineToPoint(ctx, rect.size.width, (i * cellHeight) );
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }

}

- (void)mouseDown:(GSEvent *)event
{
    CGRect rect = [self frame];
    
    int dimension = [board dimension];
    
    CGPoint point = GSEventGetLocationInWindow(event);

    int cellWidth = (int)rect.size.width/dimension;
    int cellHeight = (int)rect.size.height/dimension;
    
    int x = (int)point.x / cellWidth;
    int y = (int)point.y / cellHeight;
    
    [controller cellClicked: [board cellAtX: x Y: y] inView: self];
    
    [self setNeedsDisplay];
    
}

- (void)renderCell:(ZBOthelloCell *)cell
{
    CGContextRef ctx = UICurrentContext();

    CGRect rect = [cell rect];

    if ([cell owner] == Black)
    {
        CGContextDrawImage(ctx, rect, blackImage);
    }
    else if ([cell owner] == White)
    {
        CGContextDrawImage(ctx, rect, whiteImage);
    }
}

- (int)scoreForOwner:(Owner)owner
{
    int x, y;
    int result = 0;
    int dimension = [board dimension];

    for (y = 0; y < dimension; y++)
    {
        for (x = 0; x < dimension; x++)
        {
            if ([[board cellAtX: x Y: y] owner] == owner)
            {
                result++;
            }
        }
    }
    
    return result;
}
    
- (void)gameOver
{
    int blackCount = [self scoreForOwner: Black];
    int whiteCount = [self scoreForOwner: White];

    NSString *message;

    NSLog(@"White: %d Black: %d", whiteCount, blackCount);

    if (whiteCount > blackCount)
    {
        message = [NSString stringWithFormat: @"White wins! %d - %d", whiteCount, blackCount];
    }
    else if (blackCount > whiteCount)
    {
        message = [NSString stringWithFormat: @"Black wins! %d - %d", blackCount, whiteCount];
    }
    else
    {
        message = [NSString stringWithFormat: @"Tie! %d - %d", blackCount, whiteCount];
    }
    alert = [[UIAlertSheet alloc] initWithTitle: @"Othello" 
                buttons: [NSArray arrayWithObjects: @"OK", nil]
                defaultButtonIndex: 1
                delegate: self
                context: nil];    

            [alert setBodyText: message];
    [alert popupAlertAnimated:YES];
}

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button
{
    [alert dismiss];
    [alert release];
    [board reset];
    [self setNeedsDisplay];
}

- (void) initImages
{

    CFStringRef path;
    CFURLRef url;
    CGDataProviderRef provider;
    NSString *p;

    //Background
    p = [[NSBundle mainBundle] pathForResource: @"Default" ofType: @"png"];

    path = CFStringCreateWithCString(NULL, 
                                [p cStringUsingEncoding: NSASCIIStringEncoding], 
                                kCFStringEncodingUTF8);

    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    provider = CGDataProviderCreateWithURL(url);

    CFRelease(path);
    CFRelease(url);

    backImage = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);

    CGDataProviderRelease(provider);

    //White image
    p = [[NSBundle mainBundle] pathForResource: @"white" ofType: @"png"];
    path = CFStringCreateWithCString(NULL, 
                                [p cStringUsingEncoding: NSASCIIStringEncoding], 
                                kCFStringEncodingUTF8);

    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    provider = CGDataProviderCreateWithURL(url);

    CFRelease(path);
    CFRelease(url);
    whiteImage = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(provider);

    //Black image
    p = [[NSBundle mainBundle] pathForResource: @"black" ofType: @"png"];
    path = CFStringCreateWithCString(NULL, 
                                [p cStringUsingEncoding: NSASCIIStringEncoding], 
                                kCFStringEncodingUTF8);

    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    provider = CGDataProviderCreateWithURL(url);

    CFRelease(path);
    CFRelease(url);
    blackImage = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(provider);
}

- (ZBOthelloBoard *)board
{
    return board;
}

@end
