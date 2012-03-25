with Boards; use Boards;
with MinMax; use MinMax;
with GameTree; use GameTree;

package Players is


   task type Player (name : Cell) is
      entry Next_Move(previous : in State_Type);
      entry Choose_Move(next : out Place);
      entry Shutdown;
   end Player;

   type Player_Access is access all Player;

   protected type BeingExplored is
      entry Next(node, parent : out GameTree_Type; a, b : out BoardValue);
      entry GetResult(node : out GameTree_Type);
      procedure Report(board, parent : in GameTree_Type; bValue : in BoardValue);
      procedure Initialise (parent : in GameTree_Type);
   private
      root, best : GameTree_Type;
      boards : ExpandedChildren;
      index : Children_Range := Children_Range'First;
      more : Boolean := False; -- Any more boards to check?
      alpha, beta, value : BoardValue;
      goNuts, checkNuts : Boolean := True; --Allow everyone to compute.

      procedure CheckForTerminals;
   end BeingExplored;

   task type Explorer(toExplore : access BeingExplored) is
   end Explorer;

--     type Explorers is array(Natural range 1..8) of Explorer;

end Players;
