//
//  ViewController.m
//  WXRuler
//
//  Created by wxj on 2017/8/25.
//  Copyright © 2017年 wxj. All rights reserved.
//

#import "ViewController.h"
#import "WXScrollRulerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel * showLabel = [[UILabel alloc] init];
    showLabel.frame = CGRectMake((self.view.bounds.size.width - 120)/2.0, 100, 120, 24);
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.font = [UIFont systemFontOfSize:16.0];
    showLabel.textColor = [UIColor brownColor];
    showLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showLabel];
    
    WXScrollRulerView * aview = [[WXScrollRulerView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 70) minValue:30 maxValue:180 initialValue:200];
    aview.rulerColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    aview.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:aview];
    
    aview.currentValueChanged = ^(float value) {
        
        showLabel.text = [NSString stringWithFormat:@"%d",(int)value];
    };
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
