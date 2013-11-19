open TeabagGame;;
open OcsfmlWindow;;
open OcsfmlGraphics;;

type ball = { mutable xd : int; mutable yd : int; };;

let g = new game in (
    let b = { xd = -1; yd = 1; } in
    let bspd = 4 in
    let pspd = 4 in

    let close e = g#quit in

    let ontick () = (
        let ballbounds = g#getentitybounds "ball" in

        g#moveentity "ball" (b.xd * bspd) (b.yd * bspd);

        g#moveentity "p1" 0 
            (if (g#keypressed KeyCode.W) then -pspd else if (g#keypressed KeyCode.S) then pspd else 0);

        g#moveentity "p2" 0 
            (if (g#keypressed KeyCode.Up) then -pspd else if (g#keypressed KeyCode.Down) then pspd else 0);
        

        if ballbounds.top <= 0.0 then (b.yd <- 1) else if (ballbounds.top +. ballbounds.height) >= 600.0 then (b.yd <- -1);

        let p1bounds = g#getentitybounds "p1" in match FloatRect.intersects ballbounds p1bounds with
            | Some f -> b.xd <- 1; ()
            | None -> ();

        let p2bounds = g#getentitybounds "p2" in match FloatRect.intersects ballbounds p2bounds with
            | Some f -> b.xd <- -1; ()
            | None -> ();

        if ballbounds.left <= 50.0 then (Printf.printf "Right Wins!\n"; g#quit)
        else if ballbounds.left >= 950.0 then (Printf.printf "Left Wins!\n"; g#quit);

    ) in

    g#init true;
    g#addevtcall Closed close;
    g#addtickcall ontick;
    g#run

)
