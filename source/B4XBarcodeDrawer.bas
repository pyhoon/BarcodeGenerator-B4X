B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.3
@EndOfDesignText@
' Class module: B4XBarcodeDrawer
' Author: Refactored by ChatGPT but not working
Sub Class_Globals
    Private xui As XUI
    Private cvs As B4XCanvas
    
    ' --- CONFIG ---
    Private BAR_WIDTH As Float = 2dip
    Private BAR_HEIGHT As Float = 100dip
    'Private TEXT_HEIGHT As Float = 20dip
    Private PADDING_LEFT As Float = 10dip
    Private PADDING_TOP As Float = 10dip
    
    Private clrBlack As Int = xui.Color_Black
    Private clrBlue As Int = xui.Color_Blue
    'Private clrWhite As Int = xui.Color_White
    
    ' Encoding definitions: Each encoder has fields
    ' [ "Start", "Encodings", "Middle", "End" ]
    Private Encoders As Map
End Sub

Public Sub Initialize (Parent As B4XView)
    cvs.Initialize(Parent)
    InitEncoders
End Sub

Private Sub InitEncoders
    Encoders.Initialize
    
    ' --- EAN-13 ---
    Dim ean As Map
    ean.Initialize
    ean.Put("Start", "101") ' Guard bar left
    ean.Put("Middle", "01010") ' Guard bar center
    ean.Put("End", "101") ' Guard bar right
    Dim eanEnc As Map
    eanEnc.Initialize
    ' Left A encoding
    eanEnc.Put("A", CreateMap("0": "0001101", "1": "0011001", "2": "0010011", "3": "0111101", "4": "0100011", "5": "0110001", "6": "0101111", "7": "0111011", "8": "0110111", "9": "0001011"))
    ' Left B encoding
    eanEnc.Put("B", CreateMap("0": "0100111", "1": "0110011", "2": "0011011", "3": "0100001", "4": "0011101", "5": "0111001", "6": "0000101", "7": "0010001", "8": "0001001", "9": "0010111"))
    ' Right C encoding
    eanEnc.Put("C", CreateMap("0": "1110010", "1": "1100110", "2": "1101100", "3": "1000010", "4": "1011100", "5": "1001110", "6": "1010000", "7": "1000100", "8": "1001000", "9": "1110100"))
    ean.Put("Encodings", eanEnc)
    Encoders.Put("EAN13", ean)
    
    ' --- UPC-A ---
    ' Similar structure as EAN-13 but with different parity (reuse EAN-13 patterns)
    Dim upc As Map
    upc.Initialize
    upc.Put("Start", "101")
    upc.Put("Middle", "01010")
    upc.Put("End", "101")
    upc.Put("Encodings", eanEnc) ' Reuse same encodings
    Encoders.Put("UPCA", upc)
    
    ' --- Code128 (Set B) ---
    Dim c128 As Map
    c128.Initialize
    c128.Put("Start", "11010010000") ' Code128 Start B
    c128.Put("Middle", "") ' No middle section
    c128.Put("End", "1100011101011") ' Stop pattern
    Dim c128Enc As Map
    c128Enc.Initialize
    ' Add only few for example
    c128Enc.Put("A", "10010110000")
    c128Enc.Put("B", "10010000110")
    c128Enc.Put("C", "11000010100")
    c128.Put("Encodings", c128Enc)
    Encoders.Put("Code128B", c128)
End Sub

'<code>Dim bc As B4XBarcodeDrawer
'bc.Initialize(Pane1) ' or any B4XView container
'bc.DrawBarcode("EAN13", "123456789012")
'bc.DrawBarcode("UPCA", "12345678901")
'bc.DrawBarcode("Code128B", "ABC")</code>
Public Sub DrawBarcode (Format As String, Value As String)
    If Encoders.ContainsKey(Format) = False Then
        Log("Unknown format: " & Format)
        Return
    End If
    
    Dim encoder As Map = Encoders.Get(Format)
	
	 ' Start guard
    Dim pattern As String = "" & encoder.Get("Start")
    
    ' Encode value
    Dim encMap As Map = encoder.Get("Encodings")
    For i = 0 To Value.Length - 1
        Dim ch As String = Value.CharAt(i)
        If encMap.ContainsKey(ch) Then
            pattern = pattern & encMap.Get(ch)
        Else
            Log("Invalid char in barcode: " & ch)
        End If
        ' Add middle if halfway (EAN/UPC)
        If i = (Value.Length / 2) - 1 And encoder.Get("Middle") <> "" Then
            pattern = pattern & encoder.Get("Middle")
        End If
    Next
    
    ' End guard
    pattern = pattern & encoder.Get("End")
    
    ' Draw it
    cvs.ClearRect(cvs.TargetRect)
    DrawPattern(pattern)
    cvs.Invalidate
End Sub

Private Sub DrawPattern (pattern As String)
    Dim x As Float = PADDING_LEFT
    For i = 0 To pattern.Length - 1
        Dim digit As String = pattern.CharAt(i)
        If digit = "1" Or digit = "2" Or digit = "3" Then
            Dim clr As Int = clrBlack
            If digit = "2" Or digit = "3" Then clr = clrBlue ' Guard bar color
            cvs.DrawLine(x, PADDING_TOP, x, PADDING_TOP + BAR_HEIGHT, clr, BAR_WIDTH)
        End If
        x = x + BAR_WIDTH
    Next
End Sub