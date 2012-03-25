with Boards; use Boards;

package Configure is
   -- Total depth to search to
   depth : TurnsNo := 8;
   -- Number of worker tasks: Warning, should be set to one less than number of available cores
   workerTasks : Natural := 3;
end Configure;
