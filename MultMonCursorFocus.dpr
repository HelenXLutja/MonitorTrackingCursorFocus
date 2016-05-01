program MultMonCursorFocus;

uses
  Vcl.Forms,
  MultiMonFocusUni in 'MultiMonFocusUni.pas' {MultiMonFocusForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMultiMonFocusForm, MultiMonFocusForm);
  Application.Run;
end.
