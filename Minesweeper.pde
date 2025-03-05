import de.bezier.guido.*;
public final static int NUM_ROWS = 10;
public final static int NUM_COLS = 10;
public final static float NUM_MINES = (NUM_ROWS * NUM_COLS) * 0.3;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup () {
  size(400, 400);
  textAlign(CENTER,CENTER);
    
  // make the manager
  Interactive.make( this );
    
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for(int j = 0; j < buttons.length; j++) {
    for(int k = 0; k < buttons[j].length; k++) {
      buttons[j][k] = new MSButton(j, k);
    }
  }
  setMines();
}
public void setMines() {
  int rows = (int)(Math.random()*NUM_ROWS);
  int cols = (int)(Math.random()*NUM_COLS);
  int mine_length = mines.size();
  while(mine_length < NUM_MINES) {
    if(!mines.contains(buttons[rows][cols])) {
      mines.add(buttons[rows][cols]);
      rows = (int)(Math.random()*NUM_ROWS);
      cols = (int)(Math.random()*NUM_COLS);
      mine_length++;
    }
    rows = (int)(Math.random()*NUM_ROWS);
    cols = (int)(Math.random()*NUM_COLS);
  }
}

public void draw() {
  background( 0 );
  if(isWon() == true)
      displayWinningMessage();
}

public boolean isWon() {
  //your code here
  return false;
}

public void displayLosingMessage() {
  text("trash", 200, 300);
}

public void displayWinningMessage() {
  text("you're so good", 200, 300);
}

public boolean isValid(int r, int c) {
  if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  }
  return false;
}

public int countMines(int row, int col) {
  int numMines = 0;
  int[][] grid = new int[NUM_ROWS][NUM_COLS];
  for(int j = -1; j <= 1; j++) {
    for(int k = -1; k <= 1; k++) {
      if(j == 0 && k == 0) {
        continue;
      }
      int newRow = row + j;
      int newCol = col + k;
      if(isValid(newRow, newCol) && grid[newRow][newCol] == NUM_MINES) {
        numMines++;
      }
    }
  }
  return numMines;
}

public class MSButton {
  private int myRow, myCol;
  private float x,y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
    
  public MSButton ( int row, int col ) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    clicked = true;
    if(mouseButton == RIGHT) {
      if(flagged == false) {
        flagged = true;
      }
      flagged = clicked = false;
    } 
    else if(mines.contains(this)) {
      displayLosingMessage();
    }
  }
  public void draw () {    
    if (flagged)
        fill(0);
    else if( clicked && mines.contains(this) ) 
        fill(255,0,0);
    else if(clicked)
        fill( 200 );
    else 
        fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel,x+width/2,y+height/2);
  }
  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged() {
    return flagged;
  }
}
