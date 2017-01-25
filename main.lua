--测试用

init("0", 0);
setDeviceOrient(1);
luaExitIfCall(true);
mSleep(100);



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

	local sz = require("sz")
	local json = sz.json
	w,h = getScreenSize();
	MyTable = {
		["style"]        = "default",
		["rettype"]      = "table",
		["width"]        = h/2,
		["height"]       = w/2,
		["config"]       = "save_01.dat",
		["timer"]        = 99,
		["orient"]       = 1,
		["pagetype"]     = "multi",
		["title"]        = "触动精灵脚本UI演示",
		["cancelname"]   = "取消",
		["okname"]       = "开始",
		pages            =
		{
			{
				{
					["type"] = "Label",
					["text"] = "第一页设置",
					["size"] = 25,
					["align"] = "center",
					["color"] = "0,0,0",
				},
				{
					["id"] = "a01",
					["type"] = "RadioGroup",
					["list"] = "选项1,选项2,选项3,选项4,选项5,选项6,选项7",
					["select"] = "1",
				},
				{
					["type"] = "Label",
					["text"] = "请选择",
					["width"] = 100,
					["nowrap"] = 1,
				},
				{
					["id"] = "year",
					["type"] = "Edit",
					["width"] = 100,
					["prompt"] = "年",
					["text"] = "1900",
					["kbtype"] = "number",
					["nowrap"] = 1,
				},
				{
					["type"] = "Label",
					["text"] = "年",
					["width"] = 30,
					["nowrap"] = 1,
				},
				{
					["id"] = "mon",
					["type"] = "ComboBox",
					["width"] = 130,
					["list"] = "一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月",
					["select"] = "1",
					["nowrap"] = 1,
				},
				{
					["type"] = "Label",
					["text"] = "月",
					["width"] = 30,
					["nowrap"] = 1,
				},
				{
					["id"] = "day",
					["type"] = "ComboBox",
					["width"] = 110,
					["list"] = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31",
					["select"] = "1",
					["nowrap"] = 1,
				},
				{
					["type"] = "Label",
					["text"] = "日",
					["width"] = 30,
				},
				{
					["type"] = "Label",
					["text"] = "请选择性别:",
					["width"] = 170,
					["nowrap"] = 1,
				},
				{
					["id"] = "sex",
					["type"] = "RadioGroup",
					["list"] = "男,女,人妖",
					["select"] = "1",
				},
				},{
				{
					["type"] = "Label",
					["text"] = "第二页设置",
					["size"] = 25,
					["align"] = "center",
					["color"] = "0,0,0",
				},
				{
					["id"] = "edit01",
					["type"] = "Edit",
					["prompt"] = "请输入一个字母",
					["text"] = "默认值",
					["kbtype"] = "ascii",
				},
				{
					["id"] = "edit02",
					["type"] = "Edit",
					["prompt"] = "请输入一个数字",
					["text"] = "默认值",
					["kbtype"] = "number",
				},
				{
					["type"] = "Label",
					["text"] = "请选择兵种",
					["size"] = 25,
					["align"] = "center",
					["color"] = "0,0,0",
				},
				{
					["id"] = "arm",
					["type"] = "CheckBoxGroup",
					["list"] = "兵种1,兵种2,兵种3,兵种4,兵种5,兵种6,兵种7,兵种8,兵种9,兵种10,兵种11,兵种12",
					["images"] = "a.png,b.png,c.png,d.png,e.png,f.png,g.png,h.png,i.png,j.png,k.png,l.png",
					["select"] = "3@5",
					["scale"] = 0.4,
				},
				},{
				{
					["type"] = "Label",
					["text"] = "第三页设置",
					["size"] = 25,
					["align"] = "center",
					["color"] = "0,0,0",
				},
				{
					["id"] = "a02",
					["type"] = "CheckBoxGroup",
					["list"] = "选项1,选项2,选项3,选项4,选项5,选项6,选项7",
					["select"] = "3@5",
				},
				{
					["id"] = "cb01",
					["type"] = "ComboBox",
					["list"] = "选项1,选项2,选项3",
					["select"] = "1",
					["data"] = "子选项1,子选项2,子选项3,子选项4#子选项5,子选项6,子选项7#子选项8,子选项9",
					["source"] = "test"
				},
				{
					["id"] = "cb02",
					["type"] = "ComboBox",
					["select"] = "1",
					["dataSource"] = "test"
				},
			}
		}   
	}
	local MyJsonString = json.encode(MyTable);
	UIret,values = showUI(MyJsonString)
	if UIret == 1 then
		nLog("年:"..values.year)
		nLog("月:"..values.mon)
		nLog("日:"..values.day)
	end
end



main();