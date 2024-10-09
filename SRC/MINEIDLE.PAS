program MineIdle;

uses
  NumOps;

var
   e: Extended;
   s: String;
begin
     e := 2;
     extToString(e, True, s);
     Writeln(s);

     e := 21;
     extToString(e, True, s);
     Writeln(s);

     e := 213;
     extToString(e, True, s);
     Writeln(s);

     e := 2135;
     extToString(e, True, s);
     Writeln(s);

     e := 21358;
     extToString(e, True, s);
     Writeln(s);

     e := 1.2349e23;
     extToString(e, True, s);
     Writeln(s);
end.