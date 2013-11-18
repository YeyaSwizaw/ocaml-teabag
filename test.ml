open TeabagGame;;

let a = new game in (
    let close e = a#quit in
    let keypressed e = Printf.printf "Yay!\n" in

    a#init 800 600;
    a#addevtcall Closed close;
    a#addevtcall KeyPressed keypressed;
    a#run
)
