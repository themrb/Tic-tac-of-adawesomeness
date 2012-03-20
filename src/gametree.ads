with Boards; use Boards;
with Ada.Containers.Doubly_Linked_Lists;

package GameTree is

   type GameTree_Type;
   type GameTree_Access is access all GameTree_Type;

   type Level_Type is new Natural range 0..64;
   type Children_Type is array(Level_Type range <>) of GameTree_Access;

   type GameTree_Type is record
      state : State_Type;
--        parent : GameTree_Access;
      expanded : Boolean := False;
      best : GameTree_Access := null;
--        bestVal : BoardValue;
   end record;

   package NodeList is new Ada.Containers.Doubly_Linked_Lists(GameTree_Type);
   use NodeList;

   function Expand(state : in GameTree_Type) return NodeList.List;

end GameTree;
