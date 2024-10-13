unit Globals;

interface

const
    MAX_MINE_WIDTH = 60;
    MAX_MINE_HEIGHT = 15;
    { When picking a square type, a random number between 0 and 255 will be
      selected.  If the number is lower than ROCK_CUTOFF then the square 
      will be created as rock, otherwise as dirt. }
    ROCK_CUTOFF = 20;
type
    { A mine. It's a grid of squares with dirt and rock.  Rocks are fewer but 
      take twice as long to break.}
    Mine = record 
        { The actual width and height. }
        w: Integer;
        h: Integer;
        data: array[0..(MAX_MINE_WIDTH * MAX_MINE_HEIGHT)] of Byte;
        { How long does it take to clear a base square with no upgrades }
        base_break_rate: Single;
    end;

    Text_attr = record
        fg: Byte;
        bg: Byte;
    end;
    
    G_States = (
        STATE_TITLE,
        STATE_MINE,
        STATE_FIELD,
        STATE_FIGHT
    );

var
    g_cur_state: Integer;
    g_prev_state: Integer;

implementation

end.

