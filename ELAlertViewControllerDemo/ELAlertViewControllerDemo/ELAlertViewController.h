//
//  ELAlertViewController.h
//  AFNetworking
//
//  Created by 高欣 on 2020/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELAlertAction : NSObject

+ (instancetype)el_actionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(ELAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;

// 可选参数
/**
* 标题颜色 默认#333333
*/
@property (nonatomic,strong) UIColor *textColor;

/**
* 字体大小 默认 15
*/
@property (nonatomic,strong) UIFont *textFont;

@end

@interface ELAlertViewController : UIViewController

+ (instancetype)el_alertControllerAlertStyleWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

+ (instancetype)el_alertControllerWithActionSheetStyle;

/**
* item 高度 默认 50
*/
@property (nonatomic,assign) CGFloat itemHeight;

- (void)el_addAction:(ELAlertAction *)action;

@property (nonatomic, readonly) NSArray<ELAlertAction *> *actions;

@end

NS_ASSUME_NONNULL_END
