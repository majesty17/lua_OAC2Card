--测试用

init("0", 0);
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
	color=getColor(547, 590);
	sys_log(string.format("%x",color));
	keepScreen(false); 
end

--日志
function sys_log(msg)
	nLog("[DATE] "..msg);
end

function main()
	if_hasdialog();
end



main();