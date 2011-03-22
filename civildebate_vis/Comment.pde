class Comment { 
  
  void show() { 
    
    int comment_x = 350;
    int comment_y = 500;
    int popup_width = 555;
    int popup_heigth = 145;

    int rank = 6;
    int totalVotes = 352;
    String comment_text = "We all share this planet. If we have the resources to help those in need, why should the US come first?"; // 36 char/line 30 px/line
   
    int no_of_lines = comment_text.length()/36;
    println(no_of_lines);
    
    if(no_of_lines >= 2) {
      popup_heigth = popup_heigth + (no_of_lines - 1) * 30;
    }  
    
    noStroke();
    fill(252,139,124);
    
    beginShape(TRIANGLES); // h = 37
    vertex(comment_x - 25, comment_y - 37);
    vertex(comment_x, comment_y - 37);
    vertex(comment_x, comment_y);
    endShape();
    
    
    int popup_x = comment_x - (popup_width/2) + 50;
    int popup_y = comment_y - 37 - popup_heigth;

    rect(popup_x,popup_y,popup_width,popup_heigth);
    
    image(photo, popup_x+20, popup_y+20);

    fill(0);
    textFont(font_questionOfTheWeek, 14);    
    text("Jenna Smith voted for C and said:", popup_x+123, popup_y+20, 280, 65);
    textFont(font_comment, 24);    
    text(comment_text, popup_x+123, popup_y+45, 385, 565);  
    textFont(font_comment_sub, 15);    
    text("* "+rank+"TH MOST CONSTRUCTIVE * out of "+totalVotes+" total votes", popup_x+123, comment_y - 67, 385, 165);  
    
  }
}
    
