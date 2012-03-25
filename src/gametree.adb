with Boards; use Boards;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;
with Configure; use Configure;

package body GameTree is

   --Expand a game tree node's state and return its successor states
   function Expand(state : in GameTree_Type) return ExpandedChildren is
      temp : aliased GameTree_Type;
      Children : ExpandedChildren;
      frontCounter, backCounter : Children_Range;
   begin
      frontCounter := Children_Range'First;
      backCounter := Children_Range'Last - Children_Range(state.state.turns + 1) + 1;

      for i in Dimension'Range loop
         for j in Dimension'Range loop
            for k in Dimension'Range loop
               -- if we don't already have something sitting there
               if(not state.state.current_stateX(i,j,k) and not state.state.current_stateO(i,j,k)) then
                  temp := state;
                  temp.state.justWent := NextPlayer(state.state.justWent);

                  if (temp.state.justWent = X) then
                     temp.state.current_stateX(i,j,k) := True;
                  elsif (temp.state.justWent = O) then
                     temp.state.current_stateO(i,j,k) := True;
                  end if;

                  temp.state.spot := (i,j,k);
                  temp.state.turns := state.state.turns + 1;

                  if((temp.state.turns) /= state.state.turns + 1) then
                     Put_Line(temp.state.turns'Img & state.state.turns'Img);
                  end if;

                  -- Check if corner or inner nodes, and if so, add to front of
                  -- queue
                  if(((i = 0 or i = 3) and (j = 0 or j = 3) and (k = 0 or k = 3)) or
                    ((i = 1 or i = 2) and (j = 1 or j = 2) and (k = 1 or k = 2))) then
                     Children(frontCounter) := temp;
                     Configure.count := Configure.count + 1;
                     if(frontCounter < Children_Range'Last) then
                        frontCounter := frontCounter + 1;
                     end if;
                  else -- Otherwise, back of the line!
                     Children(backCounter) := temp;
                     Configure.count := Configure.count + 1;
                     if(backCounter > Children_Range'First) then
                        backCounter := backCounter - 1;
                     end if;
                  end if;
               end if;
            end loop;
         end loop;
      end loop;

      return Children;
   end Expand;

end GameTree;
