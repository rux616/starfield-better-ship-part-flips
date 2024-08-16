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
  Changes menu sort order of COBJ and RSPJ records via altering SNAM elements so they start at a given number
}
unit StarfieldChangeCOBJRSPJMenuSortOrder;

var order, increment: single;


function Initialize: integer;
var
  proceed: boolean;
  starting_number, str_increment: string;
begin
  // get the number to start at
  proceed := InputQuery('Enter number, empty for "1"', 'Starting number', starting_number);
  // make sure the user didn't cancel
  if not proceed then begin
    AddMessage('User cancelled');
    Result := 1;
    exit;
  end;
  if starting_number <> '' then
    order := StrToFloat(starting_number)
  else
    order := 1;

  // get the number to increment by
  proceed := InputQuery('Enter number, empty for "1"', 'Increment', str_increment);
  // make sure the user didn't cancel
  if not proceed then begin
    AddMessage('User cancelled');
    Result := 1;
    exit;
  end;
  if str_increment <> '' then
    increment := StrToFloat(str_increment)
  else
    increment := 1;

  // echo the chosen settings back to the user
  AddMessage('Changing menu sort order of records to start at ' + FloatToStr(order) + ', incrementing by ' + FloatToStr(increment));
end;


function Process(e: IInterface): integer;
var
  snam_element: IInterface;
  old_order: single;
begin
  // check to make sure that this only processes COBJ and RSPJ records
  if Pos(Signature(e), 'COBJ,RSPJ') > 0 then begin
    // get the SNAM element
    snam_element := ElementBySignature(e, 'SNAM');
    if Assigned(snam_element) then
      // save the old menu order if the element exists
      old_order := GetNativeValue(snam_element)
    else
      // create the SNAM element if it doesn't exist
      Add(e, 'SNAM', True);

    // set new SNAM value
    SetNativeValue(ElementBySignature(e, 'SNAM'), order);
    AddMessage('Changed menu sort order of ' + Name(e) + ' from ' + FloatToStr(old_order) + ' to ' + FloatToStr(order));

    // increment the order by whatever interval was chosen earlier
    order := order + increment;
  end;
end;

end.
