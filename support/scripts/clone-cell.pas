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
  Do a full clone of any selected cells and their respective subrecords as new records
}
unit CloneCell;

// TODO
// clone cell to new file
// determine whether to deal with worldspaces
// remove "temporary" group if empty when copying persistent records

var to_file: IwbFile;

// var NewCell, OldCell : IwbContainer;
//var ValidCopySignatures;
// cell record signature
// CELL
// possible record signatures in a CELL
// ACHR - Placed NPC
// REFR - Placed Object
// PGRE - Placed Projectile
// PMIS - Placed Missile
// PARW - Placed Arrow
// PBEA - Placed Beam
// PFLA - Placed Flame
// PCON - Placed Cone/Voice
// PBAR - Placed Barrier
// PHZD - Placed Hazard
// NAVM - Navigation Mesh


procedure CloneRecordElements(old_record, new_record: IInterface);
var
  i: integer;
  element: IInterface;
begin
  for i := 1 to Pred(ElementCount(old_record)) do begin
    element := ElementByIndex(old_record, i);
    wbCopyElementToRecord(element, new_record, False, True);
    // AddMessage('i: ' + IntToStr(i) + ', Sig: ' + Signature(element) + ' Elements: ' + IntToStr(ElementCount(element)));
  end;
end;


procedure CloneCellGroup(old_cell_group, new_cell: IInterface);
var
  i: integer;
  old_cell_subrecord: IInterface;
  new_cell_subrecord: IInterface;
begin
  // create new subrecords
  for i := 0 to Pred(ElementCount(old_cell_group)) do begin
    old_cell_subrecord := ElementByIndex(old_cell_group, i);
    // AddMessage('Subrecord: ' + ShortName(old_cell_subrecord) + ' ' + GetElementEditValues(old_cell_subrecord, 'NAME'));
    // AddMessage('FullPath: ' + FullPath(old_cell_subrecord));
    new_cell_subrecord := Add(new_cell, Signature(old_cell_subrecord), True);

    // copy elements from old subrecord to new subrecord
    CloneRecordElements(old_cell_subrecord, new_cell_subrecord);

    SetIsPersistent(new_cell_subrecord, GetIsPersistent(old_cell_subrecord));
  end;
end;


procedure CloneCellGroups(old_cell, new_cell: IInterface);
const
  GROUP_TYPE_CELL_PERSISTENT_CHILDREN = 8;
  GROUP_TYPE_CELL_TEMPORARY_CHILDREN = 9;
var
  old_cell_group: IInterface;
begin
  // create new subrecords for persistent subrecords
  old_cell_group := FindChildGroup(ChildGroup(old_cell), GROUP_TYPE_CELL_PERSISTENT_CHILDREN, old_cell);
  AddMessage('    # persistent children: ' + IntToStr(ElementCount(old_cell_group)));
  CloneCellGroup(old_cell_group, new_cell);

  // create new subrecords for temporary subrecords
  old_cell_group := FindChildGroup(ChildGroup(old_cell), GROUP_TYPE_CELL_TEMPORARY_CHILDREN, old_cell);
  AddMessage('    # temporary children: ' + IntToStr(ElementCount(old_cell_group)));
  CloneCellGroup(old_cell_group, new_cell);
end;


function DoCloneCell(old_cell, to_file: IInterface): IInterface;
var
  group_cell, new_cell: IInterface;
begin
  if Signature(old_cell) <> 'CELL' then begin
    Result := nil;
    exit;
  end;

  if not HasGroup(to_file, 'CELL') then
    Add(to_file, 'CELL', True);

  group_cell := GroupBySignature(to_file, 'CELL');

  new_cell := Add(group_cell, 'CELL', True);

  // copy element records from old cell to new cell
  CloneRecordElements(old_cell, new_cell);

  // clone cell subrecords
  CloneCellGroups(old_cell, new_cell);

  Result := new_cell;
end;


function FileDialog(e: IInterface): IwbFile;
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
  i: integer;
  new_cell: IInterface;
begin
  if Signature(e) <> 'CELL' then
    exit;

  if not Assigned(to_file) then begin
    to_file := FileDialog(e);
  end;
  if not Assigned(to_file) then begin
    Result := 1;
    exit;
  end;

  AddMessage('Cloning ' + ShortName(e));
  new_cell := DoCloneCell(e, to_file);

  if Assigned(new_cell) then begin
    AddMessage('Cloned to ' + ShortName(new_cell));
    Result := 0;
  end
  else begin
    Result := 1;
  end;
end;

end.
