{
  Copy injected PKIN records to a master.
  Functionally equivalent to the "Deep Copy as Override (With Overwriting)" functionality.
}
unit copy_injected_pkin;


const
  EXCLUDE_FILES_MASTERS = 'Starfield.esm,Starfield.exe,BlueprintShips-Starfield.esm,OldMars.esm,Constellation.esm';


function FileDialog(element: IInterface; var target_file: IInterface): integer;
var
  i: integer;
  frm: TForm;
  clb: TCheckListBox;
  current_file: IInterface;
  current_file_name: string;
begin
  Result := 0;

  frm := frmFileSelect;
  try
    frm.Caption := 'Select a plugin';
    clb := TCheckListBox(frm.FindComponent('CheckListBox1'));

    for i := Pred(FileCount) downto 0 do
    begin
      current_file := FileByIndex(i);
      current_file_name := GetFileName(current_file);
      if Pos(current_file_name, EXCLUDE_FILES_MASTERS) = 0 then
        clb.Items.InsertObject(0, current_file_name, current_file);
    end;

    if frm.ShowModal <> mrOk then begin
      Result := 1;
      Exit;
    end;

    for i := 0 to Pred(clb.Items.Count) do
      if clb.Checked[i] then begin
        target_file := ObjectToElement(clb.Items.Objects[i]);
        Break;
      end;

  finally
    frm.Free;
  end;

  if not Assigned(target_file) then begin
    Result := 1;
    Exit;
  end;

  if GetFileName(element) = GetFileName(target_file) then
  begin
    global_cobj_copy := true;
    global_flst_copy := true;
  end;

  AddRequiredElementMasters(element, target_file, False);
end;


procedure SetMarginsLayout(
    control: TControl;
    margin_top, margin_bottom, margin_left, margin_right: integer;
    align: integer);
begin
    control.Margins.Top := margin_top;
    control.Margins.Bottom := margin_bottom;
    control.Margins.Left := margin_left;
    control.Margins.Right := margin_right;
    control.AlignWithMargins := true;
    control.Align := align;
end;


procedure DoPanelLayout(panel: TPanel; caption: string);
begin
  if Length(caption) > 0 then
  begin
    panel.Caption := caption;
    panel.ShowCaption := true;
    panel.VerticalAlignment := 0;
    panel.Alignment := 0;
  end;
  panel.BevelOuter := 0;
  panel.AutoSize := true;
  SetMarginsLayout(panel, 4, 8, 8, 8, alTop);
end;


var
  first_record: boolean;
  copy_to_file: IwbFile;

function Initialize(): integer;
begin
  first_record := true;
end;

function Process(current_record: IInterface): Integer;
var
  return_code: integer;
  // form_id:
  copied_record: IInterface;
  form_id_new: IwbElement;
  form_id_old: IwbElement;
  native_return: string;
begin
  // AddMessage('current_record: ' + ShortName(current_record));
  // AddMessage('FormID: ' + IntToHex(FormID(current_record), 8));
  // AddMessage('FixedFormID: ' + IntToHex(FixedFormID(current_record), 8));
  // AddMessage('GetLoadOrderFormID: ' + IntToHex(GetLoadOrderFormID(current_record), 8));
  // Result := 1;
  // Exit;
  if (first_record) then
  begin
    return_code := FileDialog(current_record, copy_to_file);
    if (return_code <> 0) then
    begin
      AddMessage('return_code for FileDialog() <> 0');
      Result := return_code;
      Exit;
    end;
    AddMessage('copying to master: ' + GetFileName(copy_to_file));
    first_record := false;
  end;

  copied_record := wbCopyElementToFile(current_record, copy_to_file, true, true);
  if not Assigned(copied_record) then
  begin
    AddMessage('copied_record is not assigned, an error must have occurred');
    Result := 1;
    Exit;
  end;
  form_id_new := ElementByPath(copied_record, 'Record Header\FormID');
  SetNativeValue(copied_record, GetLoadOrderFormID(current_record));
  AddMessage('copied record: ' + ShortName(copied_record));
end;

end.
