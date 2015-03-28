unit pu_editplan;

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

uses  u_global, u_utils, u_ccdconfig, XMLConf,
  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, Grids, ExtCtrls;

type

  { Tf_EditPlan }

  Tf_EditPlan = class(TForm)
    BtnClose: TButton;
    BtnAddStep: TButton;
    BtnDeleteStep: TButton;
    CheckBoxRepeat: TCheckBox;
    Label14: TLabel;
    Panel6: TPanel;
    Panel7: TPanel;
    PanelRepeat: TPanel;
    Preview: TCheckBox;
    Desc: TEdit;
    PreviewExposure: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    RepeatCount: TEdit;
    Delay: TEdit;
    FrameType: TComboBox;
    Filter: TComboBox;
    Binning: TComboBox;
    Exposure: TEdit;
    Count: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblStepNum: TLabel;
    PlanName: TLabel;
    StepList: TStringGrid;
    procedure BtnAddStepClick(Sender: TObject);
    procedure BtnDeleteStepClick(Sender: TObject);
    procedure CheckBoxRepeatChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FrameTypeChange(Sender: TObject);
    procedure StepChange(Sender: TObject);
    procedure StepListSelection(Sender: TObject; aCol, aRow: Integer);
  private
    { private declarations }
    LockStep: boolean;
    originalFilter: array[0..99] of string;
    procedure ResetSteps;
  public
    { public declarations }
    procedure ClearStepList;
    procedure ReadStep(pfile:TCCDconfig; i: integer; var p:Tplan);
  end;

var
  f_EditPlan: Tf_EditPlan;

implementation

{$R *.lfm}

{ Tf_EditPlan }

procedure Tf_EditPlan.FormCreate(Sender: TObject);
begin
 LockStep:=false;
end;

procedure Tf_EditPlan.FormDestroy(Sender: TObject);
begin
 ClearStepList;
end;

procedure Tf_EditPlan.ReadStep(pfile:TCCDconfig; i: integer; var p:Tplan);
var str,buf: string;
    j:integer;
begin
  str:=pfile.GetValue('/Steps/Step'+inttostr(i)+'/Description','');
  p.description:=str;
  str:=pfile.GetValue('/Steps/Step'+inttostr(i)+'/FrameType','Light');
  j:=FrameType.Items.IndexOf(str);
  if j<0 then j:=0;
  p.frtype:=TFrameType(j);
  str:=pfile.GetValue('/Steps/Step'+inttostr(i)+'/Binning','1x1');
  j:=Binning.Items.IndexOf(str);
  if j<0 then j:=0;
  j:=pos('x',str);
  if j>0 then begin
     buf:=trim(copy(str,1,j-1));
     p.binx:=StrToIntDef(buf,1);
     buf:=trim(copy(str,j+1,9));
     p.biny:=StrToIntDef(buf,1);
  end else begin
    p.binx:=1;
    p.biny:=1;
  end;
  str:=pfile.GetValue('/Steps/Step'+inttostr(i)+'/Filter','');
  originalFilter[i]:=str;
  j:=Filter.Items.IndexOf(str);
  if j<0 then j:=0;
  p.filter:=j;
  p.exposure:=pfile.GetValue('/Steps/Step'+inttostr(i)+'/Exposure',1.0);
  p.previewexposure:=pfile.GetValue('/Steps/Step'+inttostr(i)+'/PreviewExposure',1.0);
  p.preview:=pfile.GetValue('/Steps/Step'+inttostr(i)+'/Preview',false);
  p.count:=trunc(pfile.GetValue('/Steps/Step'+inttostr(i)+'/Count',1));
  p.repeatcount:=trunc(pfile.GetValue('/Steps/Step'+inttostr(i)+'/RepeatCount',1));
  p.delay:=pfile.GetValue('/Steps/Step'+inttostr(i)+'/Delay',1.0);
end;

procedure Tf_EditPlan.FormShow(Sender: TObject);
var pfile: TCCDconfig;
    fn: string;
    i,n:integer;
    p: TPlan;
  procedure NewPlan;
  begin
    StepList.RowCount:=2;
    p:=TPlan.Create;
    StepList.Cells[0,1]:='1';
    StepList.Cells[1,1]:=p.description_str;
    StepList.Objects[0,1]:=p;
    StepListSelection(nil,0,1);
  end;
begin
  ClearStepList;
  fn:=slash(ConfigDir)+PlanName.Caption+'.plan';
  if FileExistsUTF8(fn) then begin
    pfile:=TCCDconfig.Create(self);
    pfile.Filename:=fn;
    n:=pfile.GetValue('/StepNum',0);
    if n=0 then begin
      NewPlan;
    end else begin
      StepList.RowCount:=n+1;
      for i:=1 to n do begin
        p:=TPlan.Create;
        ReadStep(pfile,i,p);
        StepList.Cells[0,i]:=IntToStr(i);
        StepList.Cells[1,i]:=p.description_str;
        StepList.Objects[0,i]:=p;
      end;
      pfile.Free;
      StepListSelection(nil,0,1);
    end;
  end else begin
    NewPlan;
  end;
end;

procedure Tf_EditPlan.ClearStepList;
var i: integer;
begin
  for i:=1 to StepList.RowCount-1 do begin
    if StepList.Objects[0,i]<>nil then StepList.Objects[0,i].Free;
    StepList.Objects[0,i]:=nil;
  end;
  StepList.RowCount:=1;
end;

procedure Tf_EditPlan.FrameTypeChange(Sender: TObject);
begin
  case FrameType.ItemIndex of
    0 : begin   // Light

        end;
    1 : begin   // Bias
           Exposure.Text:='0.01';
           Filter.ItemIndex:=0;
           CheckBoxRepeat.Checked:=false;
        end;
    2 : begin   // Dark
           Filter.ItemIndex:=0;
           CheckBoxRepeat.Checked:=false;
        end;
    3 : begin   // Flat
           CheckBoxRepeat.Checked:=false;
        end;
  end;
  StepChange(Sender);
end;

procedure Tf_EditPlan.StepListSelection(Sender: TObject; aCol, aRow: Integer);
var n:integer;
    p: TPlan;
begin
  LockStep:=true;
  n:=aRow;
  lblStepNum.Caption:=IntToStr(n);
  p:=TPlan(StepList.Objects[0,n]);
  Desc.Text:=p.description_str;
  FrameType.ItemIndex:=ord(p.frtype);
  Exposure.Text:=p.exposure_str;
  Binning.Text:=p.binning_str;
  Filter.ItemIndex:=p.filter;
  Count.Text:=p.count_str;
  RepeatCount.Text:=p.repeatcount_str;
  Delay.Text:=p.delay_str;
  PreviewExposure.Text:=p.previewexposure_str;
  Preview.Checked:=p.preview;
  CheckBoxRepeat.Checked:=(p.repeatcount>1);
  PanelRepeat.Visible:=CheckBoxRepeat.Checked;
  LockStep:=false;
end;

procedure Tf_EditPlan.StepChange(Sender: TObject);
var n,j:integer;
    p: TPlan;
    str,buf: string;
begin
  if LockStep then exit;
  n:=StepList.Row;
  if n < 1 then exit;
  p:=TPlan(StepList.Objects[0,n]);
  p.description:=Desc.Text;
  p.frtype:=TFrameType(FrameType.ItemIndex);
  p.exposure:=StrToFloatDef(Exposure.Text,1);
  str:=Binning.Text;
  j:=pos('x',str);
  if j>0 then begin
     buf:=trim(copy(str,1,j-1));
     p.binx:=StrToIntDef(buf,1);
     buf:=trim(copy(str,j+1,9));
     p.biny:=StrToIntDef(buf,1);
  end else begin
    p.binx:=1;
    p.biny:=1;
  end;
  p.filter:=Filter.ItemIndex;
  p.count:=StrToIntDef(Count.Text,1);
  p.repeatcount:=StrToIntDef(RepeatCount.Text,1);
  p.delay:=StrToFloatDef(Delay.Text,1);
  p.previewexposure:=StrToFloatDef(PreviewExposure.Text,1);
  p.preview:=Preview.Checked;
  StepList.Cells[1,n]:=p.description;
end;

procedure Tf_EditPlan.CheckBoxRepeatChange(Sender: TObject);
begin
  if CheckBoxRepeat.Checked then begin
     PanelRepeat.Visible:=true;
     RepeatCount.Text:='2';
  end else begin
     PanelRepeat.Visible:=false;
     RepeatCount.Text:='1';
  end;
  StepChange(nil);
end;

procedure Tf_EditPlan.BtnAddStepClick(Sender: TObject);
var txt:string;
    i: integer;
    p: TPlan;
begin
  txt:=FormEntry(self,'Step description','');
  p:=TPlan.Create;
  StepList.RowCount:=StepList.RowCount+1;
  i:=StepList.RowCount-1;
  StepList.Cells[0,i]:=IntToStr(i);
  StepList.Cells[1,i]:=txt;
  StepList.Objects[0,i]:=p;
  StepList.Row:=i;
  Desc.Text:=txt;
  StepChange(nil);
end;

procedure Tf_EditPlan.BtnDeleteStepClick(Sender: TObject);
var i: integer;
    str: string;
begin
  i:=StepList.Row;
  if i>0 then begin
     str:=StepList.Cells[0,i]+', '+StepList.Cells[1,i];
     if MessageDlg('Delete step '+str+' ?',mtConfirmation,mbYesNo,0)=mrYes then begin
        if StepList.Objects[0,i]<>nil then StepList.Objects[0,i].Free;
        StepList.Objects[0,i]:=nil;
        StepList.DeleteRow(i);
     end;
  end;
  ResetSteps;
end;

procedure Tf_EditPlan.ResetSteps;
var i: integer;
begin
  for i:=1 to StepList.RowCount-1 do begin
    StepList.Cells[0,i]:=IntToStr(i);
  end;
end;

procedure Tf_EditPlan.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var pfile: TCCDconfig;
    fn,str: string;
    i,n,k: integer;
    p: TPlan;
begin
  fn:=slash(ConfigDir)+PlanName.Caption+'.plan';
  pfile:=TCCDconfig.Create(self);
  pfile.Filename:=fn;
  pfile.Clear;
  n:=StepList.RowCount-1;
  pfile.SetValue('/PlanName',PlanName.Caption);
  pfile.SetValue('/StepNum',n);
  for i:=1 to n do begin
    p:=TPlan(StepList.Objects[0,i]);
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/Description',p.description);
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/FrameType',FrameType.Items[ord(p.frtype)]);
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/Exposure',p.exposure);
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/Binning',IntToStr(p.binx)+'x'+IntToStr(p.biny));
    if Filter.Items.Count>0 then begin // do not erase the filters if the filter wheel is not connected
      k:=p.filter;
      if (k<0)or(k>Filter.Items.Count-1) then str:=''
         else str:=Filter.Items[k];
    end else begin
      str:=originalFilter[i];
    end;
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/Filter',str);
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/Count',p.count);
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/RepeatCount',p.repeatcount);
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/Delay',p.delay);
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/PreviewExposure',p.previewexposure);
    pfile.SetValue('/Steps/Step'+inttostr(i)+'/Preview',p.preview);
  end;
  pfile.Flush;
  pfile.Free;
  ModalResult:=mrOK;
end;


end.

