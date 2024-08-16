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
  Removes '_lvlXX' from EDIDs
}
unit RemoveLevelFromEDID;

function Process(e: IInterface): integer;
var
  editor_id_element: IInterface;
  editor_id, editor_id_old: string;
begin
  editor_id_element := ElementBySignature(e, 'EDID');

  // make sure that there's an EDID on the record
  if Assigned(editor_id_element) then begin
    editor_id := GetEditValue(editor_id_element);
    editor_id_old := GetEditValue(editor_id_element);
    // make sure that '_lvlXX' is at the end
    if Pos('_lvl', editor_id) > Length(editor_id) - 6 then begin
      editor_id := LeftStr(editor_id, Pos('_lvl', editor_id) - 1);
      SetEditValue(editor_id_element, editor_id);
      AddMessage('EDID of [' + Signature(e) + ':' + IntToHex(FormID(e), 8) + '] changed from ''' + editor_id_old + ''' to ''' + editor_id + '''');
    end;
  end;
end;

end.
