hideTradecard(BagFirstX,BagFirstY,BagLastX,BagLastY)
{

BagPosX := []
BagPosY := []

	loop , 60
	{

	TempX =% BagFirstX+((BagLastX-BagFirstX)/12)*Floor((A_index-1)/5)+(BagLastX-BagFirstX)/12/2
	BagPosX.Push(TempX)
	TempY =% BagFirstY+(BagLastY-BagFirstY)/5*Mod(A_index-1,5)+(BagLastY-BagFirstY)/5/2
	BagPosY.Push(TempY)
	}
	
    BlockInput On
	send {Ctrl down}
	
    for k, v in BagPosX
		{	
		
		if GetKeyState("F12", "P") 
			{
			break 
			}
			
		;訂個休息用的亂數，國際服休 170~190 
		Random, sleeptime, 180, 200
		
		;測試滑鼠點擊前或後休息，好像是沒差的。但點擊後休息看起來沒那麼延遲，順眼一點
		MouseMove,BagPosX[k],BagPosY[k],MSpeed
		;Sleep, sleeptime
		MouseClick
		Sleep, sleeptime
		
		MouseMove,TradeButton_X,TradeButton_Y,MSpeed
		;Sleep, sleeptime
		MouseClick
		Sleep, sleeptime
		
		MouseMove,TradeInventory_X,TradeInventory_Y,MSpeed
		;Sleep, sleeptime
		MouseClick
		Sleep, sleeptime
		}
		
	send {Ctrl up}
    BlockInput Off
    return

}

hideTradeDeck()
{
    BlockInput On

	loop , 5000
	{
	
	if GetKeyState("F12", "P") 
		{
		send {Ctrl up}
		BlockInput off
		break 
		}
	
	;每輪訂一次亂數，很誇張的需要訂260~300
	Random, rand, 260, 300
	
	;放開Ctrl，並從指定位置(通貨倉庫頁)開卡
	send {Ctrl up}
	MouseMove,Deck_X,Deck_Y,MSpeed
    MouseClick,right
    Sleep, rand	
	
	;把卡片暫放到背包，再按住Ctrl，塞回倉庫
	MouseMove,BagX,BagY,MSpeed
    MouseClick
    Sleep, rand	
	
	send {Ctrl down}
	MouseMove,BagX,BagY,MSpeed
    MouseClick
	Sleep, rand	
	}
	
}


Quickmoving(){
    send {Ctrl down}
    Loop
        {
		
        if not GetKeyState("F11", "P")
			{
			send {Ctrl up}
            break
			}
			
		Click left
        Sleep 20
        }
	
    return
}

QuickBagmoving(BagFirstX,BagFirstY,BagLastX,BagLastY){

;背包欄最左上邊緣的尖角,改成用全域變數
;BagFirstX = 1694
;BagFirstY = 781
;背包欄最右下邊緣的尖角,改成用全域變數
;BagLastX = 2539
;BagLastY = 1137
BagPosX := []
BagPosY := []

	;由左上角和右下角座標，計算60個需操作的位置。
	loop , 60
	{

	TempX =% BagFirstX+((BagLastX-BagFirstX)/12)*Floor((A_index-1)/5)+(BagLastX-BagFirstX)/12/2
	BagPosX.Push(TempX)
	TempY =% BagFirstY+(BagLastY-BagFirstY)/5*Mod(A_index-1,5)+(BagLastY-BagFirstY)/5/2
	BagPosY.Push(TempY)
	}

    BlockInput On
    send {Ctrl down}
	MouseGetPos,tempX,tempY
	
    for k, v in BagPosX
    {	
	
    if GetKeyState("F12", "P") 
    break 
	
    MouseMove,BagPosX[k],BagPosY[k],1
	//國際服間隔個時間增加
	Random, rand, 20,40
	
    Sleep, rand	
    MouseClick
    Sleep, rand	
    }
	
	MouseMove,tempX,tempY,1
    send {Ctrl up}
    BlockInput Off
    return

}


saveCoordinatesTool()
{
	IfWinnotActive,Path of Exile
	{
		MsgBox,請確認視窗已聚焦在POE上!
		return
	}
	MouseGetPos, thisPosX, thisPosY
	PosX := ["Deck_X"]
	PosY := ["Deck_Y"]
	InputBox, affixID,其他解析度通貨座標指定工具, 座標[ %thisPosX% `, %thisPosY% ]`n請輸入此座標之通貨ID`n1=豐裕牌組
	if not ErrorLevel
	{
		checkAffixID := RegExMatch(affixID, "[1]$")
		if checkAffixID = 1
		{
			iniWrite,% thisPosX, setting.ini, coordinate, % PosX[affixID]
			iniWrite,% thisPosY, setting.ini, coordinate, % PosY[affixID]
		}
		else
		{
			MsgBox,請輸入正確的通貨ID
		}
		;讀取ini
		readIni()
	}	
	return
}

readIni()
{	
	;預設解析度 default : 2560*1440
	IniRead, Deck_X, 			  settings.ini, coordinate, Deck_X,			   649
	IniRead, Deck_Y, 			  settings.ini, coordinate, Deck_Y, 		   537
    IniRead, BagFirstX,           settings.ini, coordinate, BagFirstX, 		   1694
    IniRead, BagFirstY,           settings.ini, coordinate, BagFirstY, 		   781
    IniRead, BagLastX,            settings.ini, coordinate, BagLastX, 		   2539
    IniRead, BagLastY,            settings.ini, coordinate, BagLastY, 		   1137
    IniRead, Chance_X,            settings.ini, coordinate, Chance_X, 		   303
    IniRead, Chance_Y,            settings.ini, coordinate, Chance_Y, 		   370
    IniRead, Scouring_X,            settings.ini, coordinate, Scouring_X, 		   581
    IniRead, Scouring_Y,            settings.ini, coordinate, Scouring_Y, 		   694




	return
}


RunAsAdmin()
{
	Loop, %0%  
  	{
		param := %A_Index%  
		params .= A_Space . param
  	}
	ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA" 
	if not A_IsAdmin
	{
		If A_IsCompiled
			DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
		Else
			DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
		ExitApp
	}
}


hideQuickChance()
{

;座標
BagPosX := []
BagPosY := []

	;由左上角和右下角座標，把背包60個位置算出來。
	loop , 60
		{

		;初始X座標 + 格子長度*無條件捨去((當前數字-1)/5) + 格子一半長度
		TempX =% BagFirstX+((BagLastX-BagFirstX)/12)*Floor((A_index-1)/5)+(BagLastX-BagFirstX)/12/2
		BagPosX.Push(TempX)
		;初始Y座標 + 格子高度*餘數((當前數字-1)/5) + 格子一半高度
		TempY =% BagFirstY+(BagLastY-BagFirstY)/5*Mod(A_index-1,5)+(BagLastY-BagFirstY)/5/2
		BagPosY.Push(TempY)
		}

    BlockInput On
	MouseGetPos,tempX,tempY
	
	;拿BeltPos的值來用，只針對物件存放的背包第幾格來操作
    for k,v in BeltPos
		{	
		
		;休息用的隨機變數
		Random, sleeptime, 80, 100
		
		if GetKeyState("F12", "P") 
			{
			break
			}
		
		;每一個物件，都做無限迴圈直到點成傳奇
		loop
			{
			if GetKeyState("F12", "P") 
				{
				break
				}
			
			;稀有度判斷	
			MouseMove,BagPosX[v],BagPosY[v],MSpeed
			Sleep, sleeptime
			send ^c
			send ^c
			itemRarity = % getItemRarity()
			
			;如果稀有度是傳奇，離開迴圈點下一個物件。
			if itemRarity = 3
				break
			
			;重鑄機會
			MouseMove,Scouring_X, Scouring_Y,MSpeed
			Sleep, sleeptime
			MouseClick, Right
			MouseMove,BagPosX[v],BagPosY[v],MSpeed
			Sleep, sleeptime
			MouseClick, left
			MouseMove,Chance_X, Chance_Y,MSpeed
			Sleep, sleeptime
			MouseClick, Right
			MouseMove,BagPosX[v],BagPosY[v],MSpeed
			Sleep, sleeptime
			MouseClick, left
			}
			
		}
	
	MouseMove,tempX,tempY,1
    BlockInput Off
    return

}

getItemRarity()
{
	If InStr(clipboard,"稀有度: 普通") or InStr(clipboard,"Rarity: Normal")
		return 0
	If InStr(clipboard,"稀有度: 魔法") or InStr(clipboard,"Rarity: Magic")
		return 1
	If InStr(clipboard,"稀有度: 稀有") or InStr(clipboard,"Rarity: Rare")
		return 2
	If InStr(clipboard,"稀有度: 傳奇") or InStr(clipboard,"Rarity: Unique")
		return 3	
}
