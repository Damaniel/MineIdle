unit Render;

interface

uses
    Dos,
    MineOps,
    TextDraw,
    Globals;

type
    Render_Components = record
        { Mine state }
        render_full_mine : Boolean;
        render_dug_space : Boolean;
    end;

var
    { A list of things that can be drawn on command. }
    g_render_components: Render_Components;

    { Generic rendering setup functions }
    procedure init_render_settings;

    { State-specific component rendering functions }
    procedure render_mine(m: Mine; x: Integer; y: Integer);

    { State-specific rendering functions }
    procedure render_mine_state;

implementation

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
        ta: Text_attr;
        exit_y: Integer;
    begin
        { Draw a border around the mine, minus the enter and exit squares. }
        ta.fg := 3;
        ta.bg := 0;
        exit_y := y + m.h div 2;
        draw_hline(x - 1, x + m.w, y - 1, Chr(219), ta);
        draw_hline(x - 1, x + m.w, y + m.h, Chr(219), ta);
        draw_vline(x - 1, y - 1, y + m.h, Chr(219), ta);
        draw_vline(x + m.w, y - 1, y + m.h, Chr(219), ta);
        draw_vline(x - 1, exit_y - 1, exit_y + 1, ' ', ta);
        draw_vline(x + m.w, exit_y - 1, exit_y + 1, ' ', ta);

        { Draw the mine contents themselves. }
        ta.fg := 15;
        ta.bg := 0;
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
        { If requested, draw the entire mine area }
        if (g_render_components.render_full_mine = True) then
        begin
            render_mine(g_mine, 10, 5);
            g_render_components.render_full_mine := False;
        end;

        { If requested, erase the most recently dug square }
        { If requested, draw anything else that's needed... }
    end;

end.
