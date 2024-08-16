// Copyright 2023 Dan Cassidy

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

// SPDX-License-Identifier: GPL-3.0-or-later


{
}
unit CreateCOBJFromGBFMOrFLST;

var
  cobj_template, to_file: IInterface;


function FileDialog(e: IInterface): IInterface;
var
  i: integer;
  frm: TForm;
  clb: TCheckListBox;
  to_file: IInterface;
begin
  Result := 0;
  frm := frmFileSelect;
  try
    frm.Caption := 'Select a plugin';
    clb := TCheckListBox(frm.FindComponent('CheckListBox1'));
    clb.Items.Add('<new file>');
    for i := Pred(FileCount) downto 0 do begin
      clb.Items.InsertObject(1, GetFileName(FileByIndex(i)), FileByIndex(i));
      if GetFileName(e) = GetFileName(FileByIndex(i)) then begin
        break;
      end;
    end;
    if frm.ShowModal <> mrOk then begin
      Result := nil;
      Exit;
    end;
    for i := 0 to Pred(clb.Items.Count) do begin
      if clb.Checked[i] then begin
        if i = 0 then ToFile := AddNewFile else
          to_file := ObjectToElement(clb.Items.Objects[i]);
        Break;
      end;
    end;
  finally
    frm.Free;
  end;
  if not Assigned(to_file) then begin
    Result := nil;
    exit;
  end;
  AddRequiredElementMasters(e, to_file, False);
  Result := to_file;
end;


function Process(e: IInterface): integer;
var
  proceed: boolean;
  cobj_template_string: string;
  new_cobj: IInterface;
begin
  if (Signature(e) <> 'GBFM') and (Signature(e) <> 'FLST') then begin
    exit;
  end;

  if not Assigned(to_file) then begin
    to_file := FileDialog(e);
    if not Assigned(to_file) then begin
      AddMessage('File not assigned');
      Result := 1;
      exit;
    end;
  end;

  if not Assigned(cobj_template) then begin
    proceed := InputQuery('Specify template COBJ FormID, or leave empty for new', 'Template COBJ Form ID', cobj_template_string);
    if not proceed then begin
      AddMessage('User cancelled');
      Result := 1;
      exit;
    end;
    if cobj_template_string = '' then begin
      // TODO add and assign new COBJ
      cobj_template_string
      AddMessage('COBJ template form ID left blank');
      Result := 1;
      exit;
    end else begin
      cobj_template := RecordByHexFormID(cobj_template_string);
      if not Assigned(cobj_template) then begin
        AddMessage('COBJ template not assigned');
        Result := 1;
        exit;
      end else if (Signature(cobj_template) <> 'COBJ') then begin
        AddMessage('COBJ template given is not a COBJ');
        Result := 1;
        exit;
      end;
    end;
  end;

  new_cobj := wbCopyElementToFile(cobj_template, to_file, True, True);
  if not Assigned(new_cobj) then begin
    AddMessage('New COBJ not assigned; aborting!');
    Result := 1;
    exit;
  end;

  SetEditorID(new_cobj, 'co_' + EditorID(e));
  SetEditValue(ElementBySignature(new_cobj, 'CNAM'), Name(e));
end;

end.
