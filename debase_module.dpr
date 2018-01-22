program debase_module;

uses
  Forms,
  umf_mo in 'umf_mo.pas' {mf};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tmf, mf);
  Application.Run;
end.
