-- name    ac2辅助
-- author  Etrom
-- date    2017/2/8
-- info    for ipad air 2 :2048×1536

require "TSLib"

--做一些初始化
init("0", 1);			--指定坐标系，横屏home右
--setDeviceOrient(1);
luaExitIfCall(true);

--全局变量
glRunningFlag=true



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

--如果出现对话框，关闭之
function action_close_dia()
	tap(748,941);
end

--zone2:状态判断

--zone3:系统杂项

--日志
function sys_log(msg)
	nLog("[DATE] "..msg);
	print("[DATE] "..msg);
end

--zone4:主对话框

--显示主对话框
function show_dialog()
	local sz = require("sz")
	local json = sz.json
	MyTable = {
		["style"] = "default",
		["width"] = 640,
		["height"] = 650,
		["orient"] = 1,
		["config"] = "save_oac2helper.dat",
		["timer"] = 99,
		["title"] = "OAC2辅助 - by Etrom",
		views = {
			{
				["type"] = "RadioGroup",
				["list"] = 	"卡牌挂机方式1: 只捡东西                             ,"..
							"卡牌挂机方式2: 捡东西+放夹子                        ,"..
							"卡牌挂机方式3: 捡东西+普通攻击                      ,"..
							"操作1: 自动世界喊话                                 ",
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
				["width"] = 400,
                ["kbtype"] = "default",
            },
		}
	}
	local MyJsonString = json.encode(MyTable);
	return showUI(MyJsonString);
end

--建立线程，控制停止（废弃）
function contral_thread()
	local thread = require('thread')
	--处理协程的错误
	local thread_id = thread.create(function()

			fwShowWnd("wida",300,300,500,500,1)
			fwShowButton("wida","vid","停止挂机","FFFFFF","FF0000","",15,0,0,180,100)
			while (true) do
				local vid = fwGetPressedButton()
				if vid == "vid" then
					glRunningFlag=false; --停止主线程
					break;
				end
			end
			return 100
		end,{
			callBack = function()
				--协程结束会调用，不论是错误、异常、正常结束
				toast("协程结束了", 1);
			end,
			errorBack = function(err)
				--协程错误结束，一般是引用空调用,err是字符串
				toast("协程错误了:"..err,1);
			end,
			catchBack = function(exp)
				--协程异常结束,异常是脚本调用了throw激发的,exp是table，exp.message是异常原因
				local sz = require('sz')
				local json = sz.json
				toast("协程异常了\n"..json.encode(exp),1);
			end
		})
end


--真正开始做动作了
function dowork(type,extra)
	toast("开始挂机，挂机模式:"..type,1);
	glRunningFlag=true;
	if type=="0" then
		while glRunningFlag do
			action_pick();
			sys_log("take0");
			mSleep(5000);
			action_close_dia();
			sys_log("take0");
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
			sys_log("take1");
		end
	end

	if type=="2" then
		while glRunningFlag do
			action_pick();
			mSleep(1000);
			action_hit();
			mSleep(3000);
			action_close_dia();
			sys_log("take2");
		end
	end

	if type=="3" then
		--喊话
		while glRunningFlag do
			action_say(extra);
			mSleep(58000);
			sys_log("take3");
		end
	end
	if type=="?" then
		--
	end
	toast("挂机终止!",1)

end


--zone5:main

function main()
	
	--弹出主程序面板
	ret, worktype, extra= show_dialog();
	sys_log(ret..worktype..extra);
	if ret==1 then
		--根据不同的动作，执行
		--contral_thread(); 先不搞多线程了，有坑
		dowork(worktype,extra);
	end

end



main();