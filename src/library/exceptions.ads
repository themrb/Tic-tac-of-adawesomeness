--
-- Jan & Uwe R. Zimmer, Australia, July 2011
--

--
-- Usage if the purpose is to "catch all":
--
-- begin
--   ..
--   exception
--      when Exception_Id : others => Show_Exception (Exception_Id);
-- end;
--

with Ada.Exceptions; use Ada.Exceptions;

package  Exceptions is

   procedure Show_Exception (Exception_Identifier : Exception_Occurrence;
                             Optional_Message    : String := "");

end Exceptions;
