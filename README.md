# Print and Merge Suite

The Print and Merge Suite is an extention to Report Builder reports, from Digital Metaphors, and a PDF Viewer written using Developer Express VCL components. 

## The Print and Merge Suite consists of 3 runtime components: 
- TDuplicatePrinter
Hooks into one or more report. On copy 2 and following TDuplicatePrinter will add a Watermark to your reports, saying "Duplicate"

If you want some thing else written construct DuplicatePrinter like this:
```delphi
with TDuplicatePrinter.Create(ppReport1) do
  CopyText := 'Copy';
```

You'll find two demos using TDuplicatePrinter

- TPrintAndMerge

Hooks into one or more report, on prinjting it will merge it into one print, and give you the possibility to print it to PDF, RTF or DOC.

Example of use: 

TPrintAndMerge created with Self (the form) inorder for using all ppReports on the form

```delphi
with TPrintAndMerge.Create(Self, ChangeFileExt(Application.ExeName, '.pdf')) do
 try
   PrintToPDF;
finally
  Free;
end;
```

TPrintAndMerge created with an array of ppReports, inorder for only using those
```delphi
with TPrintAndMerge.Create([ppReport1, ppReport2], ChangeFileExt(Application.ExeName, '.pdf')) do
try
  PrintToPDF;
finally
  Free;
end;
```

- TPDFViewer

TPDFViewer can be used for showing a PDF file. Either from at file:
```delphi
  TPDFViewer.LoadFromFile(...);
```  
or a Stream: 
```delphi
  TPDFViewer.LoadFromStream(...)
```  

You'll find a simple demo showing how to use it. 

### PDF Viewer
![Demo Application](https://github.com/JensBorrisholt/Print-and-Merge-Suite/blob/master/Demos/PDF%20Viewer.png)

## Mega demo

Also included is a mega demo using all of the above in one demo. Watermark, Merge and PDF Viewer in one demo.

### Designtime
![Demo Application](https://github.com/JensBorrisholt/Print-and-Merge-Suite/blob/master/Demos/Mega%20Demo.PNG)

And the code 

```delphi
uses
  DuplicatePrinterU, PrintAndMergeU, PDFViewerU;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  ppReport1.PrinterSetup.Copies := StrToIntDef(Edit1.Text, 2);
  ppReport2.PrinterSetup.Copies := StrToIntDef(Edit2.Text, 2);
  ppReport3.PrinterSetup.Copies := StrToIntDef(Edit3.Text, 2);

  with TPrintAndMerge.Create(Self) do
    try
      PrintToPDF;
      TPDFViewer.LoadFromStream(OutputStream);
    finally
      Free;
    end;
end;

procedure TFormMain.DuplicatePrintersOnGetWatermarkText(Sender: TppReport; Copy: integer; var Text: string);
begin
  if Copy = 1 then
    Text := ''
  else
    Text := 'Copy ' + (Copy - 1).ToString;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  with TDuplicatePrinters.Create(Self) do
    OnGetWatermarkText := DuplicatePrintersOnGetWatermarkText;
end;
```  

So even though we merged 3 reports into 1 PDF file, adding a Watermark to page 2 following on each report and showing the PDF (loaded form a stream), only approx 30 lines of code is needed inorder for achieving this.
