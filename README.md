## XRacing (MSX) by Santiago Ontañón Villar

Download latest compiled ROMs (v1.0.5) from: https://github.com/santiontanon/xracing/releases/tag/v1.0.5

You will need an MSX emulator to play the game on a PC, for example OpenMSX: http://openmsx.org


## Play on your Browser

https://www.file-hunter.com/MSXdev/index.php?id=xracing

Thanks to Arnaud De Klerk (TFH) for setting it up in WebMSX and hosting it!


## Introduction

XRacing is an MSX1 game, in a 48KB ROM cartridge format, built to participate in the MSXDev'18 competition ( https://www.msxdev.org ).

XRacing is a tribute to a few of the car racing games I loved as a kid. In particular Super Cars ( https://en.wikipedia.org/wiki/Super_Cars ), but there are references to many other games like F-1 Spirit (MSX), 4D Sports Driving (Amiga/DOS), and others! The one thing that I set out to do was a top-view car racing game with smooth multidirectional scroll, which was quite a challenge! The final solution I adopted limits significantly the amount of graphic variety in the screen (and that's why levels look a bit empty), but it more than makes up for it allowing smooth scroll, which I think adds a lot to the experience.

## Instructions

Screenshots (of version 1.0):

<img src="https://raw.githubusercontent.com/santiontanon/xracing/master/media/ss1.png" alt="title" width="400"/> <img src="https://raw.githubusercontent.com/santiontanon/xracing/master/media/ss2.png" alt="in game 1" width="400"/>

<img src="https://raw.githubusercontent.com/santiontanon/xracing/master/media/ss3.png" alt="in game 2" width="400"/> <img src="https://raw.githubusercontent.com/santiontanon/xracing/master/media/ss4.png" alt="in game 3" width="400"/>

You can see a video of the game at: https://www.youtube.com/watch?v=5P_Qffb5mr8

XRacing is an arcade-simulation racing game where you play the role of a driver trying to become Formula 1 world champion. To achieve your goal, you will have to first prove you are worthy of driving in Formula 1 though! Before you can compete in Formula 1, you will have to play through two previous seasons: stock cars and endurance cars. Each season being harder than the previous one as your car gets faster and faster, and it's harder to control! You will also have to manage yur cash, as you will have to pay entry fees to every race, and also you will have to save money to buy better cars. Luckily, you have an agent that represents you and can give you some advise.

The following image show the basic elements of the game screen, and the game controls:

<img src="https://raw.githubusercontent.com/santiontanon/xracing/master/media/xracing-instructions.png" alt="in game screen" width="800"/>

Pay special attention to:
* To complete the game, you will have to beat three seasons: stock cars (4 races), endurance cars (4 races) and Formula 1 cars (7 races)!
* In the early seasons (specially stock cars), cars are very slow, so you can take most curves at top speed. But as you progress into more advanced categories, and specially in Formula 1, cars are too fast more most curves, and you'll have to slow down.
* While driving, be sure not to drive recklessly, however, as your car can get damaged. Cars are usually fine and can last for an entire race, but if you drive too fast, or collide too often, your engine, tyres, brakes or chasis might fail! This is usually not a problem, but just be careful with your driving style!
* Manage your cash: each race has an entry fee, which you have to pay. If you run out of money to pay the entry fee of the next race, it's Game Over! Also, make sure to save enough cash to buy better cars. There are 3 cars you can choose from in each category. You start with the slowest one, and can buy the later ones if you earn enough money. But make sure you do not overspend, and keep enough cash to still pay the next race fee!
* It's ok not to finish 1st in a race, but if you finish 4th, your agent will get mad and will kick you out (Game Over!)

## Compatibility

The game was designed to be played on MSX1 computers with at least 16KB of RAM. I used the Philips VG8020 as the reference machine (since that's the MSX I owned as a kid), but I've tested it in some other machines using OpenMSX v0.14. If you detect an incompatibility, please let me know!


## Notes:

Some notes and useful links I used when coding XRacing

* There is a "build" script in the home folder. Use it to re-build the game from sources (make sure to run "generate-data" first though, to generate all the necessary data files)
* To measure code execution time I used: http://msx.jannone.org/bit/
* Math routines: http://z80-heaven.wikidot.com/math
* PSG (sound) registers: http://www.angelfire.com/art2/unicorndreams/msx/RR-PSG.html
* Z80 tutorial: http://sgate.emt.bme.hu/patai/publications/z80guide/part1.html
* Z80 user manual: http://www.zilog.com/appnotes_download.php?FromPage=DirectLink&dn=UM0080&ft=User%20Manual&f=YUhSMGNEb3ZMM2QzZHk1NmFXeHZaeTVqYjIwdlpHOWpjeTk2T0RBdlZVMHdNRGd3TG5Ca1pnPT0=
* MSX system variables: http://map.grauw.nl/resources/msxsystemvars.php
* MSX bios calls: 
    * http://map.grauw.nl/resources/msxbios.php
    * https://sourceforge.net/p/cbios/cbios/ci/master/tree/
* VDP reference: http://bifi.msxnet.org/msxnet/tech/tms9918a.txt
* VDP manual: http://map.grauw.nl/resources/video/texasinstruments_tms9918.pdf
* The game was compiled with Grauw's Glass compiler (cannot thank him enough for creating it): https://bitbucket.org/grauw/glass
* In order to compress data I used Pletter v0.5b - XL2S Entertainment 2008 (there is a Java port of the Pletter compressor in the Java JAR file in the repository).


