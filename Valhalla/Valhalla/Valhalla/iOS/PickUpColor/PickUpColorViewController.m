//
//  PickUpColorViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/19.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "PickUpColorViewController.h"

@interface PickUpColorViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PickUpColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"Valhalla"];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    self.imageView.center = self.view.center;
    self.imageView.image = image;
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    tapGR.numberOfTouchesRequired = 1;
    tapGR.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapGR];
    self.imageView.userInteractionEnabled = YES;
}

- (void)tapGRAction:(UIGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateEnded) {
        CGPoint touchLocation = [gr locationInView:self.imageView];
        
        int alpha = 0, red = 0, green = 0, blue = 0;
        [self getColorWithPoint:touchLocation alpha:alpha red:red green:green blue:blue];
    }
}

- (void)getColorWithPoint:(CGPoint)point alpha:(int *)alpha red:(int *)red green:(int *)green blue:(int *)blue {
    if (alpha == NULL || red == NULL || green == NULL || blue == NULL) {
        return;
    }
    CGImageRef inImage = self.imageView.image.CGImage;
    point = CGPointMake(point.x * self.imageView.image.scale, point.y * self.imageView.image.scale);
    CGContextRef context = [self createARGBBitmapContextFromImage:inImage];
    if (context == NULL) {
        return;
    }
    
    size_t wide = CGImageGetWidth(inImage);
    size_t high = CGImageGetHeight(inImage);
    
    CGRect rect = {{0, 0}, {wide, high}};
    
    CGContextDrawImage(context, rect, inImage);
    
    unsigned char * data = CGBitmapContextGetData(context);
    if (data != NULL) {
        @try {
            int offset = 4 * ((wide * round(point.y)) + round(point.x));
            *alpha = data[offset];
            *red = data[offset + 1];
            *green = data[offset + 2];
            *blue = data[offset + 3];
        } @catch (NSException *exception) {
            NSLog(@"%@", [exception reason]);
        } @finally {
            
        }
    }
    CGContextRelease(context);
    if (data) {
        free(data);
    }
}

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc(bitmapByteCount);
    if (bitmapData == NULL) {
        fprintf(stderr, "Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    context = CGBitmapContextCreate(bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedFirst);
    
    if (context == NULL) {
        free(bitmapData);
        fprintf(stderr, "Context not created!");
    }
    
    CGColorSpaceRelease(colorSpace);
    return context;
}

@end
