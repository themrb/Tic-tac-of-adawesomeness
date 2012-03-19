with Boards;

package Players is

   task type Player (name : Cell) is
      entry Initialise;
      entry Next_Move(previous : in State_Type, next : out Place);
   end Player;

end Player;
