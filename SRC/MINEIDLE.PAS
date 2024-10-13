program MineIdle;

uses
    Globals,
    MineOps,
    NumOps,
    Render,
    TextDraw;

var
   ta: Text_attr;
   bta: Text_attr;
begin

    Randomize;

    ta.fg := 7;
    ta.bg := 0;
    clear_screen(ta);

    g_mine.Init(MAX_MINE_WIDTH, MAX_MINE_HEIGHT, DIRT_MINE);
    g_mine.fill;
    
    g_render_components.render_full_mine := True;
    render_mine_state;

end.
