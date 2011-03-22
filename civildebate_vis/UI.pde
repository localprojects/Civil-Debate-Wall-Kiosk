class UI { 

  void display() {

    int img_a = 0;
    int img_b = 0;
    int img_c = 0;
    int selected = 1;
    
    // Logo
    image(logo, 712, 0);    
    
    // Question   
    fill(255,255,255);
    textFont(font_questionOfTheWeek, 14);
    text("Question of the week:", 10, 15);
 
    fill(255,226,138); // Yellow
    textFont(font_question, 28);
    text("Do you think the U.S. is morally obligated to provide foreign aid to developing nations?", 10, 32, 675, 150);    
    

    if(selected == 1) {
      img_b = 10;
      img_a = img_b + 350;
      img_c = img_b + 686;
    }  
    else {
      img_a = 10;
        if(selected == 3) {
          img_b = img_a + 686;
          img_c = img_a + 350;
        } 
        else if(selected == 2) {      
          img_b = img_a + 350;
          img_c = img_a + 686;
        }    
    } 
          
    // A
    image(a, img_a, 128);
    fill(139,173,240); // Blue
    textFont(font_answer, 17);        
    text("Yes, we are still one of the wealthiest nations in the world and we can't stand idly by when people are suffering.", img_a + 35, 133, 280, 65);  
    
    // C
    image(c, img_c, 128);
    fill(252,139,124); // Red 
    textFont(font_answer, 17);   
    text("No, we have enough problems here that we shouldn't be giving money to other countries.", img_c + 35, 133, 280, 65);
    
    // B
    image(b, img_b, 128);
    fill(116,217,116); // Green
    textFont(font_answer, 17);    
    text("We are only morally obliged to help in emergency circumstances, such as after earthquakes or draughts.", img_b + 35, 133, 280, 65);

    //text("Total Votes: 520", 100, 460);         
  }
}

