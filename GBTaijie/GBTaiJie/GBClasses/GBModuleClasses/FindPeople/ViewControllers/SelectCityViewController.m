//
//  SelectCityViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/828.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "SelectCityViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GBSearchCompanyViewController.h"
#import "SelectCityCell.h"
#import "CityConst.h"
// ViewModel

@interface SelectCityViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *currentCity; // 城市
@property (nonatomic, copy) NSString *strLatitude; // 经度
@property (nonatomic, copy) NSString *strLongitude; // 维度

@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic, strong) NSMutableArray *hotCities;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    
    [self setupSubViews];
    
    [self locateMap];
    
    [self loadRegion];
}

- (void)doBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 点击当前定位城市 */
- (IBAction)locationBtnClick:(id)sender {
    if (!_currentCity || [_currentCity isEqualToString:@""] || [_currentCity isEqualToString:@"无法定位当前城市"]) {
        [_locationManager startUpdatingLocation];
    } else {
        GBFindPeopleViewModel *findPeopleVM = [[GBFindPeopleViewModel alloc] init];
        [findPeopleVM loadRequestCityCode:_currentCity];
        [findPeopleVM setSuccessReturnBlock:^(id returnValue) {
            CityModel *city = [CityModel mj_objectWithKeyValues:returnValue];
            self.cityBlock(city);
            [self.navigationController popViewControllerAnimated:YES];
            //            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

/** 获取地区列表 */
- (void)loadRegion {
    GBFindPeopleViewModel *findPeopleVM = [[GBFindPeopleViewModel alloc] init];
    [findPeopleVM loadRequestCityRegion:self.isPersonal];
    @GBWeakObj(self);
    [findPeopleVM setSuccessReturnBlock:^(id returnValue) {
    @GBStrongObj(self);
//        NSArray *cityArr = [CityModel mj_objectArrayWithKeyValuesArray:[returnValue objectForKey:@"cities"]];
        self.cities = [CityModel mj_objectArrayWithKeyValuesArray:[returnValue objectForKey:@"cities"]];
        self.hotCities = [CityModel mj_objectArrayWithKeyValuesArray:[returnValue objectForKey:@"hotCities"]];

//        [self.cities removeAllObjects];
//        [self.hotCities removeAllObjects];
//        
//        for (CityModel *city in cityArr) {
//            if ([city.isHot integerValue] == 1) {
//                [self.hotCities addObject:city];
//            } else {
//                [self.cities addObject:city];
//            }
//        }
        
        self.dataArray = [self changeToDataArrayWithCities:self.cities andHotCities:self.hotCities];
        [self.baseTableView reloadData];
    }];
}

- (void)setupSubViews {
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 111);
    self.baseTableView.tableHeaderView = self.tableHeaderView;
    [self.baseTableView registerClass:[SelectCityCell class] forCellReuseIdentifier:@"selectCityCell"];
    self.baseTableView.backgroundColor = [UIColor clearColor];

    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 28;
    self.baseTableView.sectionFooterHeight = 28;
    [self.view addSubview:self.baseTableView];
    self.baseTableView.sectionIndexColor = UIColorFromRGB(0x383F42); //设置默认时索引值颜色
    
    self.baseTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor]; //设置选中时，索引背景颜色
    self.baseTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    if (@available(iOS 11.0, *)) {
        self.baseTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}

- (void)locateMap {
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        _currentCity = [[NSString alloc]init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}

- (IBAction)searchCityBtnClick:(id)sender {
    GBSearchCompanyViewController *scVC = [[GBSearchCompanyViewController alloc] init];
    scVC.index = 2;

    scVC.cityBlock = ^(CityModel *city) {
        self.cityBlock(city);
        [self.navigationController popViewControllerAnimated:NO];
    };
    [self.navigationController pushViewController:scVC animated:YES];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    return [self calculateHeightWithArray:array];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCityCell"];
    
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    cell.cityArray = array;
    cell.backgroundColor = [UIColor kBaseBackgroundColor];
    @GBWeakObj(self);
    cell.cityBlock = ^(CityModel *city) {
    @GBStrongObj(self);
        NSLog(@"city.regionName = %@", city.regionName);
        self.cityBlock(city);
        [self.navigationController popViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //自定义Header标题
    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 32)];
    myView.backgroundColor = RGBA(242, 245, 250, 1);
    
    
    NSString *title = self.dataArray[section][@"firstLetter"];
    
    if ([title isEqualToString:@"热"]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 7, 118, 18)];
        titleLabel.textColor = UIColorFromRGB(0x96ABB5);
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"热门城市";
        [myView addSubview:titleLabel];
    } else {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 7, 18, 18)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.layer.cornerRadius = 9;
        titleLabel.layer.masksToBounds = YES;
        titleLabel.backgroundColor = [UIColor kBaseColor];
        titleLabel.text = title;
        [myView addSubview:titleLabel];
    }
    
    return myView;
}


#pragma mark---tableView索引相关设置----
//添加TableView头视图标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataArray[section];
    NSString *title = dict[@"firstLetter"];
    return title;
}


//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *resultArray =[NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (NSDictionary *dict in self.dataArray) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
}


//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        return NSNotFound;
    }
    else
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
    }
}

#pragma mark - 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingURL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当前的经纬度
    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
//    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
//    if (locationAge > 1.0){//如果调用已经一次，不再执行
//        return;
//    }
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            if (!self.currentCity) {
                self.currentCity = @"无法定位当前城市";
            }
            self.locationResultL.text = self.currentCity;
            
            //看需求定义一个全局变量来接收赋值
            NSLog(@"当前国家 - %@",placeMark.country);//当前国家
            NSLog(@"当前城市 - %@",self.currentCity);//当前城市
            NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
            NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
            NSLog(@"具体地址 - %@",placeMark.name);//具体地址
            
        }else if (error == nil && placemarks.count){
            
            NSLog(@"NO location and error return");
        }else if (error){
            
            NSLog(@"loction error:%@",error);
        }
    }];
}

- (NSMutableArray *)cities {
    if (!_cities) {
        _cities = [NSMutableArray array];
    }
    return _cities;
}

- (NSMutableArray *)hotCities {
    if (!_hotCities) {
        _hotCities = [NSMutableArray array];
    }
    return _hotCities;
}


- (NSMutableArray *)changeToDataArrayWithCities:(NSMutableArray *)cities andHotCities:(NSMutableArray *)hotCities {
    
    if (![cities count]) {
        return [NSMutableArray array];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSMutableArray array] forKey:@"#"];
    for (int i = 'A'; i <= 'Z'; i++) {
        [dict setObject:[NSMutableArray array]
                 forKey:[NSString stringWithUTF8String:(const char *)&i]];
    }
    
    for (CityModel *city in cities) {
        NSString *firstLetter = [self getFirstLetterWithName:city.regionName];
        NSMutableArray *array = dict[firstLetter];
        [array addObject:city];
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    
    if (hotCities.count > 0) {
        NSDictionary *hotDict = @{@"firstLetter": @"热",
                                  @"content": hotCities};
        [resultArray addObject:hotDict];
    }
    
    for (int i = 'A'; i <= 'Z'; i++) {
        NSString *firstLetter = [NSString stringWithUTF8String:(const char *)&i];
        NSMutableArray *array = dict[firstLetter];
        if ([array count]) {
            NSDictionary *resultDict = @{@"firstLetter": firstLetter,
                                         @"content": array};
            [resultArray addObject:resultDict];
        }
    }
    return resultArray;
}


- (NSString *)getFirstLetterWithName:(NSString *)name {
    NSString *words = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (words.length == 0) {
        return nil;
    }
    NSString *result = nil;
    unichar firstLetter = [words characterAtIndex:0];
    
    int index = firstLetter - HANZI_START;
    if (index >= 0 && index <= HANZI_COUNT) {
        result = [NSString stringWithFormat:@"%c", firstLetterArray[index]];
    } else if ((firstLetter >= 'a' && firstLetter <= 'z')
               || (firstLetter >= 'A' && firstLetter <= 'Z')) {
        result = [NSString stringWithFormat:@"%c", firstLetter];
    } else {
        result = @"#";
    }
    return [result uppercaseString];
}

- (CGFloat)calculateHeightWithArray:(NSArray *)cityArray {
    NSInteger rows = (cityArray.count - 1) / 4 + 1;
    return rows * 27 + (rows - 1) * 15;
}

@end
