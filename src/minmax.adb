with GameTree; use GameTree;
with Boards; use Boards;

package body MinMax is

   function Terminal(state : in State_Type) return Boolean is
      xrow, yrow, zrow, xdiag, ydiag, zdiag : Boolean := True;
   begin
      for i in Dimension'Range loop
         xrow := xrow and state.current_state(i,state.spot(y), state.spot(z)) = state.justWent;
         yrow := yrow and state.current_state(state.spot(x),i, state.spot(z)) = state.justWent;
         zrow := zrow and state.current_state(state.spot(x),state.spot(y), i) = state.justWent;
      end loop;
      if (xrow or yrow or zrow) then
         return True;
      end if;

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

      --diagonal in plane
      --crosscorner diagonals
      --vertical diagonals

      if(xdiag or ydiag or zdiag) then
         return True;
      end if;

      return False;

   end Terminal;

   --function Min (state : in GameTree_Type) return BoardValue is
   function Min (state : in GameTree_Type) return BoardValue is
--        value : BoardValue;
   begin

--        value := Terminal(state);

      return 1;

   end Min;

   procedure Max (state : in out GameTree_Type) is
      Successors : NodeList.List;
   begin
      Successors := Expand(state);
      state.bestVal := -1;
      --need to set first as best here
      declare
         node : NodeList.Cursor := NodeList.First(Successors);
      begin
         for i in 2 .. NodeList.Length(Successors) loop
            if(Terminal(NodeList.Element(node).state)) then
               state.bestVal :=  1;
               -- TODO: Not finished. Need to store best move. Der
               return;
            end if;

            node := NodeList.Next(node);
         end loop;

         node := NodeList.First(Successors);

         for i in 2 .. NodeList.Length(Successors) loop
            declare
               movevalue : BoardValue := Min(NodeList.Element(node));
            begin
               if(movevalue = 1) then -- min sees no way of avoiding max's win
                  state.bestVal := 1;
                  -- TODO: Not finished. Need to store best move.
                  return;
               elsif(movevalue > NodeList.Element(node).bestVal) then
                  state.bestVal := movevalue;
                  -- TODO: store this move
               end if;
            end;
            node := NodeList.Next(node);
         end loop;
      end;
   end Max;

end MinMax;
