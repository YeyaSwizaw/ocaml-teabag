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
    val mutable window = new render_window (VideoMode.create ~w:100 ~h:100 ()) "Teabag"
    val mutable evtfuncs = Hashtbl.create 10

    method init width height = window#create (VideoMode.create ~w:width ~h:height ()) "Teabag"

    method addevtcall (etype:eventtype) (efun:Event.t -> unit) = Hashtbl.add evtfuncs etype efun

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

        let rec mainloop () = 
            if window#is_open then (
                eventloop ();

                window#clear ();
                window#display;

                mainloop ();
            )
        in

        mainloop ();
    )

    method quit = window#close

end
