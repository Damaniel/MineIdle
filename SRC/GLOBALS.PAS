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
    Text_attr = record
        fg: Byte;
        bg: Byte;
    end;

implementation

end.

