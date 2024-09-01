
mutable struct Snake
    x_coords::Vector{Float64}  # List of x-coordinates of the snake's body segments
    y_coords::Vector{Float64}  # List of y-coordinates of the snake's body segments
    direction::Tuple{Float64, Float64}  # Current direction of the snake (as a vector)
    speed::Float64  # Speed of the snake
end
mutable struct Food
    init_x::Float64
    init_y::Float64
    type::Float64
    lifeTime::Float64
end

mutable struct Background
    background::String
end
background=Background("background.jpg")
#Window
WIDTH=720
HEIGHT=680
BACKGROUND= background.background
play_music("radetzky_ogg")
radius = 20
BORDER_THICKNESS = 1.0 #thickness of the borders
LIFETIME=150

#status
MENU=0
PLAY=1
GAMEOVER=2
WINNER=3
mutable struct Status
    status::Int 
end
gameState=Status(MENU)



#bacgrounds
txt = TextActor("Press SPACE to start the game", "moonhouse")
txt.pos = (120,180)
a=Actor("menu.jpg")
a.pos=(WIDTH/4,HEIGHT/3)   
b=Actor("gameover.jpg")
b.pos=(WIDTH/4,HEIGHT/3)
c=Actor("win.jpg")
c.pos=(WIDTH/6,HEIGHT/3) 

#score
mutable struct Score
    score::Int
end
score=Score(0)


#Directions
RIGHT=(1,0) 
LEFT=(-1,0)
DOWN=(0,1)
UP=(0,-1)
#counter
mutable struct Counter
    counter::Int
end
count=Counter(500)
#size of the blocks
BlockSize=40

# Initial snake setup
initial_x=[5, 4]
initial_y=[5, 5]
initial_direction = RIGHT # Moving to the RIGHT
initial_speed = 2.0
snake = Snake(initial_x, initial_y, initial_direction, initial_speed)
move_counter = 0  # Counter to control snake movement timing
move_interval = 10 # Number of frames between each snake movement

#initial goodFood setup
goodFood=Food(9,7,0,LIFETIME)
#initial badFood setup
badFood=Food(13,8,1,LIFETIME)
#initial neutralFood setup
neutralFood=Food(15,6,2,LIFETIME)




function draw(g::Game)
    
      drawBoard()
    if  gameState.status==1

        # Update the move counter
       global move_counter
       if move_counter % move_interval == 0
           moveSnake(snake)
         count.counter-=1
           
        
       end
        move_counter += 1

    
        # Draw the snake
        drawSnake(snake)

        # Draw the food
        drawFood(goodFood)
        drawFood(badFood)
        drawFood(neutralFood)
        onCollision(snake,goodFood)
        onCollision(snake,badFood)
        onCollision(snake,neutralFood)
    end
end

function drawSnake(snake::Snake)
    for i in 1:length(snake.x_coords)
        x=snake.x_coords[i]
        y=snake.y_coords[i]
        rect = Rect(x*BlockSize, y*BlockSize, BlockSize, BlockSize)
        GameZero.draw(rect, colorant"green", fill=true)
        border_rect=Rect(x*BlockSize-BORDER_THICKNESS, y*BlockSize-BORDER_THICKNESS, BlockSize+BORDER_THICKNESS, BlockSize+BORDER_THICKNESS)
        GameZero.draw(border_rect, colorant"black", fill=false)
    end
end

function moveSnake(snake::Snake)
    # Move the snake by adding the current direction vector to the head's position
    head_x, head_y = snake.x_coords[1], snake.y_coords[1]
    new_head_x = head_x + snake.direction[1]
    new_head_y = head_y + snake.direction[2]

    # Handle wall collisions (wrap around the screen)
    new_head_x = new_head_x < 0 ? WIDTH / BlockSize - 1 : new_head_x
    new_head_y = new_head_y < 0 ? HEIGHT / BlockSize - 1 : new_head_y
    new_head_x = new_head_x % (WIDTH/BlockSize)
    new_head_y = new_head_y % (HEIGHT/BlockSize)

    # Add the new head to the front of the snake
    snake.x_coords = [new_head_x; snake.x_coords]
    snake.y_coords = [new_head_y; snake.y_coords]
    # Remove the last segment of the snake
    snake.x_coords = snake.x_coords[1:end-1]
    snake.y_coords = snake.y_coords[1:end-1]
end

 function drawFood(food::Food)
    rect = Rect(food.init_x *BlockSize, food.init_y*BlockSize, BlockSize, BlockSize)
    if(food.type==0)
        GameZero.draw(rect, colorant"blue", fill=true)
    
   elseif(food.type==1)
    GameZero.draw(rect, colorant"yellow", fill=true)

   elseif(food.type==2)
    GameZero.draw(rect, colorant"red", fill=true)
 end
 food.lifeTime-=1
 generateFood(food)


end

function generateFood(food::Food)
  if (food.lifeTime==0) 
    food.init_x=rand(2:18)
    food.init_y=rand(2:18)
    food.lifeTime=LIFETIME
end

end

function drawBoard()

    if(isGameOver())
        gameState.status=GAMEOVER
end

    if gameState.status==MENU
    GameZero.draw(a)
    txt = TextActor("Press SPACE to start the game", "moonhouse")
    txt.pos = (120,180)
    GameZero.draw(txt)
    GameZero.draw(a)
# snakeGame on the title
    txt = TextActor("Snake Game", "moonhouse")
    txt.pos = (120,200)
    GameZero.draw(txt)
    elseif gameState.status==PLAY 
        #draw counter
        txt = TextActor("Counter: $(count.counter)", "moonhouse")
        txt.pos = (10,10)
        GameZero.draw(txt)
        txt=TextActor("Score: $(score.score)", "moonhouse")
        txt.pos=(10,40)
        GameZero.draw(txt)
       
    elseif gameState.status==GAMEOVER
        GameZero.draw(b)
        txt = TextActor("Game Over  Press R to resetGame the Game", "moonhouse")
        txt.pos = (10,100)
        GameZero.draw(txt)
    elseif gameState.status==WINNER
        GameZero.draw(c)
        txt = TextActor("You Win  Press R to resetGame the Game", "moonhouse")
        txt.pos = (10,180)
        GameZero.draw(txt)      
end
end

function isGameOver()
 if (count.counter==0 && score.score<10) || (score.score<0)
    return true
 elseif (score.score>=10)
    gameState.status=WINNER
    return false
end
 return false
end

#collisions
function checkCollisions(snake::Snake, food::Food)
    #check if snake eats itself
    for i in 2:length(snake.x_coords)
        if snake.x_coords[1] == snake.x_coords[i] && snake.y_coords[1] == snake.y_coords[i]
            gameState.status=GAMEOVER
        end
    end
    head_x, head_y = snake.x_coords[1], snake.y_coords[1]
    food_x, food_y = food.init_x, food.init_y
    return head_x == food_x && head_y == food_y
end
#increase in size
function increaseSize(snake::Snake)
    if(snake.direction==UP)
        pushfirst!(snake.y_coords,snake.y_coords[1]-1)
        pushfirst!(snake.x_coords,snake.x_coords[1])
    elseif(snake.direction==DOWN)
        pushfirst!(snake.y_coords,snake.y_coords[1]+1)
        pushfirst!(snake.x_coords,snake.x_coords[1])
    elseif(snake.direction==LEFT)
        pushfirst!(snake.y_coords,snake.y_coords[1])
        pushfirst!(snake.x_coords,snake.x_coords[1]-1)
    elseif(snake.direction==RIGHT)
        pushfirst!(snake.y_coords,snake.y_coords[1])
        pushfirst!(snake.x_coords,snake.x_coords[1]+1)
    end
end    

# decrease in size  
    function decreaseSize(snake :: Snake)
        pop!(snake.x_coords)
        pop!(snake.y_coords)
    end

function onCollision(snake::Snake, food::Food)
    if checkCollisions(snake, food) && gameState.status==PLAY
        food.lifeTime=0
        if (food.type==0)
            increaseSize(snake)
            score.score=score.score+1
            generateFood(food)
        elseif (food.type==1)
            decreaseSize(snake)
            score.score=score.score-1
            generateFood(food) 
        elseif (food.type==2)
            generateFood(food)
        end
    end
end     



function resetGame()
    count.counter=500
    score.score=0
    gameState.status=MENU
    snake.x_coords = initial_x
    snake.y_coords = initial_y
    snake.direction = initial_direction
    snake.speed = initial_speed
    goodFood.init_x=9
    goodFood.init_y=7
    goodFood.lifeTime=LIFETIME
    badFood.init_x=13
    badFood.init_y=8
    badFood.lifeTime=LIFETIME
    neutralFood.init_x=15
    neutralFood.init_y=6
    neutralFood.lifeTime=LIFETIME
end

function on_key_down(g, k)
    if (k == Keys.SPACE && gameState.status==MENU )
        gameState.status=1
    elseif ( k == Keys.UP && snake.direction != DOWN)
        snake.direction = UP
    elseif ( k == Keys.DOWN && snake.direction != UP)
        snake.direction = DOWN
     elseif ( k == Keys.LEFT && snake.direction != RIGHT)
        snake.direction = LEFT
     elseif ( k == Keys.RIGHT && snake.direction != LEFT)
        snake.direction = RIGHT
    elseif  ( k == Keys.R && gameState.status==GAMEOVER) || ( k == Keys.R && gameState.status==WINNER)
        resetGame()   
 else 
        print("Invalid key")     
    end                  
end




    
   
