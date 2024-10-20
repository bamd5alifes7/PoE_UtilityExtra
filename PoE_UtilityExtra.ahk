;將執行方式改為系統管理員
RunAsAdmin()
;中文簡介
MsgBox, [F7]座標設定工具，將目前游標位置所在座標設定起來。`r`n[F6]自動點傳奇，在背包最左邊放兩排皮革腰帶，開啟通貨倉庫頁並關閉倉庫頁的公開狀態後使用。`r`n[F9]在已點開換取命運卡視窗的情況下下，快速將背包中的命運卡組換成物品。`r`n[F10]快速開卡。從指定座標位置(預設為2K螢幕的通貨倉庫頁)開卡，暫放在背包左上第一格然後塞回倉庫裡。`r`n[F2]快速清包`r`n[F11]持續按住來移動游標滑過的物品`r`n[F12]長按強制結束`r`n開始前請確認座標已設好且視窗已聚焦在POE上`r`n 製作:吟月氏樹海

;不接受多重開啟
#SingleInstance force
;包含其他檔案，如函式庫
#Include functions_extra.ahk

;設定滑鼠移動的預設速度 0是順移
SetDefaultMouseSpeed, 0

;===============================================================================
; Settings:
;數值設定由rw_settings設定於settings.ini文件中，也可手動修改
;===============================================================================

; -----以下參數還沒改進settings.ini，可以直接從這邊改-----


;滑鼠移動速度，有些函數會用到
global MSpeed = 1

;背包第一格，用來暫放換出來的命運卡
global BagX = 1723
global BagY = 821

;命運卡交易按鈕的座標
global TradeButton_X = 847
global TradeButton_Y = 987

;命運卡交易欄位的座標
global TradeInventory_X = 846
global TradeInventory_Y = 617

;自動點傳奇的物件位置，預設是背包物品欄的第一欄與第三欄，共十個物件
BeltPos := [1, 2, 3, 4, 5, 11, 12, 13, 14, 15]

; -----以下參數已經改由settings.ini中讀取-----

;命運卡組的座標，預設為通貨倉庫頁的位置
global Deck_X
global Deck_Y

;用於QuickBagmoving的背包座標
;BagFirst是指背包欄最左上邊緣的尖角
;The sharp corner of the upper left edge of your inventory 
global BagFirstX
global BagFirstY
;BagLast是指背包欄最右下邊緣的尖角
;The sharp corner of the lower right edge of your inventory
global BagLastX
global BagLastY

;機會石座標
global Chance_X
global Chance_Y

;重鑄石座標
global Scouring_X 
global Scouring_Y

;讀座標設定
readIni()

;===============================================================================
; deck:
; 按鍵說明區
;===============================================================================


;-----以下是此程式的功能-----

~F7::saveCoordinatesTool()
; F7:座標設定工具，將目前游標位置的座標設定起來。

~F6::hideQuickChance()
; F6:自動點傳奇 藏身處 在背包最左邊放兩排皮革腰帶，開啟通貨倉庫頁並關閉倉庫頁的公開狀態後使用。


~F9::hideTradecard(BagFirstX,BagFirstY,BagLastX,BagLastY)                        
; F9:在已點開換取命運卡視窗的情況下，自動將背包中的命運卡組換成物品。

~F10::hideTradeDeck()
; F10:快速開卡。從指定座標位置(預設為2K螢幕的通貨倉庫頁)打開豐裕牌組，暫放在背包左上第一格然後塞回倉庫裡。



;-----以下是與PoE_UtilityBundles相同的部分-----

~F2::QuickBagmoving(BagFirstX,BagFirstY,BagLastX,BagLastY)
; F2:Quick moving item from bag, F12 to end. 迅速清包，F12為停止鍵。

~F11::Quickmoving()                     	 
; F11: Hold to Quick moving item. 持續按住來快速移動游標滑過的物件。

;================================================




