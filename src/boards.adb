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


end Boards;
