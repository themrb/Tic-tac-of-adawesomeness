with GameTree; use GameTree;
with Boards; use Boards;

package MinMax is

   procedure Min (state : in out GameTree_Type;  depth : in  TurnsNo; outValue : out BoardValue; best : out GameTree_Type;
                  alpha, beta : in BoardValue);
   procedure Max (state : in out GameTree_Type;  depth : in  TurnsNo; outValue : out BoardValue; best : out GameTree_Type;
                  alpha, beta : in BoardValue);
   --function Forced_Move_Check (state : in GameTree_Type) return GameTree_Type;

end MinMax;
