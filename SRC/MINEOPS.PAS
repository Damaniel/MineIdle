unit MineOps;

interface

    uses
        Globals;

    type
        MineType = (
            DIRT_MINE,
            DIAMOND_MINE
        );

        MineSquareType = (
            SQUARE_EMPTY,
            SQUARE_DIRT,
            SQUARE_ROCK
        );

        { A mine. It's a grid of squares with dirt and rock.  Rocks are fewer but 
          take twice as long to break.}
        Mine = object
            { The actual width and height. }
            w: Integer;
            h: Integer;
            mine_type: MineType;
            color: Text_attr;
            data: array[0..(MAX_MINE_WIDTH * MAX_MINE_HEIGHT)] of MineSquareType;
            { How long does it take to clear a base square with no upgrades }
            base_break_rate: Single;
            procedure Init(dw: Integer; dh: Integer; mt: MineType);
            procedure clear;
            procedure fill;
            procedure dig(bw: Integer; bh: Integer);
            procedure get_base_break_time(bw: Integer; bh: Integer; var break_time: Single);
        end;
var

    g_mine: Mine;

implementation

    procedure Mine.clear;
    var
        i: Integer;
    begin
        for i:=0 to (w * h) - 1 do
        begin
            data[i] := SQUARE_EMPTY;
        end;
    end;

    procedure Mine.Init(dw: Integer; dh: Integer; mt: MineType);
    begin
        w := dw;
        h := dh;
        mine_type := mt;
        color.fg := 15;
        color.bg := 0;
        clear;
    end;

    procedure Mine.fill;
    var
        i: Integer;
        rv: Word;
    begin
        for i:= 0 to (w * h) - 1 do
        begin
            rv := Random(256);
            if (rv < ROCK_CUTOFF) then
            begin
                data[i] := SQUARE_ROCK;
            end
            else begin
                data[i] := SQUARE_DIRT;
            end;
        end;
    end;

    procedure Mine.dig(bw: Integer; bh: Integer);
    begin
        data[bh * w + bw] := SQUARE_EMPTY;
    end;

    { Returns the base time to break the square at the specified location.}
    procedure Mine.get_base_break_time(bw: Integer; bh: Integer; var break_time: Single);
    var
        sq: MineSquareType;
    begin
        sq := data[bh * w + bw];
        if (sq = SQUARE_DIRT) then
        begin
            break_time := base_break_rate;
        end
        else begin
            break_time := base_break_rate * 2;
        end;
    end;

end.
