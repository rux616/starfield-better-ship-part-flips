{
  Rotates contents of cells. Supports additional filtering by record signature, REFR NAME signature,
  and REFR NAME EDIDs.

  Note: Starfield uses right-hand rule coordinates (https://en.wikipedia.org/wiki/Right-hand_rule#Coordinates)
  and rotations are clockwise positive (left-hand grip rule - thumb represents positive direction
  of axis of rotation and the fingers curl in the direction of a positive rotation), done in a ZYX
  sequence. Looking at the front of a ship that's facing you:
    +x is left (starboard)
    -x is right (port)
    +y is towards you (fore)
    -y is away from you (aft)
    +z is up
    -z is down
  --------------------
  Hotkey: Ctrl+Shift+R
}
unit rotate_cell_contents;


(*
  Copyright 2024 Dan Cassidy

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.

  SPDX-License-Identifier: GPL-3.0-or-later
  --------------------------------------------------------------------------------------------------
  Rotate Cell Contents v1.3.0

  I've done my best to organize this code into logical sections, but it's still just a lot of code.

  Section listing:
  - constants
  - globals
  - utility functions
  - event handlers
  - rotation and position functions
  - ui functions
  - xedit script functions

  Each section has a header that looks like this:

  //************************************************************************************************//
  //                                                                                                //
  // SECTION NAME                                                                                   //
  //                                                                                                //
  //************************************************************************************************//

  and can be searched for with the regex "^//\**//\n//.*//\n//.*\n//.*\n//\**//"
*)


//************************************************************************************************//
//                                                                                                //
// CONSTANTS                                                                                      //
//                                                                                                //
//************************************************************************************************//


const
  // possible rotation sequences for Tait-Bryan angles
  // see https://en.wikipedia.org/wiki/Euler_angles#Chained_rotations_equivalence for more information
  SEQUENCE_XYZ = 0; SEQUENCE_MIN = 0;
  SEQUENCE_XZY = 1;
  SEQUENCE_YXZ = 2;
  SEQUENCE_YZX = 3;
  SEQUENCE_ZXY = 4;
  SEQUENCE_ZYX = 5; SEQUENCE_MAX = 5;

  SEQUENCE_XYZ_INVERSE = SEQUENCE_ZYX;
  SEQUENCE_XZY_INVERSE = SEQUENCE_YZX;
  SEQUENCE_YXZ_INVERSE = SEQUENCE_ZXY;
  SEQUENCE_YZX_INVERSE = SEQUENCE_XZY;
  SEQUENCE_ZXY_INVERSE = SEQUENCE_YXZ;
  SEQUENCE_ZYX_INVERSE = SEQUENCE_XYZ;

  // helper constants for rotation operation modes
  OPERATION_MODE_SET = True;
  OPERATION_MODE_ROTATE = False;

  // helper constants for filter modes
  FILTER_MODE_INCLUDE = True;
  FILTER_MODE_EXCLUDE = False;

  // helper constants for filter types
  FILTER_TYPE_RECORD_SIGNATURE = 0;
  FILTER_TYPE_REFR_NAME_SIGNATURE = 1;
  FILTER_TYPE_EDID_STARTS_WITH = 2;
  FILTER_TYPE_EDID_ENDS_WITH = 3;
  FILTER_TYPE_EDID_CONTAINS = 4;
  FILTER_TYPE_EDID_EQUALS = 5;

  // helper constants for clamp modes
  CLAMP_MODE_05 = 0;  CLAMP_MODE_MIN = 0;
  CLAMP_MODE_10 = 1;
  CLAMP_MODE_15 = 2;
  CLAMP_MODE_30 = 3;
  CLAMP_MODE_45 = 4;
  CLAMP_MODE_90 = 5;  CLAMP_MODE_MAX = 5;

  // helper constants for position/rotation precision
  PRECISION_POSITION = -6;
  PRECISION_ROTATION = -4;
  PRECISION_MIN = 0;
  PRECISION_MAX = -6;

  // global defaults
  GLOBAL_DEBUG_DEFAULT = False;

  GLOBAL_RECORD_SIGNATURE_USE_DEFAULT = True;
  GLOBAL_RECORD_SIGNATURE_MODE_DEFAULT = FILTER_MODE_INCLUDE;
  GLOBAL_RECORD_SIGNATURE_LIST_DEFAULT = 'ACHR,REFR';
  GLOBAL_REFR_NAME_SIGNATURE_USE_DEFAULT = True;
  GLOBAL_REFR_NAME_SIGNATURE_MODE_DEFAULT = FILTER_MODE_INCLUDE;
  GLOBAL_REFR_NAME_SIGNATURE_LIST_DEFAULT =
    'ACTI,ALCH,ASPC,BOOK,CONT,DOOR,FURN,IDLM,LIGH,MISC,MSTT,PDCL,PKIN,SOUN,STAT,TERM';
  GLOBAL_EDID_STARTS_WITH_USE_DEFAULT = True;
  GLOBAL_EDID_STARTS_WITH_MODE_DEFAULT = FILTER_MODE_EXCLUDE;
  GLOBAL_EDID_STARTS_WITH_LIST_DEFAULT = 'SMOD_Snap_';
  GLOBAL_EDID_ENDS_WITH_USE_DEFAULT = False;
  GLOBAL_EDID_ENDS_WITH_MODE_DEFAULT = FILTER_MODE_INCLUDE;
  GLOBAL_EDID_ENDS_WITH_LIST_DEFAULT = '';
  GLOBAL_EDID_CONTAINS_USE_DEFAULT = False;
  GLOBAL_EDID_CONTAINS_MODE_DEFAULT = FILTER_MODE_INCLUDE;
  GLOBAL_EDID_CONTAINS_LIST_DEFAULT = '';
  GLOBAL_EDID_EQUALS_USE_DEFAULT = True;
  GLOBAL_EDID_EQUALS_MODE_DEFAULT = FILTER_MODE_EXCLUDE;
  GLOBAL_EDID_EQUALS_LIST_DEFAULT = 'OutpostGroupPackinDummy,PrefabPackinPivotDummy';

  GLOBAL_ROTATION_X_DEFAULT = 0.0;
  GLOBAL_ROTATION_Y_DEFAULT = 0.0;
  GLOBAL_ROTATION_Z_DEFAULT = 0.0;

  GLOBAL_OPERATION_MODE_DEFAULT = OPERATION_MODE_ROTATE;
  GLOBAL_ROTATION_SEQUENCE_DEFAULT = SEQUENCE_ZYX;
  GLOBAL_APPLY_TO_POSITION_DEFAULT = True;
  GLOBAL_APPLY_TO_ROTATION_DEFAULT = True;

  GLOBAL_CLAMP_USE_DEFAULT = True;
  GLOBAL_CLAMP_MODE_DEFAULT = CLAMP_MODE_90;
  GLOBAL_POSITION_PRECISION_DEFAULT = -6;  // precision to nearest 0.000001
  GLOBAL_ROTATION_PRECISION_DEFAULT = -4;  // precision to nearest 0.0001

  GLOBAL_DRY_RUN_DEFAULT = False;
  GLOBAL_SAVE_TO_SAME_FILE_DEFAULT = True;
  GLOBAL_USE_SAME_SETTINGS_FOR_ALL_DEFAULT = True;

  // UI constants
  MARGIN_TOP = 5;
  MARGIN_BOTTOM = 5;
  MARGIN_LEFT = 5;
  MARGIN_RIGHT = 5;
  PANEL_BEVEL = 2;
  CONTROL_HEIGHT = 22;

  CHECKBOX_PADDING = 21;
  RADIO_PADDING = 21;
  COMBO_PADDING = 24;
  SCROLLBAR_PADDING = 24;
  BUTTON_PADDING = 20;

  OK_BUTTON_NAME = 'ok_button';
  FILE_LIST_FILTER_NAME = 'file_list_filter';
  FILE_LIST_CONTROL_NAME = 'file_list_control';

  // epsilon to use for CompareValue calls
  // between positions and rotations, positions have more significant decimals (6), so this is set
  // to compliment that
  EPSILON = 0.000001;
  // complimentary epsilon for rotations, which have less significant decimals (4)
  EPSILON_ROTATION = 0.0001;

  // declare constants to replace contents of TFloatFormat enum, since it's not available in xEdit scripts
  // https://docwiki.embarcadero.com/Libraries/Alexandria/en/System.SysUtils.TFloatFormat
  ffGeneral = 0;
  ffExponent = 1;
  ffFixed = 2;
  ffNumber = 3;
  ffCurrency = 4;

  // precision of stringified floats
  PRECISION_SINGLE = 7;
  PRECISION_DOUBLE = 15;
  PRECISION_EXTENDED = 18;

  // number of decimal places to use in stringified floats
  DIGITS_NONE = 0;
  DIGITS_ANGLE = 4;
  DIGITS_POSITION = 6;
  DIGITS_FULL = 15;

  // compared against wbVersionNumber, which is a hex-encoded integer, 0xAABBCCDD, where AA is the
  // major version, BB is the minor version, CC is the patch, and DD is the revision (shown as an
  // ASCII character, starting with 'a' at 1, 'b' at 2, etc.)
  MINIMUM_REQUIRED_XEDIT_VERSION = $04010503;
  // version 4.1.5c                  │ │ │ │
  // major:    4 ────────────────────┘ │ │ │
  // minor:    1 ──────────────────────┘ │ │
  // patch:    5 ────────────────────────┘ │
  // revision: c (3) ──────────────────────┘

  // constants for new file creation
  NEW_FILE_ESP = 0;
  NEW_FILE_ESP_MASTER = 1;
  NEW_FILE_ESP_LIGHT = 2;
  NEW_FILE_ESP_MASTER_LIGHT = 3;
  NEW_FILE_ESM = 4;
  NEW_FILE_ESL = 5;


//************************************************************************************************//
//                                                                                                //
// GLOBALS                                                                                        //
//                                                                                                //
//************************************************************************************************//


var
  // global configuration options
  global_debug: boolean;

  global_record_signature_use: boolean;
  global_record_signature_mode: boolean;     // True = include, False = exclude
  global_record_signature_list: string;
  global_refr_name_signature_use: boolean;
  global_refr_name_signature_mode: boolean;  // True = include, False = exclude
  global_refr_name_signature_list: string;
  global_edid_starts_with_use: boolean;
  global_edid_starts_with_mode: boolean;     // True = include, False = exclude
  global_edid_starts_with_list: string;
  global_edid_ends_with_use: boolean;
  global_edid_ends_with_mode: boolean;       // True = include, False = exclude
  global_edid_ends_with_list: string;
  global_edid_contains_use: boolean;
  global_edid_contains_mode: boolean;        // True = include, False = exclude
  global_edid_contains_list: string;
  global_edid_equals_use: boolean;
  global_edid_equals_mode: boolean;          // True = include, False = exclude
  global_edid_equals_list: string;

  global_rotate_x: double;
  global_rotate_y: double;
  global_rotate_z: double;

  global_operation_mode: boolean;  // True = set, False = rotate
  global_rotation_sequence: integer;
  global_apply_to_position: boolean;
  global_apply_to_rotation: boolean;

  global_clamp_use: boolean;
  global_clamp_mode: integer;
  global_position_precision: integer;  // 0 to -6
  global_rotation_precision: integer;  // 0 to -4

  global_dry_run: boolean;
  global_save_to_same_file: boolean;
  global_use_same_settings_for_all: boolean;

  // global scale factor for GUI elements
  global_scale_factor: double;

  // whether the options dialog has been shown before
  global_options_dialog_shown: boolean;

  // holds the file list used when filtering the file list control in the file dialog
  temp_file_list: TStringList;
  temp_currently_selected: string;

  // files that changes are made to, if not the record's file
  global_target_file_list: TStringList;


//************************************************************************************************//
//                                                                                                //
// UTILITY FUNCTIONS                                                                              //
//                                                                                                //
//************************************************************************************************//


// return a stringified boolean
function bool_to_str(b: boolean): string;
begin
  if b then Result := 'True' else Result := 'False';
end;


// return a string representing whether a boolean would represent a checked box or not
function bool_to_checked_str(b: boolean): string;
begin
  if b then Result := 'checked' else Result := 'unchecked';
end;


// return a string representing whether a boolean would represent an enabled control/mode/etc or not
function bool_to_enabled_str(b: boolean): string;
begin
  if b then Result := 'enabled' else Result := 'disabled';
end;


// return a string representing whether a boolean would represent a selected radio button or not
function bool_to_selected_str(b: boolean): string;
begin
  if b then Result := 'selected' else Result := 'not selected';
end;


// return the width of a control's caption
function caption_width(control: TControl): integer;
begin
  Result := string_width(StringReplace(control.Caption, '&', '', [rfReplaceAll]), control.Font, nil);
end;


// check a record against a given filter, returning True if the record passes the filter
function check_filter(
  record_to_check: IInterface;
  filter_type: integer;
  filter_type_text: string;
  filter_use, filter_mode: boolean;
  filter_list: string;
): boolean;
var
  str_to_test, match_text: string;
  list: TStringList;
  i: integer;
  match: boolean;
  linked_element: IInterface;
begin
  if (not filter_use) then begin
    debug_print('check_filter: ' + filter_type_text + ': filter not active');
    Result := True;
  end else begin
    case (filter_type) of
      FILTER_TYPE_RECORD_SIGNATURE:
        str_to_test := Signature(record_to_check);
      FILTER_TYPE_REFR_NAME_SIGNATURE: begin
        linked_element := LinksTo(ElementBySignature(record_to_check, 'NAME'));
        str_to_test := Signature(linked_element);
        debug_print('check_filter: linked element file: ' + GetFileName(GetFile(linked_element)));
        debug_print('check_filter: linked element EDID: ' + EditorID(linked_element));
        debug_print('check_filter: linked element signature: ' + str_to_test);
      end;
      FILTER_TYPE_EDID_STARTS_WITH, FILTER_TYPE_EDID_ENDS_WITH, FILTER_TYPE_EDID_CONTAINS, FILTER_TYPE_EDID_EQUALS: begin
        linked_element := LinksTo(ElementBySignature(record_to_check, 'NAME'));
        str_to_test := EditorID(linked_element);
        debug_print('check_filter: linked element file: ' + GetFileName(GetFile(linked_element)));
        debug_print('check_filter: linked element EDID: ' + str_to_test);
        debug_print('check_filter: linked element signature: ' + Signature(linked_element));
      end;
    else
      raise Exception.Create('unknown filter type: ' + filter_type_text);
    end;

    if (str_to_test = '') then begin
      debug_print('check_filter: ' + filter_type_text + ': string to test is empty');
    end else begin
      debug_print('check_filter: ' + filter_type_text + ': string to test is "' + str_to_test + '"');
      list := string_array_to_string_list(SplitString(filter_list, ','));
      debug_print('check_filter: ' + filter_type_text + ': list length: ' + IntToStr(list.Count));
      debug_print('check_filter: ' + filter_type_text + ': list: [' + concat_string_list(list, '", "', '"', '"') + ']');

      for i := 0 to Pred(list.Count) do begin
        case (filter_type) of
          FILTER_TYPE_RECORD_SIGNATURE, FILTER_TYPE_REFR_NAME_SIGNATURE, FILTER_TYPE_EDID_EQUALS:
            match := SameText(str_to_test, list[i]);
          FILTER_TYPE_EDID_STARTS_WITH:
            match := SameText(LeftStr(str_to_test, Length(list[i])), list[i]);
          FILTER_TYPE_EDID_ENDS_WITH:
            match := SameText(RightStr(str_to_test, Length(list[i])), list[i]);
          FILTER_TYPE_EDID_CONTAINS:
            match := ContainsText(str_to_test, list[i]);
        end;
        if (match) then match_text := 'match' else match_text := 'no match';
        debug_print('check_filter: ' + filter_type_text + ': checking "' + str_to_test + '" against "' + list[i]
          + '": ' + match_text);
        if (match) then break;
      end;
      if (match) then match_text := '' else match_text := ' not';
      debug_print('check_filter: ' + filter_type_text + ': "' + str_to_test + '"' + match_text + ' in list');
    end;

    if (filter_mode = FILTER_MODE_INCLUDE) then
      Result := match
    else if (filter_mode = FILTER_MODE_EXCLUDE) then
      Result := not match;
  end;
  debug_print('check_filter: ' + filter_type_text + ': include: ' + bool_to_str(Result));
end;


// clamp given value d between min and max (inclusive)
function clamp(d, min, max: double): double;
begin
  if (CompareValue(d, min, EPSILON) = LessThanValue) then begin
    debug_print('clamp: clamping to min (' + float_to_str(min, DIGITS_FULL, False) + ')');
    Result := min;
  end else if (CompareValue(d, max, EPSILON) = GreaterThanValue) then begin
    debug_print('clamp: clamping to max (' + float_to_str(max, DIGITS_FULL, False) + ')');
    Result := max;
  end else begin
    debug_print('clamp: no clamping needed');
    Result := d;
  end;
end;


// clamp an angle to the nearest angle defined by the given clamp mode
function clamp_angle(d: double; clamp_mode: integer): double;
var
  clamp_angle, remainder: double;
begin
  clamp_angle := clamp_mode_to_angle(clamp_mode);
  remainder := FMod(d, clamp_angle);
  if (CompareValue(remainder, clamp_angle / 2.0, EPSILON) = LessThanValue) then
    Result := d - remainder
  else
    Result := d + (clamp_angle - remainder);
end;


// return the angle of the given clamp mode
function clamp_mode_to_angle(clamp_mode: integer): double;
begin
  case (clamp_mode) of
    CLAMP_MODE_05: Result := 5.0;
    CLAMP_MODE_10: Result := 10.0;
    CLAMP_MODE_15: Result := 15.0;
    CLAMP_MODE_30: Result := 30.0;
    CLAMP_MODE_45: Result := 45.0;
    CLAMP_MODE_90: Result := 90.0;
  else
    raise Exception.Create('unknown clamp mode: ' + IntToStr(clamp_mode));
  end;
end;


// return the stringified clamp mode
function clamp_mode_to_str(clamp_mode: integer): string;
begin
  Result := float_to_str(clamp_mode_to_angle(clamp_mode), DIGITS_NONE, False) + Chr($B0) {degree symbol};
end;


// concatenate the contents of a TStringList into a single string, with a specified delimiter between
// each element and individually specified end caps on either side
function concat_string_list(list: TStringList; delimiter, end_cap_left, end_cap_right: string): string;
var
  i: integer;
begin
  for i := 0 to Pred(list.Count) do begin
    Result := Result + list[i];
    if (i < Pred(list.Count)) then Result := Result + delimiter;
  end;
  // if the concatenation is not empty, add the end cap string on both sides
  if (Result <> '') then Result := end_cap_left + Result + end_cap_right;
end;


// print a message to the xEdit log if debug mode is active
procedure debug_print(debug_message: string);
begin
  if global_debug then AddMessage('    debug: ' + debug_message);
end;


// set some common options on a panel
// borrowed from https://github.com/fre-sch/starfield-toolbox/blob/13de7c6e1d1b13a859ad1675df68ccbae0988eb1/xedit-scripts/Create%20new%20part.pas#L462-L474
procedure do_panel_layout(panel: TPanel; bevel: integer);
begin
  panel.AutoSize := True;
  panel.BevelOuter := bevel;  // BevelOuter defaults to 2
  if (bevel = 2) then set_margins_layout(panel, 5, 5, 5, 5, alTop);
end;


// check if a given record should be filtered out, returning True if it should be kept
// rule evaluation order, first to last:
// record signature, REFR NAME signature, EDID starts with, EDID ends with, EDID contains, EDID equals
function filter_record(to_check: IInterface): boolean;
var
  subrecord, position, rotation: IInterface;
begin
  debug_print('filter_record: filtering record ' + ShortName(to_check));

  // initial filter for checking if a record has a "DATA" subrecord with Position and Rotation elements
  subrecord := ElementBySignature(to_check, 'DATA');
  if (not Assigned(subrecord)) then begin
    debug_print('filter_record: record does not have "DATA" subrecord');
    Result := False;
    exit;
  end else begin
    debug_print('filter_record: record has "DATA" subrecord');
    position := ElementByPath(subrecord, 'Position');
    rotation := ElementByPath(subrecord, 'Rotation');
    if (not Assigned(position)) or (not Assigned(rotation)) then begin
      debug_print('filter_record: record does not have Position and Rotation elements in "DATA" subrecord');
      Result := False;
      exit;
    end else begin
      debug_print('filter_record: record has Position and Rotation elements in "DATA" subrecord');
    end;
  end;

  // special case: if no filters are active, return True
  if (not global_record_signature_use) and (not global_refr_name_signature_use) and
     (not global_edid_starts_with_use) and (not global_edid_ends_with_use)      and
     (not global_edid_contains_use)    and (not global_edid_equals_use)         then begin
    debug_print('filter_record: no filters active, returning True');
    Result := True;
    exit;
  end;

  // apply filters, with short circuiting if a filter returns False (Result is False by default)
  if not check_filter(to_check, FILTER_TYPE_RECORD_SIGNATURE, 'record signature', global_record_signature_use,
    global_record_signature_mode, global_record_signature_list) then exit;
  if not check_filter(to_check, FILTER_TYPE_REFR_NAME_SIGNATURE, 'refr name signature', global_refr_name_signature_use,
    global_refr_name_signature_mode, global_refr_name_signature_list) then exit;
  if not check_filter(to_check, FILTER_TYPE_EDID_STARTS_WITH, 'edid starts with', global_edid_starts_with_use,
    global_edid_starts_with_mode, global_edid_starts_with_list) then exit;
  if not check_filter(to_check, FILTER_TYPE_EDID_ENDS_WITH, 'edid ends with', global_edid_ends_with_use,
    global_edid_ends_with_mode, global_edid_ends_with_list) then exit;
  if not check_filter(to_check, FILTER_TYPE_EDID_CONTAINS, 'edid contains', global_edid_contains_use,
    global_edid_contains_mode, global_edid_contains_list) then exit;
  if not check_filter(to_check, FILTER_TYPE_EDID_EQUALS, 'edid equals', global_edid_equals_use,
    global_edid_equals_mode, global_edid_equals_list) then exit;

  // if all filters pass, return True
  Result := True;
end;


// return a stringified float to a given decimal place, optionally padded
function float_to_str(d: double; digits: integer; pad: boolean): string;
begin
  Result := FloatToStrF(d, ffFixed, PRECISION_DOUBLE, digits);
  if (pad) then begin
    debug_print('float_to_str: padding active');
    if (Length(Result) = digits + 2) then begin
      debug_print('float_to_str: padding with 2 spaces');
      Result := '  ' + Result;
    end else if (Length(Result) = digits + 3) then begin
      debug_print('float_to_str: padding with 1 space');
      Result := ' ' + Result;
    end;
  end;
end;


// return the full height of a control, defined as height + top margin + bottom margin
function full_control_height(control: TControl): integer;
begin
  Result := control.Height + control.Margins.Top + control.Margins.Bottom;
end;


// return the full width of a control, defined as width + left margin + right margin
function full_control_width(control: TControl): integer;
begin
  Result := control.Width + control.Margins.Left + control.Margins.Right;
end;


// get the parent form of a control or raise an exception if the control has no parent form
function get_parent_form(control: TControl): TForm;
begin
  while (control.ClassType <> TForm) and (control.Parent <> nil) do
    control := control.Parent;
  if (control.ClassType <> TForm) then
    raise Exception.Create('control has no parent form');
  Result := TForm(control);
end;


// return the max width of a control's Items property
function max_item_width(control: TControl): integer;
var
  bitmap: TBitmap;
  i, width: integer;
begin
  // because this is going to be used on multiple items, create a bitmap once and reuse it
  bitmap := TBitmap.Create();
  try
    bitmap.Canvas.Font.Assign(control.Font);
    for i := 0 to Pred(control.Items.Count) do begin
      // pass the bitmap in to avoid creating a new one each time
      width := string_width(control.Items[i], nil, bitmap);
      if (width > Result) then
        Result := width;
    end;
  finally
    bitmap.Free();
  end;
end;


// returns a stringified modal result
function modal_result_to_str(modal_result: integer): string;
begin
  case (modal_result) of
    mrNone: Result := 'None';
    mrOk: Result := 'OK';
    mrCancel: Result := 'Cancel';
    mrAbort: Result := 'Abort';
    mrRetry: Result := 'Retry';
    mrIgnore: Result := 'Ignore';
    mrYes: Result := 'Yes';
    mrNo: Result := 'No';
    mrAll: Result := 'All';
    mrNoToAll: Result := 'No to All';
    mrYesToAll: Result := 'Yes to All';
  else
    Result := 'unknown (' + IntToStr(modal_result) + ')';
  end;
end;


// normalize an angle (in degrees) to [0.0, 360.0)
function normalize_angle(angle: double): double;
const
  NORMALIZER = 360.0;
begin
  // FMod(a,b) returns a value between -Abs(b) and Abs(b) exclusive, so need to add b and do it again
  // to fully catch negative angles
  Result := FMod(FMod(angle, NORMALIZER) + NORMALIZER, NORMALIZER);
  if (CompareValue(angle, Result, EPSILON) <> EqualsValue) then
    debug_print('normalize_angle: ' + float_to_str(angle, DIGITS_ANGLE, False)
      + ' -> ' + float_to_str(Result, DIGITS_ANGLE, False));
end;


// return the example string for a given precision
function precision_to_str(precision: integer): string;
begin
  Result := float_to_str(Power(10.0, precision), -precision, False);
end;


// return a stringified quaternion or vector to a given number of decimal places, with options to
// pad, show brackets, show a degree symbol, and use specified delimiters between labels and components
function qv_to_str(
  w, x, y, z: double;
  is_quaternion, pad, show_brackets, show_degree: boolean;
  label_delimiter, component_delimiter: string;
  digits: integer
): string;
begin
  if (component_delimiter = '') then component_delimiter := ', ';
  if (label_delimiter = '') then label_delimiter := ': ';

  Result := '';
  if (show_brackets) then
    Result := '[';
  if (is_quaternion) then
    Result := Result + 'W' + label_delimiter + float_to_str(w, digits, pad) + component_delimiter;
  Result := Result + 'X' + label_delimiter + float_to_str(x, digits, pad);
  if (show_degree) then Result := Result + Chr($B0) {degree symbol};
  Result := Result + component_delimiter + 'Y' + label_delimiter + float_to_str(y, digits, pad);
  if (show_degree) then Result := Result + Chr($B0) {degree symbol};
  Result := Result + component_delimiter + 'Z' + label_delimiter + float_to_str(z, digits, pad);
  if (show_degree) then Result := Result + Chr($B0) {degree symbol};
  if (show_brackets) then Result := Result + ']';
end;


// return a stringified quaternion
function quaternion_to_str(qw, qx, qy, qz: double): string;
begin
  Result := qv_to_str(qw, qx, qy, qz, True, False, True, False, '', '', DIGITS_FULL);
end;


// return the stringified rotation sequence
function rotation_sequence_to_str(rotation_order: integer): string;
begin
  case (rotation_order) of
    SEQUENCE_XYZ: Result := 'XYZ';
    SEQUENCE_XZY: Result := 'XZY';
    SEQUENCE_YXZ: Result := 'YXZ';
    SEQUENCE_YZX: Result := 'YZX';
    SEQUENCE_ZXY: Result := 'ZXY';
    SEQUENCE_ZYX: Result := 'ZYX';
  else
    Result := 'unknown (' + IntToStr(rotation_order) + ')';
  end;
end;


// returns the inverse of a given rotation sequence
// this information can be paired with giving a rotation angle of -x, -y, and -z to achieve a
// rotation back to 0, 0, 0
function rotation_sequence_inverse(rotation_sequence: integer): integer;
begin
  validate_rotation_sequence(rotation_sequence);

  case (rotation_sequence) of
    SEQUENCE_XYZ: Result := SEQUENCE_XYZ_INVERSE;
    SEQUENCE_XZY: Result := SEQUENCE_XZY_INVERSE;
    SEQUENCE_YXZ: Result := SEQUENCE_YXZ_INVERSE;
    SEQUENCE_YZX: Result := SEQUENCE_YZX_INVERSE;
    SEQUENCE_ZXY: Result := SEQUENCE_ZXY_INVERSE;
    SEQUENCE_ZYX: Result := SEQUENCE_ZYX_INVERSE;
  end;
end;


// set the margins and alignment of a control
// borrowed from https://github.com/fre-sch/starfield-toolbox/blob/13de7c6e1d1b13a859ad1675df68ccbae0988eb1/xedit-scripts/Create%20new%20part.pas#L448-L459
procedure set_margins_layout(
  control: TControl;
  margin_top, margin_bottom, margin_left, margin_right: integer;
  align: integer
);
begin
  control.Margins.Top := margin_top;
  control.Margins.Bottom := margin_bottom;
  control.Margins.Left := margin_left;
  control.Margins.Right := margin_right;
  control.AlignWithMargins := True;
  control.Align := align;
end;


// return the width of a string using the given font
// if given an optional bitmap, use that instead of creating a new one
// https://stackoverflow.com/a/2548178
function string_width(s: string; font: TFont; bitmap: TBitmap): integer;
begin
  if (bitmap = nil) then begin
    // create a bitmap to use for measuring the text width
    bitmap := TBitmap.Create();
    try
      // assign a font to the bitmap's canvas to make sure the text width is calculated correctly
      bitmap.Canvas.Font.Assign(font);
      // actually calculate the text width
      Result := bitmap.Canvas.TextWidth(s);
    finally
      bitmap.Free();
    end;
  end else begin
    Result := bitmap.Canvas.TextWidth(s);
  end;
end;


// return a string list from a string array
function string_array_to_string_list(arr: TStringDynArray): TStringsList;
var
  i: integer;
begin
  Result := TStringList.Create();
  for i := 0 to Pred(Length(arr)) do
    Result.Add(arr[i]);
end;


// ord function that works in the context of xedit scripts
function unicode_ord(s: string): integer;
begin
  Result := Ord(varAsType(s, varString));
end;


// validate the given rotation sequence and throws an error if said validation fails
procedure validate_rotation_sequence(rotation_sequence: integer);
begin
  if (rotation_sequence < SEQUENCE_MIN) or (rotation_sequence > SEQUENCE_MAX) then
    raise Exception.Create('rotation sequence is ' + rotation_sequence_to_str(rotation_sequence));
end;


// return a stringified vector, optionally padded, to a given number of decimal places
function vector_to_str(vx, vy, vz: double; pad, show_degree: boolean; digits: integer): string;
begin
  Result := qv_to_str(0, vx, vy, vz, False, pad, True, show_degree, '', '', digits);
end;


// returns the decoded and stringified version number
// based off https://github.com/matortheeternal/TES5EditScripts/blob/abe8a57fd6f73c9ad4e1f734800f0b519f176fd3/Edit%20Scripts/mteFunctions.pas#L164-L184
function version_number_to_str(v: integer): string;
var
  version_major, version_minor, version_patch, version_revision: integer;
begin
  // the version number is a 32-bit signed integer and each version component uses 8 bits. the first
  // 8 bits are the major version, followed by the minor version, then the patch version, and finally
  // the revision version. to extract these, we shift the bits to the right by 24, 16, 8, and 0 bits,
  // respectively, and then mask each result with 0xFF

  // extract the version number components
  version_major := v Shr 24;
  version_minor := (v Shr 16) and $FF;
  version_patch := (v Shr 8) and $FF;
  version_revision := v and $FF;

  // build the version number string
  Result := Format('%d.%d.%d', [version_major, version_minor, version_patch]);
  if (version_revision > 0) then
    Result := Result + Chr(version_revision + unicode_ord('a') - 1);
end;


//************************************************************************************************//
//                                                                                                //
// EVENT HANDLERS                                                                                 //
//                                                                                                //
//************************************************************************************************//


// handles the "OnClick" event for the debug checkbox
// immediately toggles debug mode
procedure debug_checkbox_click_handler(sender: TObject);
begin
  global_debug := TCheckBox(sender).Checked;
  AddMessage('Debug mode ' + bool_to_enabled_str(global_debug));
end;


// handles the "OnClick" event for the file list control in the file dialog
// enables the ok button if an item is selected
procedure file_list_click_handler(sender: TObject);
var
  file_list: TListBox;
  ok_button: TButton;
begin
  debug_print('file_list_click_handler: click detected');
  file_list := TListBox(sender);
  debug_print('file_list_click_handler: item index: ' + IntToStr(file_list.ItemIndex));
  if (file_list.ItemIndex >= 0) then begin
    temp_currently_selected := file_list.Items[file_list.ItemIndex];
    ok_button := TButton(get_parent_form(file_list).FindComponent(OK_BUTTON_NAME));
    ok_button.Enabled := True;
  end;
end;


// handles the "OnDblClick" event for the file list control in the file dialog
// "clicks" the ok button if an item is selected
procedure file_list_double_click_handler(sender: TObject);
var
  file_list: TListBox;
  ok_button: TButton;
begin
  debug_print('file_list_double_click_handler: double click detected');
  file_list := TListBox(sender);
  debug_print('file_list_double_click_handler: item index: ' + IntToStr(file_list.ItemIndex));
  if (file_list.ItemIndex >= 0) then begin
    debug_print('file_list_double_click_handler: item is valid, "clicking" OK button');
    ok_button := TButton(get_parent_form(file_list).FindComponent(OK_BUTTON_NAME));
    ok_button.Click();
  end;
end;


// handles the "OnChange" event for the file list filter in the file dialog
// filters the file list control as the user types
// modified from https://stackoverflow.com/a/35751126
procedure file_list_filter_change_handler(sender: TObject);
var
  file_list_filter: TEdit;
  file_list_control: TListBox;
  filter: string;
  i: integer;
  parent_control: TControl;
begin
  file_list_filter := TEdit(sender);
  file_list_control := TListBox(get_parent_form(file_list_filter).FindComponent(FILE_LIST_CONTROL_NAME));

  file_list_control.Items.BeginUpdate();
  try
    // clear the file list control and disable the OK button (because the selection is no longer valid)
    file_list_control.Clear();
    TButton(get_parent_form(file_list_filter).FindComponent(OK_BUTTON_NAME)).Enabled := False;

    if (file_list_filter.GetTextLen() > 0) then begin
      filter := file_list_filter.Text;
      debug_print('file_list_filter_change_handler: filtering for "' + filter + '"');
      for i := 0 to Pred(temp_file_list.Count) do begin
        // if the filter text is found in the filename, add it and its object to the file list control
        if ContainsText(temp_file_list[i], filter) then begin
          file_list_control.Items.AddObject(temp_file_list[i], temp_file_list.Objects[i]);
          // if a re-added item was previously selected, select it again and trigger the click handler
          if (temp_file_list[i] = temp_currently_selected) then begin
            file_list_control.ItemIndex := file_list_control.Items.Count - 1;
            file_list_click_handler(file_list_control);
          end;
        end;
      end;
    end else begin
      // if the filter is empty, add all items from the temp_file_list to the file list control
      file_list_control.Items.Assign(temp_file_list);
      // if an item was previously selected, select it again and trigger the click handler
      if (temp_currently_selected <> '') then begin
        file_list_control.ItemIndex := file_list_control.Items.IndexOf(temp_currently_selected);
        file_list_click_handler(file_list_control);
      end;
    end;
  finally
    file_list_control.Items.EndUpdate();
  end;
end;


// handles the "OnClick" event for the filter clear button
// clears the filter text box and sets focus to it
procedure filter_clear_button_click_handler(sender: TObject);
var
  filter_edit: TEdit;
begin
  filter_edit := TEdit(get_parent_form(TButton(sender)).FindComponent(FILE_LIST_FILTER_NAME));
  filter_edit.Text := '';
  filter_edit.SetFocus();
end;


//************************************************************************************************//
//                                                                                                //
// ROTATION AND POSITION FUNCTIONS                                                                //
//                                                                                                //
//************************************************************************************************//


// takes an euler angle and converts it to a quaternion
// partially inspired by three.js's Quaternion.setFromEuler function
// (https://github.com/mrdoob/three.js/blob/e29ce31828e85a3ecf533984417911e2304f4320/src/math/Quaternion.js#L201) (MIT license)
procedure euler_to_quaternion(
  x, y, z: double;                                         // euler angle in degrees
  rotation_sequence: integer;                              // see SEQUENCE_* constants and validate_rotation_sequence procedure
  var return_qw, return_qx, return_qy, return_qz: double;  // quaternion components
);
var
  cos_x, cos_y, cos_z, sin_x, sin_y, sin_z: double;
  sign_w, sign_x, sign_y, sign_z: integer;
begin
  validate_rotation_sequence(rotation_sequence);

  // normalize angles and convert them to radians
  x := DegToRad(normalize_angle(x));
  y := DegToRad(normalize_angle(y));
  z := DegToRad(normalize_angle(z));
  debug_print('euler_to_quaternion: radian vector: ' + vector_to_str(x, y, z, False, False, DIGITS_FULL));

  // calculate cosine and sine of the various angles once instead of multiple times
  cos_x := Cos(x / 2.0); cos_y := Cos(y / 2.0); cos_z := Cos(z / 2.0);
  sin_x := Sin(x / 2.0); sin_y := Sin(y / 2.0); sin_z := Sin(z / 2.0);

  // use the rotation sequence to determine what signs are used when calculating quaternion components
  case (rotation_sequence) of
    SEQUENCE_XYZ: begin sign_w := -1; sign_x :=  1; sign_y := -1; sign_z :=  1; end;
    SEQUENCE_XZY: begin sign_w :=  1; sign_x := -1; sign_y := -1; sign_z :=  1; end;
    SEQUENCE_YXZ: begin sign_w :=  1; sign_x :=  1; sign_y := -1; sign_z := -1; end;
    SEQUENCE_YZX: begin sign_w := -1; sign_x :=  1; sign_y :=  1; sign_z := -1; end;
    SEQUENCE_ZXY: begin sign_w := -1; sign_x := -1; sign_y :=  1; sign_z :=  1; end;
    SEQUENCE_ZYX: begin sign_w :=  1; sign_x := -1; sign_y :=  1; sign_z := -1; end;
  end;
  debug_print(
    'euler_to_quaternion: quaternion calculation signs'
    + ': sign_w: ' + IntToStr(sign_w)
    + ', sign_x: ' + IntToStr(sign_x)
    + ', sign_y: ' + IntToStr(sign_y)
    + ', sign_z: ' + IntToStr(sign_z)
  );

  // calculate the quaternion components
  return_qw := cos_x * cos_y * cos_z + sign_w * sin_x * sin_y * sin_z;
  return_qx := sin_x * cos_y * cos_z + sign_x * cos_x * sin_y * sin_z;
  return_qy := cos_x * sin_y * cos_z + sign_y * sin_x * cos_y * sin_z;
  return_qz := cos_x * cos_y * sin_z + sign_z * sin_x * sin_y * cos_z;
end;


// compute the difference between two quaternions, q1 and q2, using the formula (q_result = q1' * q2),
// where q1' is the inverse (conjugate) of the first quaternion
procedure quaternion_difference(
  qw1, qx1, qy1, qz1: double;                              // first quaternion
  qw2, qx2, qy2, qz2: double;                              // second quaternion
  var return_qw, return_qx, return_qy, return_qz: double;  // difference quaternion
);
var
  qw1i, qx1i, qy1i, qz1i: double;  // inverse (conjugate) of the first quaternion
begin
  quaternion_inverse(  // calculate (q1')
    qw1, qx1, qy1, qz1,
    qw1i, qx1i, qy1i, qz1i
  );
  debug_print('quaternion_difference: q1'': ' + quaternion_to_str(qw1i, qx1i, qy1i, qz1i));
  quaternion_multiply(  // calculate (q1' * q2)
    qw1i, qx1i, qy1i, qz1i,
    qw2, qx2, qy2, qz2,
    return_qw, return_qx, return_qy, return_qz
  );
  debug_print('quaternion_difference: q1'' * q2: ' + quaternion_to_str(return_qw, return_qx, return_qy, return_qz));
end;


// takes a quaternion and converts it to an euler angle
// partially inspired by three.js's Euler.fromQuaternion function
// (https://github.com/mrdoob/three.js/blob/cd0ff25e3c3938ec82500047ccb43500d242505c/src/math/Euler.js#L238) (MIT License)
// partially inspired by the contents of Quaternions.pdf
// https://github.com/rux616/starfield-junk-in-your-ships-trunk/blob/adc55559b38e2fb71c31ee2ca92c7dbced12c35d/support/docs/Quaternions.pdf
procedure quaternion_to_euler(
  qw, qx, qy, qz: double;                    // input quaternion
  rotation_sequence: integer;                // see SEQUENCE_* constants and validate_rotation_sequence procedure
  var return_x, return_y, return_z: double;  // euler angle (in degrees)
);
var
  p0, p1, p2, p3: double;              // variables representing dynamically-ordered quaternion components
  singularity_check: double;           // contains value used for the singularity check
  e: integer;                          // variable representing sign used in angle calculations
  euler_order: array[0..2] of double;  // holds mapping between rotation sequence angles and output angles
  euler_angle: array[0..2] of double;  // output angles
begin
  validate_rotation_sequence(rotation_sequence);

  // map quaternion components to generic p-variables, and set the sign
  p0 := qw;
  case (rotation_sequence) of
    SEQUENCE_XYZ: begin
      p1 := qx; p2 := qy; p3 := qz; e := -1;
      debug_print('quaternion_to_euler: mapping qx to p1, qy to p2, qz to p3; setting e to -1');
    end;
    SEQUENCE_XZY: begin
      p1 := qx; p2 := qz; p3 := qy; e :=  1;
      debug_print('quaternion_to_euler: mapping qx to p1, qz to p2, qy to p3; setting e to 1');
    end;
    SEQUENCE_YXZ: begin
      p1 := qy; p2 := qx; p3 := qz; e :=  1;
      debug_print('quaternion_to_euler: mapping qy to p1, qx to p2, qz to p3; setting e to 1');
    end;
    SEQUENCE_YZX: begin
      p1 := qy; p2 := qz; p3 := qx; e := -1;
      debug_print('quaternion_to_euler: mapping qy to p1, qz to p2, qx to p3; setting e to -1');
    end;
    SEQUENCE_ZXY: begin
      p1 := qz; p2 := qx; p3 := qy; e := -1;
      debug_print('quaternion_to_euler: mapping qz to p1, qx to p2, qy to p3; setting e to -1');
    end;
    SEQUENCE_ZYX: begin
      p1 := qz; p2 := qy; p3 := qx; e :=  1;
      debug_print('quaternion_to_euler: mapping qz to p1, qy to p2, qx to p3; setting e to 1');
    end;
  end;

  // create mapping between the euler angle and the rotation sequence
  case (rotation_sequence) of
    SEQUENCE_XYZ: begin euler_order[0] := 0; euler_order[1] := 1; euler_order[2] := 2; end;
    SEQUENCE_XZY: begin euler_order[0] := 0; euler_order[1] := 2; euler_order[2] := 1; end;
    SEQUENCE_YXZ: begin euler_order[0] := 1; euler_order[1] := 0; euler_order[2] := 2; end;
    SEQUENCE_YZX: begin euler_order[0] := 1; euler_order[1] := 2; euler_order[2] := 0; end;
    SEQUENCE_ZXY: begin euler_order[0] := 2; euler_order[1] := 0; euler_order[2] := 1; end;
    SEQUENCE_ZYX: begin euler_order[0] := 2; euler_order[1] := 1; euler_order[2] := 0; end;
  end;
  debug_print(
    'quaternion_to_euler: euler order'
    + ': ' + IntToStr(euler_order[0])
    + ', ' + IntToStr(euler_order[1])
    + ', ' + IntToStr(euler_order[2])
  );

  // calculate the value to be used to check for singularities
  singularity_check := 2.0 * (p0 * p2 - e * p1 * p3);
  debug_print('quaternion_to_euler: singularity check: '
    + float_to_str(singularity_check, DIGITS_FULL, False));

  // calculate second rotation angle, clamping it to prevent ArcSin from erroring
  euler_angle[euler_order[1]] := ArcSin(clamp(singularity_check, -1.0, 1.0));

  // a singularity exists when the second angle in a rotation sequence is at +/-90 degrees
  if (CompareValue(Abs(singularity_check), 1.0, EPSILON) = LessThanValue) then begin
    debug_print('quaternion_to_euler: no singularity detected');
    euler_angle[euler_order[0]] := ArcTan2(2.0 * (p0 * p1 + e * p2 * p3), 1.0 - 2.0 * (p1 * p1 + p2 * p2));
    euler_angle[euler_order[2]] := ArcTan2(2.0 * (p0 * p3 + e * p1 * p2), 1.0 - 2.0 * (p2 * p2 + p3 * p3));
  end else begin
    debug_print('quaternion_to_euler: singularity detected');
    // when a singularity is detected, the third angle basically loses all meaning so is set to 0
    euler_angle[euler_order[0]] := ArcTan2(2.0 * (p0 * p1 - e * p2 * p3), 1.0 - 2.0 * (p1 * p1 + p3 * p3));
    euler_angle[euler_order[2]] := 0.0;
  end;

  debug_print('quaternion_to_euler: resultant vector: '
    + vector_to_str(euler_angle[0], euler_angle[1], euler_angle[2], False, False, DIGITS_FULL));

  // convert results to degrees and then normalize them
  return_x := normalize_angle(RadToDeg(euler_angle[0]));
  return_y := normalize_angle(RadToDeg(euler_angle[1]));
  return_z := normalize_angle(RadToDeg(euler_angle[2]));
end;


// get the inverse of a quaternion
procedure quaternion_inverse(
  qw, qx, qy, qz: double;                                  // input quaternion
  var return_qw, return_qx, return_qy, return_qz: double;  // inverted quaternion
);
begin
  return_qw := qw;
  return_qx := -qx;
  return_qy := -qy;
  return_qz := -qz;
end;


// multiply two quaternions together - note that quaternion multiplication is NOT commutative, so
// (q1 * q2) != (q2 * q1)
procedure quaternion_multiply(
  qw1, qx1, qy1, qz1: double;                              // input quaternion 1
  qw2, qx2, qy2, qz2: double;                              // input quaternion 2
  var return_qw, return_qx, return_qy, return_qz: double;  // result quaternion
);
begin
  return_qw := qw1 * qw2 - qx1 * qx2 - qy1 * qy2 - qz1 * qz2;
  return_qx := qw1 * qx2 + qx1 * qw2 + qy1 * qz2 - qz1 * qy2;
  return_qy := qw1 * qy2 - qx1 * qz2 + qy1 * qw2 + qz1 * qx2;
  return_qz := qw1 * qz2 + qx1 * qy2 - qy1 * qx2 + qz1 * qw2;
end;


// rotate a position (duh) via quaternion math (vs matrix math)
procedure rotate_position(
  vx, vy, vz: double;                           // initial position vector (x, y, z coordinates)
  rx, ry, rz: double;                           // rotation to apply (euler angle)
  rotation_sequence: integer;                   // see SEQUENCE_* constants and validate_rotation_sequence procedure
  var return_vx, return_vy, return_vz: double;  // final position vector (x, y, z coordinates)
);
var
  qx, qy, qz, qw: double;      // quaternion representing rotation to be applied
  qwv, qxv, qyv, qzv: double;  // quaternion representing the result of the vector/quaternion multiplication
begin
  euler_to_quaternion(
    rx, ry, rz,
    rotation_sequence,
    qw, qx, qy, qz
  );
  debug_print('rotate_position: q: ' + quaternion_to_str(qw, qx, qy, qz));

  // everything i've read says this should be (q * v * q'), but only (q' * (v * q)) gives the correct
  // results ¯\_(ツ)_/¯
  quaternion_multiply(  // calculate (v * q)
    0.0, vx, vy, vz,
    qw, qx, qy, qz,
    qwv, qxv, qyv, qzv
  );
  debug_print('rotate_position: v * q: ' + quaternion_to_str(qwv, qxv, qyv, qzv));
  // instead of computing q', then multiplying that by (v * q) manually, we can compute the
  // difference between them and get the same result (because it's the same math)
  quaternion_difference(  // calculate (q' * (v * q))
    qw, qx, qy, qz,
    qwv, qxv, qyv, qzv,
    nil, return_vx, return_vy, return_vz  // the returned w component is irrelevant and so is discarded
  );
  debug_print('rotate_position: q'' * (v * q): ' + quaternion_to_str(nil, return_vx, return_vy, return_vz)
    + ' (W is discarded)');
end;


// rotate a rotation (duh) via quaternion math (vs matrix math)
procedure rotate_rotation(
  x, y, z: double;                          // initial rotation (euler angle)
  rx, ry, rz: double;                       // rotation to apply (euler angle)
  rotation_sequence: integer;               // see SEQUENCE_* constants and validate_rotation_sequence procedure
  var return_x, return_y, return_z: double  // final rotation (euler angle)
);
var
  qw1, qx1, qy1, qz1: double;  // quaternion representing initial rotation
  qw2, qx2, qy2, qz2: double;  // quaternion representing rotation to be applied
  qw3, qx3, qy3, qz3: double;  // quaternion representing final rotation
begin
  euler_to_quaternion(
    x, y, z,
    rotation_sequence,
    qw1, qx1, qy1, qz1
  );
  debug_print('rotate_rotation: q1: ' + quaternion_to_str(qw1, qx1, qy1, qz1));
  euler_to_quaternion(
    rx, ry, rz,
    rotation_sequence,
    qw2, qx2, qy2, qz2
  );
  debug_print('rotate_rotation: q2: ' + quaternion_to_str(qw2, qx2, qy2, qz2));

  // everything i've read says this should be (q2 * q1), but only (q1 * q2) gives the correct results
  // ¯\_(ツ)_/¯
  quaternion_multiply(  // calculate (q1 * q2)
    qw1, qx1, qy1, qz1,
    qw2, qx2, qy2, qz2,
    qw3, qx3, qy3, qz3
  );
  debug_print('rotate_rotation: q1 * q2: ' + quaternion_to_str(qw3, qx3, qy3, qz3));

  quaternion_to_euler(
    qw3, qx3, qy3, qz3,
    rotation_sequence,
    return_x, return_y, return_z
  );
end;


// compute the difference between two rotations by converting them to quaternions, using the
// quaternion_difference function, and converting the result back to an euler angle
procedure rotation_difference(
  x1, y1, z1: double;                        // input rotation 1 (euler angle)
  x2, y2, z2: double;                        // input rotation 2 (euler angle)
  global_rotation_sequence: integer;         // see SEQUENCE_* constants and validate_rotation_sequence procedure
  var return_x, return_y, return_z: double;  // output rotation (euler angle)
);
var
  qw1, qx1, qy1, qz1: double;  // quaternion representing rotation 1
  qw2, qx2, qy2, qz2: double;  // quaternion representing rotation 2
  qw3, qx3, qy3, qz3: double;  // quaternion representing the difference between the two rotations
begin
  euler_to_quaternion(
    x1, y1, z1,
    global_rotation_sequence,
    qw1, qx1, qy1, qz1
  );
  debug_print('rotation_difference: q1: ' + quaternion_to_str(qw1, qx1, qy1, qz1));
  euler_to_quaternion(
    x2, y2, z2,
    global_rotation_sequence,
    qw2, qx2, qy2, qz2
  );
  debug_print('rotation_difference: q2: ' + quaternion_to_str(qw2, qx2, qy2, qz2));
  quaternion_difference(
    qw1, qx1, qy1, qz1,
    qw2, qx2, qy2, qz2,
    qw3, qx3, qy3, qz3
  );
  debug_print('rotation_difference: q1'' * q2: ' + quaternion_to_str(qw3, qx3, qy3, qz3));
  quaternion_to_euler(
    qw3, qx3, qy3, qz3,
    global_rotation_sequence,
    return_x, return_y, return_z
  );
  debug_print('rotation_difference: resultant vector: '
    + vector_to_str(return_x, return_y, return_z, False, False, DIGITS_FULL));
end;


//************************************************************************************************//
//                                                                                                //
// UI FUNCTIONS                                                                                   //
//                                                                                                //
//************************************************************************************************//


// create a button panel with ok and cancel buttons, and a debug checkbox
function create_button_panel(owner, parent: TControl): TPanel;
var
  panel, button_subpanel: TPanel;
  debug_checkbox: TCheckBox;
  ok_button, cancel_button: TButton;
begin
  if (parent = nil) then parent := owner;

  panel := TPanel.Create(owner);
  panel.Parent := parent;
  do_panel_layout(panel, 0);
  set_margins_layout(panel, 0, 0, 0, 0, alTop);

  debug_checkbox := TCheckBox.Create(owner);
  debug_checkbox.Parent := panel;
  debug_checkbox.Caption := '&Debug Mode';
  debug_checkbox.Alignment := taLeftJustify;
  set_margins_layout(debug_checkbox, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
  debug_checkbox.Height := CONTROL_HEIGHT * global_scale_factor;
  debug_checkbox.Width := caption_width(debug_checkbox) + (CHECKBOX_PADDING * global_scale_factor);
  debug_checkbox.Checked := global_debug;
  // event handlers
  debug_checkbox.OnClick := debug_checkbox_click_handler;  // immediately toggle debug mode

  button_subpanel := TPanel.Create(owner);
  button_subpanel.Parent := panel;
  do_panel_layout(button_subpanel, 0);
  set_margins_layout(button_subpanel, 0, 0, 0, 0, alRight);

  ok_button := TButton.Create(owner);
  ok_button.Name := OK_BUTTON_NAME;
  ok_button.Parent := button_subpanel;
  ok_button.Caption := '&OK';
  ok_button.Default := True;
  ok_button.ModalResult := mrOk;
  set_margins_layout(ok_button, MARGIN_TOP, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alRight);

  cancel_button := TButton.Create(owner);
  cancel_button.Parent := button_subpanel;
  cancel_button.Caption := 'Ca&ncel';
  cancel_button.Cancel := True;
  cancel_button.ModalResult := mrCancel;
  set_margins_layout(cancel_button, MARGIN_TOP, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alRight);

  Result := panel;
end;


// create a filter panel with a checkbox, radio buttons, and an edit box
function create_filter_panel(
  owner, parent: TControl;
  title, edit_hint: string;
  var use_checkbox: TCheckBox;
  var include_radio, exclude_radio: TRadioButton;
  var list_edit: TEdit;
): TPanel;
var
  panel: TPanel;
  show_edit_hint: boolean;
begin
  if (parent = nil) then parent := owner;
  if (edit_hint = '') then show_edit_hint := False else show_edit_hint := True;

  panel := TPanel.Create(owner);
  panel.Parent := parent;
  do_panel_layout(panel, PANEL_BEVEL);

  use_checkbox := TCheckBox.Create(owner);
  use_checkbox.Parent := panel;
  use_checkbox.Caption := 'Filter by ' + title;
  set_margins_layout(use_checkbox, MARGIN_TOP, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
  use_checkbox.Height := CONTROL_HEIGHT * global_scale_factor;
  use_checkbox.Width := caption_width(use_checkbox) + (CHECKBOX_PADDING * global_scale_factor);

  include_radio := TRadioButton.Create(owner);
  include_radio.Parent := panel;
  include_radio.Alignment := taLeftJustify;
  include_radio.Caption := 'Include';
  set_margins_layout(include_radio, MARGIN_TOP, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
  include_radio.Height := CONTROL_HEIGHT * global_scale_factor;
  include_radio.Width := caption_width(include_radio) + (RADIO_PADDING * global_scale_factor);

  exclude_radio := TRadioButton.Create(owner);
  exclude_radio.Parent := panel;
  exclude_radio.Alignment := taLeftJustify;
  exclude_radio.Caption := 'Exclude';
  set_margins_layout(exclude_radio, MARGIN_TOP, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
  exclude_radio.Height := CONTROL_HEIGHT * global_scale_factor;
  exclude_radio.Width := caption_width(exclude_radio) + (RADIO_PADDING * global_scale_factor);

  list_edit := TEdit.Create(owner);
  list_edit.Parent := panel;
  list_edit.Hint := edit_hint;
  list_edit.ShowHint := show_edit_hint;
  set_margins_layout(list_edit, 0, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alBottom);
  list_edit.Height := CONTROL_HEIGHT * global_scale_factor;

  panel.Height := full_control_height(use_checkbox) + full_control_height(list_edit);

  Result := panel;
end;


// build and display the dialog used to select a plugin file to save into
function show_file_dialog(record_file: IwbFile; var target_file: IwbFile): integer;
var
  frm: TForm;

  description_label: TLabel;

  filter_panel: TPanel;
  filter_label: TLabel;
  file_list_filter: TEdit;
  filter_clear_button: TButton;

  file_list_control: TListBox;

  plugin_file: IwbFile;

  i, target_file_index: integer;
  plugin_filename, target_filename, new_plugin_filename, invalid_filename_characters, flag_text, dry_run_text: string;
  new_plugin_is_light, new_plugin_is_master: boolean;
  regexp: TPerlRegEx;
begin
  if (target_file <> nil) then target_filename := GetFileName(target_file);
  target_file_index := -1;

  frm := TForm.Create(nil);
  temp_file_list := TStringList.Create();
  try
    frm.Caption := 'Rotate Cell Contents: Plugin Selection';
    // frm.BorderStyle := bsSingle;
    frm.BorderIcons := [biSystemMenu];
    frm.Position := poScreenCenter;
    frm.Width := 350 * global_scale_factor;
    frm.Height := 400 * global_scale_factor;
    frm.Constraints.MinWidth := 300 * global_scale_factor;
    frm.Constraints.MinHeight := 300 * global_scale_factor;

    description_label := TLabel.Create(frm);
    description_label.Parent := frm;
    description_label.Caption := 'For records from "' + GetFileName(record_file) + '":';
    description_label.Layout := tlCenter;
    set_margins_layout(description_label, MARGIN_TOP, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alTop);

    // dynamic form width
    frm.Width := max(frm.Width, caption_width(description_label) + (MARGIN_LEFT + MARGIN_RIGHT));

    filter_panel := TPanel.Create(frm);
    filter_panel.Parent := frm;
    do_panel_layout(filter_panel, 0);
    set_margins_layout(filter_panel, MARGIN_TOP, 0, MARGIN_LEFT, MARGIN_RIGHT, alTop);
    filter_panel.Height := CONTROL_HEIGHT * global_scale_factor;

    filter_label := TLabel.Create(frm);
    filter_label.Parent := filter_panel;
    filter_label.Caption := 'Filter:';
    filter_label.Layout := tlCenter;
    set_margins_layout(filter_label, 0, 0, 0, 0, alLeft);

    file_list_filter := TEdit.Create(frm);
    file_list_filter.Name := FILE_LIST_FILTER_NAME;
    file_list_filter.Parent := filter_panel;
    file_list_filter.Text := '';
    file_list_filter.Hint := 'Type to filter the list';
    file_list_filter.ShowHint := True;
    set_margins_layout(file_list_filter, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alClient);
    // event handlers
    file_list_filter.OnChange := file_list_filter_change_handler;  // filter the list as the user types

    filter_clear_button := TButton.Create(frm);
    filter_clear_button.Parent := filter_panel;
    filter_clear_button.Caption := '&Clear';
    set_margins_layout(filter_clear_button, 0, 0, 0, 0, alRight);
    filter_clear_button.Width := caption_width(filter_clear_button) + (BUTTON_PADDING * global_scale_factor);
    // event handlers
    filter_clear_button.OnClick := filter_clear_button_click_handler;  // clear the filter text

    file_list_control := TListBox.Create(frm);
    file_list_control.Name := FILE_LIST_CONTROL_NAME;
    file_list_control.Parent := frm;
    file_list_control.MultiSelect := False;
    file_list_control.Hint := 'Click to select a file';
    file_list_control.ShowHint := True;
    set_margins_layout(file_list_control, MARGIN_TOP, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alClient);
    // event handlers
    file_list_control.OnClick := file_list_click_handler;  // enable OK button when item is selected
    file_list_control.OnDblClick := file_list_double_click_handler;  // "click" OK when item is double-clicked

    create_button_panel(frm, frm).Align := alBottom;
    TButton(frm.FindComponent(OK_BUTTON_NAME)).Enabled := False;  // disable the OK button by default

    // populate the file list with the names of all files that can be edited
    for i := 0 to Pred(FileCount) do begin
      plugin_file := FileByIndex(i);
      plugin_filename := GetFileName(plugin_file);
      // check if file is editable, is not a master of the file of the currently-selected record,
      // and is not the same file as the given record unless the global_save_to_same_file flag is set.
      // arranged this way because boolean short-circuiting isn't done in xEdit scripts; functionally
      // equivalent to `IsEditable() and (not HasMaster()) and (not SameText() or global_save_to_same_file)`
      if IsEditable(plugin_file) then begin
        if (not HasMaster(record_file, plugin_filename)) then begin
          if (not SameText(plugin_filename, GetFileName(record_file))) or
             (global_save_to_same_file) then begin
            temp_file_list.AddObject(plugin_filename, plugin_file);
            // if the filenames are the same (target_filename will be set if target_file is not nil),
            // set the target_file_index to the index of the file in the list so it can be selected
            // after the file list control is populated
            if SameText(plugin_filename, target_filename) then
              target_file_index := temp_file_list.Count - 1;
          end;
        end;
      end;
    end;

    // add a new file options to the list, but restricted based on the game
    // Morrowind (gmTES3) support might happen some day, so it's left in but commented out
    // Starfield (gmSF1) is also mostly commented out because modding for it is still in its infancy (2024-03-28)
    new_plugin_filename := ' + <new file>.';
    case (wbGameMode) of
      {gmTES3, }gmTES4, gmFO3, gmFNV, gmTES5, gmEnderal, gmFO4, gmSSE, gmEnderalSE, gmTES5VR, gmFO4VR, gmFO76{, gmSF1}:
        temp_file_list.AddObject(new_plugin_filename + 'esp', NEW_FILE_ESP);
    end;
    case (wbGameMode) of
      {gmTES3, }gmTES4, gmFO3, gmFNV, gmTES5, gmEnderal, gmFO4, gmSSE, gmEnderalSE, gmTES5VR, gmFO4VR, gmFO76{, gmSF1}:
        temp_file_list.AddObject(new_plugin_filename + 'esp [master]', NEW_FILE_ESP_MASTER);
    end;
    case (wbGameMode) of
      gmFO4, gmSSE, gmEnderalSE{, gmSF1}:
        temp_file_list.AddObject(new_plugin_filename + 'esp [light]', NEW_FILE_ESP_LIGHT);
    end;
    case (wbGameMode) of
      gmFO4, gmSSE, gmEnderalSE{, gmSF1}:
        temp_file_list.AddObject(new_plugin_filename + 'esp [master, light]', NEW_FILE_ESP_MASTER_LIGHT);
    end;
    case (wbGameMode) of
      {gmTES3, }gmTES4, gmFO3, gmFNV, gmTES5, gmEnderal, gmFO4, gmSSE, gmEnderalSE, gmTES5VR, gmFO4VR, gmFO76, gmSF1:
        temp_file_list.AddObject(new_plugin_filename + 'esm', NEW_FILE_ESM);
    end;
    case (wbGameMode) of
      gmFO4, gmSSE, gmEnderalSE{, gmSF1}:
        temp_file_list.AddObject(new_plugin_filename + 'esl', NEW_FILE_ESL);
    end;

    // copy the list of files to the file list control and select the previously-selected file
    file_list_control.Items.Assign(temp_file_list);
    if (target_file_index >= 0) then begin
      file_list_control.ItemIndex := target_file_index;
      file_list_click_handler(file_list_control);
    end;

    // adjust form and control width to accommodate the longest item
    file_list_control.ScrollWidth := max_item_width(file_list_control) + (MARGIN_LEFT + MARGIN_RIGHT);
    frm.Width := Max(
      file_list_control.ScrollWidth + (SCROLLBAR_PADDING + MARGIN_LEFT + MARGIN_RIGHT + 2) * global_scale_factor,
      frm.Width
    );
    frm.Constraints.MinWidth := frm.Width;

    // show the form as a modal dialog and exit if the OK button is not clicked
    Result := frm.ShowModal;
    if (Result <> mrOk) then exit;

    // shouldn't ever happen, but just in case
    if (file_list_control.ItemIndex < 0) then begin
      AddMessage('No file selected');
      Result := mrAbort;
      exit;
    end;
    debug_print('show_file_dialog: item selected: (' + IntToStr(file_list_control.ItemIndex) + ') '
      + file_list_control.Items[file_list_control.ItemIndex]);

    // check if the selected file is a new file or an existing file
    if (not ContainsText(file_list_control.Items[file_list_control.ItemIndex], new_plugin_filename)) then begin
      // existing file selected

      // pull out the IwbFile object from the file list control
      target_file := ObjectToElement(file_list_control.Items.Objects[file_list_control.ItemIndex]);

      // make sure the target file is actually set
      if not Assigned(target_file) then begin
        AddMessage('Error setting target file');
        Result := mrAbort;
        exit;
      end;
      debug_print('show_file_dialog: selected plugin file: ' + GetFileName(target_file));
    end else begin
      // new file selected

      // get the new plugin filename from the user
      new_plugin_filename := InputBox('New Plugin File', 'Filename without extension:', '');
      debug_print('show_file_dialog: filename as entered: ' + new_plugin_filename);

      // sanitize new_plugin_filename - characters <>:"/\|?* are not allowed
      invalid_filename_characters := '<>:"/\|?*';
      for i := 0 to Length(invalid_filename_characters) do begin
        new_plugin_filename :=
          StringReplace(new_plugin_filename, invalid_filename_characters[i], '', [rfReplaceAll]);
      end;
      debug_print('show_file_dialog: sanitized filename: ' + new_plugin_filename);

      // remove trailing .esp, .esm, .esl
      regexp := TPerlRegEx.Create();
      try
        regexp.Subject := new_plugin_filename;
        regexp.RegEx := '\.esp$|\.esm$|\.esl$';
        regexp.Replacement := '';
        regexp.Options := [preCaseLess];
        while regexp.Match() do regexp.Replace();
        new_plugin_filename := regexp.Subject;
      finally
        regexp.Free();
      end;
      debug_print('show_file_dialog: filename after removing plugin file extensions: ' + new_plugin_filename);

      // if new_plugin_filename ends up being empty after preprocessing, cancel the operation
      if (new_plugin_filename = '') then begin
        Result := mrCancel;
        exit;
      end;

      // add the appropriate extension and set flags based on the selected new file option
      case Integer(file_list_control.Items.Objects[file_list_control.ItemIndex]) of
        NEW_FILE_ESP: begin
          new_plugin_filename := new_plugin_filename + '.esp';
          new_plugin_is_master := False; new_plugin_is_light := False; flag_text := 'none';
        end;
        NEW_FILE_ESP_MASTER: begin
          new_plugin_filename := new_plugin_filename + '.esp';
          new_plugin_is_master := True; new_plugin_is_light := False; flag_text := 'master';
        end;
        NEW_FILE_ESP_LIGHT: begin
          new_plugin_filename := new_plugin_filename + '.esp';
          new_plugin_is_master := False; new_plugin_is_light := True; flag_text := 'light';
        end;
        NEW_FILE_ESP_MASTER_LIGHT: begin
          new_plugin_filename := new_plugin_filename + '.esp';
          new_plugin_is_master := True; new_plugin_is_light := True; flag_text := 'master, light';
        end;
        NEW_FILE_ESM: begin
          new_plugin_filename := new_plugin_filename + '.esm';
          new_plugin_is_master := True; new_plugin_is_light := False; flag_text := 'master';
        end;
        NEW_FILE_ESL: begin
          new_plugin_filename := new_plugin_filename + '.esl';
          new_plugin_is_master := True; new_plugin_is_light := True; flag_text := 'master, light';
        end;
      end;

      // actually create the new plugin file
      if (global_dry_run) then dry_run_text := '[DRY RUN] ' else dry_run_text := '';
      AddMessage(dry_run_text + 'Creating new plugin file: "' + new_plugin_filename + '" [flags: ' + flag_text + ']');
      if (not global_dry_run) then begin
        target_file := AddNewFileName(new_plugin_filename, new_plugin_is_light);

        // make sure the new plugin file is created before attempting to make it a master
        if (not Assigned(target_file)) then begin
          AddMessage('Error creating new plugin file');
          Result := mrAbort;
          exit;
        end;
        debug_print('show_file_dialog: new plugin file created: ' + GetFileName(target_file));

        // set the master flag on the new plugin file if necessary
        SetIsESM(target_file, new_plugin_is_master);
        debug_print('show_file_dialog: new plugin file has master flag: '
          + bool_to_str(GetIsESM(target_file)));
      end else begin
        // if this is a try run, use the original record file as the target file
        target_file := record_file;
        debug_print('show_file_dialog: dry run: using original record file as target file');
      end;
    end;
  finally
    debug_print('show_file_dialog: cleaning up');
    temp_file_list.Free();
    frm.Free();
  end;
end;


// build and display the dialog used to set the rotation options
function show_options_dialog(): integer;
var
  frm: TForm;

  angle_panel, rotation_x_subpanel, rotation_y_subpanel, rotation_z_subpanel: TPanel;
  angle_label, rotation_x_label, rotation_y_label, rotation_z_label: TLabel;
  rotation_x, rotation_y, rotation_z: TEdit;

  rotation_options_panel, rotation_mode_subpanel, rotation_sequence_subpanel, apply_to_subpanel: TPanel;
  rotation_mode_label, rotation_sequence_label, apply_to_label: TLabel;
  mode_rotate, mode_set, apply_to_both, apply_to_position, apply_to_rotation: TRadioButton;
  rotation_sequence: TComboBox;

  secondary_options_panel, clamp_subpanel, position_precision_subpanel, rotation_precision_subpanel: TPanel;
  clamp_use_checkbox: TCheckBox;
  clamp_label, position_precision_label, rotation_precision_label: TLabel;
  clamp_combo, position_precision_combo, rotation_precision_combo: TComboBox;

  meta_panel, dry_run_subpanel, save_same_file_subpanel, use_same_settings_for_all_subpanel: TPanel;
  dry_run, save_same_file, use_same_settings_for_all: TCheckBox;

  i: integer;
begin
  frm := TForm.Create(nil);
  try
    frm.Caption := 'Rotate Cell Contents: Options';
    frm.AutoSize := True;
    frm.BorderStyle := bsSingle;
    frm.BorderIcons := [biSystemMenu];
    frm.Position := poScreenCenter;
    frm.Width := 425 * global_scale_factor;

    // angle panel

    angle_panel := TPanel.Create(frm);
    angle_panel.Parent := frm;
    do_panel_layout(angle_panel, 0);
    set_margins_layout(angle_panel, MARGIN_TOP, MARGIN_BOTTOM, 0, 0, alTop);
    angle_panel.Height := CONTROL_HEIGHT * global_scale_factor;

    angle_label := TLabel.Create(frm);
    angle_label.Parent := angle_panel;
    angle_label.Layout := tlCenter;
    angle_label.Caption := 'Rotation Angle:';
    set_margins_layout(angle_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    angle_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_x_subpanel := TPanel.Create(frm);
    rotation_x_subpanel.Parent := angle_panel;
    do_panel_layout(rotation_x_subpanel, 0);
    set_margins_layout(rotation_x_subpanel, 0, 0, 0, 0, alRight);
    rotation_x_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_x_subpanel.Width := 100 * global_scale_factor;

    rotation_x_label := TLabel.Create(frm);
    rotation_x_label.Parent := rotation_x_subpanel;
    rotation_x_label.Layout := tlCenter;
    rotation_x_label.Caption := 'X:';
    set_margins_layout(rotation_x_label, 0, 0, MARGIN_LEFT, 0, alRight);
    rotation_x_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_x := TEdit.Create(frm);
    rotation_x.Parent := rotation_x_subpanel;
    rotation_x.Alignment := taRightJustify;
    rotation_x.ShowHint := True;
    rotation_x.Hint := 'The X component of the rotation angle in degrees. Defaults to "'
      + float_to_str(GLOBAL_ROTATION_X_DEFAULT, DIGITS_ANGLE, False) + '"';
    set_margins_layout(rotation_x, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_x.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_x.Width := 62 * global_scale_factor;

    rotation_y_subpanel := TPanel.Create(frm);
    rotation_y_subpanel.Parent := angle_panel;
    do_panel_layout(rotation_y_subpanel, 0);
    set_margins_layout(rotation_y_subpanel, 0, 0, 0, 0, alRight);
    rotation_y_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_y_subpanel.Width := 100 * global_scale_factor;

    rotation_y_label := TLabel.Create(frm);
    rotation_y_label.Parent := rotation_y_subpanel;
    rotation_y_label.Layout := tlCenter;
    rotation_y_label.Caption := 'Y:';
    set_margins_layout(rotation_y_label, 0, 0, MARGIN_LEFT, 0, alRight);
    rotation_y_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_y := TEdit.Create(frm);
    rotation_y.Parent := rotation_y_subpanel;
    rotation_y.Alignment := taRightJustify;
    rotation_y.ShowHint := True;
    rotation_y.Hint := 'The Y component of the rotation angle in degrees. Defaults to "'
      + float_to_str(GLOBAL_ROTATION_Y_DEFAULT, DIGITS_ANGLE, False) + '"';
    set_margins_layout(rotation_y, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_y.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_y.Width := 62 * global_scale_factor;

    rotation_z_subpanel := TPanel.Create(frm);
    rotation_z_subpanel.Parent := angle_panel;
    do_panel_layout(rotation_z_subpanel, 0);
    set_margins_layout(rotation_z_subpanel, 0, 0, 0, 0, alRight);
    rotation_z_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_z_subpanel.Width := 100 * global_scale_factor;

    rotation_z_label := TLabel.Create(frm);
    rotation_z_label.Parent := rotation_z_subpanel;
    rotation_z_label.Layout := tlCenter;
    rotation_z_label.Caption := 'Z:';
    set_margins_layout(rotation_z_label, 0, 0, MARGIN_LEFT, 0, alRight);
    rotation_z_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_z := TEdit.Create(frm);
    rotation_z.Parent := rotation_z_subpanel;
    rotation_z.Alignment := taRightJustify;
    rotation_z.ShowHint := True;
    rotation_z.Hint := 'The Z component of the rotation angle in degrees. Defaults to "'
      + float_to_str(GLOBAL_ROTATION_Z_DEFAULT, DIGITS_ANGLE, False) + '"';
    set_margins_layout(rotation_z, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_z.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_z.Width := 62 * global_scale_factor;

    // rotation options panel

    rotation_options_panel := TPanel.Create(frm);
    rotation_options_panel.Parent := frm;
    do_panel_layout(rotation_options_panel, PANEL_BEVEL);

    // rotation mode subpanel

    rotation_mode_subpanel := TPanel.Create(frm);
    rotation_mode_subpanel.Parent := rotation_options_panel;
    do_panel_layout(rotation_mode_subpanel, 0);
    set_margins_layout(rotation_mode_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    rotation_mode_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_mode_label := TLabel.Create(frm);
    rotation_mode_label.Parent := rotation_mode_subpanel;
    rotation_mode_label.Layout := tlCenter;
    rotation_mode_label.Caption := 'Rotation Mode:';
    set_margins_layout(rotation_mode_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    rotation_mode_label.Height := CONTROL_HEIGHT * global_scale_factor;

    mode_set := TRadioButton.Create(frm);
    mode_set.Parent := rotation_mode_subpanel;
    mode_set.Alignment := taLeftJustify;
    mode_set.Caption := 'Set';
    mode_set.ShowHint := True;
    mode_set.Hint := 'Rotate the record TO the specified rotation. Defaults to "'
      + bool_to_selected_str(GLOBAL_OPERATION_MODE_DEFAULT = OPERATION_MODE_SET) + '"';
    set_margins_layout(mode_set, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    mode_set.Height := CONTROL_HEIGHT * global_scale_factor;
    mode_set.Width := caption_width(mode_set) + (RADIO_PADDING * global_scale_factor);

    mode_rotate := TRadioButton.Create(frm);
    mode_rotate.Parent := rotation_mode_subpanel;
    mode_rotate.Alignment := taLeftJustify;
    mode_rotate.Caption := 'Rotate';
    mode_rotate.ShowHint := True;
    mode_rotate.Hint := 'Rotate the record BY the specified rotation. Defaults to "'
      + bool_to_selected_str(GLOBAL_OPERATION_MODE_DEFAULT = OPERATION_MODE_ROTATE) + '"';
    set_margins_layout(mode_rotate, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    mode_rotate.Height := CONTROL_HEIGHT * global_scale_factor;
    mode_rotate.Width := caption_width(mode_rotate) + (RADIO_PADDING * global_scale_factor);

    // rotation sequence subpanel

    rotation_sequence_subpanel := TPanel.Create(frm);
    rotation_sequence_subpanel.Parent := rotation_options_panel;
    do_panel_layout(rotation_sequence_subpanel, 0);
    set_margins_layout(rotation_sequence_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    rotation_sequence_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_sequence_label := TLabel.Create(frm);
    rotation_sequence_label.Parent := rotation_sequence_subpanel;
    rotation_sequence_label.Layout := tlCenter;
    rotation_sequence_label.Caption := 'Rotation Sequence:';
    set_margins_layout(rotation_sequence_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    rotation_sequence_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_sequence := TComboBox.Create(frm);
    rotation_sequence.Parent := rotation_sequence_subpanel;
    rotation_sequence.Style := csDropDownList;
    rotation_sequence.ShowHint := True;
    rotation_sequence.Hint := 'The order in which the proposed rotation would be applied. Defaults to "'
      + rotation_sequence_to_str(GLOBAL_ROTATION_SEQUENCE_DEFAULT) + '"';
    set_margins_layout(rotation_sequence, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_sequence.Height := CONTROL_HEIGHT * global_scale_factor;

    // apply to subpanel

    apply_to_subpanel := TPanel.Create(frm);
    apply_to_subpanel.Parent := rotation_options_panel;
    do_panel_layout(apply_to_subpanel, 0);
    set_margins_layout(apply_to_subpanel, MARGIN_TOP, MARGIN_BOTTOM, 0, 0, alTop);
    apply_to_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    apply_to_label := TLabel.Create(frm);
    apply_to_label.Parent := apply_to_subpanel;
    apply_to_label.Layout := tlCenter;
    apply_to_label.Caption := 'Apply To:';
    set_margins_layout(apply_to_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    apply_to_label.Height := CONTROL_HEIGHT * global_scale_factor;

    apply_to_both := TRadioButton.Create(frm);
    apply_to_both.Parent := apply_to_subpanel;
    apply_to_both.Alignment := taLeftJustify;
    apply_to_both.Caption := 'Both';
    apply_to_both.ShowHint := True;
    apply_to_both.Hint := 'Apply the proposed rotation to both the record''s position and rotation. '
      + 'Defaults to "' + bool_to_selected_str(GLOBAL_APPLY_TO_POSITION_DEFAULT and
      GLOBAL_APPLY_TO_ROTATION_DEFAULT) + '"';
    set_margins_layout(apply_to_both, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    apply_to_both.Height := CONTROL_HEIGHT * global_scale_factor;
    apply_to_both.Width := caption_width(apply_to_both) + (RADIO_PADDING * global_scale_factor);

    apply_to_position := TRadioButton.Create(frm);
    apply_to_position.Parent := apply_to_subpanel;
    apply_to_position.Alignment := taLeftJustify;
    apply_to_position.Caption := 'Position';
    apply_to_position.ShowHint := True;
    apply_to_position.Hint := 'Apply the proposed rotation to the record''s position only. Defaults to "'
      + bool_to_selected_str(GLOBAL_APPLY_TO_POSITION_DEFAULT and not GLOBAL_APPLY_TO_ROTATION_DEFAULT) + '"';
    set_margins_layout(apply_to_position, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    apply_to_position.Height := CONTROL_HEIGHT * global_scale_factor;
    apply_to_position.Width := caption_width(apply_to_position) + (RADIO_PADDING * global_scale_factor);

    apply_to_rotation := TRadioButton.Create(frm);
    apply_to_rotation.Parent := apply_to_subpanel;
    apply_to_rotation.Alignment := taLeftJustify;
    apply_to_rotation.Caption := 'Rotation';
    apply_to_rotation.ShowHint := True;
    apply_to_rotation.Hint := 'Apply the proposed rotation to the record''s rotation only. Defaults to "'
      + bool_to_selected_str(GLOBAL_APPLY_TO_ROTATION_DEFAULT and not GLOBAL_APPLY_TO_POSITION_DEFAULT) + '"';
    set_margins_layout(apply_to_rotation, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    apply_to_rotation.Height := CONTROL_HEIGHT * global_scale_factor;
    apply_to_rotation.Width := caption_width(apply_to_rotation) + (RADIO_PADDING * global_scale_factor);

    // secondary options panel

    secondary_options_panel := TPanel.Create(frm);
    secondary_options_panel.Parent := frm;
    do_panel_layout(secondary_options_panel, PANEL_BEVEL);

    // clamp subpanel

    clamp_subpanel := TPanel.Create(frm);
    clamp_subpanel.Parent := secondary_options_panel;
    do_panel_layout(clamp_subpanel, 0);
    set_margins_layout(clamp_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    clamp_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    clamp_label := TLabel.Create(frm);
    clamp_label.Parent := clamp_subpanel;
    clamp_label.Layout := tlCenter;
    clamp_label.Caption := 'Clamp Rotation to Multiples of:';
    set_margins_layout(clamp_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    clamp_label.Height := CONTROL_HEIGHT * global_scale_factor;

    clamp_use_checkbox := TCheckBox.Create(frm);
    clamp_use_checkbox.Parent := clamp_subpanel;
    clamp_use_checkbox.Alignment := taLeftJustify;
    clamp_use_checkbox.Caption := '&Clamp';
    clamp_use_checkbox.ShowHint := True;
    clamp_use_checkbox.Hint := 'Clamp the rotation to multiples of the specified angle. Defaults to "'
      + bool_to_checked_str(GLOBAL_CLAMP_USE_DEFAULT) + '"';
    set_margins_layout(clamp_use_checkbox, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    clamp_use_checkbox.Height := CONTROL_HEIGHT * global_scale_factor;
    clamp_use_checkbox.Width := caption_width(clamp_use_checkbox) + (CHECKBOX_PADDING * global_scale_factor);

    clamp_combo := TComboBox.Create(frm);
    clamp_combo.Parent := clamp_subpanel;
    clamp_combo.Style := csDropDownList;
    clamp_combo.ShowHint := True;
    clamp_combo.Hint := 'The angle to clamp to multiples of. Defaults to "'
      + clamp_mode_to_str(GLOBAL_CLAMP_MODE_DEFAULT) + '"';
    set_margins_layout(clamp_combo, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    clamp_combo.Height := CONTROL_HEIGHT * global_scale_factor;

    // position precision subpanel

    position_precision_subpanel := TPanel.Create(frm);
    position_precision_subpanel.Parent := secondary_options_panel;
    do_panel_layout(position_precision_subpanel, 0);
    set_margins_layout(position_precision_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    position_precision_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    position_precision_label := TLabel.Create(frm);
    position_precision_label.Parent := position_precision_subpanel;
    position_precision_label.Layout := tlCenter;
    position_precision_label.Caption := 'Position Final Precision:';
    set_margins_layout(position_precision_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    position_precision_label.Height := CONTROL_HEIGHT * global_scale_factor;

    position_precision_combo := TComboBox.Create(frm);
    position_precision_combo.Parent := position_precision_subpanel;
    position_precision_combo.Style := csDropDownList;
    position_precision_combo.ShowHint := True;
    position_precision_combo.Hint := 'The nearest decimal to round positions to when applying to record. '
      + 'Defaults to "' + precision_to_str(GLOBAL_POSITION_PRECISION_DEFAULT) + '"' + #13
      + 'Note: There is almost never any reason to change from the default.';
    set_margins_layout(position_precision_combo, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    position_precision_combo.Height := CONTROL_HEIGHT * global_scale_factor;

    // rotation precision subpanel

    rotation_precision_subpanel := TPanel.Create(frm);
    rotation_precision_subpanel.Parent := secondary_options_panel;
    do_panel_layout(rotation_precision_subpanel, 0);
    set_margins_layout(rotation_precision_subpanel, MARGIN_TOP, MARGIN_BOTTOM, 0, 0, alTop);
    rotation_precision_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_precision_label := TLabel.Create(frm);
    rotation_precision_label.Parent := rotation_precision_subpanel;
    rotation_precision_label.Layout := tlCenter;
    rotation_precision_label.Caption := 'Rotation Final Precision:';
    set_margins_layout(rotation_precision_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    rotation_precision_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_precision_combo := TComboBox.Create(frm);
    rotation_precision_combo.Parent := rotation_precision_subpanel;
    rotation_precision_combo.Style := csDropDownList;
    rotation_precision_combo.ShowHint := True;
    rotation_precision_combo.Hint := 'The nearest decimal to round rotations to when applying to record. '
      + 'Defaults to "' + precision_to_str(GLOBAL_ROTATION_PRECISION_DEFAULT) + '"' + #13
      + 'Note: There is almost never any reason to change from the default.';
    set_margins_layout(rotation_precision_combo, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_precision_combo.Height := CONTROL_HEIGHT * global_scale_factor;

    // meta panel

    meta_panel := TPanel.Create(frm);
    meta_panel.Parent := frm;
    do_panel_layout(meta_panel, PANEL_BEVEL);

    dry_run_subpanel := TPanel.Create(frm);
    dry_run_subpanel.Parent := meta_panel;
    do_panel_layout(dry_run_subpanel, 0);
    set_margins_layout(dry_run_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    dry_run_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    dry_run := TCheckBox.Create(frm);
    dry_run.Parent := dry_run_subpanel;
    dry_run.Caption := 'Dry &Run';
    dry_run.ShowHint := True;
    dry_run.Hint := 'Do not actually perform the rotation, just show what would be done. Defaults to "'
      + bool_to_checked_str(GLOBAL_DRY_RUN_DEFAULT) + '"';
    set_margins_layout(dry_run, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    dry_run.Height := CONTROL_HEIGHT * global_scale_factor;
    dry_run.Width := caption_width(dry_run) + (CHECKBOX_PADDING * global_scale_factor);

    save_same_file_subpanel := TPanel.Create(frm);
    save_same_file_subpanel.Parent := meta_panel;
    do_panel_layout(save_same_file_subpanel, 0);
    set_margins_layout(save_same_file_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    save_same_file_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    save_same_file := TCheckBox.Create(frm);
    save_same_file.Parent := save_same_file_subpanel;
    save_same_file.Caption := '&Save to Same File if Possible';
    save_same_file.ShowHint := True;
    save_same_file.Hint := 'Save the record to the same file if possible. Defaults to "'
      + bool_to_checked_str(GLOBAL_SAVE_TO_SAME_FILE_DEFAULT) + '"';
    set_margins_layout(save_same_file, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    save_same_file.Height := CONTROL_HEIGHT * global_scale_factor;
    save_same_file.Width := caption_width(save_same_file) + (CHECKBOX_PADDING * global_scale_factor);

    use_same_settings_for_all_subpanel := TPanel.Create(frm);
    use_same_settings_for_all_subpanel.Parent := meta_panel;
    do_panel_layout(use_same_settings_for_all_subpanel, 0);
    set_margins_layout(use_same_settings_for_all_subpanel, MARGIN_TOP, MARGIN_BOTTOM, 0, 0, alTop);
    use_same_settings_for_all_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    use_same_settings_for_all := TCheckBox.Create(frm);
    use_same_settings_for_all.Parent := use_same_settings_for_all_subpanel;
    use_same_settings_for_all.Caption := 'Use Same Settings for &All';
    use_same_settings_for_all.ShowHint := True;
    use_same_settings_for_all.Hint := 'Use the same settings for all records. Defaults to "'
      + bool_to_checked_str(GLOBAL_USE_SAME_SETTINGS_FOR_ALL_DEFAULT) + '"';
    set_margins_layout(use_same_settings_for_all, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    use_same_settings_for_all.Height := CONTROL_HEIGHT * global_scale_factor;
    use_same_settings_for_all.Width := caption_width(use_same_settings_for_all) + (CHECKBOX_PADDING
      * global_scale_factor);

    // button panel

    create_button_panel(frm, frm);

    // set the values on the various controls

    rotation_x.Text := float_to_str(global_rotate_x, DIGITS_ANGLE, False);
    rotation_y.Text := float_to_str(global_rotate_y, DIGITS_ANGLE, False);
    rotation_z.Text := float_to_str(global_rotate_z, DIGITS_ANGLE, False);
    mode_set.Checked := (global_operation_mode = OPERATION_MODE_SET);
    mode_rotate.Checked := (global_operation_mode = OPERATION_MODE_ROTATE);
    for i := SEQUENCE_MIN to SEQUENCE_MAX do
      rotation_sequence.Items.Add(rotation_sequence_to_str(i));
    rotation_sequence.ItemIndex := global_rotation_sequence;
    apply_to_both.Checked := global_apply_to_position and global_apply_to_rotation;
    apply_to_position.Checked := global_apply_to_position and not global_apply_to_rotation;
    apply_to_rotation.Checked := global_apply_to_rotation and not global_apply_to_position;
    clamp_use_checkbox.Checked := global_clamp_use;
    for i := CLAMP_MODE_MIN to CLAMP_MODE_MAX do
      clamp_combo.Items.Add(clamp_mode_to_str(i));
    clamp_combo.ItemIndex := global_clamp_mode;
    for i := PRECISION_MIN downto PRECISION_POSITION do
      position_precision_combo.Items.Add(precision_to_str(i));
    position_precision_combo.ItemIndex := -global_position_precision;
    for i := PRECISION_MIN downto PRECISION_ROTATION do
      rotation_precision_combo.Items.Add(precision_to_str(i));
    rotation_precision_combo.ItemIndex := -global_rotation_precision;
    dry_run.Checked := global_dry_run;
    save_same_file.Checked := global_save_to_same_file;
    use_same_settings_for_all.Checked := global_use_same_settings_for_all;

    // set the widths of combo boxes to the width of their widest item

    rotation_sequence.Width := max_item_width(rotation_sequence) + (COMBO_PADDING * global_scale_factor);
    clamp_combo.Width := max_item_width(clamp_combo) + (COMBO_PADDING * global_scale_factor);
    position_precision_combo.Width := max_item_width(position_precision_combo) + (COMBO_PADDING
      * global_scale_factor);
    rotation_precision_combo.Width := max_item_width(rotation_precision_combo) + (COMBO_PADDING
      * global_scale_factor);

    // show the form (duh)

    Result := frm.ShowModal;

    // get the values from the various controls and store them in their respective global variables

    if (Result = mrOk) then begin
      global_rotate_x := StrToFloat(rotation_x.Text);
      global_rotate_y := StrToFloat(rotation_y.Text);
      global_rotate_z := StrToFloat(rotation_z.Text);
      global_operation_mode := mode_set.Checked;
      global_rotation_sequence := rotation_sequence.ItemIndex;
      global_apply_to_position := apply_to_both.Checked or apply_to_position.Checked;
      global_apply_to_rotation := apply_to_both.Checked or apply_to_rotation.Checked;
      global_clamp_use := clamp_use_checkbox.Checked;
      global_clamp_mode := clamp_combo.ItemIndex;
      global_position_precision := -position_precision_combo.ItemIndex;
      global_rotation_precision := -rotation_precision_combo.ItemIndex;
      global_dry_run := dry_run.Checked;
      global_save_to_same_file := save_same_file.Checked;
      global_use_same_settings_for_all := use_same_settings_for_all.Checked;
    end;
  finally
    frm.Free();
  end;
end;


// build and display the dialog used for including/excluding records
function show_record_filter_dialog(): integer;
var
  frm: TForm;

  record_signature_use: TCheckBox;
  record_signature_mode_include, record_signature_mode_exclude: TRadioButton;
  record_signature_list: TEdit;

  refr_name_signature_use: TCheckBox;
  refr_name_signature_mode_include, refr_name_signature_mode_exclude: TRadioButton;
  refr_name_signature_list: TEdit;

  edid_starts_with_use: TCheckBox;
  edid_starts_with_mode_include, edid_starts_with_mode_exclude: TRadioButton;
  edid_starts_with_list: TEdit;

  edid_ends_with_use: TCheckBox;
  edid_ends_with_mode_include, edid_ends_with_mode_exclude: TRadioButton;
  edid_ends_with_list: TEdit;

  edid_contains_use: TCheckBox;
  edid_contains_mode_include, edid_contains_mode_exclude: TRadioButton;
  edid_contains_list: TEdit;

  edid_equals_use: TCheckBox;
  edid_equals_mode_include, edid_equals_mode_exclude: TRadioButton;
  edid_equals_list: TEdit;

  button_panel: TPanel;
  include_all_button: TButton;
const
  SIGNATURE_HINT = 'Comma-separated list of record signatures, e.g. "ACHR,REFR"';
  EDID_HINT_FULL = 'Comma-separated list of full editor IDs';
  EDID_HINT_FULL_OR_PARTIAL = 'Comma-separated list of full or partial editor IDs';
begin
  try
    frm := TForm.Create(nil);
    frm.Caption := 'Rotate Cell Contents: Include/Exclude Records';
    frm.AutoSize := True;
    frm.BorderStyle := bsSingle;
    frm.BorderIcons := [biSystemMenu];
    frm.Position := poScreenCenter;
    frm.Width := 600 * global_scale_factor;

    // filter panels

    create_filter_panel(frm, frm, 'Record Signature', SIGNATURE_HINT, record_signature_use,
      record_signature_mode_include, record_signature_mode_exclude, record_signature_list);
    create_filter_panel(frm, frm, 'REFR NAME Signature', SIGNATURE_HINT, refr_name_signature_use,
      refr_name_signature_mode_include, refr_name_signature_mode_exclude, refr_name_signature_list);
    create_filter_panel(frm, frm, 'EDID of REFR NAME (Starts With)', EDID_HINT_FULL_OR_PARTIAL, edid_starts_with_use,
      edid_starts_with_mode_include, edid_starts_with_mode_exclude, edid_starts_with_list);
    create_filter_panel(frm, frm, 'EDID of REFR NAME (Ends With)', EDID_HINT_FULL_OR_PARTIAL, edid_ends_with_use,
      edid_ends_with_mode_include, edid_ends_with_mode_exclude, edid_ends_with_list);
    create_filter_panel(frm, frm, 'EDID of REFR NAME (Contains)', EDID_HINT_FULL_OR_PARTIAL, edid_contains_use,
      edid_contains_mode_include, edid_contains_mode_exclude, edid_contains_list);
    create_filter_panel(frm, frm, 'EDID of REFR NAME (Equals)', EDID_HINT_FULL, edid_equals_use,
      edid_equals_mode_include, edid_equals_mode_exclude, edid_equals_list);

    // button panel

    button_panel := create_button_panel(frm, frm);

    include_all_button := TButton.Create(frm);
    include_all_button.Parent := button_panel;
    include_all_button.Caption := 'Include &All';
    include_all_button.ModalResult := mrYesToAll;
    include_all_button.ShowHint := True;
    include_all_button.Hint := 'Include all records - this will close the dialog and ignore all other settings';
    set_margins_layout(include_all_button, MARGIN_TOP, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    include_all_button.Width := caption_width(include_all_button) + (BUTTON_PADDING * global_scale_factor);

    // set the values on the various controls

    record_signature_use.Checked := global_record_signature_use;
    record_signature_mode_include.Checked := (global_record_signature_mode = FILTER_MODE_INCLUDE);
    record_signature_mode_exclude.Checked := (global_record_signature_mode = FILTER_MODE_EXCLUDE);
    record_signature_list.Text := global_record_signature_list;
    refr_name_signature_use.Checked := global_refr_name_signature_use;
    refr_name_signature_mode_include.Checked := (global_refr_name_signature_mode = FILTER_MODE_INCLUDE);
    refr_name_signature_mode_exclude.Checked := (global_refr_name_signature_mode = FILTER_MODE_EXCLUDE);
    refr_name_signature_list.Text := global_refr_name_signature_list;
    edid_starts_with_use.Checked := global_edid_starts_with_use;
    edid_starts_with_mode_include.Checked := (global_edid_starts_with_mode = FILTER_MODE_INCLUDE);
    edid_starts_with_mode_exclude.Checked := (global_edid_starts_with_mode = FILTER_MODE_EXCLUDE);
    edid_starts_with_list.Text := global_edid_starts_with_list;
    edid_ends_with_use.Checked := global_edid_ends_with_use;
    edid_ends_with_mode_include.Checked := (global_edid_ends_with_mode = FILTER_MODE_INCLUDE);
    edid_ends_with_mode_exclude.Checked := (global_edid_ends_with_mode = FILTER_MODE_EXCLUDE);
    edid_ends_with_list.Text := global_edid_ends_with_list;
    edid_contains_use.Checked := global_edid_contains_use;
    edid_contains_mode_include.Checked := (global_edid_contains_mode = FILTER_MODE_INCLUDE);
    edid_contains_mode_exclude.Checked := (global_edid_contains_mode = FILTER_MODE_EXCLUDE);
    edid_contains_list.Text := global_edid_contains_list;
    edid_equals_use.Checked := global_edid_equals_use;
    edid_equals_mode_include.Checked := (global_edid_equals_mode = FILTER_MODE_INCLUDE);
    edid_equals_mode_exclude.Checked := (global_edid_equals_mode = FILTER_MODE_EXCLUDE);
    edid_equals_list.Text := global_edid_equals_list;

    // show the form (duh)

    Result := frm.ShowModal;

    // get the values from the various controls

    if (Result = mrOk) then begin  // ok button
      global_record_signature_use := record_signature_use.Checked;
      global_record_signature_mode := record_signature_mode_include.Checked;
      global_record_signature_list := UpperCase(record_signature_list.Text);
      global_refr_name_signature_use := refr_name_signature_use.Checked;
      global_refr_name_signature_mode := refr_name_signature_mode_include.Checked;
      global_refr_name_signature_list := UpperCase(refr_name_signature_list.Text);
      global_edid_starts_with_use := edid_starts_with_use.Checked;
      global_edid_starts_with_mode := edid_starts_with_mode_include.Checked;
      global_edid_starts_with_list := edid_starts_with_list.Text;
      global_edid_ends_with_use := edid_ends_with_use.Checked;
      global_edid_ends_with_mode := edid_ends_with_mode_include.Checked;
      global_edid_ends_with_list := edid_ends_with_list.Text;
      global_edid_contains_use := edid_contains_use.Checked;
      global_edid_contains_mode := edid_contains_mode_include.Checked;
      global_edid_contains_list := edid_contains_list.Text;
      global_edid_equals_use := edid_equals_use.Checked;
      global_edid_equals_mode := edid_equals_mode_include.Checked;
      global_edid_equals_list := edid_equals_list.Text;
    end else if (Result = mrYesToAll) then begin  // include all button
      global_record_signature_use := False;
      global_refr_name_signature_use := False;
      global_edid_starts_with_use := False;
      global_edid_ends_with_use := False;
      global_edid_contains_use := False;
      global_edid_equals_use := False;
    end;
  finally
    frm.Free();
  end;
end;


//************************************************************************************************//
//                                                                                                //
// XEDIT SCRIPT FUNCTIONS                                                                         //
//                                                                                                //
//************************************************************************************************//


// initialize the script (ran once at the beginning)
function Initialize(): integer;
begin
  // check xEdit version
  if (wbVersionNumber < MINIMUM_REQUIRED_XEDIT_VERSION) then begin
    AddMessage('This script uses functions only available in xEdit version '
      + version_number_to_str(MINIMUM_REQUIRED_XEDIT_VERSION)
      + ' or higher; please update to use this script');
    Result := 1;
    exit;
  end;

  // initialize global variables
  global_debug := GLOBAL_DEBUG_DEFAULT;

  global_record_signature_use := GLOBAL_RECORD_SIGNATURE_USE_DEFAULT;
  global_record_signature_mode := GLOBAL_RECORD_SIGNATURE_MODE_DEFAULT;
  global_record_signature_list := GLOBAL_RECORD_SIGNATURE_LIST_DEFAULT;
  global_refr_name_signature_use := GLOBAL_REFR_NAME_SIGNATURE_USE_DEFAULT;
  global_refr_name_signature_mode := GLOBAL_REFR_NAME_SIGNATURE_MODE_DEFAULT;
  global_refr_name_signature_list := GLOBAL_REFR_NAME_SIGNATURE_LIST_DEFAULT;
  global_edid_starts_with_use := GLOBAL_EDID_STARTS_WITH_USE_DEFAULT;
  global_edid_starts_with_mode := GLOBAL_EDID_STARTS_WITH_MODE_DEFAULT;
  global_edid_starts_with_list := GLOBAL_EDID_STARTS_WITH_LIST_DEFAULT;
  global_edid_ends_with_use := GLOBAL_EDID_ENDS_WITH_USE_DEFAULT;
  global_edid_ends_with_mode := GLOBAL_EDID_ENDS_WITH_MODE_DEFAULT;
  global_edid_ends_with_list := GLOBAL_EDID_ENDS_WITH_LIST_DEFAULT;
  global_edid_contains_use := GLOBAL_EDID_CONTAINS_USE_DEFAULT;
  global_edid_contains_mode := GLOBAL_EDID_CONTAINS_MODE_DEFAULT;
  global_edid_contains_list := GLOBAL_EDID_CONTAINS_LIST_DEFAULT;
  global_edid_equals_use := GLOBAL_EDID_EQUALS_USE_DEFAULT;
  global_edid_equals_mode := GLOBAL_EDID_EQUALS_MODE_DEFAULT;
  global_edid_equals_list := GLOBAL_EDID_EQUALS_LIST_DEFAULT;

  global_rotate_x := GLOBAL_ROTATION_X_DEFAULT;
  global_rotate_y := GLOBAL_ROTATION_Y_DEFAULT;
  global_rotate_z := GLOBAL_ROTATION_Z_DEFAULT;

  global_operation_mode := GLOBAL_OPERATION_MODE_DEFAULT;
  global_rotation_sequence := GLOBAL_ROTATION_SEQUENCE_DEFAULT;
  global_apply_to_position := GLOBAL_APPLY_TO_POSITION_DEFAULT;
  global_apply_to_rotation := GLOBAL_APPLY_TO_ROTATION_DEFAULT;

  global_clamp_use := GLOBAL_CLAMP_USE_DEFAULT;
  global_clamp_mode := GLOBAL_CLAMP_MODE_DEFAULT;
  global_position_precision := GLOBAL_POSITION_PRECISION_DEFAULT;
  global_rotation_precision := GLOBAL_ROTATION_PRECISION_DEFAULT;

  global_dry_run := GLOBAL_DRY_RUN_DEFAULT;
  global_save_to_same_file := GLOBAL_SAVE_TO_SAME_FILE_DEFAULT;
  global_use_same_settings_for_all := GLOBAL_USE_SAME_SETTINGS_FOR_ALL_DEFAULT;

  // calculate the global scale factor to ensure that the UI looks good on all systems
  global_scale_factor := Screen.PixelsPerInch / 96.0;
  debug_print('Initialize: global_scale_factor = ' + float_to_str(global_scale_factor, 4, False));

  // initialize the target file variables
  global_target_file_list := TStringList.Create();
  global_target_file_list.Sorted := True;
  global_target_file_list.CaseSensitive := False;
  global_target_file_list.Duplicates := dupIgnore;

  // allow the user to make a choice about which records will be processed
  Result := show_record_filter_dialog();
  debug_print('Initialize: show_record_filter_dialog returned ' + IntToStr(Result) + ': '
    + modal_result_to_str(Result));
  if (Result = mrOk) or (Result = mrYesToAll) then begin
    Result := 0;
  end else begin
    AddMessage('User cancelled the operation');
    exit;
  end;
end;


// process record (ran for each record)
function Process(current_record: IInterface): integer;
var
  raw_x, raw_y, raw_z: double;
  local_rotate_x, local_rotate_y, local_rotate_z: double;
  initial_rotation_x, initial_rotation_y, initial_rotation_z: double;
  final_rotation_x, final_rotation_y, final_rotation_z: double;
  default_final_rotation_x, default_final_rotation_y, default_final_rotation_z: double;
  initial_position_x, initial_position_y, initial_position_z: double;
  final_position_x, final_position_y, final_position_z: double;
  operation_mode_text, dry_run_text, additional_final_text: string;
  file_list_index: integer;
  original_record: IInterface;
  current_file, target_file: IwbFile;
begin
  // put the record through the filter to see if it should be processed, but don't fail the entire
  // run if the record doesn't pass the filter, just skip it via early exit
  if (not filter_record(current_record)) then begin
    debug_print('Process: filter_record returned False, skipping record ' + ShortName(current_record));
    exit;
  end;

  // show the rotation options if they haven't been shown yet or if the user has chosen to not use
  // the same settings for all records
  if (not global_use_same_settings_for_all) or (not global_options_dialog_shown) then begin
    Result := show_options_dialog();
    debug_print('Process: show_options_dialog returned ' + IntToStr(Result) + ': '
      + modal_result_to_str(Result));
    global_options_dialog_shown := True;
    if (Result = mrOk) then begin
      Result := 0;
    end else begin
      AddMessage('User cancelled the operation');
      exit;
    end;
  end;

  current_file := GetFile(current_record);

  // if the file is editable and global_save_to_same_file has been set, other options can be ignored
  // and the record can be saved to the same file
  if IsEditable(current_file) and global_save_to_same_file then begin
    target_file := current_file;
    debug_print('Process: editable file, saving to same file');

  // otherwise the user will be prompted to select a target file at least once for each separate file
  // that they have selected records from. after that, depending on how the options are set, the user
  // may be prompted to select a target file for each record, or the same target file will be used
  // for all records from a given file
  end else begin
    // determine if the current record's file has been processed before and if so, retrieve the file
    // otherwise set target_file to nil
    if global_target_file_list.Find(GetFileName(current_file), file_list_index) then begin
      target_file := ObjectToElement(global_target_file_list.Objects[file_list_index]);
      debug_print('Process: existing target file found for ' + GetFileName(current_file) + ': '
        + GetFileName(target_file));
    end else begin
      target_file := nil;
      debug_print('Process: no existing target file found for ' + GetFileName(current_file));
    end;

    // target_file is unassigned if the current record's file has not been processed before and so a
    // target file must be selected, regardless of whether the global_use_same_settings_for_all has
    // been set or not
    if (not Assigned(target_file)) or (not global_use_same_settings_for_all) then begin
      // show the file dialog to get the target file
      Result := show_file_dialog(current_file, target_file);
      debug_print('Process: show_file_dialog returned ' + IntToStr(Result) + ': '
        + modal_result_to_str(Result));

      // handle the result of the file dialog by either adding target_file to the global list of
      // target files, or by exiting the script
      if (Result = mrOk) then begin
        Result := 0;
        global_target_file_list.AddObject(GetFileName(current_file), target_file);
        debug_print('Process: added target file ' + GetFileName(target_file) + ' for '
          + GetFileName(current_file));
      end else if (Result = mrCancel) then begin
        AddMessage('User cancelled the operation');
        exit;
      end else begin
        exit;
      end;
    end;
  end;

  // double check that target_file is assigned, since it should be at this point. then proceed to add
  // the required masters and copy the record to the target file, unless this is a dry run
  if Assigned(target_file) then begin
    debug_print('Process: target_file is assigned, adding masters and copying record');
    // save a reference to the current record before the variable is overwritten by the copy. this
    // is done because while the script operates on the copy, the original record is where the
    // initial position/rotation are pulled from
    original_record := current_record;
    if (not global_dry_run) then begin
      AddRequiredElementMasters(current_record, target_file, True);
      current_record := wbCopyElementToFile(current_record, target_file, False, True);
    end else begin
      debug_print('Process: dry run, not actually adding masters and copying record to target file');
    end;
    debug_print('Process: file of new record: ' + GetFileName(GetFile((current_record))));
  end else begin
    // this branch shouldn't ever get triggered, but putting it here as an escape hatch just in case
    AddMessage('No target file found for ' + GetFileName(current_file));
    Result := mrAbort;
    exit;
  end;

  // set up some text for messaging
  if (global_operation_mode = OPERATION_MODE_SET) then
    operation_mode_text := 'Setting to '
  else
    operation_mode_text := 'Rotating by ';
  if (global_dry_run) then dry_run_text := '[DRY RUN] ';

  // show initial messaging, including the full name of the record being processed and the rotation
  // that will be applied
  AddMessage(FullPath(current_record));
  AddMessage(ShortName(current_record));
  AddMessage(dry_run_text + operation_mode_text + qv_to_str(0, global_rotate_x, global_rotate_y,
    global_rotate_z, False, False, False, True, ' = ', '', DIGITS_ANGLE) + ' using rotation sequence '
    + rotation_sequence_to_str(global_rotation_sequence));

  // get initial rotation
  initial_rotation_x := GetElementNativeValues(original_record, 'DATA - Position/Rotation\Rotation\X');
  initial_rotation_y := GetElementNativeValues(original_record, 'DATA - Position/Rotation\Rotation\Y');
  initial_rotation_z := GetElementNativeValues(original_record, 'DATA - Position/Rotation\Rotation\Z');
  debug_print('Process: initial rotation: ' + vector_to_str(initial_rotation_x, initial_rotation_y,
    initial_rotation_z, False, True, DIGITS_ANGLE));

  // instead of using the global_rotate_* variables, initialize local_rotate_* variables for use in
  // calculations instead so that altering them won't affect subsequent records
  if (global_operation_mode = OPERATION_MODE_SET) then begin
    // if the operation mode is "set", then the local_rotate_* variables are set to the rotation that
    // will transform the current rotation to the desired rotation
    rotation_difference(
      initial_rotation_x, initial_rotation_y, initial_rotation_z,
      global_rotate_x, global_rotate_y, global_rotate_z,
      global_rotation_sequence,
      local_rotate_x, local_rotate_y, local_rotate_z
    );
  end else begin
    // if the operation mode is "rotate", then the local_rotate_* variables can just start out as
    // copies of the global_rotate_* variables
    local_rotate_x := global_rotate_x;
    local_rotate_y := global_rotate_y;
    local_rotate_z := global_rotate_z;
  end;
  debug_print('Process: applying actual rotation of: ' + vector_to_str(local_rotate_x, local_rotate_y,
    local_rotate_z, False, False, DIGITS_FULL));

  // get rotated rotation no matter what, since it's also needed for position calculation even if
  // not being applied to the rotation
  rotate_rotation(
    initial_rotation_x, initial_rotation_y, initial_rotation_z,  // initial rotation
    local_rotate_x, local_rotate_y, local_rotate_z,              // rotation to apply
    global_rotation_sequence,                                    // rotation sequence to use
    raw_x, raw_y, raw_z                                          // (output) raw rotation
  );
  debug_print('Process: rotate_rotation returned values: '
    + vector_to_str(raw_x, raw_y, raw_z, False, False, DIGITS_FULL));

  // round the rotation to the user's specified precision
  final_rotation_x := SimpleRoundTo(raw_x, global_rotation_precision);
  final_rotation_y := SimpleRoundTo(raw_y, global_rotation_precision);
  final_rotation_z := SimpleRoundTo(raw_z, global_rotation_precision);
  debug_print('Process: rotation after chosen rounding (nearest ' + precision_to_str(global_rotation_precision)
    + '): ' + vector_to_str(final_rotation_x, final_rotation_y, final_rotation_z, False, True, DIGITS_ANGLE));
  if (global_rotation_precision <> GLOBAL_ROTATION_PRECISION_DEFAULT) then
    additional_final_text := ' (rounded to nearest ' + precision_to_str(global_rotation_precision) + ')';

  // clamp the rotation if the user has chosen to do so
  if (global_clamp_use) then begin
    final_rotation_x := clamp_angle(final_rotation_x, global_clamp_mode);
    final_rotation_y := clamp_angle(final_rotation_y, global_clamp_mode);
    final_rotation_z := clamp_angle(final_rotation_z, global_clamp_mode);
    additional_final_text := ' (clamped to nearest multiple of ' + clamp_mode_to_str(global_clamp_mode) + ')';
    debug_print('Process: clamped rotation: ' + vector_to_str(final_rotation_x, final_rotation_y,
      final_rotation_z, False, True, DIGITS_ANGLE));
  end;

  // rounding or clamping may have caused the rotation to fall outside the desired range of angles,
  // so normalize them
  final_rotation_x := normalize_angle(final_rotation_x);
  final_rotation_y := normalize_angle(final_rotation_y);
  final_rotation_z := normalize_angle(final_rotation_z);

  // apply previously-computed rotation to the record
  if (global_apply_to_rotation) then begin
    AddMessage(dry_run_text + 'Initial rotation: ' + vector_to_str(initial_rotation_x,
      initial_rotation_y, initial_rotation_z, True, True, DIGITS_ANGLE));

    if (not global_dry_run) then begin
      SetElementNativeValues(current_record, 'DATA - Position/Rotation\Rotation\X', final_rotation_x);
      SetElementNativeValues(current_record, 'DATA - Position/Rotation\Rotation\Y', final_rotation_y);
      SetElementNativeValues(current_record, 'DATA - Position/Rotation\Rotation\Z', final_rotation_z);
    end;

    AddMessage(dry_run_text + 'Final rotation:   ' + vector_to_str(final_rotation_x, final_rotation_y,
      final_rotation_z, True, True, DIGITS_ANGLE) + additional_final_text);
  end;

  // apply the rotation to the position part of the record
  if (global_apply_to_position) then begin
    // reset additional_final_text since it's also used for rotation
    additional_final_text := '';

    // the following lines (having to do with the default_final_rotation_* and comparing the value)
    // don't need to be done unless the rotation is being applied to the position, so this chunk of
    // code is placed behind the global_apply_to_position check

    // calculate and save for comparison a copy of the final rotation using default rounding instead
    // of user-specified rounding
    default_final_rotation_x := SimpleRoundTo(raw_x, GLOBAL_ROTATION_PRECISION_DEFAULT);
    default_final_rotation_y := SimpleRoundTo(raw_y, GLOBAL_ROTATION_PRECISION_DEFAULT);
    default_final_rotation_z := SimpleRoundTo(raw_z, GLOBAL_ROTATION_PRECISION_DEFAULT);
    debug_print('Process: rotation default rounding (nearest '
      + precision_to_str(GLOBAL_ROTATION_PRECISION_DEFAULT) + '): '
      + vector_to_str(default_final_rotation_x, default_final_rotation_y, default_final_rotation_z,
      False, True, DIGITS_ANGLE));

    // if there are any differences between the different final rotation values, either the angle
    // was clamped or rounding happened. either way, the rotation is altered and the local_rotate_*
    // variables need to be updated to the new rotation. to do so, need to compare initial rotation
    // and final rotation, which is done via the rotation_difference procedure
    if (CompareValue(final_rotation_x, default_final_rotation_x, EPSILON_ROTATION) <> EqualsValue) or
       (CompareValue(final_rotation_y, default_final_rotation_y, EPSILON_ROTATION) <> EqualsValue) or
       (CompareValue(final_rotation_z, default_final_rotation_z, EPSILON_ROTATION) <> EqualsValue) then begin
      debug_print('Process: rotation was clamped or rounded, updating rotation variables');
      debug_print('Process: original rotation to be applied: ' + vector_to_str(local_rotate_x,
        local_rotate_y, local_rotate_z, False, True, DIGITS_FULL));
      rotation_difference(
        initial_rotation_x, initial_rotation_y, initial_rotation_z,
        final_rotation_x, final_rotation_y, final_rotation_z,
        global_rotation_sequence,
        local_rotate_x, local_rotate_y, local_rotate_z
      );
      debug_print('Process: new rotation to be applied: ' + vector_to_str(local_rotate_x,
        local_rotate_y, local_rotate_z, False, True, DIGITS_FULL));
    end;

    // get the initial position
    initial_position_x := GetElementEditValues(original_record, 'DATA - Position/Rotation\Position\X');
    initial_position_y := GetElementEditValues(original_record, 'DATA - Position/Rotation\Position\Y');
    initial_position_z := GetElementEditValues(original_record, 'DATA - Position/Rotation\Position\Z');
    AddMessage(dry_run_text + 'Initial position: ' + vector_to_str(initial_position_x,
      initial_position_y, initial_position_z, True, False, DIGITS_POSITION));

    // calculate the position with the rotation applied
    rotate_position(
      initial_position_x, initial_position_y, initial_position_z,  // initial position
      local_rotate_x, local_rotate_y, local_rotate_z,              // rotation to apply
      global_rotation_sequence,                                    // rotation sequence to use
      raw_x, raw_y, raw_z                                          // (output) raw final position
    );
    debug_print('Process: rotate_position returned values: '
      + vector_to_str(raw_x, raw_y, raw_z, False, False, DIGITS_FULL));

    // round the position to the user's specified precision
    final_position_x := SimpleRoundTo(raw_x, global_position_precision);
    final_position_y := SimpleRoundTo(raw_y, global_position_precision);
    final_position_z := SimpleRoundTo(raw_z, global_position_precision);
    debug_print('Process: position after chosen rounding (nearest ' + precision_to_str(global_position_precision)
      + '): ' + vector_to_str(final_position_x, final_position_y, final_position_z, False, False, DIGITS_POSITION));
    if (global_position_precision <> GLOBAL_POSITION_PRECISION_DEFAULT) then
      additional_final_text := ' (rounded to nearest ' + precision_to_str(global_position_precision) + ')';

    // apply the position to the record
    if (not global_dry_run) then begin
      SetElementNativeValues(current_record, 'DATA - Position/Rotation\Position\X', final_position_x);
      SetElementNativeValues(current_record, 'DATA - Position/Rotation\Position\Y', final_position_y);
      SetElementNativeValues(current_record, 'DATA - Position/Rotation\Position\Z', final_position_z);
    end;

    AddMessage(dry_run_text + 'Final position:   ' + vector_to_str(final_position_x, final_position_y,
      final_position_z, True, False, DIGITS_POSITION) + additional_final_text);
  end;
end;


// clean up the script (ran once at the end)
function Finalize(): integer;
begin
  global_target_file_list.Free();
end;


end.
