unit PDFViewerU;

interface

{$I cxVer.inc}

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  dxPDFViewer,
  dxRibbonCustomizationForm, dxRibbonSkins, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxTextEdit, cxSpinEdit, ImgList, Controls, dxPDFViewerActions, Classes, ActnList, dxActions, cxShellBrowserDialog,
  dxBar, dxRibbonGallery, dxSkinChooserGallery, cxBarEditItem, dxCustomPreview, cxClasses, dxRibbon,
  dxPDFDocument, dxBarBuiltInMenu, cxContainer, cxEdit, cxLabel, cxProgressBar, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg,
  dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxPSPDFExportCore, dxPSPDFExport,
  cxDrawTextUtils, dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon, dxPScxPageControlProducer, dxPSdxPDFViewerLnk,
  dxPScxEditorProducers, dxPScxExtEditorProducers, dxPSCore, cxImageList, dxPrinting, dxBarExtItems, cxTrackBar,
  dxZoomTrackBar, dxStatusBar, dxRibbonStatusBar, uExportToBitmaps, uExportToFileDialog, dxRibbonForm, dxProgressDialog,
  dxGDIPlusClasses, cxImage, dxPDFDocumentViewer, dxPDFBase, dxPDFText, dxPDFRecognizedObject, dxPDFCore,
  System.ImageList, System.Actions, Vcl.Forms, Vcl.StdActns;

type
  TPDFViewerExportFunc = function(AScale: Double; AExportDialog: TfrmExportToFileDialog): string of object;
  TPDFViewerExportDialogClass = class of TfrmExportToFileDialog;

  TPDFViewer = class(TdxRibbonForm)
    dxBarManager1: TdxBarManager;
    dxRibbon1: TdxRibbon;
    dxBarManager1Bar2: TdxBar;
    cxBarEditItem1: TcxBarEditItem;
    sbdSelectFolderDialog: TcxShellBrowserDialog;
    ActionList1: TActionList;
    cxImageList1: TcxImageList;
    cxImageList2: TcxImageList;
    dxPDFViewerOpenDocumentAction: TdxPDFViewerOpenDocument;
    dxRibbonTabHome: TdxRibbonTab;
    dxBarFile: TdxBar;
    dxBarLargeButtonOpen: TdxBarLargeButton;
    dxPDFViewerGoToPrevPageAction: TdxPDFViewerGoToPrevPage;
    dxBarLargeButtonPreviousPage: TdxBarLargeButton;
    dxPDFViewerGoToNextPageAction: TdxPDFViewerGoToNextPage;
    dxBarLargeButtonNextPage: TdxBarLargeButton;
    dxBarSubItem1: TdxBarSubItem;
    dxPDFViewerGoToFirstPageAction: TdxPDFViewerGoToFirstPage;
    dxBarLargeButtonFirstPage: TdxBarLargeButton;
    dxPDFViewerGoToLastPageAction: TdxPDFViewerGoToLastPage;
    dxBarLargeButtonLastPage: TdxBarLargeButton;
    dxPDFViewerZoomOutAction: TdxPDFViewerZoomOut;
    dxBarZoom: TdxBar;
    dxBarLargeButtonZoomOut: TdxBarLargeButton;
    dxPDFViewerZoomInAction: TdxPDFViewerZoomIn;
    dxBarLargeButtonZoomIn: TdxBarLargeButton;
    dxBarSubItem2: TdxBarSubItem;
    dxPDFViewerZoom10Action: TdxPDFViewerZoom10;
    dxBarLargeButton10: TdxBarLargeButton;
    dxPDFViewerZoom25Action: TdxPDFViewerZoom25;
    dxBarLargeButton25: TdxBarLargeButton;
    dxPDFViewerZoom50Action: TdxPDFViewerZoom50;
    dxBarLargeButton50: TdxBarLargeButton;
    dxPDFViewerZoom75Action: TdxPDFViewerZoom75;
    dxBarLargeButton75: TdxBarLargeButton;
    dxPDFViewerZoom100Action: TdxPDFViewerZoom100;
    dxBarLargeButton100: TdxBarLargeButton;
    dxPDFViewerZoom125Action: TdxPDFViewerZoom125;
    dxBarLargeButton125: TdxBarLargeButton;
    dxPDFViewerZoom150Action: TdxPDFViewerZoom150;
    dxBarLargeButton150: TdxBarLargeButton;
    dxPDFViewerZoom200Action: TdxPDFViewerZoom200;
    dxBarLargeButton200: TdxBarLargeButton;
    dxPDFViewerZoom400Action: TdxPDFViewerZoom400;
    dxBarLargeButton400: TdxBarLargeButton;
    dxPDFViewerZoom500Action: TdxPDFViewerZoom500;
    dxBarLargeButton500: TdxBarLargeButton;
    dxPDFViewerZoomActualSizeAction: TdxPDFViewerZoomActualSize;
    dxBarLargeButtonActualSize: TdxBarLargeButton;
    dxPDFViewerZoomToPageLevelAction: TdxPDFViewerZoomToPageLevel;
    dxBarLargeButtonZoomtoPageLevel: TdxBarLargeButton;
    dxPDFViewerZoomFitWidthAction: TdxPDFViewerZoomFitWidth;
    dxBarLargeButtonFitWidth: TdxBarLargeButton;
    dxSkinChooserGalleryItem1: TdxSkinChooserGalleryItem;
    btnAbout: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    cxLookAndFeelController1: TcxLookAndFeelController;
    dxBarExit1: TdxBarLargeButton;
    dxBarButtonAbout: TdxBarLargeButton;
    dxBarManager1Bar4: TdxBar;
    dxBarButtonExportToTIFF: TdxBarLargeButton;
    dxBarButtonExportToPNG: TdxBarLargeButton;
    bmiNavigation: TdxBar;
    biStatusBarZoom: TdxBar;
    cxBarEditItem2: TcxBarEditItem;
    bilPageCount: TcxBarEditItem;
    biStatusBarCurrentZoom: TdxBarStatic;
    dxBarSubItem3: TdxBarSubItem;
    cxBarEditItem3: TcxBarEditItem;
    dxBarSeparator1: TdxBarSeparator;
    bteActualZoom: TcxBarEditItem;
    dxRibbonNavigationGroup: TdxBar;
    dxBarSubItem4: TdxBarSubItem;
    bseActivePage: TcxBarEditItem;
    dxRibbonStatusBarActivePage: TdxBarSpinEdit;
    sseActivePage: TcxBarEditItem;
    dxBarStatic1: TdxBarStatic;
    sbPageCount: TdxBarStatic;
    dxPDFViewerShowPrintForm: TdxPDFViewerShowPrintForm;
    dxBarLargeButtonPrint: TdxBarLargeButton;
    dxBarLargeButtonClose: TdxBarLargeButton;
    dxPDFViewerGoToPrevView: TdxPDFViewerGoToPrevView;
    dxBarLargeButtonPreviousView: TdxBarLargeButton;
    dxPDFViewerGoToNextView: TdxPDFViewerGoToNextView;
    dxBarLargeButtonNextView: TdxBarLargeButton;
    dxBarSubItem5: TdxBarSubItem;
    dxPDFViewerRotateClockwise: TdxPDFViewerRotateClockwise;
    dxBarLargeButtonRotateClockwise: TdxBarLargeButton;
    dxPDFViewerRotateCounterClockwise: TdxPDFViewerRotateCounterClockwise;
    dxBarLargeButtonRotateCounterclockwise: TdxBarLargeButton;
    dxPDFViewerSelectTool: TdxPDFViewerSelectTool;
    dxBarTools: TdxBar;
    dxBarLargeButtonSelectTool: TdxBarLargeButton;
    dxPDFViewerHandTool: TdxPDFViewerHandTool;
    dxBarLargeButtonHandTool: TdxBarLargeButton;
    dxPDFViewerSelectAll: TdxPDFViewerSelectAll;
    dxBarLargeButtonSelectAll: TdxBarLargeButton;
    dxSearchProgressBar: TdxBar;
    cxBarEditItem4: TcxBarEditItem;
    dxPDFViewerFind: TdxPDFViewerFind;
    dxBarFind: TdxBar;
    dxBarLargeButtonFind: TdxBarLargeButton;
    bbAbortTextSearch: TdxBarButton;
    dxPDFViewer1: TdxPDFViewer;
    dxRibbonStatusBar1: TdxRibbonStatusBar;
    dxRibbonStatusBar1Container5: TdxStatusBarContainerControl;
    tbZoom: TdxZoomTrackBar;
    dxComponentPrinter1: TdxComponentPrinter;
    dxComponentPrinter1Link1: TdxPDFViewerReportLink;
    procedure FormCreate(Sender: TObject);
    procedure bseActivePageChange(Sender: TObject);
    procedure dxPDFViewer1ZoomFactorChanged(Sender: TObject);
    procedure bteActualZoomChange(Sender: TObject);
    procedure dxPDFViewer1DocumentLoaded(ASender: TdxPDFDocument; const AInfo: TdxPDFDocumentLoadInfo);
    procedure actExitExecute(Sender: TObject);
    procedure dxBarButtonExportToPNGClick(Sender: TObject);
    procedure dxBarButtonExportToTIFFClick(Sender: TObject);
    procedure dxPDFViewer1SelectedPageChanged(Sender: TObject; APageIndex: Integer);
    procedure tbZoomPropertiesChange(Sender: TObject);
    procedure sseActivePageChange(Sender: TObject);
    procedure dxPDFViewer1DocumentUnloaded(Sender: TObject);
    procedure dxPDFViewer1HideFindPanel(Sender: TObject);
    procedure dxPDFViewer1ShowFindPanel(Sender: TObject);
    procedure dxPDFViewer1SearchProgress(Sender: TdxPDFDocument; APageIndex, APercent: Integer);
    procedure bbAbortTextSearchClick(Sender: TObject);
    procedure dxPDFViewer1HyperlinkClick(Sender: TdxPDFCustomViewer; const AURI: string; var AHandled: Boolean);
    procedure dxPDFViewer1CustomDrawPreRenderPage(Sender: TObject; ACanvas: TcxCanvas; const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
    procedure dxPDFViewer1CustomDrawPreRenderPageThumbnail(Sender: TObject; ACanvas: TcxCanvas; const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
    procedure dxPDFViewer1AttachmentOpen(Sender: TdxPDFCustomViewer; AAttachment: TdxPDFFileAttachment; var AHandled: Boolean);
    procedure dxPDFViewer1AttachmentSave(Sender: TdxPDFCustomViewer; AAttachment: TdxPDFFileAttachment; var AHandled: Boolean);
    procedure dxBarLargeButtonCloseClick(Sender: TObject);
  private
    FAbortTextSearch: Boolean;
    FLockCount: Integer;
    FPrevZoomFactor: Integer;
    FProgressDialog: TfrmProgress;

    function ExportToBitmaps(AScale: Double; AExportDialog: TfrmExportToFileDialog): string;
    function ExportToTIFF(AScale: Double; AExportDialog: TfrmExportToFileDialog): string;
    function ShowSaveAsDialog(const AFilter, AFileExtension: string; var AFileName: string): Boolean;

    function IsLocked: Boolean;
    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure UpdateControls;

    procedure AfterExport;
    procedure BeforeExport;
    procedure DrawPreRenderPage(ACanvas: TcxCanvas; const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
    procedure InitializeLookAndFeel;
    procedure ShowExportDialog(ADialogClass: TPDFViewerExportDialogClass; AExportFunc: TPDFViewerExportFunc);
    procedure UpdateActivePageEditor(ASpinEdit: TcxBarEditItem);
  public
    { Public declarations }
    class function LoadFromStream(const aStream: TStream): Integer;
    class function LoadFromFile(AFileName: string): Integer;
  end;

implementation

{$R *.dfm}

uses
  Winapi.Windows, SysUtils, Types, Math, Dialogs, IOUtils, dxCore, dxCoreGraphics, dxPDFCommandInterpreter,
  cxGeometry, dxPDFUtils;

const
  ApplicationCaption = 'PDF Viewer';
  SecurityWarningCaption = 'Security Warning';

function DropPercentChar(const S: string): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] = '%') do
    Dec(I);
  Result := Copy(S, 1, I);
end;

{ TfrmPDFViewer }

procedure TPDFViewer.bseActivePageChange(Sender: TObject);
begin
  if not IsLocked then
    dxPDFViewer1.CurrentPageIndex := bseActivePage.EditValue - 1;
end;

procedure TPDFViewer.bteActualZoomChange(Sender: TObject);
var
  V: Variant;
begin
  try
    V := StrToInt(DropPercentChar(bteActualZoom.EditValue));
  except
    try
      V := Round(StrToFloat(DropPercentChar(bteActualZoom.EditValue)));
    except
      V := FPrevZoomFactor;
    end;
  end;
  dxPDFViewer1.OptionsZoom.ZoomFactor := V;
  FPrevZoomFactor := dxPDFViewer1.OptionsZoom.ZoomFactor;
  bteActualZoom.EditValue := IntToStr(dxPDFViewer1.OptionsZoom.ZoomFactor) + '%';
end;

function TPDFViewer.ExportToBitmaps(AScale: Double; AExportDialog: TfrmExportToFileDialog): string;
begin
  if sbdSelectFolderDialog.Execute then
  begin
    BeforeExport;
    try
      FProgressDialog.Show;
      Result := sbdSelectFolderDialog.Path;
      dxPDFDocumentExportToPNG(dxPDFViewer1.Document, Result, TfrmExportToBitmaps(AExportDialog).teFilePrefix.Text, AScale, FProgressDialog, dxPDFViewer1.RotationAngle);
    finally
      AfterExport;
    end;
  end;
end;

function TPDFViewer.ExportToTIFF(AScale: Double; AExportDialog: TfrmExportToFileDialog): string;
begin
  if ShowSaveAsDialog('TIFF - Tag Image File Format (*.tiff)|*.tiff;', 'tiff', Result) then
  begin
    BeforeExport;
    try
      FProgressDialog.Show;
      dxPDFDocumentExportToTIFF(dxPDFViewer1.Document, Result, AScale, FProgressDialog, dxPDFViewer1.RotationAngle);
    finally
      AfterExport;
    end;
  end;
end;

function TPDFViewer.ShowSaveAsDialog(const AFilter, AFileExtension: string; var AFileName: string): Boolean;
var
  ASaveDialog: TSaveDialog;
begin
  ASaveDialog := TSaveDialog.Create(nil);
  ASaveDialog.Filter := AFilter;
  try
    Result := ASaveDialog.Execute;
    if Result then
      AFileName := ASaveDialog.FileName + '.' + AFileExtension
    else
      AFileName := '';
  finally
    ASaveDialog.Free;
  end;
end;

procedure TPDFViewer.sseActivePageChange(Sender: TObject);
begin
  if not IsLocked then
    dxPDFViewer1.CurrentPageIndex := sseActivePage.EditValue - 1;
end;

procedure TPDFViewer.tbZoomPropertiesChange(Sender: TObject);
begin
  biStatusBarCurrentZoom.Caption := IntToStr(tbZoom.Position) + '%';
  dxPDFViewer1.OptionsZoom.ZoomFactor := tbZoom.Position;
end;

function TPDFViewer.IsLocked: Boolean;
begin
  Result := FLockCount <> 0;
end;

procedure TPDFViewer.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TPDFViewer.CancelUpdate;
begin
  Dec(FLockCount);
end;

procedure TPDFViewer.UpdateControls;
begin
  if dxPDFViewer1.IsDocumentLoaded and (dxPDFViewer1.Document.Information.FileName <> '') then
    Caption := TPath.GetFullPath(dxPDFViewer1.Document.Information.FileName) + ' - ' + ApplicationCaption
  else
    Caption := ApplicationCaption;

  dxBarButtonExportToPNG.Enabled := dxPDFViewer1.IsDocumentLoaded;
  dxBarButtonExportToTIFF.Enabled := dxPDFViewer1.IsDocumentLoaded;
  tbZoom.Enabled := dxPDFViewer1.IsDocumentLoaded;
  bteActualZoom.Enabled := dxPDFViewer1.IsDocumentLoaded;
  bseActivePage.Enabled := dxPDFViewer1.IsDocumentLoaded;
  dxRibbonStatusBar1.Visible := dxPDFViewer1.IsDocumentLoaded;
  UpdateActivePageEditor(bseActivePage);
  UpdateActivePageEditor(sseActivePage);
end;

procedure TPDFViewer.bbAbortTextSearchClick(Sender: TObject);
begin
  FAbortTextSearch := True;
  bbAbortTextSearch.Enabled := False;
end;

procedure TPDFViewer.dxBarButtonExportToPNGClick(Sender: TObject);
begin
  ShowExportDialog(TfrmExportToBitmaps, ExportToBitmaps);
end;

procedure TPDFViewer.dxBarButtonExportToTIFFClick(Sender: TObject);
begin
  ShowExportDialog(TfrmExportToFileDialog, ExportToTIFF);
end;

procedure TPDFViewer.dxBarLargeButtonCloseClick(Sender: TObject);
begin
  CLose;
end;

procedure TPDFViewer.dxPDFViewer1AttachmentOpen(Sender: TdxPDFCustomViewer; AAttachment: TdxPDFFileAttachment; var AHandled: Boolean);
var
  AMessage: string;
begin
  AMessage := 'The file ' + QuotedStr(AAttachment.FileName) + ' may contain programs, macros, or viruses that could ' + 'potentially harm your computer. Do you want to open it?';
  AHandled := Application.MessageBox(PChar(AMessage), PChar(SecurityWarningCaption), MB_YESNO + MB_ICONWARNING) <> ID_YES;
end;

procedure TPDFViewer.dxPDFViewer1AttachmentSave(Sender: TdxPDFCustomViewer; AAttachment: TdxPDFFileAttachment; var AHandled: Boolean);
var
  ASaveDialog: TSaveDialog;
  AFileName: string;
begin
  AHandled := True;
  ASaveDialog := TSaveDialog.Create(Application);
  try
    ASaveDialog.Filter := '*.*';
    ASaveDialog.FileName := AAttachment.FileName;
    if ASaveDialog.Execute(Handle) then
    begin
      AFileName := TPath.GetDirectoryName(ASaveDialog.FileName) + '\' + TPath.GetFileName(ASaveDialog.FileName);
      TdxPDFUtils.SaveToFile(AFileName, AAttachment.Data);
    end;
  finally
    ASaveDialog.Free;
  end;
end;

procedure TPDFViewer.dxPDFViewer1CustomDrawPreRenderPage(Sender: TObject; ACanvas: TcxCanvas; const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
begin
  DrawPreRenderPage(ACanvas, APageInfo, ADone)
end;

procedure TPDFViewer.dxPDFViewer1CustomDrawPreRenderPageThumbnail(Sender: TObject; ACanvas: TcxCanvas; const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
begin
  DrawPreRenderPage(ACanvas, APageInfo, ADone)
end;

procedure TPDFViewer.dxPDFViewer1DocumentLoaded(ASender: TdxPDFDocument; const AInfo: TdxPDFDocumentLoadInfo);
begin
  dxPDFViewer1.BeginUpdate;
  try
    dxPDFViewer1.OptionsZoom.ZoomFactor := 100;
    dxPDFViewer1.ClearViewStateHistory;
  finally
    dxPDFViewer1.EndUpdate;
  end;
  UpdateControls;
end;

procedure TPDFViewer.dxPDFViewer1DocumentUnloaded(Sender: TObject);
begin
  cxBarEditItem4.EditValue := 0;
  UpdateControls;
end;

procedure TPDFViewer.dxPDFViewer1HideFindPanel(Sender: TObject);
begin
  dxSearchProgressBar.Visible := False;
end;

procedure TPDFViewer.dxPDFViewer1HyperlinkClick(Sender: TdxPDFCustomViewer; const AURI: string; var AHandled: Boolean);
var
  AMessage: string;
begin
  AMessage := 'The document is trying to access an external resource by using the following URL:' + dxCRLF + QuotedStr(AURI) + dxCRLF + 'Do you want to open it nevertheless?';
  if Application.MessageBox(PChar(AMessage), PChar(SecurityWarningCaption), MB_YESNO + MB_ICONWARNING) = ID_YES then
    dxShellExecute(AURI, SW_SHOWMAXIMIZED);
  AHandled := True;
end;

procedure TPDFViewer.dxPDFViewer1SearchProgress(Sender: TdxPDFDocument; APageIndex, APercent: Integer);
begin
  cxBarEditItem4.EditValue := APercent;
  Application.ProcessMessages;
  if FAbortTextSearch then
  begin
    FAbortTextSearch := False;
    bbAbortTextSearch.Enabled := False;
    Abort;
  end
  else
    bbAbortTextSearch.Enabled := APercent < 100;
end;

procedure TPDFViewer.dxPDFViewer1SelectedPageChanged(Sender: TObject; APageIndex: Integer);
begin
  BeginUpdate;
  try
    bseActivePage.EditValue := dxPDFViewer1.CurrentPageIndex + 1;
    sseActivePage.EditValue := Min(Max(bseActivePage.EditValue, 1), dxPDFViewer1.PageCount);
    sbPageCount.Caption := ' of ' + IntToStr(dxPDFViewer1.PageCount);
  finally
    CancelUpdate;
  end;
end;

procedure TPDFViewer.dxPDFViewer1ShowFindPanel(Sender: TObject);
begin
  dxSearchProgressBar.Visible := True;
end;

procedure TPDFViewer.dxPDFViewer1ZoomFactorChanged(Sender: TObject);
begin
  bteActualZoom.EditValue := dxPDFViewer1.OptionsZoom.ZoomFactor;
  tbZoom.Position := dxPDFViewer1.OptionsZoom.ZoomFactor;
end;

procedure TPDFViewer.ShowExportDialog(ADialogClass: TPDFViewerExportDialogClass; AExportFunc: TPDFViewerExportFunc);
var
  AFileName: string;
  AExportDialog: TfrmExportToFileDialog;
  ANeedOpenAfterExport: Boolean;
begin
  AExportDialog := ADialogClass.Create(Self);
  try
    if AExportDialog.ShowModal = mrOk then
    begin
      ANeedOpenAfterExport := AExportDialog.cbOpenAfterExport.Checked;
      AFileName := AExportFunc(AExportDialog.sePageZoom.EditValue / 100, AExportDialog);
      if ANeedOpenAfterExport and (AFileName <> '') then
        dxShellExecute(AFileName);
    end;
  finally
    AExportDialog.Free;
  end;
end;

procedure TPDFViewer.UpdateActivePageEditor(ASpinEdit: TcxBarEditItem);
begin
  ASpinEdit.Enabled := dxPDFViewer1.IsDocumentLoaded;
  (ASpinEdit.Properties as TcxSpinEditProperties).MaxValue := dxPDFViewer1.PageCount;
  (ASpinEdit.Properties as TcxSpinEditProperties).MinValue := 1;
  ASpinEdit.EditValue := Max(dxPDFViewer1.CurrentPageIndex, 1);
end;

procedure TPDFViewer.actExitExecute(Sender: TObject);
begin
  CLose;
end;

procedure TPDFViewer.AfterExport;
begin
  FProgressDialog.Free;
end;

procedure TPDFViewer.BeforeExport;
begin
  FProgressDialog := TfrmProgress.Create(Self);
end;

procedure TPDFViewer.DrawPreRenderPage(ACanvas: TcxCanvas; const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean);
begin
  ADone := APageInfo.Thumbnail = nil;
  if ADone then
  begin
    ACanvas.Font.Size := Trunc(cxRectWidth(APageInfo.Bounds) / 20);
    cxDrawText(ACanvas, 'Page rendering...', APageInfo.Bounds, DT_CENTER or DT_VCENTER or DT_SINGLELINE, dxPDFViewer1.LookAndFeel.Painter.PrintPreviewBackgroundTextColor);
  end;
end;

procedure TPDFViewer.InitializeLookAndFeel;
begin
  cxLookAndFeelController1.NativeStyle := False;
  // cxLookAndFeelController1.SkinName := sdxDefaultSkinName;
  dxSkinChooserGalleryItem1.SelectedSkinName := RootLookAndFeel.Painter.LookAndFeelName;
  dxRibbon1.ColorSchemeName := cxLookAndFeelController1.SkinName;
end;

procedure TPDFViewer.FormCreate(Sender: TObject);
begin

  // DisableAero := True;
  InitializeLookAndFeel;
  dxPDFViewer1.OptionsZoom.ZoomStep := 3;
  dxPDFViewer1.OptionsLockedStateImage.ShowText := True;
  dxPDFViewer1.OptionsLockedStateImage.Effect := lsieLight;
  dxPDFViewer1.OptionsFindPanel.HighlightSearchResults := True;
  dxPDFViewer1ZoomFactorChanged(nil);
end;

class function TPDFViewer.LoadFromFile(AFileName: string): Integer;
var
  Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(AFileName, fmOpenRead);
    Result := LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

class function TPDFViewer.LoadFromStream(const aStream: TStream): Integer;
begin
  with TPDFViewer.Create(nil) do
    try
      dxPDFViewer1.LoadFromStream(aStream);
      Result := ShowModal;
    finally
      Free;
    end;
end;

end.
