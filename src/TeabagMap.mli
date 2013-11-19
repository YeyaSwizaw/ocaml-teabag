open Hashtbl;;
open OcsfmlGraphics;;

class map : object
    val mutable colourtoname : (Color.t, string) t
    val mutable nametotex : (string, texture) t
    val mutable nametoblocking : (string, bool) t

    val mutable tilesize : int
    val mutable mapw : int
    val mutable maph : int

    val mutable tiles : string list list

    val mutable rendtex : render_texture

    method tilefromcolour : Color.t -> string
    method texfromname : string -> texture

    method load : string -> unit

    method gettex : const_texture
end
