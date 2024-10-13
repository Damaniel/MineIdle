{ 
  NUMOPS.PAS
    Operations to manipulate large numbers and convert them to idler-friendly strings. 

  'Large numbers' in this case means 80-bit Intel extended precision floats.  As such,
  this code (and any program that uses it) will need to either run on a computer that has
  a FPU installed or a floating point emulation library will need to be linked in.

  Currently, I'm building this without softfloat to keep the code small, but depending
  on circumstances I may re-enable it in the future.  

  This code is licensed under the MIT license - see LICENSE in the root of the repo
  for the license terms.
}
unit NumOps;

interface

  procedure extToString(e: Extended; use_letters: Boolean; var outStr: String);

implementation

  { extToString: Converts an 80-bit extended value, represented in scientific
                 notation, into a value in engineering notation with at most
                 2 digits after the decimal point.  Optionally, some of the 
                lower exponents (millions, billions, trillions, etc.) can
                 be replaced with representative strings (M, B, T, etc.). }
  procedure extToString(e: Extended; use_letters: Boolean; var outStr: String);
  var
    extStr: String;
    prefix: String;
    suffix: String;
    en_suffix: String;
    len, i, exponent, c, ed, em: Integer;
  begin
    { Note that since we're manipulating Pascal-style strings directly,
      we need to make sure the length value is updated correctly. }
  
    { Convert the number into a string and get the length }
    Str(e, extStr);
    len := Length(extStr);

    { Extract the first 4 non-whitespace characters and the last 4
      characters in the string to prefix and suffix, respectively. }
    for i:=1 to 4 do
    begin
      prefix[i] := extStr[i+1];
      suffix[i] := extStr[len - 4 + i];
    end;
    prefix[0] := #4;
    suffix[0] := #4;

    { Convert the suffix we extracted to a numeric value. }
    Val(suffix, exponent, c);

    { Process the prefix value based on the suffix.}

    { Numbers less than 10 }
    if (exponent = 0) then
    begin
      outStr[1] := prefix[1];
      outStr[0] := #1;
    end;
     
    { Numbers between 10 and 99 }
    if (exponent = 1) then
    begin
      outStr[1] := prefix[1];
      outStr[2] := prefix[3];
      outStr[0] := #2;
    end;
     
    { Numbers between 100 and 999 }
    if (exponent = 2) then
    begin
      outStr[1] := prefix[1];
      outStr[2] := prefix[3];
      outStr[3] := prefix[4];
      outStr[0] := #3;
    end;

    { Note: At this point, if the number is less than 1000, we're done and outStr is set. }

    { Numbers >= 1000 }
    if (exponent > 2) then
    begin
      { Get the next lowest exponent divisible by 3
        and the difference between that and the current exponent. }
      em := exponent mod 3;
      ed := exponent - em;
      { If exponent is exactly divisible by 3, use the 4 digits chars as-is. }
      if (em = 0) then
      begin
        outStr[1] := prefix[1];
        outStr[2] := prefix[2];
        outStr[3] := prefix[3];
        outStr[4] := prefix[4];
        outStr[0] := #4;
      end;
      { If exponent has remainder 1, then pull the digit to the right of the decimal
        to the spot front of it. For example, this would make 1.23 into 12.3 }
      if (em = 1) then
      begin
        outStr[1] := prefix[1];
        outStr[2] := prefix[3];
        outStr[3] := prefix[2];
        outStr[4] := prefix[4];
        outStr[0] := #4;
      end;
      { If exponent has remainder 2, then drop the decimal point and take the first
        3 remaining digits. For example, this would make 1.23 into 123 }
      if (em = 2) then
      begin
        outStr[1] := prefix[1];
        outStr[2] := prefix[3];
        outStr[3] := prefix[4];
        outStr[0] := #3;
      end;

      { Assemble the final string }
      { Use letter suffixes for lower exponents if requested, otherwise use the
        newly calculated scientific exponent. }
      if (use_letters = True) then begin
        case ed of
          3: outStr := Concat(outStr, 'K');
          6: outStr := Concat(outStr, 'M');
          9: outStr := Concat(outStr, 'B');
          12: outStr := Concat(outStr, 'T');
          15: outStr := Concat(outStr, 'Qd');
          18: outStr := Concat(outStr, 'Qi');
          21: outStr := Concat(outStr, 'Se');
          24: outStr := Concat(outStr, 'Sp');
          27: outStr := Concat(outStr, 'Oc');
          30: outStr := Concat(outStr, 'No');
          33: outStr := Concat(outStr, 'Dc');
        else
          { Numbers larger than the above use plain engineering notation instead. }
          Str(ed, en_suffix);
          outStr := Concat(outStr, 'e', en_suffix);
        end;
      end 
      else begin
        Str(ed, en_suffix);
        outStr := Concat(outStr, 'e', en_suffix);
      end;
    end;
  end;

end.
