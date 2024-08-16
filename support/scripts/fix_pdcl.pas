{
  Fixes CELL PDCL records so that their XPDO subrecords are correctly linked to the PDCL record.
}
unit fix_pdcl;


const
  EXCLUDE_FILES_MASTERS = 'Starfield.esm,Starfield.exe,BlueprintShips-Starfield.esm,OldMars.esm,Constellation.esm,SFBGS007.esm,SFBGS008.esm,SFBGS006.esm,SFBGS003.esm';
  DRY_RUN = False;


var
  mstt_refr_records: TList;
  num_replaced: integer;
  dry_run_str: string;


function refr_needs_replacement(refr1: IInterface; refr2: IInterface): boolean;
var
  refr1_edid, refr2_edid: string;
  paths: array[0..5] of string;
  i: integer;
begin
  Result := False;

  // check form id
  if (GetLoadOrderFormID(refr1) = GetLoadOrderFormID(refr2)) then begin
    Exit;
  end;

  // check first 9 characters of the editor id
  refr1_edid := EditorID(LinksTo(ElementByPath(refr1, 'NAME')));
  refr2_edid := EditorID(LinksTo(ElementByPath(refr2, 'NAME')));
  // AddMessage('DEBUG       comparing ' + refr1_edid + ' (' + Copy(refr1_edid, 0, 9) + ') with ' + refr2_edid + ' (' + Copy(refr2_edid, 0, 9) + ')');
  if (Copy(refr1_edid, 0, 9) <> Copy(refr2_edid, 0, 9)) then begin
    Exit;
  end;

  // set paths to check
  paths[0] := 'DATA\Position\X';
  paths[1] := 'DATA\Position\Y';
  paths[2] := 'DATA\Position\Z';
  paths[3] := 'DATA\Rotation\X';
  paths[4] := 'DATA\Rotation\Y';
  paths[5] := 'DATA\Rotation\Z';

  // check if all paths are equal
  for i := 0 to High(paths) do begin
    // AddMessage('DEBUG       comparing ' + paths[i] + ' (' + FloatToStr(GetNativeValue(ElementByPath(refr1, paths[i]))) + ' with ' + FloatToStr(GetNativeValue(ElementByPath(refr2, paths[i]))) + ')');
    if (GetNativeValue(ElementByPath(refr1, paths[i])) <> GetNativeValue(ElementByPath(refr2, paths[i]))) then begin
      Exit;
    end;
  end;

  Result := True;
end;


function process_pdcl_refr_record(current_record: IInterface): integer;
var
  i, j: integer;
  mstt_refr_copy: TList;
  xpdo_subrecord: IInterface;
  xpdo_reference: IInterface;
  xpdo_linked_refr: IInterface;
  mstt_linked_refr: IInterface;
begin
  // check if Projected Decal \ XPDO subrecord exists
  xpdo_subrecord := ElementByPath(current_record, 'Projected Decal\XPDO - Projected Decal References');
  if (not Assigned(xpdo_subrecord)) then begin
    Exit;
  end;

  // duplicate MSTT REFR array
  mstt_refr_copy := TList.Create();
  for i := 0 to Pred(mstt_refr_records.Count) do begin
    mstt_refr_copy.Add(mstt_refr_records[i]);
  end;

  // for each Projected Decal \ XPDO reference
  for i := 0 to Pred(ElementCount(xpdo_subrecord)) do begin
    xpdo_reference := ElementByIndex(xpdo_subrecord, i);
    xpdo_linked_refr := LinksTo(xpdo_reference);

    // for each MSTT REFR array member
    for j := 0 to Pred(mstt_refr_copy.Count) do begin
      mstt_linked_refr := ObjectToElement(mstt_refr_copy[j]);

      // check if form ids match - if they do, remove the array member and break
      if (GetLoadOrderFormID(xpdo_linked_refr) = GetLoadOrderFormID(mstt_linked_refr)) then begin
        mstt_refr_copy.Delete(j);
        Break;
      // check if the XPDO reference needs to be replaced with the MSTT_REFR array member
      end else if (refr_needs_replacement(xpdo_linked_refr, mstt_linked_refr)) then begin
        // replace XPDO reference with MSTT_REFR array member
        AddMessage(dry_run_str + '        XPDO ref ' + IntToStr(i) + ': replacing ' + ShortName(LinksTo(xpdo_reference)) + ' with ' + ShortName(mstt_linked_refr));
        if (not DRY_RUN) then begin
          SetNativeValue(xpdo_reference, GetLoadOrderFormID(mstt_linked_refr));
        end;
        num_replaced := num_replaced + 1;

        // remove MSTT_REFR array member
        mstt_refr_copy.Delete(j);
        Break;
      end;
    end;
  end;

  mstt_refr_copy.Free();
end;


function process_cell_group(cell_group: IInterface): integer;
var
  i: integer;
  child_record: IInterface;
  child_record_name: IInterface;
  xpdo_subrecord: IInterface;
begin
  // clear MSTT REFR array
  mstt_refr_records.Clear();

  // for each cell child record
  AddMessage(dry_run_str + '    MSTT REFR records:');
  for i := 0 to Pred(ElementCount(cell_group)) do begin
    child_record := ElementByIndex(cell_group, i);
    child_record_name:= LinksTo(ElementByPath(child_record, 'NAME'));

    // if MSTT REFR
    if (Signature(child_record) <> 'REFR') or (Signature(child_record_name) <> 'MSTT') then begin
      Continue;
    end;
    AddMessage(dry_run_str + '      ' + ShortName(child_record) + ' :: ' + ShortName(child_record_name));

    // add to MSTT_REFR array
    mstt_refr_records.Add(TObject(child_record));
  end;

  // for each cell child record
  AddMessage(dry_run_str + '    PDCL REFR records:');
  for i := 0 to Pred(ElementCount(cell_group)) do begin
    child_record := ElementByIndex(cell_group, i);
    child_record_name:= LinksTo(ElementByPath(child_record, 'NAME'));
    if (Signature(child_record) <> 'REFR') or (Signature(child_record_name) <> 'PDCL') then begin
      Continue;
    end;
    AddMessage(dry_run_str + '      ' + ShortName(child_record) + ' :: ' + ShortName(child_record_name));
    process_pdcl_refr_record(child_record);
  end;
  Result := 0;
end;


function Initialize(): integer;
begin
  mstt_refr_records := TList.Create();
  num_replaced := 0;
  if (DRY_RUN) then begin
    dry_run_str := 'DRY RUN ';
  end else begin
    dry_run_str := '';
  end;
end;


function Process(current_record: IInterface): integer;
const
  GROUP_TYPE_CELL_PERSISTENT_CHILDREN = 8;
  GROUP_TYPE_CELL_TEMPORARY_CHILDREN = 9;
var
  cell_group: IInterface;
  child_record: IInterface;
  child_record_name: IInterface;
  i: integer;
begin
  if Signature(current_record) <> 'CELL' then begin
    Exit;
  end;

  AddMessage(dry_run_str + 'processing ' + Name(current_record));

  cell_group := FindChildGroup(ChildGroup(current_record), GROUP_TYPE_CELL_PERSISTENT_CHILDREN, current_record);
  AddMessage(dry_run_str + '  persistent children (qty ' + IntToStr(ElementCount(cell_group)) + '):');
  process_cell_group(cell_group);

  cell_group := FindChildGroup(ChildGroup(current_record), GROUP_TYPE_CELL_TEMPORARY_CHILDREN, current_record);
  AddMessage(dry_run_str + '  temporary children (qty ' + IntToStr(ElementCount(cell_group)) + '):');
  process_cell_group(cell_group);
end;


function Finalize(): integer;
begin
  AddMessage(dry_run_str + 'replaced ' + IntToStr(num_replaced) + ' XPDO references');
  mstt_refr_records.Free();
end;


end.
