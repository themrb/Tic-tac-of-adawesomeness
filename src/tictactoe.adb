with Ada.Text_IO;
with Boards; use Boards;
with Players; use Players;

procedure TicTacToe is
   package IO renames Ada.Text_IO;
   game : State_Type := Empty_Board;
   next_move : Place;

   playerO : Player_Access := new Player(O);
   playerX : Player_Access := new Player(X);
begin

   -- Up to a maximum of 64 moves
   while game.turns <= 64 loop

      -- Ask O for move
      playerO.Next_Move(game);
      playerO.Choose_Move(next_move);

      IO.Put_Line("Got move from O: " & Image(next_move));

      game := AdvanceMove(game, next_move);

      if(Terminal(game)) then
         IO.Put_Line("O wins in " & game.turns'Img & " moves");
         exit;
      end if;

      -- Ask X for move
      playerX.Next_Move(game);
      playerX.Choose_Move(next_move);

      IO.Put_Line("Got move from X: " & Image(next_move));

      game := AdvanceMove(game, next_move);

      if(Terminal(game)) then
         IO.Put_Line("X wins in " & game.turns'Img & " moves");
         exit;
      end if;
   end loop;

   playerX.Shutdown;
   playerO.Shutdown;

end TicTacToe;
