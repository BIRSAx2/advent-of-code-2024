(** The type of an Advent of Code puzzle which can be run by aoc. *)
module type T = sig
  val year : int
  (** The year that this puzzle is from. *)

  val day : int
  (** The day that this puzzle is from. *)

  (** Contains specific to the first part of the puzzle. *)
  module Part_1 : sig
    val run : string -> (string, string) result
    (** Runs the first part of the puzzle. 

        This should return [Error] if something goes wrong during execution -- for example, there 
        was a parsing error. If [Error] was returned, aoc will ignore the [--submit] flag. *)
  end

  (** Contains specific to the second part of the puzzle. *)
  module Part_2 : sig
    val run : string -> (string, string) result
    (** Runs the second part of the puzzle. 

        This should return [Error] if something goes wrong during execution -- for example, there 
        was a parsing error. If [Error] was returned, aoc will ignore the [--submit] flag. *)
  end
end
