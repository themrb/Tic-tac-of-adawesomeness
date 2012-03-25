with GameTree; use GameTree;
with Boards; use Boards;
with Ada.Text_IO; use Ada.Text_IO;

package body MinMax is

   procedure Min (state : in out GameTree_Type; depth : in TurnsNo; outValue : out BoardValue;
                    alpha, beta : in BoardValue) is
      successors : ExpandedChildren := Expand(state);
      move : GameTree_Type;
      a, b : BoardValue;
      value : BoardValue;
      best : GameTree_Type;
   begin
      a := alpha;
      b := beta;
      value := BoardValue'Last;  -- Set to maximum board-value;
      best := successors(1);

      -- Check if any of the successors are terminal states.
      -- Mainly to avoid exploring large portions of the game tree if the
      -- next move is already fixed.

      for i in 1.. (64-state.state.turns) loop
         move := successors(Children_Range(i));

         if(move.state.turns /= state.state.turns + 1) then
            Put_Line(move.state.turns'img & state.state.turns'Img);
         end if;
         if(Terminal(move.state)) then
            outValue :=  -1;
            best := move;
            return;
         end if;
      end loop;

      if (depth = 0) then
         outValue := 0;
         best := move;
         return;
      end if;

      -- Didn't find any terminal states above, so we continue MinMax-ing
      for i in 1.. (64-state.state.turns) loop
         move := successors(Children_Range(i));
         declare
            maxValue : BoardValue;
         begin
            Max(move, depth-1, maxValue, a, b);
            if(maxValue < value) then
               value := maxValue;
               best := move;
            end if;
         end;

         if(value <= a) then -- Max sees no way of avoiding min's win
            outValue := value;
            best := move;
            return;
         end if;
         if (value < b) then
            b := value;
            best := move;
         end if;
      end loop;

      outValue := value;

   end Min;

   procedure Max (state : in out GameTree_Type; depth : in TurnsNo; outValue : out BoardValue;
                    alpha, beta : in BoardValue) is
      successors : ExpandedChildren := Expand(state);
      move : GameTree_Type;
      a, b : BoardValue;
      value: BoardValue;
      best : GameTree_Type;
   begin
      a := alpha;
      b := beta;
      value := BoardValue'First; -- Set to minimum board-value;
      best := successors(1);

      -- Check if any of the successors are terminal states.
      -- Mainly to avoid exploring large portions of the game tree if the
      -- next move is already fixed.
      for i in 1.. (64-state.state.turns) loop
         move := successors(Children_Range(i));
         if(Terminal(move.state)) then
            outValue := 1;
            best := move;
            return;
         end if;
      end loop;

      if (depth = 0) then
         outValue := 0;
         best := move;
         return;
      end if;

      -- Didn't find any terminal states above, so we continue MinMax-ing
      for i in 1.. (64-state.state.turns) loop
         move := successors(Children_Range(i));
         declare
            minValue : BoardValue;
         begin
            Min(move, depth-1, minValue, a, b);

            if(minValue > value) then
               value := minValue;
               best := move;
            end if;
         end;

         if(value >= b) then -- min sees no way of avoiding max's win
            outValue := value;
            best := move;
            return;
         end if;
         if(value > a) then
            a := value;
            best := move;
         end if;

      end loop;

      outValue := value;

   end Max;

   ------------------------

   procedure MinBad (state : in out GameTree_Type; depth : in TurnsNo; outValue : out BoardValue;
                    alpha, beta : in BoardValue) is
      successors : ExpandedChildren := Expand(state);
      move : GameTree_Type;
      a, b : BoardValue;
      value : BoardValue;
      best : GameTree_Type;
   begin
      a := alpha;
      b := beta;
      value := BoardValue'Last;  -- Set to maximum board-value;
      best := successors(1);

      -- Check if any of the successors are terminal states.
      -- Mainly to avoid exploring large portions of the game tree if the
      -- next move is already fixed.

      for i in 1.. (64-state.state.turns) loop
         move := successors(Children_Range(i));

         if(move.state.turns /= state.state.turns + 1) then
            Put_Line(move.state.turns'img & state.state.turns'Img);
         end if;
         if(Terminal(move.state)) then
            outValue :=  -1;
            best := move;
            return;
         end if;
      end loop;

      if (depth = 0) then
         outValue := 0;
         best := move;
         return;
      end if;

      -- Didn't find any terminal states above, so we continue MinMax-ing
      for i in 1.. (64-state.state.turns) loop
         move := successors(Children_Range(i));
         declare
            maxValue : BoardValue;
         begin
            MaxBad(move, depth-1, maxValue, a, b);
            if(maxValue < value) then
               value := maxValue;
               best := move;
            end if;
         end;
      end loop;

      outValue := value;

   end MinBad;

   procedure MaxBad (state : in out GameTree_Type; depth : in TurnsNo; outValue : out BoardValue;
                    alpha, beta : in BoardValue) is
      successors : ExpandedChildren := Expand(state);
      move : GameTree_Type;
      a, b : BoardValue;
      value: BoardValue;
      best : GameTree_Type;
   begin
      a := alpha;
      b := beta;
      value := BoardValue'First; -- Set to minimum board-value;
      best := successors(1);

      -- Check if any of the successors are terminal states.
      -- Mainly to avoid exploring large portions of the game tree if the
      -- next move is already fixed.
      for i in 1.. (64-state.state.turns) loop
         move := successors(Children_Range(i));
         if(Terminal(move.state)) then
            outValue := 1;
            best := move;
            return;
         end if;
      end loop;

      if (depth = 0) then
         outValue := 0;
         best := move;
         return;
      end if;

      -- Didn't find any terminal states above, so we continue MinMax-ing
      for i in 1.. (64-state.state.turns) loop
         move := successors(Children_Range(i));
         declare
            minValue : BoardValue;
         begin
            MinBad(move, depth-1, minValue, a, b);

            if(minValue > value) then
               value := minValue;
               best := move;
            end if;
         end;

      end loop;

      outValue := value;

   end MaxBad;

end MinMax;
