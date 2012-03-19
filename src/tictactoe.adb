with Ada.Text_IO;
with Boards; use Boards;
with Players; use Players;

procedure TicTacToe is
   package IO renames Ada.Text_IO;
   game : State_Type := Empty_Board;

   playerO : Player(O);
   playerX : Player(X);
begin
   playerO.Initialise;
   playerX.Initialise;

end TicTacToe;
