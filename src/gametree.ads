with Boards; use Boards;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Unchecked_Deallocation;

package GameTree is

   type GameTree_Type;
   type GameTree_Access is access all GameTree_Type;

   type Level_Type is new Natural range 0..64;
   type Children_Type is array(Level_Type range <>) of GameTree_Access;
   type Children_Range is new Natural range 1..64;

   type GameTree_Type is record
      state : State_Type;
--        parent : GameTree_Access;
      expanded : Boolean := False;
--        best : GameTree_Access := null;
--        bestVal : BoardValue;
   end record;

   type ExpandedChildren is array(Children_Range) of GameTree_Type;

--     type GameTree_Children;
--     type Children_Access is access all GameTree_Children;
--     type GameTree_Children is record
--        successors : ExpandedChildren;
--     end record;

--     procedure Free is
--      new Ada.Unchecked_Deallocation(
--          GameTree_Children, Children_Access);
--
--     package NodeList is new Ada.Containers.Doubly_Linked_Lists(GameTree_Type);
--     use NodeList;

   function Expand(state : in GameTree_Type) return ExpandedChildren;

end GameTree;
