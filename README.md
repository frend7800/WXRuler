# WXRuler
ruler,尺子，刻度尺

使用

   WXScrollRulerView * aview = [[WXScrollRulerView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 70) minValue:30 maxValue:180 initialValue:200];
   
   aview.rulerColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    aview.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:aview];
    
    aview.currentValueChanged = ^(float value) {   
    
        showLabel.text = [NSString stringWithFormat:@"%d",(int)value];
    };





