with Boards; use Boards;
with MinMax; use MinMax;
with GameTree; use GameTree;

package Players is

   -- Task representing both of the players.
   -- Used only for setting up the computations prior to each move, and
   -- then retrieving the result once computations are done.
   task type Player (name : Cell) is
      -- Gets the move that just happened.
      entry Next_Move(previous : in State_Type);
      -- Gives the player's choice of move.
      entry Choose_Move(next : out Place);
      entry Shutdown;
   end Player;

   type Player_Access is access all Player;

   -- Protected object which manages data about and including the set of nodes
   -- currently being explored, or which are going to be explored in this pass.
   protected type BeingExplored is
      -- Allows explorer task to get the next node to be explored.
      entry Next(node, parent : out GameTree_Type; a, b : out BoardValue);
      -- Allows player task to retrieve the result of exploring the game-tree.
      entry GetResult(node : out GameTree_Type);
      -- Allows explorer tasks to report what they found.
      procedure Report(board, parent : in GameTree_Type; bValue : in BoardValue);
      -- Initialise the set to explore. Note that we do this for every turn.
      procedure Initialise (parent : in GameTree_Type);
   private
      root, best : GameTree_Type;
      boards : ExpandedChildren;
      index : Children_Range := Children_Range'First;
      more : Boolean := False; -- Any more boards to check?
      alpha, beta, value : BoardValue;
      goNuts, checkNuts : Boolean := True; --Switches which allow just one worker,
                                           -- or all to compute.

      procedure CheckForTerminals;         -- Look ahead to see if we have any terminals.
   end BeingExplored;

   -- Task which actually explores the game-tree.
   task type Explorer(toExplore : access BeingExplored) is
   end Explorer;

end Players;
