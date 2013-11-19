open TeabagGame;;
open OcsfmlWindow;;

let a = new game in (
    let close e = a#quit in
    let keypressed e = Printf.printf "Yay!\n" in

    let ontick () =
        a#moveentity "test" 
            (if (a#keypressed KeyCode.Left) then -1 
            else if (a#keypressed KeyCode.Right) then 1
            else 0)
            (if (a#keypressed KeyCode.Up) then -1 
            else if (a#keypressed KeyCode.Down) then 1
            else 0)
    in

    a#init true;
    a#addevtcall Closed close;
    a#addevtcall KeyPressed keypressed;
    a#addtickcall ontick;
    a#run
)
