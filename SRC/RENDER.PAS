unit Render;

interface

uses
    Dos,
    MineOps,
    Globals;

const
    ScrMem_Base = $B800;
    ScrMem_Offset = $0000;
    Screen_Width = 80;
    Screen_Height = 25;

type
    BorderType = (
        BORDER_SINGLE,
        BORDER_DOUBLE
    );

{ Direct text drawing functions }
procedure char_at(x: Integer; y: Integer; ch: Char; ta: Text_attr);
procedure clear_screen(ta: Text_attr);
procedure draw_hline(x1: Integer; x2: Integer; y: Integer; ch: Char; ta: Text_attr);
procedure box_at(x1: Integer; y1: Integer; x2: Integer; y2: Integer; border_type: BorderType; ta: Text_attr);
procedure fill_box_at(x1: Integer; y1: Integer; x2: Integer; y2: Integer; ch: Char; ta: Text_attr);

{ Generic rendering setup functions }
procedure init_render_settings;

{ State-specific component rendering functions }
procedure render_mine(m: Mine; x: Integer; y: Integer);

{ State-specific rendering functions }
procedure render_mine_state;

implementation

{ char_at : draws a character with the specified text attribute in the 
            specified location. }
procedure char_at(x: Integer; y: Integer; ch: Char; ta: Text_attr);
var
    off: Integer;
    attr: Byte;
begin
    off := (y * Screen_Width + x) shl 1;
    attr := ta.fg or (ta.bg shl 4);
    Mem[ScrMem_Base:ScrMem_Offset + off] := Ord(ch);
    Mem[ScrMem_Base:ScrMem_Offset + off + 1] := attr;
end;

{ clear_screen: clears the entire screen with the specified text attribute. }
procedure clear_screen(ta: Text_attr);
var 
    i: Integer;
    j: Integer;
begin
    for i := 0 to Screen_Width - 1 do
    begin
        for j := 0 to Screen_Height - 1 do
        begin
            char_at(i, j, ' ', ta);
        end;
    end;
end;

{ draw_hline: draws a horizontal line from (x1,y) to (x2, y) with the specified
              character and text attribute. }
procedure draw_hline(x1: Integer; x2: Integer; y: Integer; ch: Char; ta: Text_attr);
var
    cx: Integer;
begin
    for cx := x1 to x2 + 1 do
    begin
        char_at(cx, y, ch, ta);
    end;
end;

{ draw_vline: draws a vertical line from (x, y1) to (x, y2) with the specified
              character and text attribute. }
procedure draw_vline(x: Integer; y1: Integer; y2: Integer; ch: Char; ta: Text_attr);
var
    cy: Integer;
begin
    for cy := y1 to y2 + 1 do
    begin
        char_at(x, cy, ch, ta);
    end;
end;

{ box_at: draws an empty box with the corners specified by (x1, y1) and (x2, y2).  If border_type
          is set to BORDER_SINGLE, the box will be drawn with single box drawing characters, 
          and BORDER_DOUBLE will use the double box drawing characters.  All will be drawn with
          the specified text attribute. }
procedure box_at(x1: Integer; y1: Integer; x2: Integer; y2: Integer; border_type: BorderType; ta: Text_attr);
var
    cx: Integer;
    cy: Integer;
    h_char, v_char: Char;
    tl_char, tr_char, bl_char, br_char: Char;
begin
    if (border_type = BORDER_SINGLE) then
    begin
        h_char := Chr(196);
        v_char := Chr(179);
        tl_char := Chr(218);
        tr_char := Chr(191);
        bl_char := Chr(192);
        br_char := Chr(217);
    end
    else begin
        h_char := Chr(205);
        v_char := Chr(186);
        tl_char := Chr(201);
        tr_char := Chr(187);
        bl_char := Chr(200);
        br_char := Chr(188);
    end;
    { Draw the top and bottom minus the corners}
    draw_hline(x1+1, x2-1, y1, h_char, ta);
    draw_hline(x1+1, x2-1, y2, h_char, ta);
    { Draw the left and right minux the corners}
    draw_vline(x1, y1+1, y2-1, v_char, ta);
    draw_vline(x2, y1+1, y2-1, v_char, ta);
    { Draw the corners}
    char_at(x1, y1, tl_char, ta);
    char_at(x2, y1, tr_char, ta);
    char_at(x1, y2, bl_char, ta);
    char_at(x2, y2, br_char, ta);
end;

{ fill_box_at: fills the rectangle with the corners (x1, y1) and (x2, y2) with the specified
               character using the specified text attribute. }
procedure fill_box_at(x1: Integer; y1: Integer; x2: Integer; y2: Integer; ch: Char; ta: Text_attr);
var
    cy: Integer;
begin
    for cy := y1 to y2 + 1 do
    begin
        draw_hline(x1, x2, cy, ch, ta);
    end;
end;

{ init_render_settings: does any display init expected by the game. }
procedure init_render_settings;
begin
    Writeln('todo');
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
            s := m.data[j * m.w + i];
            if (s = SQUARE_EMPTY) then
            begin
                char_at(x+i, y+j, ' ', m.color);
            end
            else if (s = SQUARE_DIRT) then
            begin
                char_at(x+i, y+j, Chr(177), m.color);
            end
            else begin
                char_at(x+i, y+j, Chr(219), m.color);
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
