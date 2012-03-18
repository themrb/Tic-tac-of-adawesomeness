with GameTree; use GameTree;
with Boards; use Boards;

package MinMax is

   function Min (state : in GameTree_Type) return BoardValue;
   procedure Max (state : in out GameTree_Type);
   function Terminal(state : in State_Type) return Boolean;

end MinMax;
