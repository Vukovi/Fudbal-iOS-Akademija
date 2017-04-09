//: Playground - noun: a place where people can play

import UIKit

enum PozicijaUTimu: Int {
    case Golman = 1
    case Odbrana = 2
    case VezniRed = 3
    case Napad = 4
}

enum Timovi: Int {
    case Zvezda = 1
    case Partizan = 2
    case Rad = 3
    case Cukaricki = 4
}

enum ImenaIgraca: Int {
    case Bronson = 1
    case Vuk = 2
    case Marko = 3
    case Drakula = 4
    case Ajkula = 5
}

func == (porediOvo: Igrac, saOvim: Igrac) -> Bool {
    return porediOvo.brojDresa == saOvim.brojDresa //&& porediOvo.pozicija == saOvim.pozicija
}

struct Igrac: Hashable {
    var imeIgraca: String
    var brojDresa: Int
    var zutiKartoni: Int
    var crveniKarton: Bool
    var pozicija: String
    
    init(imeIgraca: String, brojDresa: Int, zutiKartoni: Int, crveniKarton: Bool, pozicija: String) {
        self.imeIgraca = imeIgraca
        self.brojDresa = brojDresa
        self.zutiKartoni = zutiKartoni
        self.crveniKarton = crveniKarton
        self.pozicija = pozicija
    }
    
    var hashValue: Int{
        return brojDresa.hashValue //^ pozicija.hashValue
    }
}

struct IgracUTimu  {
    var igrac: Igrac
    var tim: String
    var utakmicuIgra: Bool
    
    init(igrac: Igrac, tim: String, utakmica: Bool) {
        self.igrac = igrac
        self.tim = tim
        self.utakmicuIgra = utakmica
    }

}

//kreiranje igrača

func kreirajIgraca() -> Igrac {
    let brojZutihKartona = Int(arc4random_uniform(4))
    let brojCrvenihKartona = Int(arc4random_uniform(2))
    let daLiJeCrveniKarton: Bool!
    if brojZutihKartona == 3 || brojCrvenihKartona == 1 {
        daLiJeCrveniKarton = true
    } else {
        daLiJeCrveniKarton = false
    }
    
    let proizvoljniBroj = Int(arc4random_uniform(4)) + 1
    let proizvoljnaPozicijaUTimu = String(describing: PozicijaUTimu(rawValue: proizvoljniBroj)!)
    let proizvoljnoImeIgraca = String(describing: ImenaIgraca(rawValue: proizvoljniBroj)!)
    
    let igrac = Igrac(imeIgraca: proizvoljnoImeIgraca, brojDresa: Int(arc4random_uniform(22)), zutiKartoni: brojZutihKartona, crveniKarton: daLiJeCrveniKarton, pozicija: proizvoljnaPozicijaUTimu)
    return igrac
}

//kreiranje tima: njegovo ime i sve igrače, gde svaki igrač ima ime, dres, poziciju itd.

func kreirajTim() -> [IgracUTimu] {
    let proizvoljniBroj = Int(arc4random_uniform(4)) + 1
    let imeProizvoljnogTima = String(describing: Timovi(rawValue: proizvoljniBroj)!)
    
    var igraci = [IgracUTimu]()
    var kreiraniIgraci: Set<Igrac> = Set<Igrac>() //ovo sam napravio da mi se ne bi desilo da dva igraca imaju isti dres
    var golmanskiSet: Set<Igrac> = Set<Igrac>()
    var fudbalerskiSet: Set<Igrac> = Set<Igrac>()
    
    repeat {
        let igrac = kreirajIgraca()
    
        if igrac.pozicija == String(describing: PozicijaUTimu(rawValue: 1)!) && !golmanskiSet.contains(igrac) && igrac.brojDresa < 23 && golmanskiSet.count < 3 {
            golmanskiSet.insert(igrac)
        } else if igrac.pozicija != String(describing: PozicijaUTimu(rawValue: 1)!) && !fudbalerskiSet.contains(igrac) && igrac.brojDresa < 23 {
            fudbalerskiSet.insert(igrac)
        }
        
        kreiraniIgraci = golmanskiSet
        
        for fudbaler in fudbalerskiSet {
            if !kreiraniIgraci.contains(fudbaler) && igrac.brojDresa < 23 {
                kreiraniIgraci.insert(fudbaler)
            }
        }
        
    } while kreiraniIgraci.count < 22
    
    kreiraniIgraci //3 golmana, ostalo fudbaleri
    
    for igrac in kreiraniIgraci {
        let igraUtakmicu = igrac.crveniKarton
        igraci.append(IgracUTimu(igrac: igrac, tim: imeProizvoljnogTima, utakmica: igraUtakmicu))
    }

    return igraci
}

let tim1 = kreirajTim()

//ispis parametara proizvoljnog igrača

func parametriIgracTima(igrac: [IgracUTimu]) {
    let proizvoljniBroj = Int(arc4random_uniform(UInt32(igrac.count - 1)))
    let fudbaler = igrac[proizvoljniBroj]
    print("Igrac koji se zove \(fudbaler.igrac.imeIgraca) sa brojem dresa \(fudbaler.igrac.brojDresa), igra na poziciji \(fudbaler.igrac.pozicija) i ima sledeće kartone: žuti - \(fudbaler.igrac.zutiKartoni), crveni - \(fudbaler.igrac.crveniKarton ? "1":"0"). Igra za tim: \(fudbaler.tim), i utakmicu \(fudbaler.utakmicuIgra ? "ne bi mogao" : "bi mogao") da igra.")
}

parametriIgracTima(igrac: tim1)

//da li određeni igrač može učestvovati u utakmici

func ucestvovanjeIgraca(igrac: [IgracUTimu]) -> Bool {
    let proizvoljniBroj = Int(arc4random_uniform(UInt32(igrac.count - 1)))
    let fudbaler = igrac[proizvoljniBroj]
    return fudbaler.utakmicuIgra
}

//prikaz spiska svih igrača u timu

func igraciTima(igraci: [IgracUTimu]) -> [Any] {
    var rezultujuciNiz: [Any] = [Any]()
    for fudbaler in igraci {
        let igrac = fudbaler.igrac.imeIgraca
        let pozicija = fudbaler.igrac.pozicija
        let niz: [Any] = [igrac,pozicija]
        print("\(igrac),\(pozicija)")
        rezultujuciNiz.append(niz)
    }
    return rezultujuciNiz
}

//igraciTima(igraci: tim1)

//prikaz spiska igrača koji počinju utakmicu (pored svakog igrača ispisati poziciju u timu)

func startniIgraci(igraci: [IgracUTimu]) -> [IgracUTimu] {
    var startniNiz = [IgracUTimu]()
    for golman in igraci {
        if golman.igrac.pozicija == String(describing: PozicijaUTimu(rawValue: 1)!) && golman.utakmicuIgra && startniNiz.count < 3 {
            startniNiz.append(golman)
        }
        
    }
    if startniNiz.count != 0 { //ne moze bez golmana da se igra
        for fudbaler in igraci {
            if fudbaler.igrac.pozicija != String(describing: PozicijaUTimu(rawValue: 1)!) && fudbaler.utakmicuIgra && startniNiz.count < 16 {
                startniNiz.append(fudbaler)
            }
        }
    }
    igraciTima(igraci: startniNiz)
    return startniNiz
}

startniIgraci(igraci: tim1).count


//da li postoje uslovi da utakmica počne

func utakmica(tim1: [IgracUTimu], tim2: [IgracUTimu]) -> Bool {
    return startniIgraci(igraci: tim1).count > 11 && startniIgraci(igraci: tim2).count > 11
}

let tim2 = kreirajTim()

utakmica(tim1: tim1, tim2: tim2)
