unit Globals;

interface

const
    MAX_MINE_WIDTH = 60;
    MAX_MINE_HEIGHT = 15;

    { When picking a square type, a random number between 0 and 255 will be
      selected.  If the number is lower than ROCK_CUTOFF then the square 
      will be created as rock, otherwise as dirt. }
    ROCK_CUTOFF = 20;

    {
      TARGET_FRAME_RATE is our desired frame rate.  20 is the current value.

      USER_TIMER is equal to 240 / TARGET_FRAME_RATE.  240 ticks per second is
      the set speed of the high speed timer, so USER_TIMER steps that down to 
      the appropriate count for the target frame rate.

      FRAME_INCREMENT is the fraction of a second one frame takes.  Used to 
      subtract time from counters as time elapses.
    }
    TARGET_FRAME_RATE = 20;
    USER_TIMER = Trunc(240/TARGET_FRAME_RATE);
    FRAME_INCREMENT = 1 / TARGET_FRAME_RATE;

type
    Text_attr = record
        fg: Byte;
        bg: Byte;
    end;

implementation

end.

