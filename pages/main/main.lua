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

-- 读入活动列表
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
  --TODO：onMenuItemClick
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

local uimanager=activity.uiManager
local fragment=uimanager.currentFragment
fragment.setWebInterface(WebInterface{
  onPageFinished=function(view,url)
    onFloatingActionButtonClick(nil, true)
  end,
  onPageStarted=function(view,url,favicon)
    --页面开始加载事件
  end,
  onLoadResource=function(view,url)
    --页面资源加载监听
    --可通过该方法获取网页上的资源
  end,
  onUrlLoad=function(view,url)
    if url:find("index%.asp") and url:find("studyroom") then
      local uiManager=activity.getUiManager()
      local wv=uiManager.getCurrentFragment().getWebView()
      wv.loadUrl("http://studyroom.lib.sjtu.edu.cn/apply.asp")
      return true
    end
    return false
  end,
  onReceivedSslError=function(view, sslErrorHandler, sslError)
    return false
  end
})

--悬浮按钮点击事件
function onFloatingActionButtonClick(v, foo)
  local uiManager=activity.getUiManager()
  local wv=uiManager.getCurrentFragment().getWebView()
  if wv.getUrl():find("zg") then
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

   elseif wv.getUrl():find("lzd") then
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
   elseif wv.getUrl():find("byg") then
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
   elseif wv.getUrl():find("reserve") then
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
  end
end

