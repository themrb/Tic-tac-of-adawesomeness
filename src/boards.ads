with Ada.Containers.Doubly_Linked_Lists;

package Boards is

   type Dim is new Positive range 1..4;
   type Position is (X, O, Empty);
   type Turn is (X, O);
   type Board is array(Dim, Dim, Dim) of Position;
   pragma Pack (Board);

   type State is record
      go: Turn := X;
      turns : Natural range 0 .. 64 := 0;
      current_state : Board;
   end record;

   package BoardList is new Ada.Containers.Doubly_Linked_Lists(Board);
   use BoardList;

   function Symmetric(stateA, stateB : in State) return Boolean;

   function Expand(current : in Board) return BoardList.List;

end Boards;
