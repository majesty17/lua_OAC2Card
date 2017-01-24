--测试用

init("0", 0);
setDeviceOrient(1);
luaExitIfCall(true);
mSleep(1000);



--for var = 1,50 do
--    nLog("[DATE]"..var);--在编辑器的日志输入界面查看
--    mSleep(100);
--end

--nLog("GG...");


--放夹子
function action_trap()
	touchDown(9, 732, 1783);
	mSleep(50);
	touchUp(9, 732, 1783);
end

--捡东西,跳,交互
function action_pick()
	touchDown(4, 92, 1956);
	mSleep(50);
	touchUp(4, 92, 1956);
end

--普通攻击
function action_hit()
	touchDown(3, 209, 1833);
	mSleep(60);
	touchUp(3, 209, 1833);
end

--判断是否出现对话框
function if_hasdialog()
	keepScreen(true);
	color1=getColor(547, 590);
	color2=getColor(877, 567);
	--sys_log(string.format("%x",color2));
	keepScreen(false); 

	if color1==0xb93800 and color2==0xffa122 then
		return "true"
	else
		return "false"
	end
end

--日志
function sys_log(msg)
	nLog("[DATE] "..msg);
end

function main()
	sys_log(if_hasdialog());

	action_pick();
	--fakeGPS(87.1478199292, 43.4912963982);
	ret, input_1, input_2, input_3 = showUI("{\"style\":"
		.."\"default\",\"views\":[{\"type\":\"Label\",\"text\":"
		.."\"settings\",\"size\":25,\"align\":\"center\",\"color\":"
		.."\"0,0,255\"},{\"type\":\"RadioGroup\",\"list\":"
		.."\"option1,option2,option3,option4,option5,option6,option7\","
		.."\"select\":\"1\"},{\"type\":\"Edit\",\"prompt\":\"Test\","
		.."\"text\":\"Custom Text\",\"size\":15,\"align\":\"left\","
		.."\"color\":\"255,0,0\"},{\"type\":\"CheckBoxGroup\",\"list\":"
		.."\"option1,option2,option3,option4,option5,option6,option7\","
		.."\"select\":\"3@5\"}]}");
	toast("欢迎使用触动精灵！"); 
end



main();