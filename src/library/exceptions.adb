--
-- Jan & Uwe R. Zimmer, Australia, July 2011
--

with Ada.Task_Identification; use Ada.Task_Identification;
with Ada.Text_IO;            use Ada.Text_IO;

package body Exceptions is

   procedure Show_Exception (Exception_Identifier : Exception_Occurrence;
                             Optional_Message    : String := "") is

   begin
      Put_Line (Current_Error,
                "Task " & Image (Current_Task) & " reports: ");
      Put_Line (Exception_Information (Exception_Identifier));
      if Optional_Message /= "" then
         Put_Line ("Additional message: " & Optional_Message);
      end if;
   end Show_Exception;

end Exceptions;
