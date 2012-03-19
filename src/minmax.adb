with GameTree; use GameTree;
with Boards; use Boards;

package body MinMax is

   function Terminal(state : in State_Type) return Boolean is
      xrow, yrow, zrow, xdiag, ydiag, zdiag, corner : Boolean := True;
   begin
      for i in Dimension'Range loop
         xrow := xrow and state.current_state(i,state.spot(y), state.spot(z)) = state.justWent;
         yrow := yrow and state.current_state(state.spot(x),i, state.spot(z)) = state.justWent;
         zrow := zrow and state.current_state(state.spot(x),state.spot(y), i) = state.justWent;
      end loop;
      if (xrow or yrow or zrow) then
         return True;
      end if;

      -- The following 3 blocks check for diagonals in each of the planes.

      if state.spot(x) = state.spot(y) then
         for i in Dimension'Range loop
            zdiag := zdiag and state.current_state(i,i,state.spot(z)) = state.justWent;
         end loop;
      elsif state.spot(x) + state.spot(y) = 3 then
         for i in Dimension'Range loop
            zdiag := zdiag and state.current_state(i,3-i,state.spot(z)) = state.justWent;
         end loop;
      else
         zdiag := False;
      end if;

      if(zdiag) then return True; end if;

      if state.spot(y) = state.spot(z) then
         for i in Dimension'Range loop
            xdiag := xdiag and state.current_state(state.spot(x),i,i) = state.justWent;
         end loop;
      elsif state.spot(z) + state.spot(y) = 3 then
         for i in Dimension'Range loop
            xdiag := xdiag and state.current_state(state.spot(x),i,3-i) = state.justWent;
         end loop;
      else
         xdiag := False;
      end if;

      if(xdiag) then return True; end if;

      if state.spot(x) = state.spot(z) then
         for i in Dimension'Range loop
            ydiag := ydiag and state.current_state(i,state.spot(y),i) = state.justWent;
         end loop;
      elsif state.spot(x) + state.spot(z) = 3 then
         for i in Dimension'Range loop
            ydiag := ydiag and state.current_state(i,state.spot(y),3-i) = state.justWent;
         end loop;
      else
         ydiag := False;
      end if;

      if(ydiag) then return True; end if;

      --crosscorner diagonals

      if(state.spot(x) = state.spot(y) and state.spot(x) = state.spot(z)) then
         for i in Dimension'Range loop
            corner := corner and state.current_state(i,i,i) = state.justWent;
         end loop;
      elsif(state.spot(x) = (3-state.spot(y)) and state.spot(x) = state.spot(z)) then
         for i in Dimension'Range loop
            corner := corner and state.current_state(i,3-i,i) = state.justWent;
         end loop;
      elsif(state.spot(x) = state.spot(y) and state.spot(x) = (3-state.spot(z))) then
         for i in Dimension'Range loop
            corner := corner and state.current_state(i,i,3-i) = state.justWent;
         end loop;
      else
         for i in Dimension'Range loop
            corner := corner and state.current_state(3-i,i,i) = state.justWent;
         end loop;
      end if;

      return corner;

   end Terminal;

   procedure Min (state : in out GameTree_Type) is
      successors : NodeList.List := Expand(state);
   begin
      state.bestVal := BoardValue'Last; -- Set to maximum board-value;
      declare
         node : NodeList.Cursor := NodeList.First(successors);
      begin
         -- Check if any of the successors are terminal states.
         -- Mainly to avoid exploring large portions of the game tree if the
         -- next move is already fixed.
         for i in 2 .. NodeList.Length(successors) loop
            declare
               move : GameTree_Type := NodeList.Element(node);
            begin
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
