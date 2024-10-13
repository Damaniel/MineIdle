unit State;

interface
    type
        G_State = (
            STATE_TITLE,
            STATE_MINE,
            STATE_FIELD,
            STATE_FIGHT
        );

    var
        g_cur_state: G_State;
        g_prev_state: G_State;

implementation

end.