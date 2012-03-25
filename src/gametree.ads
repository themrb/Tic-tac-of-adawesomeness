with Boards; use Boards;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Unchecked_Deallocation;

package GameTree is

   type GameTree_Type;
   type GameTree_Access is access all GameTree_Type;

   type Level_Type is new Natural range 0..64;
   type Children_Range is new Natural range 1..64;

   -- Representation of a game tree node
   type GameTree_Type is record
      state : State_Type;
      expanded : Boolean := False;
   end record;

   type ExpandedChildren is array(Children_Range) of GameTree_Type;

   function Expand(state : in GameTree_Type) return ExpandedChildren;

end GameTree;
