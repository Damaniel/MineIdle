unit Render;

interface

uses
    Crt,
    MineOps,
    Globals;

{ Line drawing functions }
procedure draw_hline(x1: Integer; x2: Integer; y: Integer; ch: Char; ta: Text_attr);
procedure draw_vline(x: Integer; y1: Integer; y2: Integer; ch: Char; ta: Text_attr);

{ Generic rendering setup functions }
procedure init_render_settings;

{ State-specific component rendering functions }
procedure render_mine(m: Mine; x: Integer; y: Integer);

{ State-specific rendering functions }
procedure render_mine_state;

implementation

procedure draw_hline(x1: Integer; x2: Integer; y: Integer; ch: Char; ta: Text_attr);
var
    cx: Integer;
begin
    GotoXY(x1, y);
    TextColor(ta.fg);
    TextBackground(ta.bg);
    for cx := x1 to x2 do
    begin
        Write(ch);
    end;
end;

procedure draw_vline(x: Integer; y1: Integer; y2: Integer; ch: Char; ta: Text_attr);
var
    cx: Integer;
begin
    TextColor(ta.fg);
    TextBackground(ta.bg);
    for cx := y1 to y2 do
    begin
        GotoXY(x, cx);
        Write(ch);
    end;
end;

procedure init_render_settings;
begin
    TextMode(C80);
    TextColor(15);
    TextBackground(0);
    ClrScr;
end;

{ State-specific component rendering functions }
procedure render_mine(m: Mine; x: Integer; y: Integer);
var
    i: Integer;
    j: Integer;
    s: MineSquareType;
begin
    for j:= 0 to m.h - 1 do
    begin
        for i := 0 to m.w - 1 do
        begin
            GotoXY(x + i, y + j);
            s := m.data[j * m.w + i];
            if (s = SQUARE_EMPTY) then
            begin
                Write(' ');
            end
            else if (s = SQUARE_DIRT) then
            begin
                Write(Chr(177));
            end
            else begin
                Write(Chr(219));
            end;
        end;
    end;
end;

{ General state rendering functions }
procedure render_mine_state;
begin
    WriteLn('todo');
end;


end.
