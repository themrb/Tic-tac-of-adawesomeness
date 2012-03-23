with GameTree; use GameTree;
with Boards; use Boards;

package body MinMax is

   function Terminal(state : in State_Type) return BoardValue is
      xrow, yrow, zrow, xdiag, ydiag, zdiag : Boolean := True;
   begin
      for i in Dimension'Range loop
         xrow := xrow and state.current_state(i,state.spot(y), state.spot(z)) = state.justWent;
         yrow := yrow and state.current_state(state.spot(x),i, state.spot(z)) = state.justWent;
         zrow := zrow and state.current_state(state.spot(x),state.spot(y), i) = state.justWent;
      end loop;
      if (xrow or yrow or zrow) then
         return 1;
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
      return 0;

   end Terminal;

   function Min (state : in State_Type) return BoardValue is
      value : BoardValue;
   begin

      value := Terminal(state);

      return value;

   end Min;

   function Max (state : in State_Type) return BoardValue is
   begin
      return 0;
   end Max;

end MinMax;
