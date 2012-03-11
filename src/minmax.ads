with Boards; use Boards;

package MinMax is

   type BoardValue is new Integer range -1..1;
   function Min (current : in State) return BoardValue;
   function Max (current : in State) return BoardValue;
   function Eval(current : in State) return BoardValue;

end MinMax;
