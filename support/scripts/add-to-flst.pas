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
  Add selected forms to a FLST record, optionally creating one first
  -----
  Hotkey: Ctrl+E
}
unit AddToFLST;

var chosen_flst, flst_lnams: IInterface;

function Process(e: IInterface): integer;
var
  proceed: boolean;
  str_flst_formid, str_edid, str_full: string;
  formid_array_added: boolean;
  i: integer;
begin
  // if the FLST to add records to hasn't been chosen yet, go through that process
  if not Assigned(chosen_flst) then begin
    // get the FLST Form ID to put the records in
    proceed := InputQuery('Specify FLST FormID, or leave empty for new', 'Form ID', str_flst_formid);
    if not proceed then begin
      AddMessage('User cancelled');
      Result := 1;
      exit;
    end;

    if str_flst_formid = '' then begin  // new FLST
      // ask for EDID
      proceed := InputQuery('What editor ID should the new FLST have?', 'Editor ID', str_edid);
      if not proceed then begin
        AddMessage('User cancelled');
        Result := 1;
        exit;
      end;

      // ask for FULL
      proceed := InputQuery('What name should the new FLST have?', 'FULL - Name', str_full);
      if not proceed then begin
        AddMessage('User cancelled');
        Result := 1;
        exit;
      end;

      // create FLST record
      chosen_flst := Add(GroupBySignature(GetFile(e), 'FLST'), 'FLST', True);

      // set EDID
      SetEditValue(Add(chosen_flst, 'EDID', True), str_edid);

      // set FULL
      if str_full <> '' then
        SetEditValue(Add(chosen_flst, 'FULL', True), str_full);

      AddMessage('Created form list ' + Name(chosen_flst));
    end
    else begin  // add to existing FLST
      chosen_flst := RecordByHexFormID(str_flst_formid);
      if Signature(chosen_flst) <> 'FLST' then begin
        AddMessage('ERROR: invalid record type chosen: ' + Name(chosen_flst));
        Result := 1;
        exit;
      end;
      // TODO add case where chosen FLST is in main ESM file and has no overrides
      //  present file list minus main ESM and ask to pick where override should go, including a new file?
      (* ---> WIP CODE --->
      frm := frmFileSelect;
      try
        frm.Caption := 'Which override to use?';
        clb := TCheckListBox(frm.FindComponent('CheckListBox1'));
      finally
        free frm;
      end;
      // <--- WIP CODE <--- *)

      // TODO add case where chosen FLST has overrides
      //  present file list plus an additional option for creating a new override IF not all files (minus the main ESM and the originating record ESM) have overrides yet
      //  user picks one or more file to edit the override in, if new override, possibility of new file exists.

      // in the absence of more comprehensive checks as detailed above, this will do
      // check if FLST has an override in the plugin where 'e' resides and use that instead
      if OverrideCount(chosen_flst) > 0 then begin
        AddMessage('debug: chosen_flst: ' + FullPath(chosen_flst));
        AddMessage('debug: OverrideCount: ' + IntToStr(OverrideCount(chosen_flst)));
        for i := Pred(OverrideCount(chosen_flst)) to 0 do begin
          AddMessage('debug: i: ' + IntToStr(i));
          // possible bug: check if 'getfile' and 'getfilename' return anything for newly-created records
          if SameText(GetFileName(GetFile(OverrideByIndex(chosen_flst, i))), GetFileName(GetFile(e))) then begin
            AddMessage('debug: override check: text matches');
            chosen_flst := OverrideByIndex(chosen_flst, i);
            AddMessage('debug: override chosel_flst: ' + FullPath(chosen_flst));
            break;
          end;
        end;
      end;
      AddMessage('Using form list ' + Name(chosen_flst));
    end;
  end;

  // add plugin containing record 'e' as a master to plugin holding FLST, but only if they aren't the same file
  if not SameText(GetFileName(GetFile(chosen_flst)), GetFileName(GetFile(e))) then
    AddMasterIfMissing(GetFile(chosen_flst), GetFileName(GetFile(e)));

  // check to make sure the flst has "FormIDs" array, add if it doesn't
  if not Assigned(flst_lnams) then begin
    // add LNAM array
    flst_lnams := Add(chosen_flst, 'FormIDs', True);
  end;

  // prevent FLST from being added to itself
  if ShortName(e) = ShortName(chosen_flst) then begin
    AddMessage('Skipped: ' + ShortName(chosen_flst) + ', cannot add FLST to itself');
    exit;
  end;

  // prevent existing FormIDs from being duplicated
  for i := 0 to Pred(ElementCount(flst_lnams)) do begin
    if GetEditValue(ElementByIndex(flst_lnams, i)) = Name(e) then begin
      AddMessage('Skipped: ' + ShortName(e) + ' already exists in ' + ShortName(chosen_flst));
      exit;
    end;
  end;

  // add 'e' to FLST
  ElementAssign(flst_lnams, HighInteger, e, False);
  AddMessage('Added ' + ShortName(e) + ' to ' + ShortName(chosen_flst));
end;

end.
