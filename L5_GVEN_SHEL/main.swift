//
//  main.swift
//  L5_GVEN_SHEL
//
//  Created by Admin on 28.02.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

enum KillerMode {
    case active, inactive
}

enum Magazine {
    case full, empty
}

enum selfDestruct {
    case on, off
}

enum getReady {
    case ready
    case steady
    case go
}

protocol GenericRobot {
    var name: String { get set }
    var catchPhrase: String { get set }
    var charge: Int { get set }
    var selfDestruct: selfDestruct { get set }
    var health: Int { get set }
    var maxDamage: Int { get set }

    
    func startSelfDestruct()
    
    func executeMainDirective()
    
    func mode(mode: getReady)
    
    }

extension GenericRobot {
    
     func print_properties(mirror: GenericRobot) {
    
         let mirrored_robot = Mirror(reflecting: mirror)
         
         for (index, attr) in mirrored_robot.children.enumerated(){
             if let propertyName = attr.label as String? {
                 print("Attr \(index): \(propertyName) = \(attr.value)")
            }
         }
     }
}

protocol Fightable {
    func fight(robot1: GenericRobot, robot2: GenericRobot)
}


extension Fightable {
    
    func fight(robot1: GenericRobot, robot2: GenericRobot) {
        
        var robo1 = robot1
        var robo2 = robot2
        
        while robo1.health > 0 && robo2.health > 0 {
            let damage1 = Int.random(in: 0...robo1.maxDamage)
            let damage2 = Int.random(in: 0...robo2.maxDamage)
            
            robo1.health -= damage2 ; print("\(robo2.name) damages \(robo1.name) for \(damage2)")
            robo2.health -= damage1 ; print("\(robo1.name) damages \(robo2.name) for \(damage1)")
            
            if robo1.health < 0 && robo2.health < 0{
                print("The robots destroyed each other")
            } else if robo1.health < 0 {
                print("\(robo1.name) lost")
            } else if robo2.health < 0{
                print("\(robo2.name) lost")
            }
        }
    }
}

class KillerRobot: GenericRobot, Fightable {
    var maxDamage: Int
    var health: Int
    var name: String
    var catchPhrase: String
    var charge: Int
    var selfDestruct: selfDestruct
    var killCount: Int
    var gunClip: Magazine
    var readyForAction: KillerMode
    
    init(name: String, catchPhrase: String, charge: Int, killCount: Int, gunClip: Magazine, readyForAction: KillerMode, selfDestruct: selfDestruct, health: Int, maxDamage: Int){
        self.killCount = killCount
        self.gunClip = gunClip
        self.readyForAction = readyForAction
        self.name = name
        self.catchPhrase = catchPhrase
        self.charge = charge
        self.selfDestruct = selfDestruct
        self.health = health
        self.maxDamage = maxDamage
    }
    
    func reload() {
        if self.gunClip == .empty {
            print("*Reloads*")
            self.gunClip = .full
        } else if self.gunClip == .full {
            print("I'am already full")
        }
    }
    
    func startSelfDestruct(){
        self.selfDestruct = .on
        print("I’ll Be Back.")
        print("💥Boom!💥")
    }
    
    func killSomePunyHumans(){
        if charge > 0 {
        if self.gunClip != .empty {
        print("Bam!💥 Bang!💥")
        self.killCount += 1
            self.charge -= 10
        self.gunClip = .empty
        } else {
            print("I'm out of bullets")
        }
        } else {
        print("Out of juice")
            startSelfDestruct()
        }
    }
    
    func mode(mode: getReady){
        switch mode {
        case .ready:
            print(catchPhrase)
        case .steady:
            print(catchPhrase)
            reload()
        case .go:
            print(catchPhrase)
            reload()
            readyForAction.self = .active
            killSomePunyHumans()
            }
        }
    
    func executeMainDirective(){
        let peopleAround = Int.random(in: 0...10)
        var peopleAlive = peopleAround
        for _ in 0...peopleAround {
            if peopleAlive != 0 {
                killSomePunyHumans()
                peopleAlive -= 1
                reload()
            }
        }
    }
}

extension KillerRobot: CustomStringConvertible {
    
    var description: String {
        return "Hello, my name is \(name). \n My killCount is \(killCount). \n My gunclip currently is \(gunClip). \n I am ready for action - \(readyForAction). \n My current catchphrase is \(catchPhrase). \n The charge is \(charge). \n My selfdestruct mode is currenrly \(selfDestruct)"
    }
}

class GoofyRobot: GenericRobot, Fightable {
    var health: Int
    var maxDamage: Int
    var name: String
    var catchPhrase: String
    var charge: Int
    var selfDestruct: selfDestruct
    var beerCount: Int
    var isDrunk: Bool
    var readyForAction: KillerMode
 
    init(name: String, beerCount: Int, catchPhrase: String, isDrunk: Bool, charge: Int, readyForAction: KillerMode, selfDestruct: selfDestruct, health: Int, maxDamage: Int) {
        self.beerCount = beerCount
        self.isDrunk = isDrunk
        self.readyForAction = readyForAction
        self.name = name
        self.catchPhrase = catchPhrase
        self.charge = charge
        self.selfDestruct = selfDestruct
        self.health = health
        self.maxDamage = maxDamage
        }
    
    func haveSomeBeer() {
        self.beerCount += 1
        print("*Burps*")
    }
        
    func startSelfDestruct(){
        self.selfDestruct = .on
        print("Oops, I think I've had too much")
        print("💥Boom!💥")
    }
        
    func mode(mode: getReady){
        switch mode {
        case .ready:
        print(catchPhrase)
        case .steady:
        print(catchPhrase)
        haveSomeBeer()
        case .go:
        print(catchPhrase)
        haveSomeBeer()
        readyForAction.self = .active
         }
      }
    
    func executeMainDirective() {
        let holdYourLiqourStat = Int.random(in: 0...10)
        let upperThresholdOfBeerCapacity = Int.random(in: 5...15)
        
        for _ in 0...holdYourLiqourStat {
            if holdYourLiqourStat <= upperThresholdOfBeerCapacity {
                if holdYourLiqourStat != beerCount {
                    haveSomeBeer()
                }
            } else if holdYourLiqourStat > upperThresholdOfBeerCapacity {
                startSelfDestruct()
                break
            }
        }
    }
}
extension GoofyRobot: CustomStringConvertible {
    
    var description: String {
        return " Hello, my name is \(name). \n My beercount is \(beerCount). \n I am I drunk - \(isDrunk). \n I am ready for action - \(readyForAction). \n My current catchphrase is \(catchPhrase). \n The charge is \(charge). \n My selfdestruct mode is currenrly \(selfDestruct)"
    }
}

var Terminator = KillerRobot(name: "T-800", catchPhrase: "Hasta la vista, Baby", charge: 100, killCount: 0, gunClip: .full, readyForAction: .active, selfDestruct: .off, health: 100, maxDamage: 10)

var Bender = GoofyRobot(name: "Bender", beerCount: 0, catchPhrase: "Bite my shiny metal ass", isDrunk: false, charge: 50, readyForAction: .inactive, selfDestruct: .off, health: 100, maxDamage: 10)


print(Terminator)

print(Bender)

print(Terminator.print_properties(mirror: Bender))

Terminator.fight(robot1: Terminator, robot2: Bender)
