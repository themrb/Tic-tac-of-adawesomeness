
package body Players is

   task body Player is
      state : State_Type;
      chosenmove : Place;
   begin
      accept Initialise;

      loop
         accept Next_Move(previous : in State_Type) do
            state := previous;
         end Next_Move;

         declare
            GameTreeRoot : GameTree_Type;
         begin
            GameTreeRoot.state := state;
            Max(GameTreeRoot);
            chosenmove := GameTreeRoot.best.state.spot;
         end;

         accept Choose_Move(next : out Place) do
            next := chosenmove;
         end Choose_Move;
      end loop;
   end Player;

end Players;
