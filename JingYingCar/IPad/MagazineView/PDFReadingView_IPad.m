//
//  PDFReadingView_IPad.m
//  JingYingCar
//
//  Created by JiaMing Yan on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PDFReadingView_IPad.h"
#import "SqlManager.h"

@implementation PDFReadingView_IPad

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pdfAddress:(NSString *)str_address
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
        self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
        pdfAddress = str_address;
        NSURL *url_pdf = [[NSURL alloc] initFileURLWithPath:pdfAddress];
        pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url_pdf);
        //CFRelease((__bridge CFURLRef)url_pdf);
        currentPage = 1;
        pageCount = CGPDFDocumentGetNumberOfPages(pdf);
        arr_pdfImages = [[NSMutableArray alloc] init];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
	// PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
	// before we start drawing.
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	// Grab the first PDF page
	CGPDFPageRef page = CGPDFDocumentGetPage(pdf, currentPage);
	// We're about to modify the context CTM to draw the PDF page where we want it, so save the graphics state in case we want to do more drawing
	CGContextSaveGState(context);
	// CGPDFPageGetDrawingTransform provides an easy way to get the transform for a PDF page. It will scale down to fit, including any
	// base rotations necessary to display the PDF page correctly. 
	CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
	// And apply the transform.
	CGContextConcatCTM(context, pdfTransform);
	// Finally, we draw the page and restore the graphics state for further manipulations!
    CGContextDrawPDFPage(context, page);
    
	CGContextRestoreGState(context);
    
    for (int i = 1; i <= pageCount; i++) {
        CGPDFPageRef page = CGPDFDocumentGetPage(pdf, i);
        CGRect pdfcropBox = CGRectIntegral(CGPDFPageGetBoxRect(page, kCGPDFCropBox));
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL,self.bounds.size.width,
                                                     self.bounds.size.height,
                                                     8,
                                                     (int)self.bounds.size.width * 4,
                                                     colorSpace, 
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        CGColorSpaceRelease(colorSpace);
        colorSpace = nil;
        
        CGPDFPageRetain(page);
        CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page,
                                                                      kCGPDFCropBox,
                                                                      CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height),
                                                                      0, true);
        CGContextSaveGState(context);
        CGContextConcatCTM(context, pdfTransform);
        CGContextDrawPDFPage(context, page);
        CGPDFPageRelease (page);
        page = nil;
        CGContextRestoreGState(context);    
        CGImageRef image = CGBitmapContextCreateImage(context);
        UIImage *backgroundImage =  [UIImage imageWithCGImage:image];
        CGContextClearRect(context, self.bounds);
        CGContextClearRect(context, pdfcropBox);
        
        CGContextRelease(context);
        CGImageRelease(image);
        context = nil; 
        [arr_pdfImages addObject:backgroundImage];
        NSString *str_fileName = [NSString stringWithFormat:@"test%d.png",i];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *str_address = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/Magazine/%@",str_fileName]];
        if ([[SqlManager sharedManager] saveDoc:UIImagePNGRepresentation(backgroundImage) address:str_address] == YES) {
        }
    }
}

-(void)turnToNextPage
{
    if (currentPage < pageCount) {
        currentPage ++;
        [self setNeedsDisplay];
    }
}

-(void)turnToLastPage
{
    if (currentPage > 1) {
        currentPage --;
        [self setNeedsDisplay];
    }
}

@end
