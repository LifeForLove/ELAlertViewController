# ELAlertViewController
仿系统UIAlertController,可自定义文字颜色，及字体

### 效果图

![image](https://github.com/LifeForLove/ELAlertViewController/blob/master/001.png)
![image](https://github.com/LifeForLove/ELAlertViewController/blob/master/002.png)
![image](https://github.com/LifeForLove/ELAlertViewController/blob/master/003.png)
![image](https://github.com/LifeForLove/ELAlertViewController/blob/master/004.png)

### 使用方法

```
				ELAlertViewController * alert = [ELAlertViewController 				el_alertControllerAlertStyleWithTitle:@"标题" message:@"内容"];
            
            ELAlertAction * action1 = [ELAlertAction el_actionWithTitle:@"title1" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action1");
            }];
            action1.textColor = [UIColor blueColor];
            action1.textFont = [UIFont boldSystemFontOfSize:15];
            
            ELAlertAction * action2 = [ELAlertAction el_actionWithTitle:@"title2" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action2");
            }];
            action2.textColor = [UIColor redColor];
            
            [alert el_addAction:action1];
            [alert el_addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
```


