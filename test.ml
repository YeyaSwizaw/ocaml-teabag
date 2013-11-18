open TeabagGame;;

let a = new game in (
    let close e = a#quit in
    let keypressed e = Printf.printf "Yay!\n" in

    a#init;
    a#addevtcall Closed close;
    a#addevtcall KeyPressed keypressed;
    a#addtickcall (fun unit -> Printf.printf "Tick!\n");
    a#run
)
