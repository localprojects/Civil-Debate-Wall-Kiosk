import processing.core.*;
import processing.opengl.*;
import javax.media.opengl.*;

public class UI { 

  public void display(PApplet canvas, DbData data) {

    canvas.camera(width/2.0, height/2.0, (height/2.0) / tan(PI*60.0 / 360.0), width/2.0, height/2.0, 0, 0, 1, 0);      
    canvas.noTint();
    
    int img_a = 0;
    int img_b = 0;
    int img_c = 0;
    int selected = 1;
    
    // Logo
    canvas.image(logo, 712, 0);    
    
    // Question   
    fill(255,255,255);
    canvas.textFont(font_questionOfTheWeek);
    canvas.text("Question of the week:", 10, 18);
 
    fill(255,226,138); // Yellow
    canvas.textFont(font_question, 28);
    canvas.text(dbData.question_text, 10, 32, 675, 150);    
         
    img_a = 10;
    img_b = img_a + 350;
    img_c = img_a + 686;

    // A
    canvas.image(a, img_a, 128);
    fill(139,173,240); // Blue
    canvas.textFont(font_answer, 17);        
    canvas.text(dbData.answer_text[0], img_a + 35, 133, 280, 65);  
    fill(87,109,150);
    canvas.textFont(font_vote_count, 22);        
    canvas.text(dbData.numTotalChoicesPerAnswer[0]+" votes", img_a + 35, 222); 
 
     // B
    canvas.image(b, img_b, 128);
    fill(116,217,116); // Green
    canvas.textFont(font_answer, 17);    
    canvas.text(dbData.answer_text[1], img_b + 35, 133, 280, 65);
    fill(69,130,69);
    canvas.textFont(font_vote_count, 22);        
    canvas.text(dbData.numTotalChoicesPerAnswer[1]+" votes", img_b + 35, 222); 
   
    // C
    canvas.image(c, img_c, 128);
    fill(252,139,124); // Red 
    canvas.textFont(font_answer, 17);   
    canvas.text(dbData.answer_text[2], img_c + 35, 133, 280, 65);
    fill(166,91,81);
    canvas.textFont(font_vote_count, 22);        
    canvas.text(dbData.numTotalChoicesPerAnswer[2]+" votes", img_c + 35, 222);  
    
  }
}

