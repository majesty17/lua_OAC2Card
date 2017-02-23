-- name    ac2辅助
-- author  Etrom
-- date    2017/2/14
-- info    for ipad air 2 :2048×1536

require "TSLib"

--做一些初始化
init("0", 1);			--指定坐标系，横屏home右
--setDeviceOrient(1);
luaExitIfCall(true);

--全局变量
glRunningFlag=true;
glLastClearBagTime=0;



--zone1:动作定义

--放夹子
function action_trap()
	tap(1783, 804);
end

--捡东西,跳,交互
function action_pick()
	tap(1956, 1444);
end

--普通攻击
function action_hit()
	tap(1833, 1327);
end

--喊话
function action_say(thing)
	tap(1032, 1467,100);
	mSleep(1000);
	tap(1032, 1467,100);
	mSleep(1000);
	inputText(thing.."#ENTER#");
	mSleep(1000);
end

--清理包裹
function action_clean_bag()
	
	now=os.time();
	if (now-glLastClearBagTime)<3600 then
		sys_log("当前时间差: "..(now-glLastClearBagTime)..", 未到清理时间。");
		return
	end
	
	--更新清理时间
	glLastClearBagTime=now;
	
	-- 打开主配置
	tap(44,797);
	mSleep(500);
	-- 打开背包
	tap(355,661);
	mSleep(500);
	-- 打开背包-装备
	tap(229,472);
	mSleep(1000);
	sys_log("进入背包，开始清理中...")
	-- 逐个删除
	i=0;
	while (true) do
		--拿到第一个格子的颜色，
		if multiColor({
					{  397,  503, 0xddddda},
					{  357,  547, 0xc4c5bd},
					{  393,  453, 0xced6d5},
					{  337,  501, 0xc8c9c4},
					{  396,  555, 0xd2d2cd},
					{  441,  507, 0xcacac5}
				}) == true then
			break;
		end
		
		-- 点第一个，搜索删除图标，点击
		tap(397,508);
		mSleep(200);
		tap(1528,436);
		mSleep(200);
		tap(1304,945);
		mSleep(2000);
		i=i+1;
		if i>40 then
			break
		end
		
	end
	
	--返回两次
	tap(76,61);
	mSleep(500);
	tap(76,61);
	mSleep(500);
	sys_log("背包清理完毕。");
end

--去花园躲一躲(todo)
function action_hide_in_garden()
	-- 进去
	-- 等一段时间
	--出来
end

--自动加血
function action_add_blood()
	if getColor(56,   72) ~= 0x69ff67 then 
        sys_log("开始加血！");
        tap(1956,639);
	end	
end


--如果出现对话框，关闭之
function action_close_dia()
	tap(748,941);
end

--zone2:状态判断

--zone3:系统杂项

--日志
function sys_log(msg)
	nLog("[DATE] "..msg)
	toast("[DATE] "..msg,1)
end

--zone4:主对话框

--显示主对话框
function show_dialog()
	local sz = require("sz")
	local json = sz.json
	MyTable = {
		["style"] = "default",
		["width"] = 690,
		["height"] = 790,
		["orient"] = 1,
		["config"] = "save_oac2helper.dat",
		["timer"] = 99,
		["title"] = "OAC2辅助 - by Etrom",
		views = {
			{
				["type"] = "RadioGroup",
				["list"] = 	"卡牌挂机1: 只捡东西（每5秒捡一次）                  ,"..
							"卡牌挂机2: 捡东西+放夹子（第二排第一个技能）        ,"..
							"卡牌挂机3: 捡东西+普通攻击（可能会跑走）            ,"..
							"操作1: 自动世界喊话                                 ,"..
							"操作2: 清包(no use)",
				["select"] = "1",
			},
			{
                ["type"] = "Label",
                ["text"] = "喊话内容",
				["width"] = 130,
				["nowrap"] = 1,
            },
			{
                ["type"] = "Edit",
                ["prompt"] = "喊话内容",
                ["text"] = "100 1346 s45 弓求组",
				["width"] = 450,
                ["kbtype"] = "default",
            },
			{
                ["type"] = "Label",
                ["text"] = 	"注意：自动清包目前只能清理装备栏的东西，自动进行逐个删除；挂机前请确认装备栏没有重要物品！"..
							"清包周期为1小时",
				["width"] = 625,
				["size"] = 14,
            },
		}
	}
	local MyJsonString = json.encode(MyTable);
	return showUI(MyJsonString);
end



--真正开始做动作了
function dowork(type,extra)
	sys_log("开始挂机，挂机模式:"..type);
	glRunningFlag=true;
	if type=="0" then
		while glRunningFlag do
			action_pick();
			mSleep(5000);
			action_close_dia();
			action_add_blood();
			action_clean_bag();
		end
	end
	if type=="1" then
		while glRunningFlag do
			action_trap();
			mSleep(3000);
			action_pick();
			mSleep(4000);
			action_pick();
			mSleep(4000);
			action_pick();
			mSleep(1500);
			action_close_dia();
			action_add_blood();
			action_clean_bag();
		end
	end

	if type=="2" then
		while glRunningFlag do
			action_pick();
			mSleep(1500);
			action_hit();
			mSleep(4000);
			action_close_dia();
			action_add_blood();
			action_clean_bag();
		end
	end

	if type=="3" then
		--喊话
		while glRunningFlag do
			action_say(extra);
			mSleep(58000);
		end
	end
	if type=="?" then
		--
	end
	sys_log("挂机终止!")

end


--zone5:main

function main()
	--测试区
	--action_clean_bag();
	--return;
	--测试区
	
	--弹出主程序面板
	ret, worktype, extra= show_dialog();
	--sys_log("对话框输出: "..ret..worktype..extra);
	if ret==1 then
		--根据不同的动作，执行
		--设定上次清理时间为当前时间
		glLastClearBagTime=os.time();
		dowork(worktype,extra);
	end

end



main();