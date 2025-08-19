B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
#Macro: Title, Export, ide://run?file=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip
#Macro: Title, GitHub, ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=github&Args=..\..\
#Macro: Title, Sync Files, ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private B4XImageView1 As B4XImageView
	Private B4XFloatTextField1 As B4XFloatTextField
	Private B4XFloatTextField2 As B4XFloatTextField
	Private B4XFloatTextField3 As B4XFloatTextField
	Private barcode As BarcodeGenerator
	'Private barcode As B4XBarcodeDrawer
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
	barcode.Initialize
	'barcode.Initialize(B4XImageView1.mBase)
	B4XFloatTextField1.Text = "7891268101799"
	B4XFloatTextField2.Text = "075678164125"
	B4XFloatTextField3.Text = "0123456789 abcABC"
	'For i = 32 To 126
	'	Log(Bit.ToBinaryString(i))
	'Next
End Sub

Private Sub B4XFloatTextField1_EnterPressed
	Button1_Click
End Sub

Private Sub Button1_Click	
	B4XImageView1.Bitmap = barcode.EAN13(B4XFloatTextField1.Text)
	'barcode.DrawBarcode("EAN13", B4XFloatTextField1.Text)
	' EAN-13 (13 digits):
	'Dim bmp As B4XBitmap = barcode.DrawEAN13("0123456789012")
	'B4XImageView1.Bitmap = bmp ' or save/print the bitmap
	'B4XImageView1.Bitmap = barcode.DrawEAN13("0123456789012")
	'B4XImageView1.Bitmap = barcode.DrawEAN13(B4XFloatTextField1.Text)
End Sub

Private Sub Button2_Click
	B4XImageView1.Bitmap = barcode.UPCA(B4XFloatTextField2.Text)
	'barcode.DrawBarcode("UPCA", B4XFloatTextField2.Text)
End Sub

Private Sub Button3_Click
	B4XImageView1.Bitmap = barcode.CODE128(B4XFloatTextField3.Text)
	'barcode.DrawBarcode("Code128B", B4XFloatTextField3.Text)
	'Dim bmp As B4XBitmap = B4XImageView1.Bitmap
	'Dim out As OutputStream
	'out = File.OpenOutput(File.DirApp, "code128.png", False)
	'bmp.WriteToStream(out, 100, "PNG")
	'out.Close
End Sub