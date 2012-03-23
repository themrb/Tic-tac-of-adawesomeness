with Boards; use Boards;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body GameTree is

   function Expand(state : in GameTree_Type) return ExpandedChildren is
      temp : aliased GameTree_Type;
      Childrens : ExpandedChildren;
      Child_Counter : Children_Range := Children_Range'First;
   begin
--        temp.parent := new GameTree_Type'(state);
      for i in Dimension'Range loop
         for j in Dimension'Range loop
            for k in Dimension'Range loop
               if(state.state.current_stateX(i,j,k) = False and state.state.current_stateO(i,j,k) = False) then
                  temp := state;
                  temp.state.justWent := NextPlayer(state.state.justWent);
                  if (temp.state.justWent = X) then
                     temp.state.current_stateX(i,j,k) := True;
                  elsif (temp.state.justWent = O) then
                     temp.state.current_stateO(i,j,k) := True;
                  end if;

--                    temp.state.current_state(i,j,k) := temp.state.justWent;
                  temp.state.spot := (i,j,k);
                  temp.state.turns := state.state.turns + 1;
--                    Put_Line(Image(temp.state));
--                  Prepend(The_List, temp);
--                    Put_Line(Child_Counter'Img);
                  Childrens(Integer(Child_Counter)) := temp;
                  if (Integer(Child_Counter) /= 64) then
                     Child_Counter := Child_Counter + 1;
                  end if;
               end if;
            end loop;
         end loop;
      end loop;

      return Childrens;
   end Expand;

end GameTree;
