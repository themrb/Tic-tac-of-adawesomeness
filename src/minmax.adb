with GameTree; use GameTree;
with Boards; use Boards;
with Ada.Text_IO; use Ada.Text_IO;

use GameTree.NodeList;



package body MinMax is

   procedure Min (state : in out GameTree_Type; depth : in TurnsNo; outValue : out BoardValue; best : out GameTree_Type;
                    alpha, beta : in BoardValue) is
      successors : Children_Access := Expand(state);
--        node : GameTree_Access := successors(0);
      move : GameTree_Type;
      a, b : BoardValue;
      value : BoardValue;
   begin
      a := alpha;
      b := beta;
      value := BoardValue'Last;  -- Set to maximum board-value;
      outValue := value;
      best := successors.successors(1);

      -- Check if any of the successors are terminal states.
      -- Mainly to avoid exploring large portions of the game tree if the
      -- next move is already fixed.

      for i in 1.. (64-state.state.turns) loop
         move := successors.successors(i);
         if(Terminal(move.state)) then
            outValue :=  -1;
            best := move;
            Free(successors);
            return;
         end if;
      end loop;


      if (depth = 0) then
         outValue := 0;
         best := move;
         Free(successors);
         return;
      end if;


      -- Didn't find any terminal states above, so we continue MinMax-ing
      for i in 1.. (64-state.state.turns) loop
         move := successors.successors(i);
         declare
            chosentree : GameTree_Type;
         begin
            Max(move, depth-1, outValue, chosentree, a, b);
         end;

         if(outValue < value) then
            value := outValue;
         end if;

         if(value <= a) then -- Max sees no way of avoiding min's win
            outValue := value;
            best := move;
            Free(successors);
            return;
         elsif(value < b) then
            b := value;
            best := move;
         end if;
      end loop;

--        if(best = null) then
--           outValue := value;
--           best := move;
--        end if;
      Free(successors);
   end Min;

   procedure Max (state : in out GameTree_Type; depth : in TurnsNo; outValue : out BoardValue; best : out GameTree_Type;
                    alpha, beta : in BoardValue) is
      successors : Children_Access := Expand(state);
      move : GameTree_Type;
      a, b : BoardValue;
      value: BoardValue;
   begin
      a := alpha;
      b := beta;
      value := BoardValue'First; -- Set to minimum board-value;
      outValue := value;
      best := successors.successors(1);

      -- Check if any of the successors are terminal states.
      -- Mainly to avoid exploring large portions of the game tree if the
      -- next move is already fixed.
      for i in 1.. (64-state.state.turns) loop
         move := successors.successors(i);
         if(Terminal(move.state)) then
            outValue := 1;
            best := move;
            Free(successors);
            return;
         end if;

      end loop;

      if (depth = 0) then
         outValue := 0;
         best := move;
         Free(successors);
         return;
      end if;

      -- Didn't find any terminal states above, so we continue MinMax-ing
      for i in 1.. (64-state.state.turns) loop
         move := successors.successors(i);
         declare
            chosentree : GameTree_Type;
         begin
            Min(move, depth-1, outValue, chosentree, a, b);
         end;

         if(outValue > value) then
            value := outValue;
         end if;

         if(value >= b) then -- min sees no way of avoiding max's win
            outValue := value;
            best := move;
            Free(successors);
            return;
         elsif(value > a) then
            a := value;
            best := move;
         end if;

      end loop;

--        if(state.best = null) then
--           outValue := value;
--           best := move;
--        end if;

      Free(successors);
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
