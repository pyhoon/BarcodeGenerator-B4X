B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.3
@EndOfDesignText@
' Class: BarcodeGenerator
' version 1.14
'
' Author: Aeric Poon
' Credits: Lucas Siqueira
' Reference: https://www.b4x.com/android/forum/threads/b4x-barcodegenerator-cross-platform-barcode-code-generator.147841/
Sub Class_Globals
	Private xui As XUI
	Private Pattern1 As Map = CreateMap("0": "0001101", "1": "0011001", "2": "0010011", "3": "0111101", "4": "0100011", "5": "0110001", "6": "0101111", "7": "0111011", "8": "0110111", "9": "0001011")
	Private Pattern2 As Map = CreateMap("0": "0100111", "1": "0110011", "2": "0011011", "3": "0100001", "4": "0011101", "5": "0111001", "6": "0000101", "7": "0010001", "8": "0001001", "9": "0010111")
	Private Pattern3 As Map = CreateMap("0": "1110010", "1": "1100110", "2": "1101100", "3": "1000010", "4": "1011100", "5": "1001110", "6": "1010000", "7": "1000100", "8": "1001000", "9": "1110100")
	Private Pattern4 As Map = CreateMap("0": "-LLLLLL=RRRRRR-", "1": "-LLGLGG=RRRRRR-", "2": "-LLGGLG=RRRRRR-", "3": "-LLGGGL=RRRRRR-", "4": "-LGLLGG=RRRRRR-", "5": "-LGGLLG=RRRRRR-", "6": "-LGGGLL=RRRRRR-", "7": "-LGLGLG=RRRRRR-", "8": "-LGLGGL=RRRRRR-", "9": "-LGGLGL=RRRRRR-")
	Private Magic As List = Array As Int(1740, 1644, 1638, 1176, 1164, 1100, 1224, 1220, 1124, 1608, 1604, 1572, 1436, 1244, 1230, 1484, 1260, 1254, 1650, 1628, 1614, 1764, 1652, 1902, 1868, 1836, 1830, 1892, 1844, 1842, 1752, 1734, 1590, 1304, 1112, 1094, 1416, 1128, 1122, 1672, 1576, 1570, 1464, 1422, 1134, 1496, 1478, 1142, 1910, 1678, 1582, 1768, 1762, 1774, 1880, 1862, 1814, 1896, 1890, 1818, 1914, 1602, 1930, 1328, 1292, 1200, 1158, 1068, 1062, 1424, 1412, 1232, 1218, 1076, 1074, 1554, 1616, 1978, 1556, 1146, 1340, 1212, 1182, 1508, 1268, 1266, 1956, 1940, 1938, 1758, 1782, 1974, 1400, 1310, 1118)
	Private blueBars As Boolean = False
End Sub

Public Sub Initialize

End Sub

Private Sub CreateCanvas As B4XCanvas
    Dim xview As B4XView = xui.CreatePanel("")
    xview.SetLayoutAnimated(0, 0, 0, 1050dip, 300dip)
    xview.Color = xui.Color_White
    Dim cvs As B4XCanvas
    cvs.Initialize(xview)
    Return cvs
End Sub

Private Sub DrawBarcode (cvs As B4XCanvas, code2 As String, totalBars As Int)
    Dim Height As Int = cvs.TargetRect.Height
    Dim Width As Int = cvs.TargetRect.Width
    Dim NewWidth As Int = Width - 100dip
    Dim NumberHeight As Int = 40dip
    Dim BarWidth As Float = NewWidth / totalBars
    Dim BarHeight As Int = Height - NumberHeight

    ' White background
	Dim rect As B4XRect
	rect.Initialize(0, 0, Width, Height)
	cvs.DrawRect(rect, xui.Color_White, True, 0)

    ' Draw bars
    Dim CurrentWidth As Int = 50dip
    For i = 0 To code2.Length - 1
        Dim cor As Int = xui.Color_Black
        If code2.CharAt(i) = "0" Then cor = xui.Color_White
        If blueBars And code2.CharAt(i) = "3" Then cor = xui.Color_Blue

        If code2.CharAt(i) = "2" Or code2.CharAt(i) = "3" Then
            cvs.DrawLine(CurrentWidth, 0, CurrentWidth, BarHeight, cor, BarWidth)
        Else
            cvs.DrawLine(CurrentWidth, 0, CurrentWidth, BarHeight - NumberHeight, cor, BarWidth)
        End If
        CurrentWidth = CurrentWidth + BarWidth
    Next
End Sub

Private Sub DrawText (cvs As B4XCanvas, barcodeType As String, code As String)
	Dim font As B4XFont = xui.CreateFontAwesome(63)
	Dim sb As StringBuilder
	sb.Initialize
	Select barcodeType
		Case "UPCA"
			For i = 1 To code.Length
				Dim value As String = code.CharAt(i - 1)
				sb.Append(value)
				If i = 1 Then
					sb.Append("        ")
				Else If i = 6 Then
					sb.Append("      ")
				Else If i = 11 Then
					sb.Append("         ")
				Else If i = 12 Then
					'doesn't add anything
				Else
					sb.Append("  ")
				End If
			Next
			cvs.DrawText(sb.ToString, 1dip, cvs.TargetView.Height - 20dip, font, xui.Color_Black, "LEFT")
		Case "EAN13"
			For i = 1 To code.Length
				Dim value As String = code.CharAt(i - 1)
				sb.Append(value)
				If i = 1 Then
					sb.Append("    ")
				Else If i = 7 Then
					sb.Append("      ")
				Else If i = 13 Then
					'doesn't add anything
				Else
					sb.Append("  ")
				End If
			Next
			cvs.DrawText(sb.ToString, 1dip, cvs.TargetView.Height - 20dip, font, xui.Color_Black, "LEFT")
		Case "CODE128"
			For i = 1 To code.Length
				Dim value As String = code.CharAt(i - 1)
				sb.Append(value)
				If i = 1 Then
					sb.Append("    ")
				Else If i = 7 Then
					sb.Append("      ")
				Else If i = 13 Then
					'doesn't add anything
				Else
					sb.Append("  ")
				End If
			Next
			cvs.DrawText(code, cvs.TargetView.Width / 2, cvs.TargetView.Height - 20dip, font, xui.Color_Black, "CENTER")
	End Select
End Sub

Private Sub Dec2Bin (digit As Int) As String
	Return Bit.ToBinaryString(digit)
End Sub

Private Sub BinToDec (value As String) As Int 'ignore
	Dim num As Int
	For i = 0 To value.Length - 1
		Dim digit As Int = value.SubString2(i, i + 1)
		num = num * 2 + digit
	Next
	Return num
End Sub

Private Sub CreateBitmap (cvs As B4XCanvas) As B4XBitmap
	cvs.Invalidate
	Dim res As B4XBitmap = cvs.CreateBitmap
	cvs.Release
	Return res
End Sub

Public Sub EAN13 (code As String) As B4XBitmap
	If code.Length = 12 Then code = "0" & code
	If code.Length <> 13 Then Return Null
	Dim code2 As String = EAN13Generate(code)
	Dim cvs As B4XCanvas = CreateCanvas
	cvs.ClearRect(cvs.TargetRect)
	DrawBarcode(cvs, code2, 95)
	DrawText(cvs, "EAN13", code)
	Return CreateBitmap(cvs)
End Sub

Private Sub EAN13Generate (code As String) As String
	Dim First 		As String = code.SubString2(0, 1)
	Dim Middle 		As String = code.SubString2(1, 7)
	Dim Last 		As String = code.SubString2(7, 13)
	Dim code2 		As String = "-" & Middle & "=" & Last & "-"
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To code2.Length - 1
		Dim value2 As String = code2.CharAt(i)
		Dim code3 As String = Pattern4.Get(First)
		Dim value3 As String = code3.CharAt(i)
		Select value3
			Case "L"
				sb.Append(Pattern1.Get(value2))
			'Case "J"
			Case "G"
				sb.Append(Pattern2.Get(value2))
			Case "R"
				sb.Append(Pattern3.Get(value2))
			'Case "S"
			Case "-"
				sb.Append("202")
			Case "="
				sb.Append("02020")
		End Select
	Next
	Return sb.ToString
End Sub

Public Sub UPCA (code As String) As B4XBitmap
	If code.Length = 11 Then code = "0" & code
	If code.Length <> 12 Then Return Null
	Dim code2 As String = UPCAGenerate(code)
	Dim cvs As B4XCanvas = CreateCanvas
	cvs.ClearRect(cvs.TargetRect)
	DrawBarcode(cvs, code2, 95)
	DrawText(cvs, "UPCA", code)
	Return CreateBitmap(cvs)
End Sub

Private Sub UPCAGenerate (code As String) As String
	Dim Middle As String = code.SubString2(0, 6)
	Dim Last As String = code.SubString2(6, 12)
	Dim code2 As String = "-" & Middle & "=" & Last & "-"
	Dim code3 As String = "-JLLLLL=RRRRRS-"
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To code2.Length - 1
		Dim value2 As String = code2.CharAt(i)
		Dim value3 As String = code3.CharAt(i)
		Select value3
			Case "L"
				sb.Append(Pattern1.Get(value2))
			Case "J"
				value2 = Pattern1.Get(value2)
				value2 = value2.Replace("1", "2")
				sb.Append(value2)
			'Case "G"
			Case "R"
				sb.Append(Pattern3.Get(value2))
			Case "S"
				value2 = Pattern3.Get(value2)
				value2 = value2.Replace("1", "2")
				sb.Append(value2)
			Case "-"
				sb.Append("202")
			Case "="
				sb.Append("02020")
		End Select
	Next
	Return sb.ToString
End Sub

Public Sub CODE128 (code As String) As B4XBitmap
	Dim code2 As String = Code128Generate(code)
	Dim cvs As B4XCanvas = CreateCanvas
	cvs.ClearRect(cvs.TargetRect)
	DrawBarcode(cvs, code2, (code.Length * 11) + 11 + 11 + 13)
	DrawText(cvs, "CODE128", code)
	Return CreateBitmap(cvs)
End Sub

Private Sub Code128Generate (code As String) As String
	Dim sum As Int = 104 ' starting value
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("11010010000") ' start code b
	For i = 0 To code.Length - 1
		Dim value As String = code.CharAt(i)
		Dim multiplier As Int = i + 1
		Dim digit As Int = Code128Decode(value)
		Dim result As Int = multiplier * digit
		sum = sum + result
		sb.Append(Code128Sequence(value))
	Next
	Dim checksum As Int = sum Mod 103
	Dim value2 As String = Code128Encode(checksum)
	sb.Append(Code128Sequence(value2))
	sb.Append("1100011101011") ' end of code
	Return sb.ToString
End Sub

Private Sub Code128Sequence (value As String) As String
	Dim digit As Int = Code128Decode(value)
	If digit < 0 Or digit > 94 Then Return ""
	Return Dec2Bin(Magic.Get(digit))
End Sub

Private Sub Code128Decode (value As String) As Int
	Return Asc(value) - 32
End Sub

Private Sub Code128Encode (digit As Int) As String
	If digit < 0 Or digit > 94 Then digit = 0
	digit = digit + 32
	Return Chr(digit)
End Sub