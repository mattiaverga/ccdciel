unit pu_options;

{$mode objfpc}{$H+}

{
Copyright (C) 2015 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>. 

}

interface

uses u_utils, UScaleDPI,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ValEdit, Grids, EditBtn, enhedits;

type

  { Tf_option }

  Tf_option = class(TForm)
    AutofocusMeanNumPoint: TEdit;
    AutofocusMeanMovement: TEdit;
    BtnDisableBacklash: TButton;
    BtnDisableFocuserTemp: TButton;
    ButtonDir: TButton;
    BayerMode: TComboBox;
    Autofocusmode: TRadioGroup;
    AutofocusMinSpeed: TEdit;
    AutofocusMaxSpeed: TEdit;
    AutofocusNearHFD: TEdit;
    AutofocusExposure: TEdit;
    AutofocusNearNum: TEdit;
    BPMsigma: TEdit;
    AutofocusBinning: TEdit;
    AutofocusTolerance: TEdit;
    AstUseScript: TCheckBox;
    AstCustScript: TEdit;
    CameraAutoCool: TCheckBox;
    AutofocusMinSNR: TEdit;
    AutofocusStartHFD: TEdit;
    AutofocusPrecisionSlew: TEdit;
    FocuserTempCoeff: TEdit;
    GroupBox16: TGroupBox;
    GroupBox17: TGroupBox;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Notebook3: TNotebook;
    PageLinGuider: TPage;
    PagePHD: TPage;
    LinGuiderSocket: TEdit;
    LinGuiderHostname: TEdit;
    LinGuiderPort: TEdit;
    PlatesolveWait: TEdit;
    Label79: TLabel;
    Label80: TLabel;
    PlatesolveFolder: TEdit;
    ElevationMin: TEdit;
    Label78: TLabel;
    platesolve: TGroupBox;
    HorizonFile: TFileNameEdit;
    Label76: TLabel;
    Label77: TLabel;
    MeridianFlipAutofocus: TCheckBox;
    MeridianFlipCalibrate: TCheckBox;
    Page4: TPage;
    PageHNSKY: TPage;
    rbLinUnixSocket: TRadioButton;
    rbLinTCP: TRadioButton;
    SlewDelay: TEdit;
    TemperatureSlopeActive: TCheckBox;
    TemperatureSlope: TEdit;
    CameraAutoCoolTemp: TEdit;
    GroupBox14: TGroupBox;
    GroupBox15: TGroupBox;
    Label74: TLabel;
    Label75: TLabel;
    PanelTemperatureSlope: TPanel;
    StarLostRestart: TEdit;
    StarLostCancel: TEdit;
    FileBin: TCheckBox;
    FileExp: TCheckBox;
    GroupBox13: TGroupBox;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    SubfolderBin: TCheckBox;
    SubfolderExp: TCheckBox;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    SlewFilter: TComboBox;
    FocusStarMag: TComboBox;
    FocuserBacklash: TEdit;
    GroupBox10: TGroupBox;
    GroupBacklash: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    AutofocusNotebook: TNotebook;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    MinutesPastMeridianMin: TEdit;
    PageMean: TPage;
    PageNone: TPage;
    PageVcurve: TPage;
    PageIterative: TPage;
    PanelNearFocus: TPanel;
    PanelAutofocus: TPanel;
    AutofocusMoveDirIn: TRadioButton;
    AutofocusMoveDirOut: TRadioButton;
    FilterList: TStringGrid;
    TabSheet10: TTabSheet;
    RedBalance: TTrackBar;
    GreenBalance: TTrackBar;
    BlueBalance: TTrackBar;
    TabSheet11: TTabSheet;
    VideoPreviewRate: TEdit;
    VideoGroup: TGroupBox;
    Label44: TLabel;
    Label45: TLabel;
    MeridianWarning: TLabel;
    MeridianFlipPauseTimeout: TEdit;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    MeridianFlipPauseBefore: TCheckBox;
    DebayerPreview: TCheckBox;
    CheckBoxLocalCdc: TCheckBox;
    CalibrationDelay: TEdit;
    AstrometryTimeout: TEdit;
    CygwinPath: TEdit;
    CaptureDir: TEdit;
    MeridianFlipPauseAfter: TCheckBox;
    MinutesPastMeridian: TEdit;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    hemis: TComboBox;
    Label33: TLabel;
    CygwinPanel: TPanel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    latdeg: TFloatEdit;
    LatitudeGroup: TGroupBox;
    latmin: TLongEdit;
    latsec: TFloatEdit;
    long: TComboBox;
    longdeg: TFloatEdit;
    LongitudeGroup: TGroupBox;
    longmin: TLongEdit;
    longsec: TFloatEdit;
    MeridianOption: TRadioGroup;
    MeridianFlipPanel: TPanel;
    Page3: TPage;
    RefColor: TRadioGroup;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SlewPrec: TEdit;
    SlewRetry: TEdit;
    SlewExp: TEdit;
    SlewBin: TEdit;
    GroupBox7: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    OtherOptions: TEdit;
    GroupBoxSkychart: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Notebook2: TNotebook;
    PageSkychart: TPage;
    PageSamp: TPage;
    PanelRemoteCdc: TPanel;
    CdChostname: TEdit;
    CdCport: TEdit;
    PlanetariumBox: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    DitherRAonly: TCheckBox;
    Label23: TLabel;
    PrecSlewBox: TRadioGroup;
    SettlePixel: TEdit;
    SettleMinTime: TEdit;
    SettleMaxTime: TEdit;
    FileFiltername: TCheckBox;
    FileDate: TCheckBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    FileObjname: TCheckBox;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    DitherPixel: TEdit;
    SubfolderStep: TCheckBox;
    SubfolderSequence: TCheckBox;
    SubfolderObjname: TCheckBox;
    SubfolderFrametype: TCheckBox;
    PHDhostname: TEdit;
    PHDport: TEdit;
    ElbrusFolder: TEdit;
    ElbrusUnixpath: TEdit;
    GroupBox3: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Notebook1: TNotebook;
    ObserverName: TEdit;
    ObservatoryName: TEdit;
    Page1: TPage;
    Page2: TPage;
    AutoguiderBox: TRadioGroup;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TelescopeName: TEdit;
    GroupBox4: TGroupBox;
    elbrus: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label5: TLabel;
    PageControl1: TPageControl;
    Plot: TCheckBox;
    Downsample: TEdit;
    ResolverBox: TRadioGroup;
    SourcesLimit: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Tolerance: TEdit;
    Label7: TLabel;
    MinRadius: TEdit;
    Label6: TLabel;
    PixelSizeFromCamera: TCheckBox;
    FocaleFromTelescope: TCheckBox;
    PixelSize: TEdit;
    Focale: TEdit;
    FocusWindow: TEdit;
    astrometrynet: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Logtofile: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label14: TLabel;
    Panel1: TPanel;
    StarWindow: TEdit;
    RefTreshold: TTrackBar;
    procedure AutofocusmodeClick(Sender: TObject);
    procedure AutoguiderBoxClick(Sender: TObject);
    procedure BtnDisableBacklashClick(Sender: TObject);
    procedure BtnDisableFocuserTempClick(Sender: TObject);
    procedure CheckStartNearHFD(Sender: TObject);
    procedure ButtonDirClick(Sender: TObject);
    procedure CheckBoxLocalCdcChange(Sender: TObject);
    procedure FocaleFromTelescopeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure latChange(Sender: TObject);
    procedure longChange(Sender: TObject);
    procedure MeridianOptionClick(Sender: TObject);
    procedure PixelSizeFromCameraChange(Sender: TObject);
    procedure PlanetariumBoxClick(Sender: TObject);
    procedure rbLinSocketChange(Sender: TObject);
    procedure ResolverBoxClick(Sender: TObject);
    procedure TemperatureSlopeActiveClick(Sender: TObject);
  private
    { private declarations }
    FGetPixelSize, FGetFocale: TNotifyEvent;
    Flatitude, Flongitude: double;
    Lockchange: boolean;
    SaveTemperatureSlope: string;
    function GetResolver: integer;
    procedure SetResolver(value:integer);
    procedure SetLatitude(value:double);
    procedure SetLongitude(value:double);
    procedure SetLinGuiderUseUnixSocket(value: boolean);
    function  GetLinGuiderUseUnixSocket: boolean;
  public
    { public declarations }
    property Resolver: integer read GetResolver write SetResolver;
    property Latitude: double read Flatitude write SetLatitude;
    property Longitude: double read Flongitude write SetLongitude;
    property LinGuiderUseUnixSocket: boolean read GetLinGuiderUseUnixSocket write SetLinGuiderUseUnixSocket;
    property onGetPixelSize : TNotifyEvent read FGetPixelSize write FGetPixelSize;
    property onGetFocale : TNotifyEvent read FGetFocale write FGetFocale;
  end;

var
  f_option: Tf_option;

implementation

{$R *.lfm}

{ Tf_option }


procedure Tf_option.FormCreate(Sender: TObject);
begin
  {$ifdef mswindows}
    CygwinPanel.Visible:=true;
    ElbrusUnixpath.Visible:=false;
    Label13.Visible:=false;
  {$endif}
  ScaleDPI(Self);
  Lockchange:=false;
  PageControl1.ActivePageIndex:=0;
end;

procedure Tf_option.FormShow(Sender: TObject);
begin
  SaveTemperatureSlope:=TemperatureSlope.Text;
  f_option.TemperatureSlopeActive.Checked:=(f_option.TemperatureSlope.Text<>'0.0');
end;

procedure Tf_option.latChange(Sender: TObject);
begin
  if LockChange then exit;
  if frac(latdeg.Value)>0 then
    Flatitude:=latdeg.value
  else
    Flatitude:=latdeg.value+latmin.value/60+latsec.value/3600;
  if hemis.Itemindex>0 then Flatitude:=-Flatitude;
end;

procedure Tf_option.longChange(Sender: TObject);
begin
  if LockChange then exit;
  if frac(longdeg.Value)>0 then
     Flongitude:=longdeg.value
  else
     Flongitude:=longdeg.value+longmin.value/60+longsec.value/3600;
  if long.Itemindex>0 then Flongitude:=-Flongitude;
end;

procedure Tf_option.MeridianOptionClick(Sender: TObject);
begin
  MeridianFlipPanel.Visible:=(MeridianOption.ItemIndex=1);
  if MeridianOption.ItemIndex<>1 then begin
     MinutesPastMeridian.Text:='0';
     MinutesPastMeridianMin.Text:='0';
  end;
end;

procedure Tf_option.SetLatitude(value:double);
var d,m,s : string;
begin
try
  LockChange:=true;
  Flatitude:=value;
  ArToStr4(abs(value),'0.0',d,m,s);
  latdeg.Text:=d;
  latmin.Text:=m;
  latsec.Text:=s;
  if value>=0 then hemis.Itemindex:=0
              else hemis.Itemindex:=1;
finally
  LockChange:=false;
end;
end;

procedure Tf_option.SetLongitude(value:double);
var d,m,s : string;
begin
try
  LockChange:=true;
  Flongitude:=value;
  ArToStr4(abs(value),'0.0',d,m,s);
  longdeg.Text:=d;
  longmin.Text:=m;
  longsec.Text:=s;
  if value>=0 then long.Itemindex:=0
                   else long.Itemindex:=1;
finally
  LockChange:=false;
end;
end;

procedure Tf_option.PixelSizeFromCameraChange(Sender: TObject);
begin
  PixelSize.Enabled:=not PixelSizeFromCamera.Checked;
  if (not PixelSize.Enabled) and (assigned(FGetPixelSize)) then
      FGetPixelSize(self);
end;

procedure Tf_option.FocaleFromTelescopeChange(Sender: TObject);
begin
  Focale.Enabled:=not FocaleFromTelescope.Checked;
  if (not Focale.Enabled) and (assigned(FGetFocale)) then
      FGetFocale(self);
end;

procedure Tf_option.PlanetariumBoxClick(Sender: TObject);
begin
  Notebook2.PageIndex:=PlanetariumBox.ItemIndex;
end;

procedure Tf_option.CheckBoxLocalCdcChange(Sender: TObject);
begin
  if CheckBoxLocalCdc.Checked then begin
    CdChostname.Text:='localhost';
    CdCport.Text:='';
    PanelRemoteCdc.Visible:=false;
  end else begin
    PanelRemoteCdc.Visible:=true;
  end;
end;

procedure Tf_option.ButtonDirClick(Sender: TObject);
begin
SelectDirectoryDialog1.InitialDir:=CaptureDir.text;
SelectDirectoryDialog1.FileName:=CaptureDir.text;
if SelectDirectoryDialog1.Execute then CaptureDir.text:=SelectDirectoryDialog1.FileName;
end;

procedure Tf_option.AutofocusmodeClick(Sender: TObject);
begin
  AutofocusNotebook.PageIndex:=Autofocusmode.ItemIndex;
  PanelAutofocus.Visible:=(Autofocusmode.ItemIndex<3);
  PanelNearFocus.Visible:=(Autofocusmode.ItemIndex<>1);
end;

procedure Tf_option.AutoguiderBoxClick(Sender: TObject);
begin
  Notebook3.PageIndex:=AutoguiderBox.ItemIndex;
  groupbox6.Visible:=(AutoguiderBox.ItemIndex=0);
  groupbox13.Visible:=(AutoguiderBox.ItemIndex=0);
  DitherRAonly.Visible:=(AutoguiderBox.ItemIndex=0);
end;

procedure Tf_option.BtnDisableBacklashClick(Sender: TObject);
begin
 FocuserBacklash.Text:='0';
end;

procedure Tf_option.BtnDisableFocuserTempClick(Sender: TObject);
begin
  FocuserTempCoeff.Text:='0.0';
end;

procedure Tf_option.CheckStartNearHFD(Sender: TObject);
var a,b: double;
begin
  a:=StrToFloatDef(AutofocusStartHFD.Text,-9999);
  b:=StrToFloatDef(AutofocusNearHFD.Text,-9999);
  if (a<0)or(b<0) then exit;
  if a<=b then ShowMessage('Near HFD must be smaller than Start HFD!');
end;

function Tf_option.GetResolver: integer;
begin
  result:=ResolverBox.ItemIndex;
end;

procedure Tf_option.SetResolver(value:integer);
begin
  if (value<0)or(value>3) then exit;
  ResolverBox.ItemIndex:=value;
  ResolverBoxClick(nil);
end;

procedure Tf_option.ResolverBoxClick(Sender: TObject);
begin
  Notebook1.PageIndex:=ResolverBox.ItemIndex;
end;

procedure Tf_option.TemperatureSlopeActiveClick(Sender: TObject);
begin
  if TemperatureSlopeActive.Checked then begin
     TemperatureSlope.Text:=SaveTemperatureSlope;
     PanelTemperatureSlope.Visible:=true;
  end
  else begin
     TemperatureSlope.Text:='0';
     PanelTemperatureSlope.Visible:=false;
  end;
end;

procedure Tf_option.SetLinGuiderUseUnixSocket(value: boolean);
begin
{$ifdef mswindows}
value:=false;
{$endif}
rbLinUnixSocket.Checked:=value;
rbLinTCP.Checked:=not value;
end;

function Tf_option.GetLinGuiderUseUnixSocket: boolean;
begin
result:=rbLinUnixSocket.Checked;
end;

procedure Tf_option.rbLinSocketChange(Sender: TObject);
begin
{$ifdef mswindows}
   if rbLinUnixSocket.Checked then begin
      rbLinUnixSocket.Checked:=false;
      rbLinTCP.Checked:=true;
   end;
{$endif}
end;

end.

