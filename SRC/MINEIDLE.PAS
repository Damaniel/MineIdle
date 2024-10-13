program MineIdle;

uses
    Globals,
    MineOps,
    Render;

var
   m: Mine;
begin

    Randomize;
    init_render_settings;

    m.Init(MAX_MINE_WIDTH, MAX_MINE_HEIGHT, DIRT_MINE);
    m.fill;

    render_mine(m, 10, 5);

end.
