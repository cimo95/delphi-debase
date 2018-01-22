Unit umf_ma;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, FileCtrl, XPMan, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  IniFiles;

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
    Procedure bbsaClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure bbdaClick(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure bbeClick(Sender: TObject);
  Private
    { Deklarasi hanya untuk penggunaan dalam unit ini saja }
  Public
    { Deklarasi untuk penggunaan ke semua unit yang terintegerasi }
    vs, tf: String;
  End;

Var
  mf: Tmf;

Implementation

{$R *.dfm} //template tweaked by : Araachmadi Putra Pambudi

Procedure uer(Const s, d, n: String);
Var
  tfs: TFileStream;
  th: THANDLE;
  p: Pointer;
  dw: DWORD;
Begin
  tfs := TFileStream.Create(s, fmOpenRead Or fmShareDenyNone);
  Try
    tfs.Seek(0, soFromBeginning);
    dw := tfs.Size;
    If dw > 0 Then
    Begin
      GetMem(p, dw);
      Try
        tfs.Read(p^, dw);
        th := BeginUpdateResource(PChar(d), False);
        If th <> 0 Then
          If UpdateResource(th, RT_RCDATA, PChar(n), 0, p, dw) Then
          Begin
            If Not EndUpdateResource(th, FALSE) Then
              RaiseLastOSError
          End
          Else
            RaiseLastOSError
        Else
          RaiseLastOSError;
      Finally
        FreeMem(p);
      End;
    End;
  Finally
    tfs.Free;
  End;
End;

Function dd(d: String): boolean;
Var
  f: TSHFileOpStruct;
Begin
  ZeroMemory(@f, SizeOf(f));
  With f Do
  Begin
    wFunc := FO_DELETE;
    fFlags := FOF_SILENT Or FOF_NOCONFIRMATION;
    pFrom := PChar(d + #0);
  End;
  Result := (0 = SHFileOperation(f));
End;

Function rs(i: Integer): String;
Var
  s: String;
Begin
  Randomize;
  s := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
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

Function mgft(Const fn: String): String;
Var
  tsfi: TSHFileInfo;
Begin
  FillChar(tsfi, SizeOf(tsfi), #0);
  SHGetFileInfo(PChar(fn), 0, tsfi, SizeOf(tsfi), SHGFI_TYPENAME);
  Result := tsfi.szTypeName;
End;

Function gfs(s: String; b: boolean): String;
Var
  fh: THandle;
  fs: LongWord;
  d: double;
Begin
  fh := CreateFile(PCHAR(s), GENERIC_READ, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  fs := GetFileSize(fh, nil);
  result := INTTOSTR(fs);
  CloseHandle(fh);
  If b = true Then
  Begin
    If Length(result) > 3 Then
    Begin
      d := strtofloat(result) / 100;
      result := inttostr(Round(d)) + ' KB'
    End
    Else
      result := '1 KB';
  End;
End;

Procedure Tmf.bbsaClick(Sender: TObject);
Var
  tod: TOpenDialog;
  tli: TListItem;
  s: String;
  i: integer;
Begin
  tod := TOpenDialog.Create(nil);
  tod.Title := 'Adding file...';
  tod.Options := [ofallowmultiselect];
  If Not tod.Execute Then
  Begin
    tod.Free;
    Exit
  End
  Else
  Begin
    For i := 0 To tod.Files.Count - 1 Do
    Begin
      If FileExists(tf + '\' + ExtractFileName(tod.files.strings[i])) Then
      Begin
        If MessageBox(Handle, PChar('The file "' + ExtractFileName(tod.files.strings[i]) + '" already exists, rename this file so it can be added to list ?'), 'File Exists', 4) = mryes Then
        Begin
          If InputQuery('Rename existing file', 'Rename pre-added "' + ExtractFileName(tod.files.strings[i]) + '" to ...', s) Then
          Begin
            CopyFile(PChar(tod.files.strings[i]), PChar(tf + '\' + ChangeFileExt(s, ExtractFileExt(tod.files.strings[i]))), false);
            tli := lv.items.add;
            tli.Caption := s;
            tli.SubItems.Add(gfs(tod.files.strings[i], True));
            tli.SubItems.Add(mgft(tod.files.strings[i]));
            tli.SubItems.Add(FormatDateTime('dddd, dd mmmm yyyy', Now));
            tli.Checked := True;
          End;
        End;
      End
      Else
      Begin
        CopyFile(PChar(tod.files.strings[i]), PChar(tf + '\' + ExtractFileName(tod.files.strings[i])), false);
        tli := lv.items.add;
        tli.Caption := ExtractFileName(tod.files.strings[i]);
        tli.SubItems.Add(gfs(tod.files.strings[i], True));
        tli.SubItems.Add(mgft(tod.files.strings[i]));
        tli.SubItems.Add(FormatDateTime('dddd, dd mmmm yyyy', Now));
        tli.Checked := true;
      End;
    End;
    tod.Free;
  End;
End;

Procedure Tmf.FormCreate(Sender: TObject);
Begin
  tf := gtd + '\' + UpperCase(rs(8));
  MkDir(tf);
End;

Procedure Tmf.bbdaClick(Sender: TObject);
Var
  i: integer;
Begin
  If lv.SelCount <= 0 Then
    Exit
  Else
  Begin
    If MessageBox(handle, pchar('Do you really want to delete ' + inttostr(lv.SelCount) + ' selected added file(s) ?'), 'Deleting Added File(s)', 4) = mrno Then
      Exit
    Else
    Begin
      For i := lv.Items.Count - 1 Downto 0 Do
        If lv.Items.Item[i].Checked Then
        Begin
          DeleteFile(tf + '\' + lv.Items.Item[i].Caption);
          lv.Items.Item[i].Delete;
        End;
    End;
  End;
End;

Procedure Tmf.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  pc.Caption := 'cleaning up temporary data...';
  Application.ProcessMessages;
  dd(tf);
  pc.Caption := '© 2016 Arachmadi Putra Pambudi';
  Application.ProcessMessages;
End;

Procedure Tmf.bbeClick(Sender: TObject);
Var
  trs: TResourceStream;
  tif: TIniFile;
  i: integer;
  tsd: TSaveDialog;
  fn: String;
Begin
  If lv.Items.Count <= 0 Then
    Exit
  Else
    pb.Max := lv.Items.Count + 2;
  tsd := TSaveDialog.Create(nil);
  tsd.Title := 'Create DeBase As...';
  tsd.Filter := 'PE Modules|*.exe';
  If Not tsd.Execute Then
  Begin
    tsd.Free;
    Exit
  End
  Else
    fn := tsd.FileName;
  If FileExists(ChangeFileExt(fn, '.exe')) Then
    fn := ChangeFileExt(fn, '.' + rs(3) + '.exe');
  MkDir(tf + '\module');
  trs := TResourceStream.Create(HInstance, 'DEBASE_MODULE', RT_RCDATA);
  trs.SaveToFile(tf + '\module\module.exe');
  trs.Free;
  pb.Position := pb.Position + 1;
  Sleep(Random(500));
  Application.ProcessMessages;
  tif := TIniFile.Create(tf + '\module\init_data.ini');
  tif.WriteInteger('init', 'sum', lv.Items.Count);
  For i := 0 To lv.Items.Count - 1 Do
  Begin
    uer(tf + '\' + lv.Items.Item[i].Caption, tf + '\module\module.exe', 'DEBASE_' + inttostr(i));
    tif.WriteString('index', IntToStr(i), 'DEBASE_' + inttostr(i));
    tif.WriteString('name', IntToStr(i), lv.Items.Item[i].Caption);
    tif.WriteString('size', IntToStr(i), lv.Items.Item[i].SubItems.Strings[0]);
    tif.WriteString('type', IntToStr(i), lv.Items.Item[i].SubItems.Strings[1]);
    tif.WriteString('date', IntToStr(i), lv.Items.Item[i].SubItems.Strings[2]);
    pb.Position := pb.Position + 1;
    Sleep(Random(500));
    Application.ProcessMessages;
  End;
  uer(tf + '\module\init_data.ini', tf + '\module\module.exe', 'INIT_DATA');
  pb.Position := pb.Position + 1;
  Sleep(Random(500));
  Application.ProcessMessages;
  CopyFile(pchar(tf + '\module\module.exe'), PChar(ChangeFileExt(fn, '.exe')), false);
  Sleep(Random(500));
  Application.ProcessMessages;
  pb.Position := 0;
  If MessageBox(Handle, 'Debase Module creation completed, try to open it now?', 'Module Creation', 4) = mrno Then
    Exit
  Else
    ShellExecute(handle, 'open', PChar(fn), nil, nil, sw_show);
End;

End.

