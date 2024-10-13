program MineIdle;

uses
  NumOps,
  Render,
  State,
  Globals;

var
   e: Extended;
   s: String;
   t: Text_attr;
begin

    init_render_settings;

    t.fg := 14;
    t.bg := 0;
    draw_hline(1,80,1, Chr(196), t);
    draw_vline(10, 10, 20, Chr(179), t);
end.