with Ada.Text_IO;
with Boards; use Boards;
with Players; use Players;

procedure TicTacToe is
   package IO renames Ada.Text_IO;
   game : State_Type := Empty_Board;
   next_move : Place;

   playerO : Player(O);
   playerX : Player(X);
begin
   playerO.Initialise;
   playerX.Initialise;

   loop
      playerO.Next_Move(game);
      playerO.Choose_Move(next_move);

      game := AdvanceMove(game, next_move);

      playerX.Next_Move(game);
      playerX.Choose_Move(next_move);

      game := AdvanceMove(game, next_move);

   end loop;

end TicTacToe;
