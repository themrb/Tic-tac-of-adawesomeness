with Boards; use Boards;
with MinMax; use MinMax;
with GameTree; use GameTree;

package Players is

   task type Player (name : Cell) is
      entry Initialise;
      entry Next_Move(previous : in State_Type);
      entry Choose_Move(next : out Place);
   end Player;

end Players;
