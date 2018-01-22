program debase_master;

uses
  Forms,
  umf_ma in 'umf_ma.pas' {mf};

{$R *.res}
{$R backupres.res}

begin
  Application.Initialize;
  Application.Title := 'Debase Master';
  Application.CreateForm(Tmf, mf);
  Application.Run;
end.
