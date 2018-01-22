Unit umf_mo;

Interface

Uses
  Windows, SysUtils, Forms, FileCtrl, XPMan, IniFiles, Buttons, Controls,
  ExtCtrls, StdCtrls, ComCtrls, Classes, ShlObj, ActiveX, Dialogs;

Type
  Tmf = Class(TForm)
    lv: TListView;
    ldbl: TLabel;
    ldbd: TLabel;
    pc: TPanel;
    bbsa: TBitBtn;
    bbda: TBitBtn;
    bbe: TBitBtn;
    pb: TProgressBar;
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure bbdaClick(Sender: TObject);
    Procedure bbsaClick(Sender: TObject);
    Procedure bbeClick(Sender: TObject);
  Private
    { Deklarasi hanya untuk penggunaan dalam unit ini saja }
  Public
    { Deklarasi untuk penggunaan ke semua unit yang terintegerasi }
    vs: String;
    tif: TIniFile;
  End;

Var
  mf: Tmf;

Implementation

{$R *.dfm} //template tweaked by : Araachmadi Putra Pambudi

Function rs(i: Integer): String;
Var
  s: String;
Begin
  Randomize;
  s := '0123456789ABCDEF';
  Result := '';
  Repeat
    Result := Result + s[Random(Length(s)) + 1];
  Until (Length(Result) = i)
End;

Function gtd: String;
Var
  s: String;
  i: Integer;
Begin
  SetLength(s, 255);
  i := GetTempPath(255, PChar(s));
  SetLength(s, i);

  Result := s;
End;

Function sf: String;
Var
  bi: TBrowseInfo;
  pidl: PItemIDList;
  dn: Array[0..MAX_PATH] Of Char;
Begin
  FillChar(bi, SizeOf(bi), #0);
  bi.hwndOwner := Application.Handle;
  bi.pszdisplayname := @dn[0];
  bi.lpszTitle := 'Extract to...';

  bi.ulFlags := BIF_RETURNONLYFSDIRS Or BIF_EDITBOX Or $40;
  CoInitialize(NIL);

  pidl := SHBrowseForFolder(bi);
  If Assigned(pidl) Then
    If SHGetPathFromIDList(pidl, dn) Then
      Result := dn;
End;

Procedure lr(rn, fn: String);
Var
  rs: TResourceStream;
Begin
  rs := TResourceStream.Create(hinstance, rn, RT_RCDATA);
  Try
    rs.SaveToFile(fn);
  Finally
    rs.Free;
  End;
End;

Procedure Tmf.FormCreate(Sender: TObject);
Var
  tli: TListItem;
  i: integer;
Begin
  vs := rs(8);
  Try
    lr('init_data', gtd + '\' + vs + '_ID.ini');
  Except
    MessageBox(Handle, 'Unable to read initialization data, module is exiting', 'Debase Module', 16);
    Application.Terminate;
  End;
  tif := TIniFile.Create(gtd + '\' + vs + '_ID.ini');
  For i := 0 To tif.ReadInteger('init', 'sum', 0) - 1 Do
  Begin
    tli := lv.Items.Add;
    tli.Caption := tif.ReadString('name', IntToStr(i), '-');
    tli.SubItems.Add(tif.ReadString('size', IntToStr(i), '-'));
    tli.SubItems.Add(tif.ReadString('type', IntToStr(i), '-'));
    tli.SubItems.Add(tif.ReadString('date', IntToStr(i), '-'));
  End;
End;

Procedure Tmf.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  tif.Free;
  DeleteFile(gtd + '\' + vs + '_ID.ini')
End;

Procedure Tmf.bbdaClick(Sender: TObject);
Var
  i: integer;
Begin
  For i := 0 To lv.Items.Count - 1 Do
    lv.Items.Item[i].Checked := False;
End;

Procedure Tmf.bbsaClick(Sender: TObject);
Var
  i: integer;
Begin
  For i := 0 To lv.Items.Count - 1 Do
    lv.Items.Item[i].Checked := True;

End;

Function cek: integer;
Var
  i: integer;
Begin
  For i := 0 To mf.lv.Items.Count - 1 Do
    If mf.lv.Items.Item[i].Checked Then
      Inc(Result);
End;

Procedure Tmf.bbeClick(Sender: TObject);
Var
  s: String;
  i, j, k: integer;
Begin
  s := sf;
  If cek <= 0 Then
    exit
  Else If s = '' Then
    Exit
  Else
  Begin
    pb.Max := cek - 1;
    For i := 0 To tif.ReadInteger('Init', 'sum', 0) - 1 Do
    Begin
      If lv.Items.Item[i].Checked Then
      Begin
        Try
          lr(tif.ReadString('index', IntToStr(i), '-'), s + '\' + tif.ReadString('name', IntToStr(i), '-'));
          Inc(j);
        Except
          Inc(k)
        End;
        pb.Position := pb.Position + 1;
        Application.ProcessMessages;
      End;
    End;
    Application.ProcessMessages;
    pb.Position := 0;
    MessageBox(handle, PChar('Extraction finished, ' + inttostr(j) + ' success, ' + inttostr(k) + ' error '), 'Debase', 0);
  End;
End;

End.

