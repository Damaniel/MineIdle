{ TextDraw - some ASCII mode drawing functions.

  "But Shaun," you say,  "why not just use CRT?"
  
  CRT is slower, has way more functionality than I need, and if a line is drawn 
  to the far side of the screen, the cursor scrolls to the next line.  I'd
  rather just do it myself.
}
unit TextDraw;

interface

    uses
        Dos,
        Globals;

    const
        ScrMem_Base = $B800;
        ScrMem_Offset = $0000;
        Screen_Width = 80;
        Screen_Height = 25;
        Bios_Video_interrupt = $10;

    type
        BorderType = (
            BORDER_SINGLE,
            BORDER_DOUBLE
        );

    { Direct text drawing functions }
    procedure set_cursor_at(x: Integer; y: Integer);
    procedure char_at(x: Integer; y: Integer; ch: Char; ta: Text_attr);
    procedure clear_screen(ta: Text_attr);
    procedure draw_hline(x1: Integer; x2: Integer; y: Integer; ch: Char; ta: Text_attr);
    procedure draw_vline(x: Integer; y1: Integer; y2: Integer; ch: Char; ta: Text_attr);
    procedure box_at(x1: Integer; y1: Integer; x2: Integer; y2: Integer; border_type: BorderType; ta: Text_attr);
    procedure fill_box_at(x1: Integer; y1: Integer; x2: Integer; y2: Integer; ch: Char; ta: Text_attr);
    procedure string_at(x: Integer; y: Integer; str: String; ta: Text_attr);
    procedure hide_cursor;
    procedure show_cursor;
    procedure set_bg_intensity(enabled: Boolean);

implementation

    { set_cursor_at : moves the cursor to the specified position. }
    procedure set_cursor_at(x: Integer; y: Integer);
    var
        regs: Registers;
    begin
        regs.ah := $02;
        regs.dh := y;
        regs.dl := x;
        Intr(Bios_Video_interrupt, regs);
    end;

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
        for cx := x1 to x2 do
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
        for cy := y1 to y2 do
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
        for cy := y1 to y2 do
        begin
            draw_hline(x1, x2, cy, ch, ta);
        end;
    end;

    { string_at: draws the specified string at the location (x,y) using the specified text attribute. }
    procedure string_at(x: Integer; y: Integer; str: String; ta: Text_attr);
    var
        i: Integer;
    begin
        for i := 0 to Ord(str[0]) - 1 do 
        begin
            char_at(x+i, y, str[i+1], ta);
        end;
    end;

    procedure hide_cursor;
    var
        regs: Registers;
    begin
        regs.ah := $01;
        regs.cx := $2000;
        Intr(Bios_Video_interrupt, regs);
    end;
    
    procedure show_cursor;
    var
        regs: Registers;
    begin
        regs.ah := $01;
        regs.cx := $0000;
        Intr(Bios_Video_interrupt, regs);
    end;

    procedure set_bg_intensity(enabled: Boolean);
    var
        regs: Registers;
    begin
        regs.ax := $1003;
        if (enabled = True) then
        begin
            regs.bx := $0000;
        end
        else begin
            regs.bx := $0001;
        end;
        Intr(Bios_Video_interrupt, regs);
    end;
end.