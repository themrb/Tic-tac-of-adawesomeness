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

end Boards;
