unit MultiMonFocusUni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus;

type
  TMultiMonFocusForm = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    ListBox1: TListBox;
    Label5: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    PopupMenu1: TPopupMenu;
    Disable1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    TrayIcon1: TTrayIcon;
    procedure Timer1Timer(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Disable1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Function PosBackwards(const source,Mask:String;StartIndex:Integer;CaseSensitive:Boolean):Integer;overload;

    Function FindWindowCaption(wnd:HWND):String;

    Function IsSubstringAt(source:String;atPos:integer;Mask:String;CaseSensitive:boolean):Boolean;overload;
    Function CountSubStrings(Source,mask:String;CaseSensitive:Boolean):Integer;Overload;

    function GrabSubString(Source,Mask:String;Index:integer;CaseInsensitive:Boolean;var Offset:Integer):String;overload;
    Function PointToStr(p:TPoint):String;
  end;

var
  MultiMonFocusForm: TMultiMonFocusForm;

implementation

{$R *.dfm}
Function TMultiMonFocusForm.FindWindowCaption(wnd:HWND):String;
var
  ts:String;
  tl:integer;
  TimeoutP:DWORD;
  pc:PWideChar;
  i:integer;
begin
     setlength(ts,1025);
     pc:=@ts[1];
      GetWindowText(wnd,pc,512);

     if Pos(#0,ts)>0 then ts:=Grabsubstring(ts,#0,1,true,i);
     ts:=trim(ts);

     if ts='' then exit;
     result:=ts;
end;


function TMultiMonFocusForm.PointToStr(p: TPoint): String;
begin
      Result:=Inttostr(p.X)+','+inttostr(p.Y);
end;

Function TMultiMonFocusForm.PosBackwards(const source,Mask:String;StartIndex:Integer;CaseSensitive:Boolean):Integer;
var
  ws,wsource,wmask:String;
  wsl:Integer;
  i:integer;
  ts:String;
begin
    Result:=0;
    wsl:=Length(Source);
    if wsl<1 then exit;
    if Mask='' then exit;
    if StartIndex<1 then exit;
    if caseSensitive then
    begin
        wsource:=Source;
        wmask:=Mask
    end else
    begin
        wSource:=AnsiUpperCase(Source);
        wMask:=AnsiUpperCase(mask);
    end;
    ws:='';

    ts:='';
    For i:=Length(Mask) downto 1 do ts:=ts+WMask[i];

    for i:=StartIndex downto 1 do
    begin
         ws:=ws+wsource[i];
    end;

    i:=pos(ts,ws);
    if i>0 then
    begin
        if Length(mask)>1 then
        result:=wsl-(Length(mask)-i) else Result:=wsl;
    end else result:=0;
end;
Function TMultiMonFocusForm.IsSubstringAt(source:String;atPos:integer;Mask:String;CaseSensitive:boolean):Boolean;
var
    SourceP,MaskP:PChar;
    sourceL,maskl:integer;
    i:integer;
begin
   result:=false;
   if source='' then exit;
   if mask='' then exit;
   if atpos<1 then exit;

   SourceL:=Length(Source);
   MaskL:=Length(mask);
   if atpos>SourceL-maskL+1 then exit;

   SourceP:=@Source[atpos];
   MaskP:=@Mask[1] ;

   result:=true; //now we can only fail and set false;
   for i:=1 to maskL do
   begin
        case CaseSensitive of
        True : Begin
                    if sourcep^<>maskp^ then
                    begin
                        result:=false;
                        break;
                    end;
                    inc(sourcep);
                    inc(maskp);
               end;
        False:Begin
                   if AnsiUpperCase(SourceP^)<>ansiuppercase(Maskp^) then
                   begin
                        result:=false;
                        break;
                   end;
                   inc(sourceP);
                   inc(maskP);
              end;
        end;//of case
   end;


end;

Function TMultiMonFocusForm.CountSubStrings(Source,mask:String;CaseSensitive:Boolean):Integer;
var
  ss,ms:String;
  sl,ml,si:Integer;
  sp,mp:PChar;
  RS:String;
begin
    result:=0;
    if source='' then Exit;
    if mask='' then exit;

    if not CaseSensitive then
    begin
        ss:=AnsiUppercase(source);
        ms:=AnsiUppercase(Mask);
    end else
    begin
      ss:=Source;
      ms:=Mask;
    end;


    sl:=Pos(ms,ss);
    rs:=ss;
    While sl=1 do
    begin
         rs:=Copy(rs,2,length(rs));
         sl:=pos(ms,rs);
    end;
    ss:=rs;

    sl:=PosBackwards(rs,ms,length(rs),False);
    While sl=Length(rs) do
    begin
          if rs='' then Break;
          if rs[Length(rs)]<>ms then break;
          if sl=1 then
          begin
              rs:='';
              Result:=0;
              Exit;
          end;

          rs:=Copy(rs,1,sl-1);
          sl:=PosBackwards(rs,ms,length(rs),false);
    end;
    ss:=rs;
    if rs='' then exit;



    sl:=Length(Ss);
    ml:=Length(mask);
    Si:=0;

    Result:=0;
    While si<sl do
    begin
        if IsSubStringAt(ss,si+1,ms,CaseSensitive) then
        begin
             inc(Result);
             While IsSubStringat(ss,si+1,ms,casesensitive) do
                   si:=si+ml;

             if si<sl then inc(result)
        end else
        begin
          inc(si);
        end;
    end;
    if Result=0 then Result:=1;

end;

function TMultiMonFocusForm.GrabSubString(Source,Mask:String;Index:integer;CaseInsensitive:Boolean;var Offset:Integer):String;
var
    wString,WMask:String;
    wStringP,wMaskP:PChar;
    OrigSourcep:PWideChar;

    wIndex:Integer;
    i,SourceL,MaskL,FindIndex,MatchCount:integer;

    MaxC:Integer;

    cMaskPos:integer;
    Function MatchMask:Boolean;
    var
        i:integer;
        oSourcep:PWideChar;
        OChar,MaskChar:Char;
    begin
          oSourcep:=wStringP;
          result:=False;
          try
             wmaskp:=@wMask[1];
             for i:=1 to length(wmask) do
             begin
                  OChar:=String(wStringp^)[1];
                  MAskChar:=String(WMaskp^)[1];
                  if MaskChar <> OChar then
                  begin
                        wStringP:=oSourceP;
                        result:=false;
                        exit;
                  end;

                  inc(wmaskp);
                  inc(wStringp);
             end;

             result:=True;

          except on exception do begin wStringp:=oSourceP; result:= false; end;
          end;
          wStringP:=OSourceP;
    end;

begin
    wString:=Source;
    wMask:=Mask;
    if CaseInsensitive then
    begin
        wString:=AnsiUppercase(wString);
        wMask:=AnsiUppercase(wMask);
    end;
    result:=Source; //not the uppercased wSource

    if mask='' then exit;

    cMaskPos:=Pos(wMask,wString);
    if cMaskPos<1 then exit;

    MaxC:=CountSubStrings(Source,mask,not CaseInSensitive);
    if index>MaxC then exit('');


    wStringP:=@wString[1];
    wMaskP:=@wMask[1];
    SourceL:=Length(wString);
    maskL:=Length(wMask);

    FindIndex:=Index;
    if Index<=0 then FindIndex:=1;

  //hello TEST world TEST of
  // 1           2        3
  //TEST hello TEST world TEST of
  //      1           3        3
  //hello TESTTEST world of TEST gielinor
  // 1               2             3

    MatchCount:=1;
    origSourcep:=@Source[1];
    result:='';
    i:=1;
    //strip any leading instances of mask
     if MatchMask then
     Repeat
                i:=i+1;
                inc(wStringP,MaskL);//,MaskL);
                inc(origSourceP,MaskL);//,MaskL);
     until not MatchMask;


    While i <= SourceL  do
    begin
          if MatchMask=false then //Something other than Mask is at our position
          begin
                if MatchCount = FindIndex then
                begin
                     Offset:=i;
                     //now we will stream OrigSourceP to result until another matchmask, exception or string end;
                     try
                     repeat
                         result:=Result+OrigSourceP^;

                         inc(i);
                         inc(OrigSourcep);
                         inc(wStringP);


                     until (matchmask) or (i>SourceL);

                           if matchmask then
                           begin
                              Inc(OrigSourceP,MaskL);
                              inc(wStringP,Maskl);
                              inc(i,MaskL);
                              inc(i,SourceL);
                              inc(MatchCount);
                           end

                     except on exception do begin end;
                     end;

                end else begin
                         inc(wStringP);
                         inc(OrigSourceP);
                         inc(i);
                         end;

          end else
          begin

               if not MatchMask then
               Repeat
                i:=i+1;
                inc(wStringP);//,MaskL);
                inc(origSourceP);//,MaskL);
               until (not MatchMask) {or (i>SourceL)};
               if (i<=SourceL) and (MaskL>0) then
               begin
                   i:=i+MaskL;
                   inc(WStringP,MaskL);
                   inc(OrigSourceP,MaskL);
               end;
               inc(matchcount);
          end;


    end;

end;


procedure TMultiMonFocusForm.Close1Click(Sender: TObject);
begin
    Close;
end;

procedure TMultiMonFocusForm.Disable1Click(Sender: TObject);
begin
     if Disable1.Caption='&Disable' then
     begin
        Timer1.Enabled:=False;
        Disable1.Caption:='Enable';
     end else
     begin
        Timer1.Enabled:=True;
        Disable1.Caption:='Disable';
     end;
end;

procedure TMultiMonFocusForm.FormActivate(Sender: TObject);
begin
    Timer1.Enabled:=true;
end;

procedure TMultiMonFocusForm.Timer1Timer(Sender: TObject);
var
    tp:TPoint;
    CMon:TMonitor;
    FHWND:HWND;
    FMon:TMonitor;
    FCap:String;

    GetW:HWND;
    GetMon:TMonitor;
    GetCap:String;
    GetMonC:integer;

    WindList:TStringList;
    i:integer;
begin
    hide;
    Timer1.Interval:=100;
    Winapi.Windows.GetCursorPos(tp);
    Edit1.Text:=PointToStr(tp);
    CMon:=Screen.MonitorFromPoint(tp);
    Edit2.Text:=Inttostr(CMon.MonitorNum);

    Edit5.Text:=Inttostr(handle);


    FHWND:=winapi.Windows.GetForegroundWindow;

    FMon:=Screen.MonitorFromWindow(FHWND);
    Edit4.Text:=Inttostr(FMon.MonitorNum);

    FCap:=FindWindowCaption(FHWND);
    Edit3.Text:=inttostr(FHWND)+' '+inttostr(FMon.MonitorNum)+' '+FCap;


    GetW:=Winapi.Windows.WindowFromPoint(tp);
    while GetParent(GetW)<>0 do GetW:=GetParent(GetW);

    GetCap:=FindWindowCaption(GetW);
    GetMon:=Screen.MonitorFromWindow(GetW);
    Edit6.Text:=Inttostr(GetW)+' '+inttostr(GetMon.MonitorNum)+' '+GetCap;


    if FMon<>GetMon then
    begin
      begin
       winapi.Windows.SetForegroundWindow(GetW);
       Winapi.Windows.SetFocus(GetW);
       winapi.Windows.BringWindowToTop(GetW);// ShowWindow(GetW,wm_show);
       SetActiveWindow(GetW);
      end;
       
    end;

  {  ListBOx1.Items.Clear;
    GetMonC:=0;
    WindList:=crsl;
    Commonfunctions.EnumerateAltTabWindows(WindList);
    for i:=0 to WindList.Count - 1 do
    begin
         GetW:=Int64(WindList.Objects[i]);
         Listbox1.Items.add(inttostr(getw));
    end;
    WindList.free;

   }
    {WindList:=TList.Create;
    Commonfunctions.EnumWindowsList(WindList);
    for i:=0 to Screen.MonitorCount - 1 do
    begin
        GetW:=FirstPerMon(I);
        if GetW<>0 then
        begin
              Listbox1.Items.Addobject(Inttostr(GetW)+' '+inttostr(i)+' '+FindWindowCaption(GetW),Pointer(GetW));
        end;
    end;
    WindList.Free;}








end;

end.
