require("import")
import "android.webkit.*"
import "android.view.View"
import "net.fusionapp.core.ui.fragment.WebInterface"
import "com.google.android.material.snackbar.Snackbar"
import "android.webkit.ValueCallback"
import "com.google.android.material.dialog.MaterialAlertDialogBuilder"
import "com.google.android.material.textfield.TextInputEditText"
import "com.google.android.material.textfield.TextInputLayout"
import "android.webkit.ValueCallback"
import "com.google.android.material.snackbar.Snackbar"
import "android.view.View"
import "android.R$id"
import "android.content.Intent"
import "android.net.Uri"
import "java.net.NetworkInterface"
import "java.util.Collections"
import "java.util.Enumeration"
import "java.util.Iterator"
import "android.content.Context"
import "android.content.ClipData"

local clipboard = this.getSystemService(Context.CLIPBOARD_SERVICE)
local function copyToClipboard(str)
  clipboard.setPrimaryClip(ClipData.newPlainText("Message", str))
end
local function getFromClipboard()
  return clipboard.getPrimaryClip().getItemAt(0).getText()
end

local function isVpnConnected()
  local interfaceList = NetworkInterface.getNetworkInterfaces()
  local it = Collections.list(interfaceList).iterator()
  while (it.hasNext())
    local interface = it.next()
    if interface.isUp() and interface.getInterfaceAddresses().size() > 0 then
      if interface.getName() == "tun0" or interface.getName() == "ppp0" then
        return true
      end
    end
  end
  return false
end

-- 读入活动信息列表
local EventTemplate = require("stringjson")
local json = require("dkjson")
EventTemplate = json.decode(EventTemplate)
-- 读入更新日志
local UpdateLog = require("updatelog") 

-- @param data 侧滑栏列表的全部数据
-- @param recyclerView 侧滑栏列表控件
-- @param listIndex 点击的列表索引（点击的是第几个列表）
-- @param clickIndex 点击的项目索引（点击的第几个项目）
function onDrawerListItemClick(data, recyclerView, listIndex, itemIndex)
  --侧滑栏列表的数据是二维结构，所以需要先获取到点击项目所在列表的数据
  local listData = data.get(listIndex);
  --获取到所在列表的数据后获取点击项目的数据
  local itemData = listData.get(itemIndex);
  --最后获取到点击的项目的标题
  local itemTitle = itemData.getTitle();
end

-- @param title 点击的菜单标题
-- @description 顶栏菜单项目点击回调事件
function onMenuItemClick(title)
  if title == "刷新" then
    local uiManager=activity.getUiManager()
    local wv=uiManager.getCurrentFragment().getWebView()
    wv.reload()
  end
  if title == "用浏览器打开" then
    local uiManager=activity.getUiManager()
    local wv=uiManager.getCurrentFragment().getWebView()
    local url=wv.getUrl()
    local viewIntent = Intent("android.intent.action.VIEW", Uri.parse(url))
    activity.startActivity(viewIntent)
  end
end

local uiManager=activity.uiManager
fragment=uiManager.getFragment(0)
fragment.setWebInterface(WebInterface{
  onPageFinished=function(view,url)
    onFloatingActionButtonClick(nil, true)
  end,
  onPageStarted=function(view,url,favicon)
    if url:find("/my") and url:find("booking") then -- http://booking.lib.sjtu.edu.cn/my.asp
      local uiManager=activity.getUiManager()
      local wv=uiManager.getCurrentFragment().getWebView()
      wv.loadUrl("http://booking.lib.sjtu.edu.cn/")
      local viewPager=uiManager.viewPager
      viewPager.setCurrentItem(1)
      wv=uiManager.getFragment(1).getWebView()
      wv.reload()
      return true
    end
    return false
  end,
  onUrlLoad=function(view,url)
  end,
  onReceivedSslError=function(view, sslErrorHandler, sslError)
    return false
  end
})

local fragment=uiManager.getFragment(3)
fragment.setWebInterface(WebInterface{
  onPageFinished=function(view,url)
    onFloatingActionButtonClick(nil, true)
  end,
  onPageStarted=function(view,url,favicon)
    if url:find("/index") and url:find("studyroom") then -- http://studyroom.lib.sjtu.edu.cn/index.asp
      local uiManager=activity.getUiManager()
      local wv=uiManager.getCurrentFragment().getWebView()
      wv.loadUrl("http://studyroom.lib.sjtu.edu.cn/apply.asp")
      return true
    end
    return false
  end,
  onUrlLoad=function(view,url)
  end,
  onReceivedSslError=function(view, sslErrorHandler, sslError)
    return false
  end
})

local fragment=uiManager.getFragment(4)
fragment.setWebInterface(WebInterface{
  onPageFinished=function(view,url)
    onFloatingActionButtonClick(nil, true)
  end,
  onPageStarted=function(view,url,favicon)
    if url:find("/index") and url:find("studyroom") then -- http://studyroom.lib.sjtu.edu.cn/index.asp
      local uiManager=activity.getUiManager()
      local wv=uiManager.getCurrentFragment().getWebView()
      wv.loadUrl("http://studyroom.lib.sjtu.edu.cn/apply.asp")
      return true
    end
    return false
  end,
  onUrlLoad=function(view,url)
  end,
  onReceivedSslError=function(view, sslErrorHandler, sslError)
    return false
  end
})

local fragment=uiManager.getFragment(5)
fragment.setWebInterface(WebInterface{
  onPageFinished=function(view,url)
    onFloatingActionButtonClick(nil, true)
  end,
  onPageStarted=function(view,url,favicon)
    if url:find("/index") and url:find("studyroom") then -- http://studyroom.lib.sjtu.edu.cn/index.asp
      local uiManager=activity.getUiManager()
      local wv=uiManager.getCurrentFragment().getWebView()
      wv.loadUrl("http://studyroom.lib.sjtu.edu.cn/apply.asp")
      return true
    end
    return false
  end,
  onUrlLoad=function(view,url)
  end,
  onReceivedSslError=function(view, sslErrorHandler, sslError)
    return false
  end
})

--悬浮按钮点击事件
function onFloatingActionButtonClick(v, foo)
  local uiManager=activity.getUiManager()
  local wv=uiManager.getCurrentFragment().getWebView()
  if wv.getUrl():find("zg") and wv.getUrl():find("booking") then
    -- 弹出对话框请求用户手机号
    createSnackbar("快捷方式 - 预约主馆", "执行", function()
      local dialog=MaterialAlertDialogBuilder(activity)
      dialog.setTitle("输入预约用手机号")
      dialog.setView(loadlayout(
      {
        TextInputLayout,
        id="TIL_phoneNumber",
        layout_height="wrap",
        padding="24dp",
        helperText="必填",
        layout_width="match",
        hint="手机号",--设置输入框提示文本
        {
          TextInputEditText,
          id="ET_phoneNumber",
          layout_height="wrap",
          layout_width="match",
        },
      }
      ))
      dialog.setPositiveButton("确认",{
        onClick=function()
          wv.evaluateJavascript(luajava.tostring([[
          mobile.value="]]..ET_phoneNumber.text..[["
          yuelan.value=2
          ck()
          $("input[name=\"shijianduan\"")[0].checked=1
          $("input[name=\"chengnuo\"]")[0].checked=true
          $("input[type=\"submit\"]")[0].click()
          ]]), ValueCallback({
            onReceiveValue = function(s)
              -- 返回值 Discarded
              return
            end
          }))

        end
      })
      dialog.setNegativeButton("取消",{
        onClick=function()
        end
      })
      dialog.show()
    end)
   elseif wv.getUrl():find("user_reserve_list") then
    
    createSnackbar("快捷方式 - 转成 Markdown", "转换", function()
      local str = getFromClipboard()
      local function parse(s)
        local function expl(inputstr, sep)
          if not(sep) then
            sep = "%s"
          end
          local t = {}
          for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[#t + 1] = str
          end
          return t
        end
        local l = expl(s, "\n")
        local c = 0
        local o = "| 申请号 | 图书馆 | 房间 | 开始时间 | 结束时间 | 预约人 | 密码 | Status |\n| ------ | ------------ | ---- | ------------------ | ------------------ | ------ | ------ | -------- |\n"
        for i = 1, #l do
	      local info = l[i]
	      if #info > 30 then
		    local infoSeg = expl(info, "\t")
            if infoSeg and #infoSeg > 7 then
  		      if l[i]:find("等待加入") then
		  	    c = c + 1
                o = o .. string.format("| %s | %s | %s | %s | %s | %s | %s | %s |\n",
		      infoSeg[2], infoSeg[4], infoSeg[5], infoSeg[7], infoSeg[8], infoSeg[9], infoSeg[#infoSeg - 1]:sub(-7, -2), ":accept:")
		      end
            end
          end
	    end
        return o, c
      end
      local outStr, count = parse(str)
      print(count)
      if count >= 1 then
        copyToClipboard(outStr)
        createSnackbar(string.format("已复制：%d 个未完成预约", count))
      else
        createSnackbar("剪贴板上没有未完成的预约")
      end
    end)
   
   elseif wv.getUrl():find("lzd") and wv.getUrl():find("booking") then
    createSnackbar("快捷方式 - 预约李政道图书馆", "执行", function()
      local dialog=MaterialAlertDialogBuilder(activity)
      dialog.setTitle("输入预约用手机号")
      dialog.setView(loadlayout(
      {
        TextInputLayout,
        id="TIL_phoneNumber",
        layout_height="wrap",
        padding="24dp",
        helperText="必填",
        layout_width="match",
        hint="手机号",--设置输入框提示文本
        {
          TextInputEditText,
          id="ET_phoneNumber",
          layout_height="wrap",
          layout_width="match",
        },
      }
      ))
      dialog.setPositiveButton("确认",{
        onClick=function()
          wv.evaluateJavascript(luajava.tostring([[
          mobile.value="]]..ET_phoneNumber.text..[["
          $("input[name=\"shijianduan\"")[0].checked=1
          $("input[name=\"chengnuo\"]")[0].checked=true
          $("input[type=\"submit\"]")[0].click()
          ]]), ValueCallback({
            onReceiveValue = function(s)
              -- 返回值 Discarded
              return
            end
          }))

        end
      })
      dialog.setNegativeButton("取消",{
        onClick=function()
        end
      })
      dialog.show()
    end)
   elseif wv.getUrl():find("byg") and wv.getUrl():find("booking") then
    createSnackbar("快捷方式 - 预约包玉刚图书馆", "执行", function()
      local dialog=MaterialAlertDialogBuilder(activity)
      dialog.setTitle("输入预约用手机号")
      dialog.setView(loadlayout(
      {
        TextInputLayout,
        id="TIL_phoneNumber",
        layout_height="wrap",
        padding="24dp",
        helperText="必填",
        layout_width="match",
        hint="手机号",--设置输入框提示文本
        {
          TextInputEditText,
          id="ET_phoneNumber",
          layout_height="wrap",
          layout_width="match",
        },
      }
      ))
      dialog.setPositiveButton("确认",{
        onClick=function()
          wv.evaluateJavascript(luajava.tostring([[
          mobile.value="]]..ET_phoneNumber.text..[["
          $("input[name=\"shijianduan\"")[0].checked=1
          $("input[name=\"chengnuo\"]")[0].checked=true
          $("input[type=\"submit\"]")[0].click()
          ]]), ValueCallback({
            onReceiveValue = function(s)
              -- 返回值 Discarded
              return
            end
          }))

        end
      })
      dialog.setNegativeButton("取消",{
        onClick=function()
        end
      })
      dialog.show()
    end)
   elseif wv.getUrl():find("notes%.sjtu%.edu%.cn") then
    createSnackbar("快捷方式 - 编辑本文档", "跳转", function()
      import "android.content.Intent"
      import "android.net.Uri"
      local url="https://notes.sjtu.edu.cn/LQ04wW4yRcSLBMUr1Heaug?edit"
      local viewIntent = Intent("android.intent.action.VIEW", Uri.parse(url))
      activity.startActivity(viewIntent)
    end)
   elseif wv.getUrl():find("reserve") and not(wv.getUrl():find("user_reserve")) and not(wv.getUrl():find("reserve_plus")) then
    createSnackbar("快捷方式 - 随机填写申请", "执行", function()
      local event = EventTemplate[math.random(1, #EventTemplate)]
      wv.evaluateJavascript(luajava.tostring(string.format([[
          $("[name='groupname']")[0].value="%s";
          $("[name='classify']")[0].value="%s";
          $("[name='topic']")[0].value="%s";
          $("[name='detail']")[0].value="%s";
          $("[name='attendcount']")[0].value="3";
          $("[name='partake']")[0].value=0;
        ]], event['groupName'], event['type'], event['topic'], event['detail'])), ValueCallback({
        onReceiveValue = function(s)
          -- 返回值 Discarded
          return
        end
      }))
    end)
   elseif wv.getUrl():find("apply%.asp") then
    createSnackbar("快捷方式：设置时间 18:00~22:00", "搜索", function()
      wv.evaluateJavascript(luajava.tostring([[
        $("[name='tend']")[0].value="22:00";
        $("[name='tstart']")[0].value="18:00";
        $("input[type=\"submit\"]")[0].click();
      ]]),
        ValueCallback({
          onReceiveValue = function(s)
          -- 返回值 Discarded
          return
        end
        })
      )
    end)
   elseif not(foo) then
    createSnackbar("本页无快捷方式", "OK", function() end)
  end
end

function createSnackbar(message, actionText, actionFunction)
  local anchor=activity.findViewById(android.R.id.content)
  local bar = Snackbar.make(anchor, message, Snackbar.LENGTH_LONG).setAction(actionText, View.OnClickListener{
    onClick=function(v)
      actionFunction(v)
    end
  }).setActionTextColor(0xff66ccff).setBackgroundTint(0xff223344).show()
end

-- @param data 侧滑栏列表的全部数据
-- @param recyclerView 侧滑栏列表控件
-- @param listIndex 点击的列表索引（点击的是第几个列表）
-- @param clickIndex 点击的项目索引（点击的第几个项目）
function onDrawerListItemClick(data, recyclerView, listIndex, itemIndex)
  local listData = data.get(listIndex);
  local itemData = listData.get(itemIndex);
  local itemTitle = itemData.getTitle();
  if itemTitle == "更新日志" then
    local dialog=MaterialAlertDialogBuilder(activity)
    dialog.setTitle("更新日志")
    dialog.setMessage(UpdateLog)
    dialog.setPositiveButton("确认",{
      onClick=function()
      end
    })
    dialog.show()
  elseif itemTitle == "退出" then
    activity.finish()
  end
end

