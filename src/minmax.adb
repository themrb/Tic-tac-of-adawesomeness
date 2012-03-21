with GameTree; use GameTree;
with Boards; use Boards;
with Ada.Text_IO; use Ada.Text_IO;

with Ada.Containers; use Ada.Containers;

package body MinMax is

   procedure Min (state : in out GameTree_Type; depth : in TurnsNo; value : out BoardValue;
                    alpha, beta : in BoardValue) is
      successors : GameTree_Children := Expand(state);
--        node : GameTree_Access := successors(0);
      move : GameTree_Type;
      a, b : BoardValue;
   begin
      a := alpha;
      b := beta;
      value := BoardValue'Last;  -- Set to maximum board-value;

      -- Check if any of the successors are terminal states.
      -- Mainly to avoid exploring large portions of the game tree if the
      -- next move is already fixed.
      for i in 1.. (63-state.state.turns) loop
         move := successors(i);
         if(Terminal(move.state)) then
            value :=  -1;
            state.best := new GameTree_Type'(move);
            return;
         end if;
      end loop;


      if (depth = 0) then
         value := 0;
         state.best := new GameTree_Type'(move);
         return;
      end if;


      -- Didn't find any terminal states above, so we continue MinMax-ing
      for i in 1.. (63-state.state.turns) loop
         move := successors(i);
         Max(move, depth-1, value, a, b);
         if(value <= a) then -- Max sees no way of avoiding min's win
            value := -1;
            state.best := new GameTree_Type'(move);
            return;
         elsif(value < b) then
            b := value;
            state.best := new GameTree_Type'(move);
         end if;
      end loop;

      if(state.best = null) then
         state.best := new GameTree_Type'(move);
      end if;
   end Min;

   procedure Max (state : in out GameTree_Type; depth : in TurnsNo; value : out BoardValue;
                    alpha, beta : in BoardValue) is
      successors : GameTree_Children := Expand(state);
      move : GameTree_Type;
      a, b : BoardValue;
   begin
      a := alpha;
      b := beta;
      value := BoardValue'First; -- Set to minimum board-value;

      -- Check if any of the successors are terminal states.
      -- Mainly to avoid exploring large portions of the game tree if the
      -- next move is already fixed.
      for i in 1.. (63-state.state.turns) loop
         move := successors(i);

         if(Terminal(move.state)) then
            value := 1;
            state.best := new GameTree_Type'(move);
            return;
         end if;

      end loop;

      if (depth = 0) then
         value := 0;
         state.best := new GameTree_Type'(move);
         return;
      end if;

      -- Didn't find any terminal states above, so we continue MinMax-ing
      for i in 1.. (63-state.state.turns) loop
         move := successors(i);
         Min(move, depth-1, value, a, b);
         if(value >= b) then -- min sees no way of avoiding max's win
            value := 1;
            state.best := new GameTree_Type'(move);
            return;
         elsif(value > a) then
            a := value;
            state.best := new GameTree_Type'(move);
         end if;

      end loop;

      if(state.best = null) then
         state.best := new GameTree_Type'(move);
      end if;
   end Max;

--     function Forced_Move_Check (state : in GameTree_Type) return Place is
--        successors : NodeList.List;
--        switch_move_state : GameTree_Type := state;
--     begin
--        -- need at least 4 moves for there to be a fully forced move
--        if(switch_move_state.state.turns > 4) then
--
--           -- expand game tree for other player
--           if(switch_move_state.state.justWent = X) then
--              switch_move_state.state.justWent := O;
--           elsif(switch_move_state.state.justWent = O) then
--              switch_move_state.state.justWent := X;
--           end if;
--
--           successors := Expand(switch_move_state);
--
--           -- Check if any of the successors are terminal states.
--           -- This means the opponent will have a winning move
--           for i in 2 .. NodeList.Length(successors) loop
--              declare
--                 move : GameTree_Type := NodeList.Element(node);
--              begin
--                 if(Terminal(move.state)) then
--                    return move.state.spot;
--                 end if;
--              end;
--              node := NodeList.Next(node);
--           end loop;
--        end if;
--
--        -- We haven't found any forced move
--        return null;
--
--  end Forced_Move_Check;

end MinMax;
