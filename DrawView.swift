//
//  DrawView.swift
//  TicTacToe Lilian
//
//  Created by Lilian Wang on 2019-03-16.
//  Copyright © 2019 COMP2601. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    
    var finishPoint = [CGPoint]()
    var game = [[" "," "," "],[" "," "," "],[" "," "," "]]

    var player1 = "X",player2 = "O",rInfo = " ",winInfo = "DRAW BOARD"
    var scoreX = 0, scoreO = 0, gameRound = 0, turn = 1,lineNumber = 0;
    var run = true, board = true, xTurn = true

    var p1,p2,p3,p4:CGPoint?
    var tem,x0,x1,x2,x3,y0,y1,y2,y3:CGFloat?
    var row = -1,col = -1

    var context = UIGraphicsGetCurrentContext()
    var currentLines = [NSValue:Line]() //dictionary of key-value pairs
    var paths = [[CGPoint]]()//DRAW SHAMP

    var currentLine: Line?
    var winLine = Line(begin: CGPoint(x:0,y:0), end: CGPoint(x:0,y:0));
    var finishedLines = [Line]()
    
    @IBInspectable var finishColor: UIColor = UIColor.blue {didSet {setNeedsDisplay()}}
    @IBInspectable var pathColor: UIColor = UIColor.orange {didSet {setNeedsDisplay()}}
    @IBInspectable var infoColor: UIColor = UIColor.orange {didSet {setNeedsDisplay()}}
    @IBInspectable var pathThickness: CGFloat = 8 {didSet {setNeedsDisplay()}}
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {didSet {setNeedsDisplay()}}
    @IBInspectable var currentLineColor: UIColor = UIColor.red {didSet {setNeedsDisplay()}}
    @IBInspectable var lineThickness: CGFloat = 5 {didSet {setNeedsDisplay()}}
   

    func strokeLine(line: Line){
        //Use BezierPath to draw lines
        let path = UIBezierPath();
        path.lineWidth = lineThickness;
        path.lineCapStyle = CGLineCap.round;
        path.move(to: line.begin);
        path.addLine(to: line.end);
        path.stroke(); //actually draw the path
    }
    
    func strokePath(line: Line){
        //Use BezierPath to draw lines
        let path = UIBezierPath();
        path.lineWidth = pathThickness;
        path.lineCapStyle = CGLineCap.round;
        path.move(to: line.begin);
        path.addLine(to: line.end);
        path.stroke(); //actually draw the path
    }
    
    func printBoard(){

        //printed the state of the board
        for i in 0...2 {
            for j in 0...2{
                if j == 2{
                    print(game[i][j],terminator:"")
                }else{
                    print(game[i][j],terminator:" | ")
                }
            }
            if i != 2 {
                print("\n----------")
            }
        }
        print("\n")
    }
 
    override func draw(_ rect: CGRect) {
        let s: NSString = " X - O                        \(rInfo) \n \(scoreX) : \(scoreO)                         \(winInfo)" as NSString

        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Helvetica Neue", size: 18)
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        // set the Obliqueness to 0.1
        let skew = 0.1
        let attributes: NSDictionary = [
            NSAttributedString.Key.foregroundColor: infoColor,
            NSAttributedString.Key.paragraphStyle: paraStyle,
            NSAttributedString.Key.obliqueness: skew,
            NSAttributedString.Key.font: fieldFont!
        ]
        s.draw(in: CGRect(x: 20.0, y: 50.0, width: 300.0, height: 48.0), withAttributes: attributes as? [NSAttributedString.Key : Any])
        
        //draw current path if it exists
        pathColor.setStroke()
        if board == false{
            guard let context = UIGraphicsGetCurrentContext() else{return}
            context.setLineWidth(pathThickness)
            context.setLineCap(CGLineCap.round)
            
            paths.forEach { (currPath) in
                for(i,p) in currPath.enumerated(){
                    if i == 0 {context.move(to: p)}
                    else {context.addLine(to: p)}
                }
            }
            context.strokePath()
        }
        //draw the finished lines
        finishedLineColor.setStroke() //set colour to draw
        for line in finishedLines{ strokeLine(line: line);}
        //draw win Line
        if checkWin() == "X" || checkWin() == "O"{
            finishColor.setStroke() //set colour to draw
            strokePath(line: winLine)
        }
        //draw current lines if it exists
        for (_ ,line) in currentLines{
            currentLineColor.setStroke();
            strokeLine(line: line);
        }
    }
    
    //Override Touch Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        print(#function) //for debugging
        if board == true{
            for touch in touches {
                let location = touch.location(in: self)
                let newLine = Line(begin: location, end: location)
                let key = NSValue(nonretainedObject: touch)
                currentLines[key] = newLine
            }
        }else{
            let touch = touches.first!; //get first touch event and unwrap optional
            let location = touch.location(in: self); //get location in view co-ordinate
            currentLine = Line(begin: location, end: location);
            if p1 == nil {
                p1 = location
            }else{
                p3 = location
            }
            paths.append([CGPoint]())
        }
        setNeedsDisplay(); //this view needs to be updated
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //TODO
//        print(#function) //for debugging
       if board == true{
            for touch in touches{
                let location = touch.location(in: self);
                let key = NSValue(nonretainedObject: touch)
                currentLines[key]?.end = location
            }
       }else{
            let touch = touches.first!
            let location = touch.location(in: self);
            currentLine?.end = location
        
            guard let point = touches.first?.location(in: nil) else {return}
            guard var lastPath = paths.popLast() else {return}

            lastPath.append(point)
            paths.append(lastPath)

        }
        setNeedsDisplay();
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //TODO
        print(#function) //for debugging
        if board == true{
            for touch in touches{
                let key = NSValue(nonretainedObject: touch)
                if currentLines[key] != nil {
                    var location = touch.location(in: self)
                    let firstlocation = currentLines[key]!.begin
                    let distance = distanceBetween(from: firstlocation, to: location)
                    if distance > 220 {
                        let differX = location.x - firstlocation.x
                        let differY = location.y - firstlocation.y
                        
                        if abs(differX) > abs(differY){
                            x0 = firstlocation.x
                            x3 = location.x
                            if x3!.isLess(than: x0!){
                                tem = x0;
                                x0 = x3;
                                x3 = tem;
                            }
                           
                            location.y = firstlocation.y
                            if y1 == nil  {
                                y1 = location.y
                            }else{
                                y2 = location.y
                                if y2!.isLess(than: y1!){
                                    tem = y1;
                                    y1 = y2;
                                    y2 = tem;
                                }
                            }
                        }
                        else{
                            y0 = firstlocation.y
                            y3 = location.y
                            
                            if y3!.isLess(than: y0!){
                                tem = y0;
                                y0 = y3;
                                y3 = tem;
                            }
                            location.x = firstlocation.x
                            if x1 == nil{
                                x1 = location.x

                            }else{
                                x2 = location.x
                                if x2!.isLess(than: x1!){
                                    tem = x1;
                                    x1 = x2;
                                    x2 = tem;
                                    x3 = max(x3!,x2!)
                                }
                            }
                        }

                        currentLines[key]?.end = location;
                        finishedLines.append(currentLines[key]!)
                        lineNumber += 1
                    }
                   
                    if lineNumber == 4{
                       
                        gameRound += 1
                        rInfo = "—Round: \(gameRound)—"
                        winInfo = "     X or O"
                        print("x0 = \(x0!), x1 = \(x1!), x2 = \(x2!), x3 = \(x3!)\n")
                        print("y0 = \(y0!), y1 = \(y1!), y2 = \(y2!), y3 = \(y3!)\n")
                        
                        let px0 = abs(x1!-x0!)/2 + x0!
                        let px1 = abs(x2!-x1!)/2 + x1!
                        let px2 = abs(x3!-x2!)/2 + x2!
                        
                        let py0 = abs(y1!-y0!)/2 + y0!
                        let py1 = abs(y2!-y1!)/2 + y1!
                        let py2 = abs(y3!-y2!)/2 + y2!
                        
                        finishPoint.append(CGPoint(x:px0,y:py0))
                        finishPoint.append(CGPoint(x:px1,y:py0))
                        finishPoint.append(CGPoint(x:px2,y:py0))
                        
                        finishPoint.append(CGPoint(x:px0,y:py1))
                        finishPoint.append(CGPoint(x:px1,y:py1))
                        finishPoint.append(CGPoint(x:px2,y:py1))
                        
                        finishPoint.append(CGPoint(x:px0,y:py2))
                        finishPoint.append(CGPoint(x:px1,y:py2))
                        finishPoint.append(CGPoint(x:px2,y:py2))
                    
                        board = false
                        printBoard()
                    }
                    
                }
                currentLines[key] = nil
            }
        }else{
          
            if var line = currentLine {
                let touch = touches.first!
                let location = touch.location(in: self)
                line.end = location;
                if p2 == nil {
                    p2 = location
                }else{
                    p4 = location
                }
                
                var fp:CGPoint?
                if p3 == nil {
                    fp = p1!
                }else{
                    fp = p3!
                }
                let px = fp!.x
                let py = fp!.y
                let distance = distanceBetween(from: fp!, to: location)
                
                if px.isLess(than: x1!) {col = 0;}
                if (x1!.isLess(than: px) && px.isLess(than: x2!)){col = 1}
                if x2!.isLess(than: px) {col = 2}
                
                if py.isLess(than: y1!) {row = 0}
                if (y1!.isLess(than: py) && py.isLess(than: y2!)) {row = 1}
                if y2!.isLess(than: py) {row = 2}
                
                if (row != -1) && (col != -1){
                    if game[row][col] == " "{
                        if checkShape(d:Double(distance),r:row,c:col){
                        }
//                        print("[\(row)][\(col)]")
                        row = -1
                        col = -1
                    }else{
                        print("error: wrong place!!")
                        undo()
                    }
                }
            }
            currentLine = nil
            
            if checkWin() == "X" {
                xWin()
            }else if checkWin() == "O"{
                oWin()
            }else if checkWin() == "D"{
                drawGame()
            }else{
            }
        }
        setNeedsDisplay()
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        //TODO
        print(#function) //for debugging
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        let doubleTapRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)

    }
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer){
        print("I got a double tap")
        if run == true{
            print("Game in still run")
        }else if run == false {
            print("Double to clean")
            resetGame()
        }
        setNeedsDisplay()
    }

    func checkShape(d:Double,r:Int,c:Int)->Bool{
        if d < 40 {
            if turn == 1{
                xTurn = false
            }
            if xTurn == true {
                print("please draw a X")
                undo()
            }else{
                game[r][c] = "O"
                print("[\(r)][\(c)] = O")
                printBoard()
                turn += 1
                xTurn = true
                winInfo = "     X Turn"
            }
            resetPoints()
        }else{
            if turn == 1{
                xTurn = true
            }
            if xTurn == true {
                if p3 != nil && p4 != nil && p1 != nil && p2 != nil {
                    if intersect(a:p1!, b:p2!, c:p3!, d:p4!) {
                        game[r][c] = "X"
                        print("[\(r)][\(c)] = X\n")
                        printBoard()
                        turn += 1
                        resetPoints()
                        xTurn = false
                        winInfo = "     O Turn"
                    }else{
                        print("It is not a X or O")
                        undo()
                        undo()
                        resetPoints()
                    }
                }
                
            }else {
                print("please draw a O")
                undo()
            }
        
        }
        return false
    }
    func undo(){
        _ = paths.popLast()
        setNeedsDisplay()
    }
    func mult(a:CGPoint,b: CGPoint,c: CGPoint)-> CGFloat{
        let acx = a.x-c.x
        let acy = a.y-c.y
        let bcy = b.y-c.y
        let bcx = b.x-c.x
        return acx * bcy - bcx * acy;
    }
    
    func resetPoints(){
        p1 = nil
        p2 = nil
        p3 = nil
        p4 = nil
    }
    
    //check intersect of four points of two lines
    func intersect(a:CGPoint, b:CGPoint, c:CGPoint, d:CGPoint)->Bool{
        if ( max(a.x, b.x)<min(c.x, d.x) )
        {
            return false;
        }
        if ( max(a.y, b.y)<min(c.y, d.y) )
        {
            return false;
        }
        if ( max(c.x, d.x)<min(a.x, b.x) )
        {
            return false;
        }
        if ( max(c.y, d.y)<min(a.y, b.y) )
        {
            return false;
        }
        if ( mult(a: c, b: b, c: a) * mult(a:b, b:d, c:a) < 0 )
        {
            return false;
        }
        if ( mult(a: a, b: d, c: c) * mult(a:d, b:b, c:c)<0 )
        {
            return false;
        }
        return true;
    }

   
    func resetGame(){
        x0 = nil
        x1 = nil
        x2 = nil
        x3 = nil
        
        y0 = nil
        y1 = nil
        y2 = nil
        y3 = nil
        
        print(">> Restar Game <<")
        resetPoints()
        turn = 1
        
        winInfo = "DRAW BOARD"
        currentLines.removeAll(keepingCapacity: false)
        finishedLines.removeAll(keepingCapacity: false)
        paths.removeAll(keepingCapacity: false)
        board = true
        run = true
        lineNumber = 0;
        game = [[" "," "," "],[" "," "," "],[" "," "," "]]
    }
    
    func drawGame(){
        printBoard()
        winInfo = "—— TIE ——"
        print("DRAW GAME!")
        run = false
    }
    
    func xWin(){
        scoreX += 1
        winInfo = " X WIN!!!"
        print("X WIN!!!")
        run = false
    }
    
    func oWin(){
        scoreO += 1
        winInfo = " O WIN!!!"
        print("O WIN!!!")
        run = false
    }
    
    func checkWin()->String {
        if (game[0][0] == game[1][1]) && (game[0][0] == game[2][2]) && (game[0][0] !=  " ") {

            winLine.begin = finishPoint[0]
            winLine.end   = finishPoint[8]
            return game[0][0]
        }
        if (game[2][0] == game[1][1]) && (game[2][0] == game[0][2]) && (game[2][0] !=  " ") {
            winLine.begin = finishPoint[6]
            winLine.end   = finishPoint[2]
            return game[2][0]
        }
        for i in 0...2 {
            if (game[i][0] == game[i][1]) && (game[i][0] == game[i][2]) && (game[i][0] !=  " ") {
                if i == 0 {
                    winLine.begin = finishPoint[0]
                    winLine.end   = finishPoint[2]
                }
                if i == 1 {
                    winLine.begin = finishPoint[3]
                    winLine.end   = finishPoint[5]
                }
                if i == 2 {
                    winLine.begin = finishPoint[6]
                    winLine.end   = finishPoint[8]
                }
                return game[i][0]
                
            }
            if (game[0][i] == game[1][i]) && (game[0][i] == game[2][i]) && (game[0][i] !=  " ") {
                if i == 0 {
                    winLine.begin = finishPoint[0]
                    winLine.end   = finishPoint[6]
                }
                if i == 1 {
                    winLine.begin = finishPoint[1]
                    winLine.end   = finishPoint[7]
                }
                if i == 2 {
                    winLine.begin = finishPoint[2]
                    winLine.end   = finishPoint[8]
                }
                return game[0][i]
            }
        }
        for i in 0...2 {
            for j in 0...2 {
                if game[i][j] ==  " " {
                    return game[i][j]
                }
            }
        }
        return "D";
    }

    func distanceBetween(from: CGPoint, to: CGPoint) -> CFloat{
        let distXsquared = Float((to.x-from.x)*(to.x-from.x))
        let distYsquared = Float((to.y-from.y)*(to.y-from.y))
        return sqrt(distXsquared + distYsquared);
    }
    
}

