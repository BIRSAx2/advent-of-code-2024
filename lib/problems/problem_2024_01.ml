let year = 2024
let day = 1

let parse (input : string) : (int list * int list, string) result =
  try
    let lines = String.split_on_char '\n' input in
    let non_empty_lines = List.filter (fun s -> String.length (String.trim s) > 0) lines in
    let parsed_lines =
      List.map
        (fun line ->
          String.split_on_char ' ' line
          |> List.filter (fun s -> String.length s > 0)
          |> List.map int_of_string)
        non_empty_lines
    in
    let list_a = List.map List.hd parsed_lines in
    let list_b = List.map (fun l -> List.hd (List.tl l)) parsed_lines in
    Ok (list_a, list_b)
  with
  | Failure msg -> Error ("parse error: " ^ msg)
  | _ -> Error "parse error: unknown"

module Part_1 = struct
  let run (input : string) : (string, string) result =
    match parse input with
    | Ok (list_a, list_b) ->
        let sorted_a = List.sort compare list_a in
        let sorted_b = List.sort compare list_b in
        let diffs =
          List.map2 (fun a b -> abs (a - b)) sorted_a sorted_b
        in
        let sum = List.fold_left ( + ) 0 diffs in
        Ok (string_of_int sum)
    | Error msg -> Error msg
end

module Part_2 = struct
  let count_occurrences lst =
    let rec aux acc = function
      | [] -> acc
      | hd :: tl ->
          let count = try List.assoc hd acc with Not_found -> 0 in
          aux ((hd, count + 1) :: List.remove_assoc hd acc) tl
    in
    aux [] lst
  
  let run (input : string) : (string, string) result =
    match parse input with
    | Ok (list_a, list_b) ->
        let freq_map = count_occurrences list_b in
        let sum =
          List.fold_left
            (fun acc a ->
              let count = try List.assoc a freq_map with Not_found -> 0 in
              acc + (a * count))
            0 list_a
        in
        Ok (string_of_int sum)
    | Error msg -> Error msg
end