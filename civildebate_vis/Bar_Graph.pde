import processing.core.*;
import processing.opengl.*;
import javax.media.opengl.*;

public class Bar_Graph {   
  
  int one_a, one_b, one_c, i_a, i_b, i_c, f_in, f_in_1;  
  
  public void plot(PApplet canvas, DbData data) {  
    
    smooth(); 
    noStroke();
     
    int bar_x = 12;
    int bar_y = 239;
    
    int total = dbData.numTotalChoices;
    int p_a, p_c, p_b, x_b, x_c;
    
    p_a = (dbData.numTotalChoicesPerAnswer[0] * 880)/ total;
    p_b = (dbData.numTotalChoicesPerAnswer[1] * 880)/ total;
    p_c = (880 - (p_a + p_b + 10));
      
    x_b = (p_a + bar_x);
    x_c = (p_a + p_b + bar_x);
    
    fill(0); 
    rect(0, bar_y +33, 1024, 50);
  
    fill(87,109,150); // blue
    rect(bar_x, bar_y, p_a, 19);
    
    fill(69,130,69); // green
    rect(x_b, bar_y, p_b, 19);
      
    fill(166,91,81); // red
    rect(x_c, bar_y, p_c, 19);
      
    if(dbData.choice_answer_number != 1 && one_a > 14) { 
        fill (139, 173, 240); //BLUE     
        rect(bar_x, 244, i_a, 14);
        fill (139, 173, 240, f_in_1); //BLUE fade in
        triangle((bar_x + (i_a / 2 - 7)), bar_y + 19, (bar_x + (i_a / 2 + 7)), bar_y + 19, (bar_x + i_a /2), bar_y + 33);   
        canvas.textFont(font_idea_constructive);        
        canvas.text(dbData.numPositiveRatingsPerAnswer[0]+" found "+dbData.choice_user_firstName+"'s", (bar_x+(i_a/2))-25 , bar_y + 55);
        canvas.text("idea constructive", (bar_x+(i_a/2))-25, bar_y + 80);
    }  
    
    if(dbData.choice_answer_number != 2 && one_b > 14) {
        fill (116, 217, 116);//GREEN
        rect(x_b, 244, one_b, 14);
        fill (116, 217, 116, f_in_1);//GREEN fade in
        triangle((x_b + (i_b / 2 - 7)), bar_y + 19, (x_b + (i_b / 2 + 7)), bar_y + 19, (x_b + i_b /2), bar_y + 33);  
        canvas.textFont(font_idea_constructive);        
        canvas.text(dbData.numPositiveRatingsPerAnswer[1]+" found "+dbData.choice_user_firstName+"'s", (x_b+(i_b/2))-25 , bar_y + 55);
        canvas.text("idea constructive", (x_b+(i_b/2))-25, bar_y + 80);
    }
    
    if(dbData.choice_answer_number != 3 && one_c > 14) {
        fill (252, 139, 124);//RED
        rect(x_c, 244, one_c, 14);
        fill (252, 139, 124, f_in_1);//RED fade in
        triangle((x_c + (i_c / 2 - 7)), bar_y + 19, (x_c + (i_c / 2 + 7)), bar_y + 19, (x_c + i_c /2), bar_y + 33);  
        canvas.textFont(font_idea_constructive);        
        canvas.text(dbData.numPositiveRatingsPerAnswer[2]+" found "+dbData.choice_user_firstName+"'s", (x_c+(i_c/2))-25 , bar_y + 55);
        canvas.text("idea constructive", (x_c+(i_c/2))-25, bar_y + 80);
    }
  
    // Total votes text
    fill(0);
    canvas.rect ( 895, bar_y - 3, 130, 25);
    fill(255);
    canvas.textAlign(RIGHT);
    canvas.textFont(font_vote_count);       
    canvas.text(total+" total votes", 1005, bar_y + 18);
    canvas.textAlign(LEFT);
   }
   
    public void ani(PApplet canvas) {  
       one_a = 0;
       one_b = 0;
       one_c = 0;
       f_in_1 = 0;
     
       i_a = (dbData.numPositiveRatingsPerAnswer[0] * 100) / dbData.numTotalChoicesPerAnswer[0];
       i_b = (dbData.numPositiveRatingsPerAnswer[1] * 100) / dbData.numTotalChoicesPerAnswer[1];
       i_c = (dbData.numPositiveRatingsPerAnswer[2] * 100) / dbData.numTotalChoicesPerAnswer[2];
     
       one_aAni = new Ani(this, 2.0, "one_a", i_a, Ani.EXPO_IN_OUT);
       one_bAni = new Ani(this, 2.0, "one_b", i_b, Ani.EXPO_IN_OUT);
       one_cAni = new Ani(this, 2.0, "one_c", i_c, Ani.EXPO_IN_OUT); 
       
       f_in_1Ani = new Ani(this, 5.0, "f_in_1", 255, Ani.EXPO_IN_OUT);   
    }
    
    public void anio(PApplet canvas) {  
      f_in_1 = 255;
      f_inAni = new Ani(this, 1.5, "f_in_1", 0, Ani.EXPO_IN_OUT);
      
      one_aAni = new Ani(this, 2.0, "one_a", 0, Ani.EXPO_IN_OUT);
      one_bAni = new Ani(this, 2.0, "one_b", 0, Ani.EXPO_IN_OUT);
      one_cAni = new Ani(this, 2.0, "one_c", 0, Ani.EXPO_IN_OUT);     
    }     
        
}

