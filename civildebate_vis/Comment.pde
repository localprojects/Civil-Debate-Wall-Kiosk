import processing.core.*;
import processing.opengl.*;
import javax.media.opengl.*;

public class Comment { 

  public void show(PApplet canvas, DbData data) { 

    canvas.noTint();
    canvas.camera(width/2.0, height/2.0, (height/2.0) / tan(PI*60.0 / 360.0), width/2.0, height/2.0, 0, 0, 1, 0);

    int comment_x = 550;
    int comment_y = 600;
    int popup_width = 555;
    int popup_heigth = 145;
    int rank = 6;
    int no_of_lines = dbData.choice_comment_text.length()/36;
    if(no_of_lines >= 2) {
      popup_heigth = popup_heigth + (no_of_lines - 1) * 30;
    }  

    canvas.noStroke();
    if(dbData.choice_answer_number == 1) fill(139,173,240); // Blue
    if(dbData.choice_answer_number == 2) fill(116,217,116); // Green
    if(dbData.choice_answer_number == 3) fill(252,139,124); // Red
    
    canvas.beginShape(TRIANGLES); // h = 37
    canvas.vertex(comment_x - 25, comment_y - 37);
    canvas.vertex(comment_x, comment_y - 37);
    canvas.vertex(comment_x, comment_y);
    canvas.endShape();

    int popup_x = comment_x - (popup_width/2) + 50;
    int popup_y = comment_y - 37 - popup_heigth;

    canvas.rect(popup_x,popup_y,popup_width,popup_heigth);
    canvas.image(photo, popup_x+20, popup_y+20);

    fill(0);
    canvas.textFont(font_questionOfTheWeek, 14);    
    canvas.text(dbData.choice_user_firstName+" "+dbData.choice_user_lastName+" voted for C and said:", popup_x+123, popup_y+20, 280, 65);
    canvas.textFont(font_comment, 24);    
    canvas.text(dbData.choice_comment_text, popup_x+123, popup_y+45, 385, 565);  
    canvas.textFont(font_comment_sub, 15);    
    canvas.text("* "+rank+"TH MOST CONSTRUCTIVE * out of "+dbData.numTotalChoices+" total votes", popup_x+123, comment_y - 67, 385, 165);
  }
}

