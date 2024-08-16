unit edid_from_sntp;

function Initialize(): integer;
begin
end;

function Process(e: IInterface): integer;
var
  sntp: IInterface;
  edid: IInterface;
  mstt_prefix: string;
  mstt_edid: string;
  sntp_prefix: string;
  sntp_edid: string;
begin
  if (Signature(e) <> 'MSTT') then Exit;

  sntp := LinksTo(ElementBySignature(e, 'SNTP'));
  if not Assigned(sntp) then Exit;

  sntp_prefix := 'ShipSnap_SMOD_Generic_';
  sntp_edid := EditorID(sntp);

  mstt_prefix := 'SMOD_Snap_Generic_';
  mstt_edid := mstt_prefix + RightStr(sntp_edid, Length(sntp_edid) - Length(sntp_prefix));

  AddMessage('Changing MSTT EDID on [' + Signature(e) + ':' + IntToHex(FormID(e), 8) + '] from ' + EditorID(e) + ' to ' + mstt_edid);
  SetEditorID(e, mstt_edid);

end;

end.
