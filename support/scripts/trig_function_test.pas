{
  function tests for additional trig functions exposed by fire
}
unit trig_function_test;

var
  PI_BY_2: Single;
  PI_BY_3: Single;
  PI_BY_4: Single;
  PI_BY_6: Single;
  SQRT2: Single;
  SQRT3: Single;

function Initialize: integer;
begin
  SetPrecisionMode(pmSingle);
  SetRoundMode(rmTruncate);

  PI_BY_2 := Pi / 2;
  PI_BY_3 := Pi / 3;
  PI_BY_4 := Pi / 4;
  PI_BY_6 := Pi / 6;
  SQRT2 := Sqrt(2);
  SQRT3 := Sqrt(3);
end;


function prt_float(d: Single): string;
begin
  Result := FloatToStrF(d, 2, 9999, 6);
end;


function do_test(): boolean;
begin
  Result := True;

  AddMessage('beginning trig function test...');

  if (not test_arccos) then Result := False;
  if (not test_arccot) then Result := False;
  if (not test_arccsc) then Result := False;
  if (not test_arcsec) then Result := False;
  if (not test_arcsin) then Result := False;
  if (not test_arctan2) then Result := False;
  if (not test_cot) then Result := False;
  if (not test_csc) then Result := False;
  if (not test_deg_to_rad) then Result := False;
  if (not test_rad_to_deg) then Result := False;
  if (not test_sec) then Result := False;

  if (not Result) then AddMessage('one or more tests failed');
end;


function test_arctan2(): boolean;
var
  test_values_y, test_values_x, expected: array[0..16] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values_y[0] := -1.0;
  test_values_y[1] := -1.0;
  test_values_y[2] := -1.0;
  test_values_y[3] := -1.0 * SQRT3;
  test_values_y[4] := -1.0;
  test_values_y[5] := -1.0 * SQRT3;
  test_values_y[6] := -1.0;
  test_values_y[7] := -1.0;
  test_values_y[8] := 0.0;
  test_values_y[9] := 1.0;
  test_values_y[10] := 1.0;
  test_values_y[11] := SQRT3;
  test_values_y[12] := 1.0;
  test_values_y[13] := SQRT3;
  test_values_y[14] := 1.0;
  test_values_y[15] := 1.0;
  test_values_y[16] := 0.0;

  test_values_x[0] := NegInfinity;
  test_values_x[1] := -1.0 * SQRT3;
  test_values_x[2] := -1.0;
  test_values_x[3] := -1.0;
  test_values_x[4] := 0.0;
  test_values_x[5] := 1.0;
  test_values_x[6] := 1.0;
  test_values_x[7] := SQRT3;
  test_values_x[8] := 1.0;
  test_values_x[9] := SQRT3;
  test_values_x[10] := 1.0;
  test_values_x[11] := 1.0;
  test_values_x[12] := 0.0;
  test_values_x[13] := -1.0;
  test_values_x[14] := -1.0;
  test_values_x[15] := -1.0 * SQRT3;
  test_values_x[16] := -1.0;

  expected[0] := -1.0 * Pi;        // -1, NegInfinity
  expected[1] := -5.0 * PI_BY_6;   // -1, -SQRT3
  expected[2] := -3.0 * PI_BY_4;   // -1, -1
  expected[3] := -2.0 * PI_BY_3;   // -SQRT3, -1
  expected[4] := -1.0 * PI_BY_2;   // -1, 0
  expected[5] := -1.0 * PI_BY_3;   // -SQRT3, 1
  expected[6] := -1.0 * PI_BY_4;   // -1, 1
  expected[7] := -1.0 * PI_BY_6;   // -1, SQRT3
  expected[8] := 0.0;              // 0, 1
  expected[9] := PI_BY_6;          // 1, SQRT3
  expected[10] := PI_BY_4;         // 1, 1
  expected[11] := PI_BY_3;         // SQRT3, 1
  expected[12] := PI_BY_2;         // 1, 0
  expected[13] := 2 * PI_BY_3;     // SQRT3, -1
  expected[14] := 3 * PI_BY_4;     // 1, -1
  expected[15] := 5 * PI_BY_6;     // 1, -SQRT3
  expected[16] := Pi;              // 0, -1

  AddMessage('testing ''ArcTan2''...');
  for i := Low(expected) to High(expected) do begin
    returned := ArcTan2(test_values_y[i], test_values_x[i]);
    if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
      AddMessage('ArcTan2(test_values_y[' + IntToStr(i) + '] = ' + prt_float(test_values_y[i]) + ', test_values_x[' + IntToStr(i) + '] = ' + prt_float(test_values_x[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;


function test_arcsin(): boolean;
var
  test_values, expected: array[0..8] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := -1.0;
  test_values[1] := -1.0 * SQRT3 / 2.0;
  test_values[2] := -1.0 / SQRT2;
  test_values[3] := -0.5;
  test_values[4] := 0.0;
  test_values[5] := 0.5;
  test_values[6] := 1.0 / SQRT2;
  test_values[7] := SQRT3 / 2.0;
  test_values[8] := 1.0;

  expected[0] := -1.0 * PI_BY_2;
  expected[1] := -1.0 * PI_BY_3;
  expected[2] := -1.0 * PI_BY_4;
  expected[3] := -1.0 * PI_BY_6;
  expected[4] := 0.0;
  expected[5] := PI_BY_6;
  expected[6] := PI_BY_4;
  expected[7] := PI_BY_3;
  expected[8] := PI_BY_2;

  AddMessage('testing ''ArcSin''...');
  for i := Low(expected) to High(expected) do begin
    returned := ArcSin(test_values[i]);
    if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
      AddMessage('ArcSin(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;


function test_arccos(): boolean;
var
  test_values, expected: array[0..8] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := -1.0;
  test_values[1] := -1.0 * SQRT3 / 2.0;
  test_values[2] := -1.0 / SQRT2;
  test_values[3] := -0.5;
  test_values[4] := 0.0;
  test_values[5] := 0.5;
  test_values[6] := 1.0 / SQRT2;
  test_values[7] := SQRT3 / 2.0;
  test_values[8] := 1.0;

  expected[0] := Pi;
  expected[1] := 5.0 * PI_BY_6;
  expected[2] := 3.0 * PI_BY_4;
  expected[3] := 2.0 * PI_BY_3;
  expected[4] := PI_BY_2;
  expected[5] := PI_BY_3;
  expected[6] := PI_BY_4;
  expected[7] := PI_BY_6;
  expected[8] := 0.0;

  AddMessage('testing ''ArcCos''...');
  for i := Low(expected) to High(expected) do begin
    returned := ArcCos(test_values[i]);
    if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
      AddMessage('ArcCos(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;


function test_arccot(): boolean;
var
  test_values, expected: array[0..8] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := NegInfinity;
  test_values[1] := SQRT3;
  test_values[2] := 1.0;
  test_values[3] := 1.0 / SQRT3;
  test_values[4] := 0.0;
  test_values[5] := -1.0 / SQRT3;
  test_values[6] := -1.0;
  test_values[7] := -1.0 * SQRT3;
  test_values[8] := Infinity;

  expected[0] := 0.0;
  expected[1] := PI_BY_6;
  expected[2] := PI_BY_4;
  expected[3] := PI_BY_3;
  expected[4] := PI_BY_2;
  expected[5] := -1.0 * PI_BY_3;
  expected[6] := -1.0 * PI_BY_4;
  expected[7] := -1.0 * PI_BY_6;
  expected[8] := 0.0;

  AddMessage('testing ''ArcCot''...');
  for i := Low(expected) to High(expected) do begin
    returned := ArcCot(test_values[i]);
    if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
      AddMessage('ArcCot(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;


function test_arccsc(): boolean;
var
  test_values, expected: array[0..10] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := NegInfinity;
  test_values[1] := -2.0;
  test_values[2] := -1.0 * SQRT2;
  test_values[3] := -2.0 / SQRT3;
  test_values[4] := -1.0;
  test_values[5] := 0.0;
  test_values[6] := 1.0;
  test_values[7] := 2.0 / SQRT3;
  test_values[8] := SQRT2;
  test_values[9] := 2.0;
  test_values[10] := Infinity;

  expected[0] := 0.0;
  expected[1] := -1.0 * PI_BY_6;
  expected[2] := -1.0 * PI_BY_4;
  expected[3] := -1.0 * PI_BY_3;
  expected[4] := -1.0 * PI_BY_2;
  expected[5] := Infinity;
  expected[6] := PI_BY_2;
  expected[7] := PI_BY_3;
  expected[8] := PI_BY_4;
  expected[9] := PI_BY_6;
  expected[10] := 0.0;

  AddMessage('testing ''ArcCsc''...');
  AddMessage('expected[5] is infinite: ' + IsInfinite(expected[5]));
  for i := Low(expected) to High(expected) do begin
    AddMessage('  test value ' + IntToStr(i));
    returned := ArcCsc(test_values[i]);
    if (IsInfinite(expected[i])) then begin
      if (returned <> expected[i]) then begin
        AddMessage('ArcCsc(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
        Return := False;
      end
      else begin
        if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
          AddMessage('ArcCsc(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
          Result := False;
        end;
      end;
    end;
  end;
end;


function test_arcsec(): boolean;
var
  test_values, expected: array[0..10] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := NegInfinity;
  test_values[1] := -2.0
  test_values[2] := -1.0 * SQRT2;
  test_values[3] := -2.0 / SQRT3;
  test_values[4] := -1.0;
  test_values[5] := 0.0;
  test_values[6] := 1.0;
  test_values[7] := 2.0 / SQRT3;
  test_values[8] := SQRT2;
  test_values[9] := 2.0;
  test_values[10] := Infinity;

  expected[0] := PI_BY_2;
  expected[1] := 2.0 * PI_BY_3;
  expected[2] := 3.0 * PI_BY_4
  expected[3] := 5.0 * PI_BY_6;
  expected[4] := Pi;
  expected[5] := Infinity;
  expected[6] := 0.0;
  expected[7] := PI_BY_6;
  expected[8] := PI_BY_4;
  expected[9] := PI_BY_3;
  expected[10] := PI_BY_2;

  AddMessage('testing ''ArcSec''...');
  for i := Low(expected) to High(expected) do begin
    returned := ArcSec(test_values[i]);
    if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
      AddMessage('ArcSec(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;


function test_deg_to_rad(): boolean;
var
  test_values, expected: array[0..16] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := 0.0;
  test_values[1] := 30.0;
  test_values[2] := 45.0;
  test_values[3] := 60.0;
  test_values[4] := 90.0;
  test_values[5] := 120.0;
  test_values[6] := 135.0;
  test_values[7] := 150.0;
  test_values[8] := 180.0;
  test_values[9] := 210.0;
  test_values[10] := 225.0;
  test_values[11] := 240.0;
  test_values[12] := 270.0;
  test_values[13] := 300.0;
  test_values[14] := 315.0;
  test_values[15] := 330.0;
  test_values[16] := 360.0;

  expected[0] := 0.0;
  expected[1] := PI_BY_6;
  expected[2] := PI_BY_4;
  expected[3] := PI_BY_3;
  expected[4] := PI_BY_2;
  expected[5] := 2 * PI_BY_3;
  expected[6] := 3 * PI_BY_4;
  expected[7] := 5 * PI_BY_6;
  expected[8] := Pi;
  expected[9] := 7 * PI_BY_6;
  expected[10] := 5 * PI_BY_4;
  expected[11] := 4 * PI_BY_3;
  expected[12] := 3 * PI_BY_2;
  expected[13] := 5 * PI_BY_3;
  expected[14] := 7 * PI_BY_4;
  expected[15] := 11 * PI_BY_6;
  expected[16] := 2 * Pi;

  AddMessage('testing ''DegToRad''...');
  for i := Low(expected) to High(expected) do begin
    returned := DegToRad(test_values[i]);
    if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
      AddMessage('DegToRad(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;


function test_rad_to_deg(): boolean;
var
  test_values, expected: array[0..16] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := 0.0;
  test_values[1] := PI_BY_6;
  test_values[2] := PI_BY_4;
  test_values[3] := PI_BY_3;
  test_values[4] := PI_BY_2;
  test_values[5] := 2 * PI_BY_3;
  test_values[6] := 3 * PI_BY_4;
  test_values[7] := 5 * PI_BY_6;
  test_values[8] := Pi;
  test_values[9] := 7 * PI_BY_6;
  test_values[10] := 5 * PI_BY_4;
  test_values[11] := 4 * PI_BY_3;
  test_values[12] := 3 * PI_BY_2;
  test_values[13] := 5 * PI_BY_3;
  test_values[14] := 7 * PI_BY_4;
  test_values[15] := 11 * PI_BY_6;
  test_values[16] := 2 * Pi;

  expected[0] := 0.0;
  expected[1] := 30.0;
  expected[2] := 45.0;
  expected[3] := 60.0;
  expected[4] := 90.0;
  expected[5] := 120.0;
  expected[6] := 135.0;
  expected[7] := 150.0;
  expected[8] := 180.0;
  expected[9] := 210.0;
  expected[10] := 225.0;
  expected[11] := 240.0;
  expected[12] := 270.0;
  expected[13] := 300.0;
  expected[14] := 315.0;
  expected[15] := 330.0;
  expected[16] := 360.0;

  AddMessage('testing ''RadToDeg''...');
  for i := Low(expected) to High(expected) do begin
    returned := RadToDeg(test_values[i]);
    if CompareValue(returned, expected[i], 0.00001) <> EqualsValue then begin
      AddMessage('RadToDeg(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;


function test_csc(): boolean;
var
  test_values, expected: array[0..16] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := 0.0;
  test_values[1] := PI_BY_6;
  test_values[2] := PI_BY_4;
  test_values[3] := PI_BY_3;
  test_values[4] := PI_BY_2;
  test_values[5] := 2 * PI_BY_3;
  test_values[6] := 3 * PI_BY_4;
  test_values[7] := 5 * PI_BY_6;
  test_values[8] := Pi;
  test_values[9] := 7 * PI_BY_6;
  test_values[10] := 5 * PI_BY_4;
  test_values[11] := 4 * PI_BY_3;
  test_values[12] := 3 * PI_BY_2;
  test_values[13] := 5 * PI_BY_3;
  test_values[14] := 7 * PI_BY_4;
  test_values[15] := 11 * PI_BY_6;
  test_values[16] := 2 * Pi;

  expected[0] := Infinity;
  expected[1] := 2.0;
  expected[2] := SQRT2;
  expected[3] := 2.0 / SQRT3;
  expected[4] := 1.0;
  expected[5] := 2.0 / SQRT3;
  expected[6] := SQRT2;
  expected[7] := 2.0;
  expected[8] := Infinity;
  expected[9] := -2.0;
  expected[10] := -1.0 * SQRT2;
  expected[11] := -2.0 / SQRT3;
  expected[12] := -1.0;
  expected[13] := -2.0 / SQRT3;
  expected[14] := -1.0 * SQRT2;
  expected[15] := -2.0;
  expected[16] := Infinity;

  AddMessage('testing ''Csc''...');
  for i := Low(expected) to High(expected) do begin
    try
      returned := Csc(test_values[i]);
    except
      on E : EZeroDivide do begin
        AddMessage('Csc(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') passed; expected value: Undefined; actual value: Undefined');
        Result := True;
        Exit;
      end;
    end;
    if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
      AddMessage('Csc(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;


function test_cot(): boolean;
var
  test_values, expected: array[0..16] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := 0.0;
  test_values[1] := PI_BY_6;
  test_values[2] := PI_BY_4;
  test_values[3] := PI_BY_3;
  test_values[4] := PI_BY_2;
  test_values[5] := 2 * PI_BY_3;
  test_values[6] := 3 * PI_BY_4;
  test_values[7] := 5 * PI_BY_6;
  test_values[8] := Pi;
  test_values[9] := 7 * PI_BY_6;
  test_values[10] := 5 * PI_BY_4;
  test_values[11] := 4 * PI_BY_3;
  test_values[12] := 3 * PI_BY_2;
  test_values[13] := 5 * PI_BY_3;
  test_values[14] := 7 * PI_BY_4;
  test_values[15] := 11 * PI_BY_6;
  test_values[16] := 2 * Pi;

  expected[0] := Infinity;
  expected[1] := SQRT3;
  expected[2] := 1.0;
  expected[3] := 1.0 / SQRT3;
  expected[4] := 0.0;
  expected[5] := -1.0 / SQRT3;
  expected[6] := -1.0;
  expected[7] := -1.0 * SQRT3;
  expected[8] := Infinity;
  expected[9] := SQRT3;
  expected[10] := 1.0;
  expected[11] := 1.0 / SQRT3;
  expected[12] := 0.0;
  expected[13] := -1.0 / SQRT3;
  expected[14] := -1.0;
  expected[15] := -1.0 * SQRT3;
  expected[16] := Infinity;

  AddMessage('testing ''Cot''...');
  for i := Low(expected) to High(expected) do begin
    try
      returned := Cot(test_values[i]);
    except
      on E : EZeroDivide do begin
        AddMessage('Cot(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') passed; expected value: Undefined; actual value: Undefined');
        Result := True;
        Exit;
      end;
    end;
    if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
      AddMessage('Cot(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;


function test_sec(): boolean;
var
  test_values, expected: array[0..16] of Single;
  i: integer;
  returned: Single;
begin
  Result := True;

  test_values[0] := 0.0;
  test_values[1] := PI_BY_6;
  test_values[2] := PI_BY_4;
  test_values[3] := PI_BY_3;
  test_values[4] := PI_BY_2;
  test_values[5] := 2 * PI_BY_3;
  test_values[6] := 3 * PI_BY_4;
  test_values[7] := 5 * PI_BY_6;
  test_values[8] := Pi;
  test_values[9] := 7 * PI_BY_6;
  test_values[10] := 5 * PI_BY_4;
  test_values[11] := 4 * PI_BY_3;
  test_values[12] := 3 * PI_BY_2;
  test_values[13] := 5 * PI_BY_3;
  test_values[14] := 7 * PI_BY_4;
  test_values[15] := 11 * PI_BY_6;
  test_values[16] := 2 * Pi;

  expected[0] := 1.0;
  expected[1] := 2.0 / SQRT3;
  expected[2] := SQRT2;
  expected[3] := 2.0;
  expected[4] := Infinity;
  expected[5] := -2.0;
  expected[6] := -1.0 * SQRT2;
  expected[7] := -2.0 / SQRT3;
  expected[8] := -1;
  expected[9] := -2.0 / SQRT3;
  expected[10] := -1.0 * SQRT2;
  expected[11] := -2.0;
  expected[12] := Infinity;
  expected[13] := 2.0;
  expected[14] := SQRT2;
  expected[15] := 2.0 / SQRT3;
  expected[16] := 1.0;

  AddMessage('testing ''Sec''...');
  for i := Low(expected) to High(expected) do begin
    returned := Sec(test_values[i]);
    if CompareValue(returned, expected[i], 0.000001) <> EqualsValue then begin
      AddMessage('Sec(test_values[' + IntToStr(i) + '] = ' + prt_float(test_values[i]) + ') failed; expected value: ' + prt_float(expected[i]) + '; actual value: ' + prt_float(returned));
      Result := False;
    end;
  end;
end;

function Finalize: integer;
begin
  do_test();
end;

end.
