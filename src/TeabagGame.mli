open OcsfmlGraphics;;
open OcsfmlWindow;;
open Hashtbl;;

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

class game : object
    val mutable window : render_window
    val mutable evtfuncs : (eventtype, (Event.t -> unit)) t

    method init : int -> int -> unit
    method addevtcall : eventtype -> (Event.t -> unit) -> unit

    method run : unit
    method quit : unit
end
