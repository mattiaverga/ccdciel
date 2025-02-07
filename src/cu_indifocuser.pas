unit cu_indifocuser;

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

uses cu_focuser, indibaseclient, indibasedevice, indiapi, indicom, u_translation,
     u_global, u_utils, math, ExtCtrls, Forms, Classes, SysUtils;

type

T_indifocuser = class(T_focuser)
 private
   indiclient: TIndiBaseClient;
   InitTimer: TTimer;
   ConnectTimer: TTimer;
   ReadyTimer: TTimer;
   FocuserDevice: Basedevice;
   connectprop: ISwitchVectorProperty;
   connecton,connectoff: ISwitch;
   FocusMotion: ISwitchVectorProperty;
   FocusInward,FocusOutward: ISwitch;
   FocusSpeed: INumberVectorProperty;
   FocusTimer: INumberVectorProperty;
   FocusRelativePosition: INumberVectorProperty;
   FocusAbsolutePosition: INumberVectorProperty;
   FocusAbort: ISwitchVectorProperty;
   FocusPreset: INumberVectorProperty;
   FocusGotoPreset: ISwitchVectorProperty;
   FocusTemperature: INumberVectorProperty;
   configprop: ISwitchVectorProperty;
   configload,configsave: ISwitch;
   Fready,Fconnected,FConnectDevice: boolean;
   Findiserver, Findiserverport, Findidevice: string;
   procedure CreateIndiClient;
   procedure InitTimerTimer(Sender: TObject);
   procedure ConnectTimerTimer(Sender: TObject);
   procedure ReadyTimerTimer(Sender: TObject);
   procedure ClearStatus;
   procedure CheckStatus;
   procedure NewDevice(dp: Basedevice);
   procedure NewMessage(mp: IMessage);
   procedure NewProperty(indiProp: IndiProperty);
   procedure NewNumber(nvp: INumberVectorProperty);
   procedure NewText(tvp: ITextVectorProperty);
   procedure NewSwitch(svp: ISwitchVectorProperty);
   procedure NewLight(lvp: ILightVectorProperty);
   procedure DeleteDevice(dp: Basedevice);
   procedure DeleteProperty(indiProp: IndiProperty);
   procedure ServerConnected(Sender: TObject);
   procedure ServerDisconnected(Sender: TObject);
   procedure LoadConfig;
 protected
   procedure SetPosition(p:integer); override;
   function  GetPosition:integer; override;
   procedure SetRelPosition(p:integer); override;
   function  GetRelPosition:integer; override;
   procedure SetSpeed(p:integer); override;
   function  GetSpeed:integer; override;
   procedure SetTimer(p:integer); override;
   function  GetTimer:integer; override;
   function  GethasAbsolutePosition: boolean; override;
   function  GethasRelativePosition: boolean; override;
   function  GethasTimerSpeed: boolean; override;
   function  GetPositionRange: TNumRange; override;
   function  GetRelPositionRange: TNumRange; override;
   procedure SetTimeout(num:integer); override;
   function  GetTemperature:double; override;
 public
   constructor Create(AOwner: TComponent);override;
   destructor  Destroy; override;
   Procedure Connect(cp1: string; cp2:string=''; cp3:string=''; cp4:string=''; cp5:string=''; cp6:string='');  override;
   Procedure Disconnect; override;
   procedure FocusIn; override;
   procedure FocusOut; override;
end;

implementation

procedure T_indifocuser.CreateIndiClient;
begin
if csDestroying in ComponentState then exit;
  indiclient:=TIndiBaseClient.Create;
  indiclient.Timeout:=FTimeOut;
  indiclient.onNewDevice:=@NewDevice;
  indiclient.onNewMessage:=@NewMessage;
  indiclient.onNewProperty:=@NewProperty;
  indiclient.onNewNumber:=@NewNumber;
  indiclient.onNewText:=@NewText;
  indiclient.onNewSwitch:=@NewSwitch;
  indiclient.onNewLight:=@NewLight;
  indiclient.onDeleteDevice:=@DeleteDevice;
  indiclient.onDeleteProperty:=@DeleteProperty;
  indiclient.onServerConnected:=@ServerConnected;
  indiclient.onServerDisconnected:=@ServerDisconnected;
  ClearStatus;
end;

constructor T_indifocuser.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FFocuserInterface:=INDI;
 ClearStatus;
 Findiserver:='localhost';
 Findiserverport:='7624';
 Findidevice:='';
 InitTimer:=TTimer.Create(nil);
 InitTimer.Enabled:=false;
 InitTimer.Interval:=60000;
 InitTimer.OnTimer:=@InitTimerTimer;
 ConnectTimer:=TTimer.Create(nil);
 ConnectTimer.Enabled:=false;
 ConnectTimer.Interval:=1000;
 ConnectTimer.OnTimer:=@ConnectTimerTimer;
 ReadyTimer:=TTimer.Create(nil);
 ReadyTimer.Enabled:=false;
 ReadyTimer.Interval:=2000;
 ReadyTimer.OnTimer:=@ReadyTimerTimer;
end;

destructor  T_indifocuser.Destroy;
begin
 InitTimer.Enabled:=false;
 ConnectTimer.Enabled:=false;
 ReadyTimer.Enabled:=false;
 if indiclient<>nil then  indiclient.onServerDisconnected:=nil;
 FreeAndNil(InitTimer);
 FreeAndNil(ConnectTimer);
 FreeAndNil(ReadyTimer);
 inherited Destroy;
end;

procedure T_indifocuser.ClearStatus;
begin
    FocuserDevice:=nil;
    FocusMotion:=nil;
    FocusInward:=nil;
    FocusOutward:=nil;
    FocusSpeed:=nil;
    FocusTimer:=nil;
    FocusRelativePosition:=nil;
    FocusAbsolutePosition:=nil;
    FocusAbort:=nil;
    FocusPreset:=nil;
    FocusGotoPreset:=nil;
    FocusTemperature:=nil;
    FhasTemperature:=false;
    connectprop:=nil;
    configprop:=nil;
    Fready:=false;
    Fconnected := false;
    FConnectDevice:=false;
    FStatus := devDisconnected;
    if Assigned(FonStatusChange) then FonStatusChange(self);
end;

procedure T_indifocuser.CheckStatus;
begin
    if Fconnected and
       (FocusMotion<>nil) and
       ((FocusAbsolutePosition<>nil)or(FocusRelativePosition<>nil)or(FocusTimer<>nil))
    then begin
      ReadyTimer.Enabled := false;
      ReadyTimer.Enabled := true;
    end;
end;

procedure T_indifocuser.ReadyTimerTimer(Sender: TObject);
begin
  ReadyTimer.Enabled := false;
  FStatus := devConnected;
  if (not Fready) then begin
    Fready:=true;
    if FAutoloadConfig and FConnectDevice then LoadConfig;
    if Assigned(FonStatusChange) then FonStatusChange(self);
  end;
end;

Procedure T_indifocuser.Connect(cp1: string; cp2:string=''; cp3:string=''; cp4:string=''; cp5:string=''; cp6:string='');
begin
CreateIndiClient;
if not indiclient.Connected then begin
  Findiserver:=cp1;
  Findiserverport:=cp2;
  Findidevice:=cp3;
  Fdevice:=cp3;
  FStatus := devDisconnected;
  if Assigned(FonStatusChange) then FonStatusChange(self);
  msg('Connecting to INDI server "'+Findiserver+':'+Findiserverport+'" for device "'+Findidevice+'"',9);
  indiclient.SetServer(Findiserver,Findiserverport);
  indiclient.watchDevice(Findidevice);
  indiclient.ConnectServer;
  FStatus := devConnecting;
  if Assigned(FonStatusChange) then FonStatusChange(self);
  InitTimer.Enabled:=true;
end
else msg('Focuser already connected',0);
end;

procedure T_indifocuser.InitTimerTimer(Sender: TObject);
begin
  InitTimer.Enabled:=false;
  if (FocuserDevice=nil)or(not Fready) then begin
    msg(rsError2,0);
    if not Fconnected then begin
      msg(rsNoResponseFr,0);
      msg('Is "'+Findidevice+'" a running focuser driver?',0);
    end
    else if (configprop=nil) then
       msg('Missing property CONFIG_PROCESS',0)
    else if (FocusMotion=nil) then
       msg('Missing property FOCUS_MOTION',0)
    else if ((FocusAbsolutePosition=nil)and(FocusRelativePosition=nil)and(FocusTimer=nil)) then
       msg('One of the properties ABS_FOCUS_POSITION, REL_FOCUS_POSITION, FOCUS_TIMER is required',0);
    Disconnect;
  end;
end;

Procedure T_indifocuser.Disconnect;
begin
InitTimer.Enabled:=False;
ConnectTimer.Enabled:=False;
indiclient.Terminate;
ClearStatus;
end;

procedure T_indifocuser.ServerConnected(Sender: TObject);
begin
   ConnectTimer.Enabled:=True;
end;

procedure T_indifocuser.ConnectTimerTimer(Sender: TObject);
begin
  ConnectTimer.Enabled:=False;
  if (connectprop<>nil) then begin
    if (connectoff.s=ISS_ON) then begin
      FConnectDevice:=true;
      indiclient.connectDevice(Findidevice);
      exit;
    end;
  end
  else begin
    ConnectTimer.Enabled:=true;
    exit;
  end;
end;

procedure T_indifocuser.ServerDisconnected(Sender: TObject);
begin
  FStatus := devDisconnected;
  if Assigned(FonStatusChange) then FonStatusChange(self);
  msg(rsServer+' '+rsDisconnected3,0);
end;

procedure T_indifocuser.NewDevice(dp: Basedevice);
begin
  if dp.getDeviceName=Findidevice then begin
     msg('INDI server send new device: "'+dp.getDeviceName+'"',9);
     Fconnected:=true;
     FocuserDevice:=dp;
  end;
end;

procedure T_indifocuser.DeleteDevice(dp: Basedevice);
begin
  if dp.getDeviceName=Findidevice then begin
     Disconnect;
  end;
end;

procedure T_indifocuser.DeleteProperty(indiProp: IndiProperty);
begin
  { TODO :  check if a vital property is removed ? }
end;

procedure T_indifocuser.NewMessage(mp: IMessage);
begin
  if Assigned(FonDeviceMsg) then FonDeviceMsg(Findidevice+': '+mp.msg);
  mp.Free;
end;

procedure T_indifocuser.NewProperty(indiProp: IndiProperty);
var propname: string;
    proptype: INDI_TYPE;
    TxtProp: ITextVectorProperty;
    Txt: IText;
    buf: string;
begin
  propname:=indiProp.getName;
  proptype:=indiProp.getType;

  if (proptype=INDI_TEXT)and(propname='DRIVER_INFO') then begin
     buf:='';
     TxtProp:=indiProp.getText;
     if TxtProp<>nil then begin
       Txt:=IUFindText(TxtProp,'DRIVER_EXEC');
       if Txt<>nil then buf:=buf+Txt.lbl+': '+Txt.Text+', ';
       Txt:=IUFindText(TxtProp,'DRIVER_VERSION');
       if Txt<>nil then buf:=buf+Txt.lbl+': '+Txt.Text+', ';
       Txt:=IUFindText(TxtProp,'DRIVER_INTERFACE');
       if Txt<>nil then buf:=buf+Txt.lbl+': '+Txt.Text;
       msg(buf,9);
     end;
  end
  else if (proptype=INDI_SWITCH)and(connectprop=nil)and(propname='CONNECTION') then begin
     connectprop:=indiProp.getSwitch;
     connecton:=IUFindSwitch(connectprop,'CONNECT');
     connectoff:=IUFindSwitch(connectprop,'DISCONNECT');
     if (connecton=nil)or(connectoff=nil) then connectprop:=nil;
  end
  else if (proptype=INDI_SWITCH)and(configprop=nil)and(propname='CONFIG_PROCESS') then begin
     configprop:=indiProp.getSwitch;
     configload:=IUFindSwitch(configprop,'CONFIG_LOAD');
     configsave:=IUFindSwitch(configprop,'CONFIG_SAVE');
     if (configload=nil)or(configsave=nil) then configprop:=nil;
  end
  else if (proptype=INDI_SWITCH)and(FocusMotion=nil)and(propname='FOCUS_MOTION') then begin
     FocusMotion:=indiProp.getSwitch;
     FocusInward:=IUFindSwitch(FocusMotion,'FOCUS_INWARD');
     FocusOutward:=IUFindSwitch(FocusMotion,'FOCUS_OUTWARD');
     if (FocusInward=nil)or(FocusOutward=nil) then FocusMotion:=nil;
  end
  else if (proptype=INDI_NUMBER)and(FocusSpeed=nil)and(propname='FOCUS_SPEED') then begin
     FocusSpeed:=indiProp.getNumber;
  end
  else if (proptype=INDI_NUMBER)and(FocusTimer=nil)and(propname='FOCUS_TIMER') then begin
     FocusTimer:=indiProp.getNumber;
  end
  else if (proptype=INDI_NUMBER)and(FocusRelativePosition=nil)and(propname='REL_FOCUS_POSITION') then begin
     FocusRelativePosition:=indiProp.getNumber;
  end
  else if (proptype=INDI_NUMBER)and(FocusAbsolutePosition=nil)and(propname='ABS_FOCUS_POSITION') then begin
     FocusAbsolutePosition:=indiProp.getNumber;
  end
  else if (proptype=INDI_SWITCH)and(FocusAbort=nil)and(propname='FOCUS_ABORT_MOTION') then begin
     FocusAbort:=indiProp.getSwitch;
  end
  else if (proptype=INDI_NUMBER)and(FocusPreset=nil)and(propname='Presets') then begin
     FocusPreset:=indiProp.getNumber;
  end
  else if (proptype=INDI_SWITCH)and(FocusGotoPreset=nil)and(propname='Goto') then begin
     FocusGotoPreset:=indiProp.getSwitch;
  end
  else if (proptype=INDI_NUMBER)and(FocusTemperature=nil)and(propname='FOCUS_TEMPERATURE') then begin
     FocusTemperature:=indiProp.getNumber();
     FhasTemperature:=true;
  end;
  CheckStatus;
end;

procedure T_indifocuser.NewNumber(nvp: INumberVectorProperty);
begin
  if nvp=FocusAbsolutePosition then begin
     if Assigned(FonPositionChange) then FonPositionChange(nvp.np[0].value);
  end
  else if (FocusAbsolutePosition=nil)and(nvp=FocusRelativePosition) then begin
     if Assigned(FonPositionChange) then FonPositionChange(nvp.np[0].value);
  end
  else if nvp=FocusSpeed then begin
     if Assigned(FonSpeedChange) then FonSpeedChange(nvp.np[0].value);
  end
  else if nvp=FocusTimer then begin
     if Assigned(FonTimerChange) then FonTimerChange(nvp.np[0].value);
  end
  else if nvp=FocusTemperature then begin
     if Assigned(FonTemperatureChange) then FonTemperatureChange(nvp.np[0].value);
  end;
end;

procedure T_indifocuser.NewText(tvp: ITextVectorProperty);
begin
//  writeln('NewText: '+tvp.name+' '+tvp.tp[0].text);
end;

procedure T_indifocuser.NewSwitch(svp: ISwitchVectorProperty);
var sw: ISwitch;
begin
  if (svp.name='CONNECTION') then begin
    sw:=IUFindOnSwitch(svp);
    if (sw<>nil)and(sw.name='DISCONNECT') then begin
      Disconnect;
    end;
  end;
end;

procedure T_indifocuser.NewLight(lvp: ILightVectorProperty);
begin
//  writeln('NewLight: '+lvp.name);
end;

procedure T_indifocuser.SetPosition(p:integer);
begin
if FocusAbsolutePosition<>nil then begin
  if PositionRange<>NullRange then begin
     if (p>PositionRange.max)or(p<PositionRange.min) then begin
       msg('Invalid position request: '+inttostr(p),1);
       exit;
     end;
  end;
  FocusAbsolutePosition.np[0].value:=p;
  indiclient.sendNewNumber(FocusAbsolutePosition);
  FocuserLastTemp:=FocuserTemp;
  indiclient.WaitBusy(FocusAbsolutePosition,60000);
end;
end;

function  T_indifocuser.GetPosition:integer;
begin
if FocusAbsolutePosition<>nil then begin;
  result:=round(FocusAbsolutePosition.np[0].value);
end
else result:=0;
end;

function  T_indifocuser.GetPositionRange: TNumRange;
begin
if FocusAbsolutePosition<>nil then begin;
  result.min:=FocusAbsolutePosition.np[0].min;
  result.max:=FocusAbsolutePosition.np[0].max;
  result.step:=FocusAbsolutePosition.np[0].step;
end
else result:=NullRange;
end;

procedure T_indifocuser.SetRelPosition(p:integer);
var n: integer;
begin
if FocusRelativePosition<>nil then begin
  if RelPositionRange<>NullRange then
     n:=max(min(p,round(RelPositionRange.max)),round(RelPositionRange.min))
   else
     n:=p;
  FocusRelativePosition.np[0].value:=n;
  indiclient.sendNewNumber(FocusRelativePosition);
  FocuserLastTemp:=FocuserTemp;
  indiclient.WaitBusy(FocusRelativePosition,60000);
  if FDelay>0 then wait(FDelay);
end;
end;

function  T_indifocuser.GetRelPosition:integer;
begin
if FocusRelativePosition<>nil then begin;
  result:=round(FocusRelativePosition.np[0].value);
end
else result:=0;
end;

function  T_indifocuser.GetRelPositionRange: TNumRange;
begin
if FocusRelativePosition<>nil then begin;
  result.min:=FocusRelativePosition.np[0].min;
  result.max:=FocusRelativePosition.np[0].max;
  result.step:=FocusRelativePosition.np[0].step;
end
else result:=NullRange;
end;

procedure T_indifocuser.SetSpeed(p:integer);
begin
if (FocusSpeed<>nil)and(FocusSpeed.np[0].value<>p) then begin
  FocusSpeed.np[0].value:=p;
  indiclient.sendNewNumber(FocusSpeed);
  indiclient.WaitBusy(FocusSpeed);
end;
end;

function  T_indifocuser.GetSpeed:integer;
begin
if FocusSpeed<>nil then begin;
  result:=round(FocusSpeed.np[0].value);
end
else result:=0;
end;

procedure T_indifocuser.SetTimer(p:integer);
begin
if (FocusTimer<>nil) then begin
  FocusTimer.np[0].value:=p;
  indiclient.sendNewNumber(FocusTimer);
  indiclient.WaitBusy(FocusTimer);
  if FDelay>0 then wait(FDelay);
end;
end;

function  T_indifocuser.GetTimer:integer;
begin
if FocusTimer<>nil then begin;
  result:=round(FocusTimer.np[0].value);
end
else result:=0;
end;

procedure T_indifocuser.FocusIn;
begin
 if (FocusMotion<>nil)and(FocusInward.s=ISS_OFF) then begin
   IUResetSwitch(FocusMotion);
   FocusInward.s:=ISS_ON;
   indiclient.sendNewSwitch(FocusMotion);
   indiclient.WaitBusy(FocusMotion);
 end;
 FLastDirection:=FocusDirIn;
 FFocusdirection:=-1;
end;

procedure T_indifocuser.FocusOut;
begin
 if (FocusMotion<>nil)and(FocusOutward.s=ISS_OFF) then begin
   IUResetSwitch(FocusMotion);
   FocusOutward.s:=ISS_ON;
   indiclient.sendNewSwitch(FocusMotion);
   indiclient.WaitBusy(FocusMotion);
 end;
 FLastDirection:=FocusDirOut;
 FFocusdirection:=1;
end;

function  T_indifocuser.GethasAbsolutePosition: boolean;
begin
 result:=FocusAbsolutePosition<>nil;
end;

function  T_indifocuser.GethasRelativePosition: boolean;
begin
  result:=FocusRelativePosition<>nil;
end;

function  T_indifocuser.GethasTimerSpeed: boolean;
begin
  result:=(FocusSpeed<>nil)and(FocusTimer<>nil);
end;

procedure T_indifocuser.SetTimeout(num:integer);
begin
 FTimeOut:=num;
 if indiclient<>nil then indiclient.Timeout:=FTimeOut;
end;

procedure T_indifocuser.LoadConfig;
begin
  if configprop<>nil then begin
    IUResetSwitch(configprop);
    configload.s:=ISS_ON;
    indiclient.sendNewSwitch(configprop);
  end;
end;

function  T_indifocuser.GetTemperature:double;
begin
  if FocusTemperature<>nil then begin;
    result:=round(FocusTemperature.np[0].value);
  end
  else result:=0;
end;

end.

