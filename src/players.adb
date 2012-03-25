with Ada.Text_IO; use Ada.Text_IO;
with Exceptions; use Exceptions;
with Ada.Task_Attributes;
with Configure;


package body Players is

   task body Player is
      state : State_Type;
      best : GameTree_Type;
      toExplore : aliased BeingExplored;
      workers : array(Natural range 1..Configure.workerTasks) of Explorer(toExplore'Access);
   begin

      loop
         -- Would be good if we could store (some of?) the gametree between
         -- moves and then just cull it depending on the new move. Would save a
         -- lot of recomputation.
         select
            accept Next_Move(previous : in State_Type) do
               state := previous;
            end Next_Move;
         or
            accept Shutdown do
               for i in workers'Range loop
                  abort workers(i);
               end loop;
            end Shutdown;
            exit;
         end select;

         declare
            gameTreeRoot : GameTree_Type;
         begin
            gameTreeRoot.state := state;
            toExplore.Initialise(gameTreeRoot);
            toExplore.GetResult(best);
--              Max(GameTreeRoot, 7, value, chosentree, alpha, beta);

--              Put_Line(Image(chosentree.state) & " " & value'Img &" "& Name'Img);
         end;

         accept Choose_Move(next : out Place) do
            next := best.state.spot;
         end Choose_Move;
         delay 0.0;
      end loop;
   exception
      when E : others => Show_Exception (E);
   end Player;

   ----------------------

   task body Explorer is
      current, parent : GameTree_Type;
      -- Note, this is one LESS than the tests from pre-concurrency, so
      -- a normal 7 is now a 6, because we start on Min-nodes now.
      depth : TurnsNo := Configure.depth - 1;
      value, a, b : BoardValue;
   begin
      loop
         toExplore.all.Next(current, parent, a, b);
         Min(current, depth, value, a, b);
         toExplore.all.Report(current, parent, value);
         delay 0.0;
      end loop;
   end Explorer;

   ----------------------

   protected body BeingExplored is
      procedure Initialise (parent : in GameTree_Type) is
      begin
         root := parent;
         index := Children_Range'First;
         boards := Expand(root);
         alpha := BoardValue'First;
         beta := BoardValue'Last;
         value := BoardValue'First; -- Set to minimum board-value;
         best := boards(Children_Range'First);
         more := True;
         goNuts := True;
         checkNuts := True;
         CheckForTerminals;
      end Initialise;

      entry GetResult(node : out GameTree_Type) when not more is
      begin
         node := best;
      end GetResult;

      entry Next(node, parent : out GameTree_Type; a, b : out BoardValue)
         when (more and goNuts) is
      begin
         node := boards(index);
         a := alpha;
         b := beta;
         parent := root;
         if(index < Children_Range(64 - root.state.turns)) then
            index := index + 1;
         else
            more := False;
         end if;

         -- See if we only want one worker computing at this point.
         if(checkNuts) then
            goNuts := False;
         end if;
      end Next;

      procedure Report(board, parent : in GameTree_Type; bValue : in BoardValue) is
      begin
         -- This is basically a chunk of the 'Max' part of Minmax
         if(parent = root) then -- Have to make sure result is still relevant
            if(bValue > value) then
               value := bValue;
               best := board;
            end if;

            if(value >= beta) then -- min sees no way of avoiding max's win
               best := board;
               more := False;
            end if;
            if(value > alpha) then
               alpha := value;
               best := board;
            end if;
         end if;

         -- Make it so everyone can compute.
         goNuts := True;
         checkNuts := False;
      end Report;

      procedure CheckForTerminals is
         move : GameTree_Type;
      begin
         for i in 1 .. (64-root.state.turns) loop
            move := boards(Children_Range(i));
            if(Terminal(move.state)) then
               more := False;
               best := move;
            end if;
         end loop;
      end CheckForTerminals;
   end BeingExplored;


end Players;
