package body Players is

   task body Player is
      state : State_Type;
      chosenmove : Place;
   begin
      accept Initialise;

      loop
         -- Would be good if we could store (some of?) the gametree between
         -- moves and then just cull it depending on the new move. Would save a
         -- lot of recomputation.
         select
            accept Next_Move(previous : in State_Type) do
               state := previous;
            end Next_Move;
         or
            terminate;
         end select;

         declare
            GameTreeRoot : GameTree_Type;
         begin
            GameTreeRoot.state := state;
            Max(GameTreeRoot, 0);
            chosenmove := GameTreeRoot.best.state.spot;
         end;

         accept Choose_Move(next : out Place) do
            next := chosenmove;
         end Choose_Move;
      end loop;
   end Player;

end Players;
