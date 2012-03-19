package body Boards is

   function Symmetric(stateA, stateB : in State_Type) return Boolean is
   begin
      return False;
   end Symmetric;

   function NextPlayer(prev : Cell) return Cell is
   begin
      if(prev = Empty or prev = X) then
         return O;
      else
         return X;
      end if;
   end NextPlayer;

   function AdvanceMove(state : State_Type; move : Place) return State_Type is
      placedPiece : Cell := NextPlayer(state.justWent);
      newState : State_Type := state;
   begin
      newState.current_state(move(x), move(y), move(z)) := placedPiece;
      newState.turns := newState.turns + 1;
      newState.justWent := placedPiece;
      newState.spot := move;
      return newState;
   end AdvanceMove;

   function Image(state : State_Type) return String is
   begin
      return "[" & Cell'Image(state.justWent) & "," & Image(state.spot)
        & "," & Natural'Image(state.turns) & "]";
   end;

   function Image(spot : Place) return String is
   begin
      return "(" & Dimension'Image(spot(x)) & "," & Dimension'Image(spot(y))
        & "," & Dimension'Image(spot(z)) & ")";
   end;

   function Terminal(state : in State_Type) return Boolean is
      xrow, yrow, zrow, xdiag, ydiag, zdiag, corner : Boolean := True;
   begin
      if(state.turns < 4) then
         return False;
      end if;

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


end Boards;
