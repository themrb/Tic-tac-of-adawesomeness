with Boards; use Boards;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body GameTree is

   function Expand(state : in GameTree_Type) return Children_Access is
      temp : aliased GameTree_Type;
      Children : Children_Access;
      Child_Counter : Children_Range := Children_Range'First;
   begin
      Children := new GameTree_Children;
--        temp.parent := new GameTree_Type'(state);
      for i in Dimension'Range loop
         for j in Dimension'Range loop
            for k in Dimension'Range loop
               if(state.state.current_state(i,j,k) = Empty) then
                  temp := state;
                  temp.state.justWent := NextPlayer(state.state.justWent);
                  temp.state.current_state(i,j,k) := temp.state.justWent;
                  temp.state.spot := (i,j,k);
                  temp.state.turns := state.state.turns + 1;
--                    Put_Line(Image(temp.state));
--                  Prepend(The_List, temp);
--                    Put_Line(Child_Counter'Img);
                  Children.successors(Integer(Child_Counter)) := temp;
                  if (Integer(Child_Counter) /= 64) then
                     Child_Counter := Child_Counter + 1;
                  end if;
               end if;
            end loop;
         end loop;
      end loop;

      return Children;
   end Expand;

end GameTree;
