package Boards is

   type BoardValue is new Integer range -1..1;
   type Dimension is new Natural range 0..3;

   type Cell is (X, O, Empty);

   type Board_Type is array(Dimension, Dimension, Dimension) of Boolean;
   pragma Pack (Board_Type);

   type Coordinate is (x, y, z);

   type Place is array(Coordinate) of Dimension;

   subtype TurnsNo is Natural range 0 .. 64;

   -- Information on the game state
   type State_Type is record
      justWent : Cell;
      spot : Place;
      turns : TurnsNo;
      current_stateX : Board_Type;
      current_stateO : Board_Type;
   end record;

   Empty_Board : constant State_Type := (Empty, (1,1,1), 0, (others => (others => (others => False))), (others => (others => (others => False))));

   function NextPlayer(prev : Cell) return Cell;

   function AdvanceMove(state : State_Type; move : Place) return State_Type;

   function Terminal(state : in State_Type) return Boolean;

   function Image(state : State_Type) return String;

   function Image(spot : Place) return String;

   function Image(board : Board_Type) return String;

end Boards;
