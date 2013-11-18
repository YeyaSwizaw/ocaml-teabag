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
    val mutable gamename : string
    val mutable winw : int
    val mutable winh : int
    val mutable window : render_window
    val mutable evtfuncs : (eventtype, (Event.t -> unit)) t
    val mutable tickfuncs : (unit -> unit) list

    method init : unit
    method addevtcall : eventtype -> (Event.t -> unit) -> unit
    method addtickcall : (unit -> unit) -> unit

    method run : unit
    method quit : unit
end
