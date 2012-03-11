package body Boards is

   function Symmetric(stateA, stateB : in State) return Boolean is
   begin
      return False;
   end Symmetric;

   function Expand(current : in Board) return BoardList.List is
      The_List : BoardList.List;
   begin
      return The_List;
   end Expand;

end Boards;
