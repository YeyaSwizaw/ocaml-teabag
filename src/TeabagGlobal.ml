let readfile filename = 
    let rec getline f =
        try
            let s = input_line f in (Str.split (Str.regexp " ") s)::(getline f)
        with End_of_file ->
            close_in f;
            []
    in

    getline (open_in filename)
