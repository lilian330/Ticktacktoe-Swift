COMP1601:    Assignment3
Author:      Lilian Wang
Student#:    101087269
Date:        Wed. Mar.27
Instructor:  Louis Nel



Virtual Device Info:
	

	Name: Iphone SE
	Operating system: iOS
	Brand: Apple
	Operating system: iOS
	Screen size: 4 inches screen
	
	Target:	Swift 5 for iOS 12.2
	Xcode Version: Version 10.2 
	(SimulatorApp-880.5 CoreSimulator-587.35)
	

Source Files:
	readme.txt: 			Introduction of the application
	TicTacToe:			The file of the application of the TicTacToe game
	TicTacToe. xcodeproj:	        The Xcode project of the application


Application Introduction:

	R1.1 The game is built with Xcode 10.2, and Swift 5. The game provided a two-player tic tac toe game played by two people on the same device taking turns to draw on the screen.


	R1.2 After the game launched, it will show "DRAW BOARD" to ask user to draw the game bard. A user is able to draw the game board using a two-finger vertical drag and a two finger horizontal drag. Once the game board has been drawn the game is ready to receive player inputs.

	R1.3 When the game board has been constructed, a caricature of the empty game board will print on the console. 
	Eg.

	   | | 
	---------
	   | |
	---------
	   | |

	R1.4 After each player plays a new caricature will be printed the console on the state of the board. 
	Eg.

  	 X | | 
	---------
	   | | O
	---------
	   | |

	R1.5 The first player should be able to start with either an X or an O. After that the players play in turn. The game will determine whether the correct symbol (X, or O) has been drawn by the user with their finger.

	R1.6 The player need to enter their symbol by drawing it with a finger, or mouse

	R1.7 The game retains the shape they draw for their X or O symbol and use that shape in the game board display.

	R1.8 The game will determine whether they drew an X, an O, or some other (non-legal) symbol. The game will use the touch points to determine whether users draw a X of O or not. Also when a player plays the game board caricature will be update.

	R1.9 If the player plays out of turn or draws a shape that is not sufficiently like an X or an O the shape will be erased and the current player's turn should still be in effect (allowing them to draw another shape).

	R1.10 If the game ends with someone winning the "winning line" will be drawn by the game.

	R1.11 If the game ends in a tie, the game board will show "- TIE -".

	R1.12 Once a game is over, the user can clear the screen by doing a double tap and the double tap does not work when the game is still underway.

Enhancements:
	
	R1.13 Enhancement #1. The game has a scoreboard to show the winning time of each symbol.

	R1.14 Enhancement #2. Suspend Button, to suspend the app.

Execution Process:
	Run the application in the Xcode .

	** When the start or destination is changing or not set up yet the application is not able to solve

	Use Xcode (Version 10.2) to open the TicTacToe.xcodeproj.
	Run on iPhone SE
	Touch to draw 4 lines for a game board
	Touch to draw X or O to play the game
	When the game is finished (X Win, O Win or Draw), the usr can double tap to star next game
	