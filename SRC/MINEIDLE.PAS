program MineIdle;

uses
    Globals,
    MineOps,
    Render;

var
   m: Mine;
   ta: Text_attr;
   bta: Text_attr;
begin

    Randomize;

    ta.fg := 7;
    ta.bg := 0;
    clear_screen(ta);

    box_at(10, 5, 20, 8, BORDER_DOUBLE, ta);
    fill_box_at(10, 10, 50, 14, Chr(177), ta);
end.
