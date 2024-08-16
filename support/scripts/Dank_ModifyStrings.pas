{
	Add and replace strings.

	Hotkey: Ctrl+D
}
unit UserScript;

var
	processCount: integer;
	strElement, strAction, strAdd, strSearch, strMessage: string;
	cmbContainer: TComboBox;

const
	ELEMENT_NAME_EDID = 'EDID - Editor ID';
	ELEMENT_NAME_FULL = 'FULL - Name';
	ELEMENT_NAME_DESC = 'DESC - Description';
	ELEMENT_NAME_DATA = 'DATA - Weight';
	ELEMENT_NAME_ONAM = 'ONAM - Short Name';

function Initialize: integer;
begin
	processCount := 0;
	strMessage := 'String processing canceled.';
	ShowBrowser;
	if not Assigned(strAction) then begin
		Result := 1;
	end else begin
		Result := 0;
	end;
	exit;
end;

//=================== Browser

procedure ShowBrowser;
var
	frm: TForm;
	i, tOff, lOff, vPad, hPad, btnWidth, btnHeight: integer;
	panelMain: TPanel;
	btnAddPrefix, btnAddSuffix, btnReplace: TButton;
begin
	tOff := 50;
	lOff := 25;
	vPad := 10;
	hPad := 10;
	btnWidth := 200;
	frm := TForm.Create(nil);
	try
		frm.Caption := 'Modify Strings';
		frm.Width := 250;
		frm.Height := 220;
		frm.Position := poScreenCenter;
		frm.KeyPreview := True;

		panelMain := TPanel.Create(frm);
		panelMain.Parent := frm;
		panelMain.Width := frm.Width;
		panelMain.Height := frm.Height;
		panelMain.Top := frm.Top;
		panelMain.Left := frm.Left;
		panelMain.Anchors := [akRight, akBottom];
		panelMain.AlignWithMargins := true;

		cmbContainer := TComboBox.Create(panelMain);
		cmbContainer.Parent := panelMain;
		cmbContainer.Top := tOff;
		cmbContainer.Left := lOff;
		cmbContainer.Width := btnWidth;
		cmbContainer.Style := csDropDownList;
		cmbContainer.Anchors := [akTop, akRight];
		cmbContainer.OnChange := cmbContainerOnChange;
		// Add editor fields you want to alter with the script here
		cmbContainer.Items.Add(ELEMENT_NAME_EDID);
		cmbContainer.Items.Add(ELEMENT_NAME_FULL);
		cmbContainer.Items.Add(ELEMENT_NAME_DESC);
		cmbContainer.Items.Add(ELEMENT_NAME_DATA);
		cmbContainer.Items.Add(ELEMENT_NAME_ONAM);
		cmbContainer.ItemIndex := 0;

		btnAddPrefix := TButton.Create(panelMain);
		btnAddPrefix.Parent := panelMain;
		btnAddPrefix.Top := cmbContainer.Top + cmbContainer.Height + vPad * 2;
		btnAddPrefix.Left := lOff;
		btnAddPrefix.Width := btnWidth;
		btnAddPrefix.Caption := 'Add Prefix';
		btnAddPrefix.Anchors := [akRight, akBottom];
		btnAddPrefix.OnClick := evtButtonAddPrefix;
		btnAddPrefix.ModalResult := mrOk;

		btnAddSuffix := TButton.Create(panelMain);
		btnAddSuffix.Parent := panelMain;
		btnAddSuffix.Top := btnAddPrefix.Top + btnAddPrefix.Height + vPad;
		btnAddSuffix.Left := lOff;
		btnAddSuffix.Width := btnWidth;
		btnAddSuffix.Caption := 'Add Suffix';
		btnAddSuffix.Anchors := [akRight, akBottom];
		btnAddSuffix.OnClick := evtButtonAddSuffix;
		btnAddSuffix.ModalResult := mrOk;

		btnReplace := TButton.Create(panelMain);
		btnReplace.Parent := panelMain;
		btnReplace.Top := btnAddSuffix.Top + btnAddSuffix.Height + vPad;
		btnReplace.Left := lOff;
		btnReplace.Width := btnWidth;
		btnReplace.Caption := 'Replace';
		btnReplace.Anchors := [akRight, akBottom];
		btnReplace.OnClick := evtButtonReplace;
		btnReplace.ModalResult := mrOk;

		strElement := cmbContainer.Text;
		frm.ShowModal;
	finally
		frm.Free;
	end;
end;

//=================== Button Handler

procedure evtButtonAddPrefix(Sender: TObject);
begin
	strAction := 'AddPrefix';
	if not InputQuery('Add Prefix', 'String to add as prefix: ', strAdd) then begin
		AddMessage(strMessage);
		exit;
	end;
end;

procedure evtButtonAddSuffix(Sender: TObject);
begin
	strAction := 'AddSuffix';
	if not InputQuery('Add Suffix', 'String to add as suffix: ', strAdd) then begin
		AddMessage(strMessage);
		exit;
	end;
end;

procedure evtButtonReplace(Sender: TObject);
begin
	strAction := 'Replace';
	if (not InputQuery('Replace', 'Search for:', StrSearch)) or (not InputQuery('Replace', 'Replace with:', strAdd)) then begin
		AddMessage(strMessage);
		exit;
	end;
end;

procedure cmbContainerOnChange(Sender: TObject);
begin
	strElement := cmbContainer.Text;
end;

//=================== Processing

function Process(e: IInterface): integer;
var
	components, component, elementName: IInterface;
	strPresent, strResult: string;
	i: integer;
begin
	if (Signature(e) = 'GBFM') and (strElement = ELEMENT_NAME_FULL) then begin
		// do gbfm things here
		components := ElementByPath(e, 'Base Form Components');
		for i := 0 to Pred(ElementCount(components)) do begin
			component := ElementByIndex(components, i);
			elementName := ElementByPath(component, 'Component Data - Fullname\' + strElement);
			// AddMessage('debug: gbfm full: ' + Name(component) + ' \ ' + Name(component_data));
			if Assigned(elementName) then break;
		end;
	end else begin
		elementName := ElementByName(e, strElement);
	end;
	strPresent := GetEditValue(elementName);
	Inc(processCount);
	AddMessage('Processing in ' + FullPath(e));
	if strAction = 'AddPrefix' then begin
		SetEditValue(elementName, strAdd + strPresent)
	end;
	if strAction = 'AddSuffix' then begin
		SetEditValue(elementName, strPresent + strAdd)
	end;
	if strAction = 'Replace' then begin
		strResult := StringReplace(strPresent, strSearch, strAdd, [rfReplaceAll]);
		if not SameText(strResult, strPresent) then begin
			SetEditValue(elementName, strResult)
		end;
	end;
end;

function Finalize: integer;
begin
	AddMessage(Format('%d records processed.', [processCount]));
end;

end.
