--测试用


--做一些初始化
init("0", 1);			--指定坐标系，横屏home右
--setDeviceOrient(1);
luaExitIfCall(true);
-- for ipad air 2 :2048×1536

--全局变量

glRunningFlag=true





--放夹子
function action_trap()
	touchDown(9, 1783, 804);
	mSleep(50);
	touchUp(9, 1783, 804);
end

--捡东西,跳,交互
function action_pick()
	touchDown(4, 1956, 1444);
	mSleep(50);
	touchUp(4, 1956, 1444);
end

--普通攻击
function action_hit()
	touchDown(3, 1833, 1327);
	mSleep(60);
	touchUp(3, 1833, 1327);
end

--喊话
function action_say(thing)
	touchDown(2,1032, 1467);
	mSleep(100);
	touchUp(2, 1032, 1467);
	
	mSleep(1000);
	
	touchDown(2,1032, 1467);
	mSleep(100);
	touchUp(2, 1032, 1467);
	
	mSleep(1000);
	
	inputText(thing.."#ENTER#");
	
	mSleep(1000);
	
end


--判断是否出现对话框
function if_hasdialog()
	keepScreen(true);
	color1=getColor(590, 989);
	color2=getColor(567, 659);
	--sys_log(string.format("color1 is %x",color1));
	--sys_log(string.format("color2 is %x",color2));
	keepScreen(false); 
	if color1==0xb93800 and color2==0xffa022 then
		return "true"
	else
		return "false"
	end
end

--如果出现对话框，关闭之
function clear_dia()
	if if_hasdialog()=="true" then
	end
end


--日志
function sys_log(msg)
	nLog("[DATE] "..msg);
	print("[DATE] "..msg);
end

--显示主对话框
function show_dialog()
	local sz = require("sz")
	local json = sz.json
	MyTable = {
		["style"] = "default",
		["width"] = 600,
		["height"] = 600,
		["orient"] = 1,
		["config"] = "save_001.dat",
		["timer"] = 30,
		["title"] = "功能模式",
		views = {
			{
				["type"] = "RadioGroup",
				["list"] = "方式1: 只捡东西,方式2: 捡东西+放夹子,方式3: 捡东西+攻击,自动喊话",
				["select"] = "1",
			},
			{
                ["type"] = "Edit",
                ["prompt"] = "喊话内容",
                ["text"] = "100 1346 s45 弓求组",
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
			sys_log("take1");
		end
	end

	if type=="2" then
		while glRunningFlag do
			action_pick();
			mSleep(1000);
			action_hit();
			mSleep(3000);
			sys_log("take2");
		end
	end

	if type=="3" then
		while glRunningFlag do
			action_say(extra);
			mSleep(58000);
			sys_log("take3");
		end
	end
	
	toast("挂机终止!",1)

end

function main()
	sys_log(if_hasdialog());


	ret, worktype, extra= show_dialog();
	if ret==1 then
		--根据不同的动作，执行
		--contral_thread(); 先不搞多线程了，有坑
		dowork(worktype,extra);
	end

	sys_log(ret..worktype);
--	while true do
--		sys_log("log");
--		mSleep(1000);
--	end
end



main();