//
//  FoundViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/5.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "FoundViewController.h"
#import "FoundTableViewCell.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "CCLocationManager.h"
#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define corner_radius 14
@interface FoundViewController ()
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@end

@implementation FoundViewController
{
    UIView * Weather;
    NSArray * LinkArray1;
    NSArray * LinkArray2;
    NSArray * LinkArray3;
    NSArray * LinkArray4;
    CLGeocoder *geoCoder;
    NSString *cityIds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"发现"];
    
    cityIds = @"北京:101010100朝阳:101010300顺义:101010400怀柔:101010500通州:101010600昌平:101010700延庆:101010800丰台:101010900石景山:101011000大兴:101011100房山:101011200密云:101011300门头沟:101011400平谷:101011500八达岭:101011600佛爷顶:101011700汤河口:101011800密云上甸子:101011900斋堂:101012000霞云岭:101012100北京城区:101012200海淀:101010200天津:101030100宝坻:101030300东丽:101030400西青:101030500北辰:101030600蓟县:101031400汉沽:101030800静海:101030900津南:101031000塘沽:101031100大港:101031200武清:101030200宁河:101030700上海:101020100宝山:101020300嘉定:101020500南汇:101020600浦东:101021300青浦:101020800松江:101020900奉贤:101021000崇明:101021100徐家汇:101021200闵行:101020200金山:101020700石家庄:101090101张家口:101090301承德:101090402唐山:101090501秦皇岛:101091101沧州:101090701衡水:101090801邢台:101090901邯郸:101091001保定:101090201廊坊:101090601郑州:101180101新乡:101180301许昌:101180401平顶山:101180501信阳:101180601南阳:101180701开封:101180801洛阳:101180901商丘:101181001焦作:101181101鹤壁:101181201濮阳:101181301周口:101181401漯河:101181501驻马店:101181601三门峡:101181701济源:101181801安阳:101180201合肥:101220101芜湖:101220301淮南:101220401马鞍山:101220501安庆:101220601宿州:101220701阜阳:101220801亳州:101220901黄山:101221001滁州:101221101淮北:101221201铜陵:101221301宣城:101221401六安:101221501巢湖:101221601池州:101221701蚌埠:101220201杭州:101210101舟山:101211101湖州:101210201嘉兴:101210301金华:101210901绍兴:101210501台州:101210601温州:101210701丽水:101210801衢州:101211001宁波:101210401重庆:101040100合川:101040300南川:101040400江津:101040500万盛:101040600渝北:101040700北碚:101040800巴南:101040900长寿:101041000黔江:101041100万州天城:101041200万州龙宝:101041300涪陵:101041400开县:101041500城口:101041600云阳:101041700巫溪:101041800奉节:101041900巫山:101042000潼南:101042100垫江:101042200梁平:101042300忠县:101042400石柱:101042500大足:101042600荣昌:101042700铜梁:101042800璧山:101042900丰都:101043000武隆:101043100彭水:101043200綦江:101043300酉阳:101043400秀山:101043600沙坪坝:101043700永川:101040200福州:101230101泉州:101230501漳州:101230601龙岩:101230701晋江:101230509南平:101230901厦门:101230201宁德:101230301莆田:101230401三明:101230801兰州:101160101平凉:101160301庆阳:101160401武威:101160501金昌:101160601嘉峪关:101161401酒泉:101160801天水:101160901武都:101161001临夏:101161101合作:101161201白银:101161301定西:101160201张掖:101160701广州:101280101惠州:101280301梅州:101280401汕头:101280501深圳:101280601珠海:101280701佛山:101280800肇庆:101280901湛江:101281001江门:101281101河源:101281201清远:101281301云浮:101281401潮州:101281501东莞:101281601中山:101281701阳江:101281801揭阳:101281901茂名:101282001汕尾:101282101韶关:101280201南宁:101300101柳州:101300301来宾:101300401桂林:101300501梧州:101300601防城港:101301401贵港:101300801玉林:101300901百色:101301001钦州:101301101河池:101301201北海:101301301崇左:101300201贺州:101300701贵阳:101260101安顺:101260301都匀:101260401兴义:101260906铜仁:101260601毕节:101260701六盘水:101260801遵义:101260201凯里:101260501昆明:101290101红河:101290301文山:101290601玉溪:101290701楚雄:101290801普洱:101290901昭通:101291001临沧:101291101怒江:101291201香格里拉:101291301丽江:101291401德宏:101291501景洪:101291601大理:101290201曲靖:101290401保山:101290501呼和浩特:101080101乌海:101080301集宁:101080401通辽:101080501阿拉善左旗:101081201鄂尔多斯:101080701临河:101080801锡林浩特:101080901呼伦贝尔:101081000乌兰浩特:101081101包头:101080201赤峰:101080601南昌:101240101上饶:101240301抚州:101240401宜春:101240501鹰潭:101241101赣州:101240701景德镇:101240801萍乡:101240901新余:101241001九江:101240201吉安:101240601武汉:101200101黄冈:101200501荆州:101200801宜昌:101200901恩施:101201001十堰:101201101神农架:101201201随州:101201301荆门:101201401天门:101201501仙桃:101201601潜江:101201701襄樊:101200201鄂州:101200301孝感:101200401黄石:101200601咸宁:101200701成都:101270101自贡:101270301绵阳:101270401南充:101270501达州:101270601遂宁:101270701广安:101270801巴中:101270901泸州:101271001宜宾:101271101内江:101271201资阳:101271301乐山:101271401眉山:101271501凉山:101271601雅安:101271701甘孜:101271801阿坝:101271901德阳:101272001广元:101272101攀枝花:101270201银川:101170101中卫:101170501固原:101170401石嘴山:101170201吴忠:101170301西宁:101150101黄南:101150301海北:101150801果洛:101150501玉树:101150601海西:101150701海东:101150201海南:101150401济南:101120101潍坊:101120601临沂:101120901菏泽:101121001滨州:101121101东营:101121201威海:101121301枣庄:101121401日照:101121501莱芜:101121601聊城:101121701青岛:101120201淄博:101120301德州:101120401烟台:101120501济宁:101120701泰安:101120801西安:101110101延安:101110300榆林:101110401铜川:101111001商洛:101110601安康:101110701汉中:101110801宝鸡:101110901咸阳:101110200渭南:101110501太原:101100101临汾:101100701运城:101100801朔州:101100901忻州:101101001长治:101100501大同:101100201阳泉:101100301晋中:101100401晋城:101100601吕梁:101101100乌鲁木齐:101130101石河子:101130301昌吉:101130401吐鲁番:101130501库尔勒:101130601阿拉尔:101130701阿克苏:101130801喀什:101130901伊宁:101131001塔城:101131101哈密:101131201和田:101131301阿勒泰:101131401阿图什:101131501博乐:101131601克拉玛依:101130201拉萨:101140101山南:101140301阿里:101140701昌都:101140501那曲:101140601日喀则:101140201林芝:101140401台北县:101340101高雄:101340201台中:101340401海口:101310101三亚:101310201东方:101310202临高:101310203澄迈:101310204儋州:101310205昌江:101310206白沙:101310207琼中:101310208定安:101310209屯昌:101310210琼海:101310211文昌:101310212保亭:101310214万宁:101310215陵水:101310216西沙:101310217南沙岛:101310220乐东:101310221五指山:101310222琼山:101310102长沙:101250101株洲:101250301衡阳:101250401郴州:101250501常德:101250601益阳:101250700娄底:101250801邵阳:101250901岳阳:101251001张家界:101251101怀化:101251201黔阳:101251301永州:101251401吉首:101251501湘潭:101250201南京:101190101镇江:101190301苏州:101190401南通:101190501扬州:101190601宿迁:101191301徐州:101190801淮安:101190901连云港:101191001常州:101191101泰州:101191201无锡:101190201盐城:101190701哈尔滨:101050101牡丹江:101050301佳木斯:101050401绥化:101050501黑河:101050601双鸭山:101051301伊春:101050801大庆:101050901七台河:101051002鸡西:101051101鹤岗:101051201齐齐哈尔:101050201大兴安岭:101050701长春:101060101延吉:101060301四平:101060401白山:101060901白城:101060601辽源:101060701松原:101060801吉林:101060201通化:101060501沈阳:101070101鞍山:101070301抚顺:101070401本溪:101070501丹东:101070601葫芦岛:101071401营口:101070801阜新:101070901辽阳:101071001铁岭:101071101朝阳:101071201盘锦:101071301大连:101070201锦州:101070701 ";
    
    LinkArray1=[NSArray arrayWithObjects:@"http://www.baidu.com",@"http://www.sina.com.cn/",@"http://www.sohu.com/",@"http://www.qq.com/",@"http://www.ifeng.com/",nil];
    LinkArray2=[NSArray arrayWithObjects:@"http://www.taobao.com",@"http://www.jd.com/",@"http://www.tmall.com/",@"http://www.yhd.com/",@"http://www.vip.com/",nil];
    LinkArray3=[NSArray arrayWithObjects:@"http://www.ganji.com",@"http://www.youyuan.com/",@"http://tv.sohu.com/",@"http://ios.d.cn/",@"http://www.qidian.com/Default.aspx",nil];
    LinkArray4=[NSArray arrayWithObjects:@"http://www.qunar.com/",@"http://www.12306.cn/mormhweb/",@"http://www.ip138.com/weizhang.htm",@"http://www.kuaidi100.com/",@"http://baidu.lecai.com/",nil];
    
    
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        CLLocation *c = [[CLLocation alloc] initWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
        //创建位置
        CLGeocoder *revGeo = [[CLGeocoder alloc] init];
        [revGeo reverseGeocodeLocation:c
         //反向地理编码
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if (!error && [placemarks count] > 0)
                         {
                             NSDictionary *dict =
                             [[placemarks objectAtIndex:0] addressDictionary]; NSLog(@"street address: %@",
                                                                                     //记录地址
                                                                                     [dict objectForKey:@"City"]);
                             
                             DataProvider * dataprovider =[[DataProvider alloc] init];
                             [dataprovider setDelegateObject:self setBackFunctionName:@"GetWeatherCallBack:"];
                             [dataprovider GetWeather:[self GetCityID:[[dict objectForKey:@"City"] stringByReplacingOccurrencesOfString:@"市" withString:@""]]];
                             
                         }
                         else
                         {
                             NSLog(@"ERROR: %@", error); }
                     }];
    }];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    
    Weather =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+25, SCREEN_WIDTH, 60)];
    Weather.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];;
    [self.view addSubview:Weather];
    
    UITableView *foundTable=[[UITableView alloc] initWithFrame:CGRectMake(0, Weather.frame.origin.y+Weather.frame.size.height+5, SCREEN_WIDTH, SCREEN_HEIGHT-49-120)];
    foundTable.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    foundTable.delegate=self;
    foundTable.dataSource=self;
    [self.view addSubview:foundTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"foundCellIdentifier";
    FoundTableViewCell *cell = (FoundTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"FoundTableViewCell" owner:self options:nil] lastObject];
        cell.layer.masksToBounds=YES;
        cell.bounds=CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
        switch (indexPath.section) {
            case 0:
                cell.GroupTitle.text=@"资讯";
                cell.img_1.image=[UIImage imageNamed:@"baidu_icon"];
                cell.img_1.layer.masksToBounds =YES;
                
                cell.img_1.layer.cornerRadius =corner_radius;
                
                
                cell.lbl_1.text=@"百度";
                cell.btn_1.tag=10;
                [cell.btn_1 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_2.image=[UIImage imageNamed:@"Image-5"];
                cell.img_2.layer.masksToBounds =YES;
                cell.img_2.layer.cornerRadius =corner_radius;

                cell.lbl_2.text=@"新浪";
                cell.btn_2.tag=11;
                [cell.btn_2 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.image=[UIImage imageNamed:@"Image-6"];
                cell.lbl_3.text=@"搜狐";
                cell.btn_3.tag=12;
                [cell.btn_3 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_4.image=[UIImage imageNamed:@"Image-7"];
                cell.lbl_4.text=@"腾讯";
                cell.btn_4.tag=13;
                [cell.btn_4 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_5.image=[UIImage imageNamed:@"Image-8"];
                cell.lbl_5.text=@"凤凰";
                cell.btn_5.tag=14;
                [cell.btn_5 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.layer.masksToBounds =YES;
                cell.img_3.layer.cornerRadius =corner_radius;

                cell.img_4.layer.masksToBounds =YES;
                cell.img_4.layer.cornerRadius =corner_radius;
                cell.img_5.layer.masksToBounds =YES;
                cell.img_5.layer.cornerRadius =corner_radius;

                break;
            case 1:
                cell.GroupTitle.text=@"购物";
                cell.img_1.image=[UIImage imageNamed:@"taobao.png"];
                cell.img_1.layer.masksToBounds =YES;
                cell.img_1.layer.cornerRadius =corner_radius;
                cell.lbl_1.text=@"淘宝";
                cell.img_2.image=[UIImage imageNamed:@"jingdong.png"];
                cell.img_2.layer.masksToBounds =YES;
                cell.img_2.layer.cornerRadius =corner_radius;

                cell.lbl_2.text=@"京东";
                cell.img_3.image=[UIImage imageNamed:@"tianmao.png"];
                cell.lbl_3.text=@"天猫";
                cell.img_4.image=[UIImage imageNamed:@"yihaodian.png"];
                cell.lbl_4.text=@"1号店";
                cell.img_5.image=[UIImage imageNamed:@"vip.png"];
                cell.lbl_5.text=@"唯品会";
                
                cell.btn_1.tag=20;
                [cell.btn_1 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_2.tag=21;
                [cell.btn_2 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_3.tag=22;
                [cell.btn_3 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_4.tag=23;
                [cell.btn_4 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_5.tag=24;
                [cell.btn_5 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.layer.masksToBounds =YES;
                cell.img_3.layer.cornerRadius =corner_radius;
                
                cell.img_4.layer.masksToBounds =YES;
                cell.img_4.layer.cornerRadius =corner_radius;
                cell.img_5.layer.masksToBounds =YES;
                cell.img_5.layer.cornerRadius =corner_radius;
                break;
            case 2:
                cell.GroupTitle.text=@"生活";
                cell.img_1.image=[UIImage imageNamed:@"ganji.png"];
                cell.img_1.layer.masksToBounds =YES;
                cell.img_1.layer.cornerRadius =corner_radius;

                cell.lbl_1.text=@"赶集";
                cell.img_2.image=[UIImage imageNamed:@"youyuan.png"];
                cell.img_2.layer.masksToBounds =YES;
                cell.img_2.layer.cornerRadius =corner_radius;
                cell.lbl_2.text=@"有缘";
                cell.img_3.image=[UIImage imageNamed:@"souhushipin.png"];
                cell.lbl_3.text=@"搜狐";
                cell.img_4.image=[UIImage imageNamed:@"game.png"];
                cell.lbl_4.text=@"游戏";
                cell.img_5.image=[UIImage imageNamed:@"EBook.png"];
                cell.lbl_5.text=@"电子书";
                
                cell.btn_1.tag=30;
                [cell.btn_1 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_2.tag=31;
                [cell.btn_2 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_3.tag=32;
                [cell.btn_3 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_4.tag=33;
                [cell.btn_4 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_5.tag=34;
                [cell.btn_5 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.layer.masksToBounds =YES;
                cell.img_3.layer.cornerRadius =corner_radius;
                
                cell.img_4.layer.masksToBounds =YES;
                cell.img_4.layer.cornerRadius =corner_radius;
                cell.img_5.layer.masksToBounds =YES;
                cell.img_5.layer.cornerRadius =corner_radius;
                break;
            case 3:
                cell.GroupTitle.text=@"查询";
                cell.img_1.image=[UIImage imageNamed:@"baidu_icon"];
                cell.img_1.layer.masksToBounds =YES;
                cell.img_1.layer.cornerRadius =corner_radius;

                cell.lbl_1.text=@"去哪";
                cell.img_2.image=[UIImage imageNamed:@"huochepiao.png"];
                cell.img_2.layer.masksToBounds =YES;
                cell.img_2.layer.cornerRadius =corner_radius;
                cell.lbl_2.text=@"火车票";
                cell.img_3.image=[UIImage imageNamed:@"qicheweizhang.png"];
                cell.lbl_3.text=@"汽车违章";
                cell.img_4.image=[UIImage imageNamed:@"kuaidi.png"];
                cell.lbl_4.text=@"快递";
                cell.img_5.image=[UIImage imageNamed:@"caipiao.png"];
                cell.lbl_5.text=@"彩票";
                
                cell.btn_1.tag=40;
                [cell.btn_1 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_2.tag=41;
                [cell.btn_2 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_3.tag=42;
                [cell.btn_3 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_4.tag=43;
                [cell.btn_4 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_5.tag=44;
                [cell.btn_5 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.layer.masksToBounds =YES;
                cell.img_3.layer.cornerRadius =corner_radius;
                
                cell.img_4.layer.masksToBounds =YES;
                cell.img_4.layer.cornerRadius =corner_radius;
                cell.img_5.layer.masksToBounds =YES;
                cell.img_5.layer.cornerRadius =corner_radius;
                break;
            default:
                break;
        }
        //        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
    }
    else
    {
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

-(void)BtnInCellClick:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    int temp=sender.tag/10;
    switch (temp) {
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LinkArray1[sender.tag-10]]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LinkArray2[sender.tag-20]]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LinkArray3[sender.tag-30]]];
            break;
        case 4:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LinkArray4[sender.tag-40]]];
            break;
        default:
            break;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]animated:YES];
}

-(void)GetWeatherCallBack:(id)dict
{
    NSLog(@"%@",dict);
    UIView * v_temp=[[UIView alloc] initWithFrame:CGRectMake(10, 3, SCREEN_WIDTH/2, Weather.frame.size.height-6)];
    v_temp.backgroundColor=[UIColor whiteColor];
    UILabel * Temp=[[UILabel alloc] initWithFrame:CGRectMake(10, 00, v_temp.frame.size.width-10, v_temp.frame.size.height)];
    Temp.text=[NSString stringWithFormat:@"%@摄氏度",dict[@"weatherinfo"][@"temp"]];
    Temp.textAlignment=NSTextAlignmentRight;
    [v_temp addSubview:Temp];
    [Weather addSubview:v_temp];
    
    UIView * v_city=[[UIView alloc] initWithFrame:CGRectMake(v_temp.frame.origin.x+v_temp.frame.size.width+1, 3, SCREEN_WIDTH/2, Weather.frame.size.height-6)];
    v_city.backgroundColor=[UIColor whiteColor];
    UILabel *city=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, v_city.frame.size.height/2)];
    city.text=dict[@"weatherinfo"][@"city"];
    [v_city addSubview:city];
    UILabel * weather=[[UILabel alloc] initWithFrame:CGRectMake(0, v_city.frame.size.height/2, 130, v_city.frame.size.height/2)];
    weather.text=[NSString stringWithFormat:@"%@%@",dict[@"weatherinfo"][@"WD"],dict[@"weatherinfo"][@"WS"]];
    [v_city addSubview:weather];
    [Weather addSubview:v_city];
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}


- (void)locationAddressWithLocation:(CLLocation *)locationGps
{
    geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:locationGps completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error) {
             NSLog(@"error: %@",error.description);
         }
         else{
             NSLog(@"placemarks count %lu",(unsigned long)placemarks.count);
             for (CLPlacemark *placeMark in placemarks)
             {
                 NSLog(@"地址name:%@ ",placeMark.name);
                 NSLog(@"地址thoroughfare:%@",placeMark.thoroughfare);
                 NSLog(@"地址subThoroughfare:%@",placeMark.subThoroughfare);
                 NSLog(@"地址locality:%@",placeMark.locality);
                 NSLog(@"地址subLocality:%@",placeMark.subLocality);
                 NSLog(@"地址administrativeArea:%@",placeMark.administrativeArea);
                 NSLog(@"地址subAdministrativeArea:%@",placeMark.subAdministrativeArea);
                 NSLog(@"地址postalCode:%@",placeMark.postalCode);
                 NSLog(@"地址ISOcountryCode:%@",placeMark.ISOcountryCode);
                 NSLog(@"地址country:%@",placeMark.country);
                 NSLog(@"地址inlandWater:%@",placeMark.inlandWater);
                 NSLog(@"地址ocean:%@",placeMark.ocean);
                 NSLog(@"地址areasOfInterest:%@",placeMark.areasOfInterest);
             }
         }
         
     }];
}

-(NSString *)GetCityID:(NSString *)cityName
{
    NSRange range=[cityIds rangeOfString:[NSString stringWithFormat:@"%@:",cityName]];//指定的字符串从左往右匹配（系统默认）。
    NSLog(@"%@",NSStringFromRange(range));
    NSString * stringcityid=[cityIds substringWithRange:NSMakeRange(range.location+3, 9) ];
    NSLog(@"%@",stringcityid);
    return stringcityid;
}


@end
