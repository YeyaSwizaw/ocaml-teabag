open TeabagGlobal;;
open TeabagMap;;
open OcsfmlGraphics;;
open OcsfmlWindow;;

type eventtype = 
    | Closed
    | LostFocus
    | GainedFocus
    | Resized
    | TextEntered
    | KeyPressed
    | KeyReleased
    | MouseWheelMoved
    | MouseButtonPressed
    | MouseButtonReleased
    | MouseMoved
    | MouseEntered
    | MouseLeft
    | JoystickButtonPressed
    | JoystickButtonReleased
    | JoystickMoved
    | JoystickConnected
    | JoystickDisconnected

class game = object(self)
    val mutable gamename = "Teabag Engine"
    val mutable winw = 800
    val mutable winh = 600

    val mutable window = new render_window (VideoMode.create ~w:800 ~h:600 ()) "Teabag"

    val mutable m = new map

    val mutable evtfuncs = Hashtbl.create 10
    val mutable tickfuncs = []

    val mutable mapspr = new sprite ()

    method loadmap n = (
        m#load n;

        mapspr <- new sprite ~texture:(m#gettex) ~position:(0.0, 0.0) ();

        ()

    )

    method init loadmapnow = (
        let parseline line = match line with
            | "wind"::tl -> (match tl with
                | [w; h] -> winw <- (int_of_string w); winh <- (int_of_string h); ()
                | _ -> ())

            | "name"::tl -> gamename <- (String.concat " " tl); ()

            | "start"::tl -> (if loadmapnow then (
                match tl with
                    | [n] -> self#loadmap n
                    | _ -> ()
                ) else () )

            | _ -> ()
        in

        let rec parsefile file = match file with
            | [] -> ()
            | hd::tl -> parseline hd; parsefile tl
        in

        parsefile (readfile "data/main.tea");
        window#create (VideoMode.create ~w:winw ~h:winh ()) gamename 

    )

    method addevtcall (etype:eventtype) (efun:Event.t -> unit) = Hashtbl.add evtfuncs etype efun
    method addtickcall (tfun:unit -> unit) = tickfuncs <- (tfun::tickfuncs); ()

    method run = (
        let rec callfuncs fs e = match fs with
            | [] -> ()
            | hd::tl -> hd e; callfuncs tl e
        in

        let rec eventloop () = match window#poll_event with
            | Some e -> (let et = match e with
                | Event.Closed -> Closed
                | Event.LostFocus -> LostFocus
                | Event.GainedFocus -> GainedFocus
                | Event.Resized _ -> Resized
                | Event.TextEntered _ -> TextEntered
                | Event.KeyPressed _ -> KeyPressed
                | Event.KeyReleased _ -> KeyReleased
                | Event.MouseWheelMoved _ -> MouseWheelMoved
                | Event.MouseButtonPressed _ -> MouseButtonPressed
                | Event.MouseButtonReleased _ -> MouseButtonReleased
                | Event.MouseMoved _ -> MouseMoved
                | Event.MouseEntered -> MouseEntered
                | Event.MouseLeft -> MouseLeft
                | Event.JoystickButtonPressed _ -> JoystickButtonPressed
                | Event.JoystickButtonReleased _ -> JoystickButtonReleased
                | Event.JoystickMoved _ -> JoystickMoved
                | Event.JoystickConnected _ -> JoystickConnected
                | Event.JoystickDisconnected _ -> JoystickDisconnected in (

                    if (Hashtbl.mem evtfuncs et) then callfuncs (Hashtbl.find_all evtfuncs et) e;
                    eventloop ();
                )
            )

            | _ -> ()
        in

        let rec callticks ls = match ls with 
            | [] -> ()
            | f::tl -> f (); callticks tl;
        in

        let rec mainloop () = 
            if window#is_open then (
                eventloop ();
                callticks tickfuncs;

                window#clear ();
                window#draw mapspr;
                let draw _ s = window#draw s in Hashtbl.iter draw (m#getsprites);
                window#display;

                mainloop ();
            )
        in

        mainloop ();
    )

    method quit = window#close

    method keypressed k = Keyboard.is_key_pressed k

    method moveentity name x y = 
        let tbl = m#getsprites in

        if Hashtbl.mem tbl name then
            let spr = Hashtbl.find tbl name in spr#move (float_of_int x) (float_of_int y)
        else ()

end
