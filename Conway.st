Morph subclass: #GameOfLifeMorph
	"Set the value to all cells"
     content atAllPut: value.! !
	"Verifies the rules of the Game Of Life"
	| tmp |

	1 to: rows do:  [ :row | 
		1 to: columns do:  [ :column |
			nextGrid at: row at: column put: (self getNextGenerationFor: row column: column).
			 ]
      ].
      tmp := content.
      content := nextGrid.
      nextGrid := tmp.
      self changed.! !
	"Sets the row and column count of the grid"
       rows := rowCount.
       columns := columnCount.
       content := Matrix  rows: rows columns: columns.
       nextGrid :=Matrix rows: rows columns: columns.
       content atAllPut: 0.
       mouseInteraction := false.
       self stopStepping.
       ^self.! !
     ^mouseInteraction.! !
	      |cellRow cellColumn valueToSet|  
	 
	      cellRow :=  (((anEvent cursorPoint y) - (bounds top))/ self height ) asFloat * rows.
	      cellRow := cellRow truncated.
	      cellColumn :=(  ((anEvent cursorPoint x) - (bounds left))/ self width) asFloat * columns.
	      cellColumn := cellColumn truncated.
            valueToSet :=  ((content at: (cellRow + 1) at: (cellColumn + 1)) = 0) ifTrue: [ 1 ] ifFalse: [ 0 ].
	      content at: (cellRow + 1) at: (cellColumn + 1) put: valueToSet.

	      self changed.! !
     mouseInteraction := true.! !
	"Disables modifying the grid using a mouse click"
     mouseInteraction := false.! !
	"Draws the game of life widget with the current state"

	| cellWidth cellHeight rectangle  cellColor cellValue|
	
	cellWidth :=   (self width) / columns.
	cellHeight :=   (self height) / rows.
      1 to: rows do: [ :row |
	       1 to: columns do: [ :column |
		      cellValue := (content at: row at: column).
		      cellColor := cellValue = 1 ifTrue: [ Color black ] ifFalse: [ Color white  ].
                  rectangle := Rectangle left: (self bounds left) + ((column - 1)*cellWidth) 
                                                      right: (self bounds left) + ((column - 1)*cellWidth) + cellWidth
                                                      top: (self bounds top) + ((row - 1)*cellHeight )
                                                      bottom: (self bounds top) + ((row - 1)*cellHeight ) + cellHeight.
         
		      cellValue = 1 ifTrue: [canvas fillRectangle:  rectangle color:  cellColor]
		                           ifFalse: [canvas frameAndFillRectangle: rectangle 
			                                              fillColor:  (Color white) 
			                                              borderWidth: 1 
			                                              borderColor: (Color black)].
             ]
       ].
  	^self.! !
	"Gets the value of the specified cell"
      ^ ((row < 1) | (row > rows) | (column > columns) | (column < 1))
            ifTrue: [ 0 ]
            ifFalse: [ content at: row at: column ] .! !
	"Verifies the Game Of Life rules"
      |topLeft top topRight left right bottomLeft bottomRight bottom neighbors|

      topLeft :=  self getCellValue: (row - 1) column: (column - 1).
      top := self getCellValue: (row - 1) column: column.
      left := self getCellValue: row column: (column - 1).
      right := self getCellValue: row column: (column + 1).
      topRight := self getCellValue: (row - 1) column: (column + 1).
      bottomRight := self getCellValue: (row + 1) column: (column + 1).
      bottom := self getCellValue: (row + 1) column: column.
      bottomLeft := self getCellValue: (row + 1) column: (column - 1).
   
      neighbors := topLeft + top + left + right + topRight + bottomRight + bottom  + bottomLeft.

      ^ ((content at: row at: column) = 1) 
             ifTrue: [ (neighbors < 2 | (neighbors > 3)) ifTrue: [ 0 ] ifFalse: [ 1 ]  ] 
             ifFalse: [ (neighbors = 3) ifTrue: [ 1 ] ifFalse: [ 0 ] ].
! !
	"Creates a new instance of the widget"

	| newInstance  |
	newInstance := GameOfLifeMorph new.
	newInstance rows: rowCount
                          columns: columnCount.	                   
	^newInstance.! !