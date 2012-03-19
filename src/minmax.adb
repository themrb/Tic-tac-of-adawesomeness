with GameTree; use GameTree;
with Boards; use Boards;
with Ada.Text_IO; use Ada.Text_IO;

with Ada.Containers; use Ada.Containers;

package body MinMax is

   procedure Min (state : in out GameTree_Type) is
      successors : NodeList.List := Expand(state);
   begin
      state.bestVal := BoardValue'Last; -- Set to maximum board-value;
      declare
         node : NodeList.Cursor := NodeList.First(successors);
      begin
--           Put_Line("Min" & Image(state.state));

         -- Check if any of the successors are terminal states.
         -- Mainly to avoid exploring large portions of the game tree if the
         -- next move is already fixed.
         for i in 2 .. NodeList.Length(successors) loop
            declare
               move : GameTree_Type := NodeList.Element(node);
            begin
--                 if(move.state.turns = 64) then
--                    Put_Line("Last" & Image(move.state));
--                    Put_Line(Image(move.state.current_state));
--                 end if;
               if(Terminal(move.state)) then
                  state.bestVal :=  -1;
                  state.best := new GameTree_Type'(move);
                  return;
               end if;
            end;
            node := NodeList.Next(node);
         end loop;

         node := NodeList.First(successors);

         -- Didn't find any terminal states above, so we continue MinMax-ing
         for i in 2 .. NodeList.Length(successors) loop
            declare
               move : GameTree_Type := NodeList.Element(node);
            begin
               Max(move);
               if(move.bestVal = -1) then -- Max sees no way of avoiding min's win
                  state.bestVal := -1;
                  state.best := new GameTree_Type'(move);
                  return;
               elsif(move.bestVal < NodeList.Element(node).bestVal) then
                  state.bestVal := move.bestVal;
                  state.best := new GameTree_Type'(move);
               end if;
            end;
            node := NodeList.Next(node);
         end loop;
      end;
   end Min;

   procedure Max (state : in out GameTree_Type) is
      successors : NodeList.List := Expand(state);
   begin
      state.bestVal := BoardValue'First; -- Set to minimum board-value;
      declare
         node : NodeList.Cursor := NodeList.First(successors);
      begin
--           Put_Line("Max" & Image(state.state));

         -- Check if any of the successors are terminal states.
         -- Mainly to avoid exploring large portions of the game tree if the
         -- next move is already fixed.
         for i in 2 .. NodeList.Length(successors) loop
            declare
               move : GameTree_Type := NodeList.Element(node);
            begin
               if(Terminal(move.state)) then
                  state.bestVal :=  1;
                  state.best := new GameTree_Type'(move);
                  return;
               end if;
            end;
            node := NodeList.Next(node);
         end loop;

         node := NodeList.First(successors);
--           Put_Line(Count_Type'Image(NodeList.Length(successors)));
         -- Didn't find any terminal states above, so we continue MinMax-ing
         for i in 2 .. NodeList.Length(successors) loop
            declare
               move : GameTree_Type := NodeList.Element(node);
            begin
               Min(move);
               if(move.bestVal = 1) then -- min sees no way of avoiding max's win
                  state.bestVal := 1;
                  state.best := new GameTree_Type'(move);
                  return;
               elsif(move.bestVal > NodeList.Element(node).bestVal) then
                  state.bestVal := move.bestVal;
                  state.best := new GameTree_Type'(move);
               end if;
            end;
            node := NodeList.Next(node);
         end loop;
      end;
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
