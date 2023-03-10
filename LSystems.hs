module LSystems where

import IC.Graphics

type Rule
  = (Char, String)

type Rules
  = [Rule]

type Angle
  = Float

type Axiom
  = String

type LSystem
  = (Angle, Axiom, Rules)

type Vertex
  = (Float, Float)

type TurtleState
  = (Vertex, Float)

type Command
  = Char

type Commands
  = [Command]

type Stack
  = [TurtleState]

type ColouredLine
  = (Vertex, Vertex, Colour)

----------------------------------------------------------
-- Functions for working with systems.

-- Returns the rotation angle for the given system.
angle :: LSystem -> Float
angle (ang,axi,rul) 
  = ang

-- Returns the axiom string for the given system.
axiom :: LSystem -> String
axiom (ang,axi,rul) 
  = axi 

-- Returns the set of rules for the given system.
rules :: LSystem -> Rules
rules (ang,axi,rul) 
  = rul 

-- Return the binding for the given character in the list of rules
lookupChar :: Char -> Rules -> String
-- Pre: the character has a binding in the Rules list
-- Char [(Char, String)..]
lookupChar char (r:rs) 
  |char == fst r = snd r
  |otherwise = lookupChar char rs

-- Expand command string s once using rule table r
expandOne :: String -> Rules -> String
-- lookupChar Char [(Char, String)..]
expandOne "" rules = ""
expandOne (str:strs) rules = a 
  where 
    result = lookupChar str rules
    results = expandOne strs rules
    a = result ++ results 


-- Expand command string s n times using rule table r
expand :: String -> Int -> Rules -> String
expand str 0 rul = str 
expand str int rul = expand result (int - 1) rul
  where 
    result = expandOne str rul -- -> "M-N-M", 1
   -- next step of the recursion ->"N+M+N-M-N-M-N+M+N" 0

   

-- Move a turtle
{-type Angle = Float
type Axiom = String
type LSystem = (Angle, Axiom, Rules)
type Vertex = (Float, Float)
type TurtleState = (Vertex, Float)
type Command = Char
type Commands = [Command]
-}
move :: Command -> Angle -> TurtleState -> TurtleState
move char angle ((x,y), angle') 
  |char == 'R' = ((x,y), angle' - angle)
  |char == 'F' = ((x + 1 * cos(pi * (angle' / 180)),y + 1 * sin(pi * (angle' / 180))), angle')
  |char == 'L' = ((x,y), angle + angle')

--
-- Trace lines drawn by a turtle using the given colour, following the
-- commands in `cs' and assuming the given angle of rotation.
--
trace1 :: Commands -> Angle -> Colour -> [ColouredLine]
trace1
  = undefined

trace2 :: Commands -> Angle -> Colour -> [ColouredLine]
trace2
  = undefined

----------------------------------------------------------
-- Some given functions

expandLSystem :: LSystem -> Int -> String
expandLSystem (_, axiom, rs) n
  = expandOne (expand axiom n rs) commandMap

drawLSystem1 :: LSystem -> Int -> Colour -> IO ()
drawLSystem1 system n colour
  = drawLines (trace1 (expandLSystem system n) (angle system) colour)

drawLSystem2 :: LSystem -> Int -> Colour -> IO ()
drawLSystem2 system n colour
  = drawLines (trace2 (expandLSystem system n) (angle system) colour)

----------------------------------------------------------
-- Some test systems.

cross, triangle, arrowHead, peanoGosper, dragon, snowflake, tree, bush, canopy, galaxy :: LSystem

cross
  = (90,
     "M-M-M-M",
     [('M', "M-M+M+MM-M-M+M"),
      ('+', "+"),
      ('-', "-")
     ]
    )

triangle
  = (90,
     "-M",
     [('M', "M+M-M-M+M"),
      ('+', "+"),
      ('-', "-")
     ]
    )

arrowHead
  = (60,
     "N",
     [('M', "N+M+N"),
      ('N', "M-N-M"),
      ('+', "+"),
      ('-', "-")
     ]
    )

peanoGosper
  = (60,
     "M",
     [('M', "M+N++N-M--MM-N+"),
      ('N', "-M+NN++N+M--M-N"),
      ('+', "+"),
      ('-', "-")
     ]
    )

dragon
  = (45,
     "MX",
     [('M', "A"),
      ('X', "+MX--MY+"),
      ('Y', "-MX++MY-"),
      ('A', "A"),
      ('+', "+"),
      ('-', "-")
     ]
    )

snowflake
  = (60,
     "M--M--M",
     [('M', "M+M--M+M"),
      ('+', "+"),
      ('-', "-")
     ]
    )

tree
  = (45,
     "M",
     [('M', "N[-M][+M][NM]"),
      ('N', "NN"),
      ('[', "["),
      (']', "]"),
      ('+', "+"),
      ('-', "-")
     ]
    )

bush
  = (22.5,
     "X",
     [('X', "M-[[X]+X]+M[+MX]-X"),
      ('M', "MM"),
      ('[', "["),
      (']', "]"),
      ('+', "+"),
      ('-', "-")
     ]
    )

canopy
  = (30.0,
     "M",
     [('M', "M[+MM][-MM]M[-M][+M]M"),
      ('[', "["),
      (']', "]"),
      ('+', "+"),
      ('-', "-")
     ]
    )

galaxy
  = (36.0,
     "[M]++[M]++[M]++[M]++[M]",
     [('M', "+M--M---M"),
      ('[', "["),
      (']', "]"),
      ('+', "+"),
      ('-', "-")
     ]
    )

commandMap :: Rules
commandMap
  = [('M', "F"),
     ('N', "F"),
     ('X', ""),
     ('Y', ""),
     ('A', ""),
     ('[', "["),
     (']', "]"),
     ('+', "L"),
     ('-', "R")
    ]
