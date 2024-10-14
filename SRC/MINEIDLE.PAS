program MineIdle;

uses
    Globals,
    MineOps,
    NumOps,
    Render,
    TextDraw,
    timer;

type

    Player = object
        mine_x, mine_y, mine_depth: Integer;
        field_x, field_y, field_depth: Integer;
        current_mine: MineType;
        remaining_action_time, total_action_time: Single;
    end;

var
   ta: Text_attr;
   bta: Text_attr;
   g_player: Player;
begin

    Randomize;

    ta.fg := 7;
    ta.bg := 0;
    clear_screen(ta);
    
end.
