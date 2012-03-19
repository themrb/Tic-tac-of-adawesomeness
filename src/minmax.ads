with GameTree; use GameTree;
with Boards; use Boards;

package MinMax is

   procedure Min (state : in out GameTree_Type);
   procedure Max (state : in out GameTree_Type);
   function Terminal(state : in State_Type) return Boolean;
   --function Forced_Move_Check (state : in GameTree_Type) return GameTree_Type;

end MinMax;
