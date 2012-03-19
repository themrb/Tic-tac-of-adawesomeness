package body Boards is

   function Symmetric(stateA, stateB : in State_Type) return Boolean is
   begin
      return False;
   end Symmetric;

   function NextPlayer(prev : Cell) return Cell is
   begin
      if(prev = Empty or prev = O) then
         return X;
      else
         return O;
      end if;
   end NextPlayer;

   function AdvanceMove(state : State_Type; move : Place) return State_Type is
      PlacedPiece : Cell := NextPlayer(state.justWent);
      NewState : State_Type := state;
   begin
      NewState.current_state(move(x), move(y), move(z)) := PlacedPiece;
      NewState.turns := NewState.turns + 1;
      NewState.justWent := PlacedPiece;
      NewState.spot := move;
      return NewState;
   end AdvanceMove;

end Boards;
