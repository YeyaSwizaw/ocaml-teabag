open TeabagGame;;

let a = new game in (
    let close e = a#quit in
    let keypressed e = Printf.printf "Yay!\n" in

    a#init true;
    a#addevtcall Closed close;
    a#addevtcall KeyPressed keypressed;
    a#run
)
