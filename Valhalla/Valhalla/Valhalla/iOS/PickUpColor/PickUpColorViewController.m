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

@property (nonatomic, strong) UILabel *colorLabel;

@property (nonatomic, strong) UIView *colorView;

@end

@implementation PickUpColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"Valhalla"];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    self.imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
    self.imageView.image = image;
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    tapGR.numberOfTouchesRequired = 1;
    tapGR.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapGR];
    self.imageView.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.plt_y - 70, PltScreenWidth, 50)];
    label.text = NSLocalizedString(@"Plase Touch Image", nil);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    self.colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.plt_maxY + 50, PltScreenWidth, 50)];
    self.colorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.colorLabel];
    
    self.colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.colorView.center = CGPointMake(self.view.center.x, self.colorLabel.plt_maxY + 60);
    self.colorView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.colorView];
}

- (void)tapGRAction:(UIGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateEnded) {
        CGPoint touchLocation = [gr locationInView:self.imageView];
        
        int alpha = 0, red = 0, green = 0, blue = 0;
        [self getColorWithPoint:touchLocation alpha:&alpha red:&red green:&green blue:&blue];
        
        self.colorLabel.text = [NSString stringWithFormat:@"ARGB: %d %d %d %d(%0X%0X%0X%0X)", alpha, red, green, blue, alpha, red, green, blue];
        self.colorView.backgroundColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];
    }
}

- (void)getColorWithPoint:(CGPoint)point alpha:(int *)alpha red:(int *)red green:(int *)green blue:(int *)blue {
    if (alpha == NULL || red == NULL || green == NULL || blue == NULL) {
        return;
    }
    CGImageRef inImage = self.imageView.image.CGImage;
    point = CGPointMake(point.x * self.imageView.image.scale, point.y * self.imageView.image.scale);
    CGContextRef context = [self createARGBBitmapContextFromImage:inImage];
    CFRetain(context);
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
    if (context) {
        CFAutorelease(context);
    }
    return context;
}

@end
