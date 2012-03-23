with GameTree;
with Boards; use Boards;

package MinMax is

   type BoardValue is new Integer range -1..1;
   function Min (state : in State_Type) return BoardValue;
   function Max (state : in State_Type) return BoardValue;
   function Terminal(state : in State_Type) return BoardValue;

end MinMax;
