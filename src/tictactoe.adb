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

   while game.turns /= 64 loop

      IO.Put_Line(Image(game));

      playerO.Next_Move(game);
      playerO.Choose_Move(next_move);

      IO.Put_Line("Got move from O: " & Image(next_move));

      game := AdvanceMove(game, next_move);

      IO.Put_Line(Image(game));

      playerX.Next_Move(game);
      playerX.Choose_Move(next_move);

      IO.Put_Line("Got move from X: " & Image(next_move));

      game := AdvanceMove(game, next_move);
   end loop;

end TicTacToe;
