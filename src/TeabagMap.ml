open TeabagGlobal;;
open Hashtbl;;
open OcsfmlGraphics;;

class map = object(self)
    val mutable colourtoname = Hashtbl.create 10
    val mutable nametotex = Hashtbl.create 10
    val mutable nametoblocking = Hashtbl.create 10

    val mutable enttextures = Hashtbl.create 10
    val mutable sprites = Hashtbl.create 10

    val mutable tilesize = 0
    val mutable mapw = 100
    val mutable maph = 100

    val mutable tiles = []

    val mutable rendtex = new render_texture 100 100

    method tilefromcolour c = if (Hashtbl.mem colourtoname c) then (Hashtbl.find colourtoname c) else ""
    method texfromname n = Hashtbl.find nametotex n

    method load mapname = (
        let loadtea filename = (
            let loadtile r g b name blocking = (
                let texname = ("data/tiles/" ^ name ^ ".png") in
                let tex = new texture (`File texname) in
                let (a, _) = tex#get_size in 
                
                tilesize <- a;

                Hashtbl.replace colourtoname (Color.rgb r g b) name;
                Hashtbl.replace nametotex name tex;
                Hashtbl.replace nametoblocking name blocking
            ) in

            let loadentity name x y = (
                let spr = new sprite ~position:(x, y) () in

                let settex texname = (
                    let texfile = "data/sprites/" ^ texname ^ ".png" in
                    let tex = new texture (`File texfile) in

                    Hashtbl.replace enttextures texname tex;
                    spr#set_texture (Hashtbl.find enttextures texname)
                ) in

                let parseline line = match line with
                    | "sprite"::tl -> (match tl with
                        | [name] -> settex name
                        | _ -> ())

                    | _ -> ()
                in

                let rec parsefile file = match file with
                    | [] -> ()
                    | hd::tl -> parseline hd; parsefile tl
                in

                parsefile (readfile ("data/entities/" ^ name ^ ".tea"));
                Hashtbl.replace sprites name spr;
                
                ()
                       
            ) in

            let parseline line = match line with
                | "tile"::tl -> (match tl with
                    | [r; g; b; name; blocking] -> loadtile (int_of_string r) (int_of_string g) (int_of_string b) name (bool_of_string blocking)
                    | _ -> ())

                | "entity"::tl -> (match tl with
                    | [name; x; y] -> loadentity name (float_of_string x) (float_of_string y)
                    | _ -> ())

                | _ -> ()
            in

            let rec parsefile file = match file with
                | [] -> ()
                | hd::tl -> parseline hd; parsefile tl
            in

            parsefile (readfile filename)

        ) in

        let loadimg filename = (
            let img = new image (`File filename) in
            let (w, h) = img#get_size in

            let rec readimgloop y =
                let rec innerloop x = if x = w
                    then
                        []
                    else
                        (self#tilefromcolour (img#get_pixel x y))::(innerloop (x + 1))

                in if y = h
                    then
                        []
                    else
                        (innerloop 0)::(readimgloop (y + 1))

            in

            mapw <- w;
            maph <- h;
            tiles <- readimgloop 0

        ) in

        let renderimg () = (
            let texw = tilesize * mapw in
            let texh = tilesize * maph in

            let rec renderloop rows y =
                let rec innerloop row x = match row with
                    | [] -> ()
                    | hd::tl -> let spr = (new sprite ~texture:(self#texfromname hd) ~position:((float_of_int (x * tilesize)), (float_of_int (y * tilesize))) ()) in
                        rendtex#draw spr; innerloop tl (x + 1)
                
                in match rows with
                    | [] -> ()
                    | hd::tl -> innerloop hd 0; renderloop tl (y + 1)

            in

            rendtex <- new render_texture texw texh;
            rendtex#clear ();
            renderloop tiles 0;
            rendtex#display

        ) in

        loadtea ("data/maps/" ^ mapname ^ ".tea");
        loadimg ("data/maps/" ^ mapname ^ ".png");
        renderimg ()
    )

    method gettex = rendtex#get_texture

    method getsprites = sprites

end

