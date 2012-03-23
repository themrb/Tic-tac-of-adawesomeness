with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Text_IO; use Ada.Text_IO;

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
      if (placedPiece = X) then
         newState.current_stateX(move(x), move(y), move(z)) := True;
      elsif (placedPiece = O) then
         newState.current_stateO(move(x), move(y), move(z)) := True;
      end if;
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

   function Image(board : Board_Type) return String is
      temp : Unbounded_String;
   begin
      for i in Dimension'Range loop
         for j in Dimension'Range loop
            temp := temp & "[";
            for k in Dimension'Range loop
               temp := temp & Boolean'Image(board(i,j,k));
               if(k /= Dimension'Last) then
                  temp := temp & ",";
               end if;
            end loop;
            temp := temp & "]" & LF;
         end loop;
         temp := temp & LF;
      end loop;

      return To_String(temp);
   end;

   function Terminal(state : in State_Type) return Boolean is
      xrow, yrow, zrow, xdiag, ydiag, zdiag, corner : Boolean := True;
      currentstate : Board_Type;
   begin
      if(state.turns < 4) then
         return False;
      end if;

      if (state.justWent = X) then
         currentstate := state.current_stateX;
      elsif (state.justWent = O) then
         currentstate := state.current_stateO;
      end if;

      for i in Dimension'Range loop
         xrow := xrow and currentstate(i,state.spot(y), state.spot(z)) = True;
         yrow := yrow and currentstate(state.spot(x),i, state.spot(z)) = True;
         zrow := zrow and currentstate(state.spot(x),state.spot(y), i) = True;
      end loop;
      if (xrow or yrow or zrow) then
         return True;
      end if;

      -- The following 3 blocks check for diagonals in each of the planes.

      if state.spot(x) = state.spot(y) then
         for i in Dimension'Range loop
            zdiag := zdiag and currentstate(i,i,state.spot(z)) = True;
         end loop;
      elsif state.spot(x) + state.spot(y) = 3 then
         for i in Dimension'Range loop
            zdiag := zdiag and currentstate(i,3-i,state.spot(z)) = True;
         end loop;
      else
         zdiag := False;
      end if;

      if(zdiag) then return True; end if;

      if state.spot(y) = state.spot(z) then
         for i in Dimension'Range loop
            xdiag := xdiag and currentstate(state.spot(x),i,i) = True;
         end loop;
      elsif state.spot(z) + state.spot(y) = 3 then
         for i in Dimension'Range loop
            xdiag := xdiag and currentstate(state.spot(x),i,3-i) = True;
         end loop;
      else
         xdiag := False;
      end if;

      if(xdiag) then return True; end if;

      if state.spot(x) = state.spot(z) then
         for i in Dimension'Range loop
            ydiag := ydiag and currentstate(i,state.spot(y),i) = True;
         end loop;
      elsif state.spot(x) + state.spot(z) = 3 then
         for i in Dimension'Range loop
            ydiag := ydiag and currentstate(i,state.spot(y),3-i) = True;
         end loop;
      else
         ydiag := False;
      end if;

      if(ydiag) then return True; end if;

      --crosscorner diagonals

      if(state.spot(x) = state.spot(y) and state.spot(x) = state.spot(z)) then
         for i in Dimension'Range loop
            corner := corner and currentstate(i,i,i) = True;
         end loop;
      elsif(state.spot(x) = (3-state.spot(y)) and state.spot(x) = state.spot(z)) then
         for i in Dimension'Range loop
            corner := corner and currentstate(i,3-i,i) = True;
         end loop;
      elsif(state.spot(x) = state.spot(y) and state.spot(x) = (3-state.spot(z))) then
         for i in Dimension'Range loop
            corner := corner and currentstate(i,i,3-i) = True;
         end loop;
      else
         for i in Dimension'Range loop
            corner := corner and currentstate(3-i,i,i) = True;
         end loop;
      end if;

--        Put_Line(Boolean'Image(xrow) & "," & Boolean'Image(yrow) & "," &
--                 Boolean'Image(zrow) & "," & Boolean'Image(xdiag) & "," &
--                 Boolean'Image(ydiag) & "," & Boolean'Image(zdiag) & "," &
--                 Boolean'Image(corner));

      return corner;

   end Terminal;


end Boards;
