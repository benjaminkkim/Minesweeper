import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static float NUM_MINES = (NUM_ROWS * NUM_COLS) * .13;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;
private boolean gameLost = false;

void setup () {
  size(400, 400);
  textAlign(CENTER,CENTER);
  Interactive.make(this);
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for(int j = 0; j < buttons.length; j++) {
    for(int k = 0; k < buttons[j].length; k++) {
      buttons[j][k] = new MSButton(j, k);
    }
  }
  setMines(NUM_ROWS, NUM_COLS);
}

public void setMines(int notInRow, int notInCol) {
  while(mines.size() < NUM_MINES) {
    int rows = (int)(Math.random()*NUM_ROWS);
    int cols = (int)(Math.random()*NUM_COLS);
    if(rows == notInRow && cols == notInCol || mines.contains(buttons[rows][cols])) {
      continue;
    }
    mines.add(buttons[rows][cols]);
  }
}

public void draw() {
  background(0);
  if(gameOver == true) {
    return;
  }
  for(int j = 0; j < NUM_ROWS; j++) {
    for(int k = 0; k < NUM_COLS; k++) {
      buttons[j][k].draw();
    }
  }
  if(isWon() == true) {
    displayWinningMessage();
    gameOver = true;
  }
  if(gameLost == true) {
    displayLosingMessage();
    gameOver = true;
  }
}

public boolean isWon() {
  for(int j = 0; j < NUM_ROWS; j++) {
    for(int k = 0; k < NUM_COLS; k++) {
      MSButton button = buttons[j][k];
      if(!mines.contains(button) && !button.isClicked()) {
        return false;
      }
    }
  }
  return true;
}

public void keyPressed() {
  if(key == 'w' || key == 'W') {
    gameOver = true;
    displayWinningMessage();
  }
  if(key == 'l' || key == 'L') {
    gameOver = true;
    displayLosingMessage();
  }
}

public void displayLosingMessage() {
  for(int i = 0; i < mines.size(); i++) {
    mines.get(i).showMines();
  }
  buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("u");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("r");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-2].setLabel(" ");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-1].setLabel("t");
  buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("r");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+1].setLabel("a");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+2].setLabel("s");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+3].setLabel("h");
}

public void displayWinningMessage() {
  buttons[NUM_ROWS/2][(NUM_COLS/2)-8].setLabel("u");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-7].setLabel("r");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-6].setLabel(" ");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-5].setLabel("s");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("o");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel(" ");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-2].setLabel("g");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-1].setLabel("o");
  buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("o");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+1].setLabel("d");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+2].setLabel(" ");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+3].setLabel("w");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+4].setLabel("o");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+5].setLabel("w");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+6].setLabel("i");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+7].setLabel("e");
}

public boolean isValid(int r, int c) {
  if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  }
  return false;
}

public int countMines(int row, int col) {
  int numMines = 0;
  for(int j = -1; j <= 1; j++) {
    for(int k = -1; k <= 1; k++) {
      if(j == 0 && k == 0) {
        continue;
      }
      int newRow = row + j;
      int newCol = col + k;
      if(isValid(newRow, newCol) && mines.contains(buttons[newRow][newCol])) {
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
    Interactive.add(this); // register it with the manager
  }
  public void mousePressed () {
    if(gameOver == true) {
      return;
    }
    clicked = true;
    if(mines.isEmpty()) {
      setMines(myRow, myCol);
    }
    if(mouseButton == RIGHT) {
      flagged = !flagged;
    }
    else if(mines.contains(this)) {
      gameLost = true;
      displayLosingMessage();
      gameOver = true;
    }
    else if(countMines(myRow, myCol) > 0) {
      myLabel = "" + countMines(myRow, myCol);
    }
    else if(mouseButton == LEFT && countMines(myRow, myCol) == 0) {
      myLabel = "";
      for(int j = -1; j <= 1; j++) {
        for(int k = -1; k <= 1; k++) {
          if(j == 0 && k == 0) {
            continue;
          }
          int newRow = myRow + j;
          int newCol = myCol + k;
          if(isValid(newRow, newCol)) {
            MSButton neighboringButton = buttons[newRow][newCol];
            if(!neighboringButton.isClicked()) {
              neighboringButton.mousePressed();
            }
          }
        }
      }
    }
  }
  public void draw() {
    if (flagged)
        fill(0);
    else if( clicked && mines.contains(this)) 
        fill(255,0,0);
    else if(clicked)
        fill(200);
    else 
        fill(100);

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
  public boolean isClicked() {
    return clicked;
  }
  public void showMines() {
  clicked = true;
  }
}
