with Ada.Text_IO; use Ada.Text_IO;
with Exceptions; use Exceptions;

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
            value, alpha, beta : BoardValue;
         begin
            alpha := BoardValue'First;
            beta := BoardValue'Last;
            GameTreeRoot.state := state;

            Max(GameTreeRoot, 6, value, alpha, beta);

--              Put_Line(Image(GameTreeRoot.state) & GameTreeRoot.bestVal'Img &" "& Name'Img);

            chosenmove := GameTreeRoot.best.state.spot;
         end;

         accept Choose_Move(next : out Place) do
            next := chosenmove;
         end Choose_Move;
      end loop;
   exception
      when E : others => Show_Exception (E);
   end Player;

end Players;
