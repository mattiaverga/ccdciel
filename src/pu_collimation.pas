unit pu_collimation;

{$mode objfpc}{$H+}
{
Copyright (C) 2020 Patrick Chevalley

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

uses  u_translation, u_global, UScaleDPI,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Spin, ComCtrls;

type

  { Tf_collimation }

  Tf_collimation = class(TForm)
    BtnApplySplit: TButton;
    BtnStart: TButton;
    BtnStartSplit: TButton;
    BtnStop: TButton;
    BtnCenter: TButton;
    BtnStopSplit: TButton;
    CircleNum: TSpinEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TrackBarZoom: TTrackBar;
    TrackBarMargin: TTrackBar;
    procedure BtnApplySplitClick(Sender: TObject);
    procedure BtnCenterClick(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure BtnStartSplitClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure BtnStopSplitClick(Sender: TObject);
    procedure CircleNumChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TrackBarMarginChange(Sender: TObject);
    procedure TrackBarZoomChange(Sender: TObject);
  private
    FonStart,FonStop,FonCircleChange,FonCenterStar: TNotifyEvent;
    FonStartSplit,FonStopSplit,FonApplySplit: TNotifyEvent;
  public
    procedure SetLang;
    property onStart: TNotifyEvent read FonStart write FonStart;
    property onStop: TNotifyEvent read FonStop write FonStop;
    property onCenterStar: TNotifyEvent read FonCenterStar write FonCenterStar;
    property onCircleChange: TNotifyEvent read FonCircleChange write FonCircleChange;
    property onStartSplit: TNotifyEvent read FonStartSplit write FonStartSplit;
    property onStopSplit: TNotifyEvent read FonStopSplit write FonStopSplit;
    property onApplySplit: TNotifyEvent read FonApplySplit write FonApplySplit;
  end;

var
  f_collimation: Tf_collimation;

implementation

{$R *.lfm}

{ Tf_collimation }

procedure Tf_collimation.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_collimation.SetLang;
begin
  Caption:=rsCollimation;
  TabSheet1.Caption:=rsSingleStar;
  Label1.Caption:=rsNumberOfCirc;
  Label2.Caption:=Format(StringReplace(rsCenterABrigh,' %s ','%s',[rfReplaceAll]),[crlf,crlf]);
  BtnCenter.Caption:=rsCenter;
  BtnStart.Caption:=rsStart;
  BtnStop.Caption:=rsStop;
  TabSheet2.Caption:=rs9PanelImage;
  label5.Caption:=Format(StringReplace(rsSplitTheImag,' %s ','%s',[rfReplaceAll]),[crlf]);
  label3.Caption:=rsZoom;
  label4.Caption:=rsMarginOffset;
  BtnStartSplit.Caption:=rsStart;
  BtnStopSplit.Caption:=rsStop;
  BtnApplySplit.Caption:=rsSet;
  TrackBarZoom.Hint:='1'+ellipsis+'5 x';
end;

procedure Tf_collimation.BtnStartClick(Sender: TObject);
begin
  if Assigned(FonStart) then FonStart(self);
end;

procedure Tf_collimation.BtnCenterClick(Sender: TObject);
begin
  if Assigned(FonCenterStar) then FonCenterStar(self);
end;

procedure Tf_collimation.BtnStopClick(Sender: TObject);
begin
  if Assigned(FonStop) then FonStop(self);
end;

procedure Tf_collimation.CircleNumChange(Sender: TObject);
begin
  if Assigned(FonCircleChange) then FonCircleChange(self);
end;

procedure Tf_collimation.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FonStop) then FonStop(self);
  if Assigned(FonStopSplit) then FonStopSplit(self);
end;

procedure Tf_collimation.BtnStartSplitClick(Sender: TObject);
begin
  if Assigned(FonStartSplit) then FonStartSplit(self);
end;

procedure Tf_collimation.BtnStopSplitClick(Sender: TObject);
begin
  if Assigned(FonStopSplit) then FonStopSplit(self);
end;

procedure Tf_collimation.BtnApplySplitClick(Sender: TObject);
begin
  if Assigned(FonApplySplit) then FonApplySplit(self);
end;

procedure Tf_collimation.TrackBarMarginChange(Sender: TObject);
begin
  SplitMargin:=TrackBarMargin.Position;
end;

procedure Tf_collimation.TrackBarZoomChange(Sender: TObject);
begin
  SplitZoom:=TrackBarZoom.Position/10;
end;

end.

