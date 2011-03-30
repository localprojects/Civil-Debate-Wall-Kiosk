import processing.core.*;
import processing.opengl.*;
import javax.media.opengl.*;
import de.looksgood.ani.*;

public class Comment { 

  PVector v1;
  public String rsentence[] = {"","","","","","","",
                         "","","","","","","",
                         "","","","","","","",
                         "","","","","","","",
                         "","","","",""};
  public int lineNo; 
  String blank = "";
  int f_in_2, f_in_3,popup_heigth;  
  String selectedAns = "";
  char lastname;
    
  public void show(PApplet canvas, DbData data, HashMap<String, PVector> coordinates) { 
    
    canvas.noTint();
    canvas.camera(width/2.0, height/2.0, (height/2.0) / tan(PI*60.0 / 360.0), width/2.0, height/2.0, 0, 0, 1, 0);    
       
    v1 = coordinates.get("bubbleOrigin");    
    int comment_x = int(v1.x);
    int comment_y = int(v1.y)+5;
    int popup_x = 500;
    int popup_y = 500;
    int popup_width = 595;
    if(photo.height > 105) popup_heigth = photo.height + 40;
    else popup_heigth = 145;
    int rank = 6;
    if(lineNo >= 2) popup_heigth = popup_heigth + ((lineNo - 1) * 31);
   
    canvas.noStroke();
    if(dbData.choice_answer_number == 1) {
      fill(139,173,240,f_in_2); // Blue
      selectedAns = "A";
    }
    if(dbData.choice_answer_number == 2) {
      fill(116,217,116,f_in_2); // Green
      selectedAns = "B";
    }
    if(dbData.choice_answer_number == 3) {
      fill(252,139,124,f_in_2); // Red
      selectedAns = "C";
    }
    canvas.beginShape(TRIANGLES); // h = 37
    canvas.vertex(comment_x - 25, comment_y - 37);
    canvas.vertex(comment_x, comment_y - 37);
    canvas.vertex(comment_x, comment_y);
    canvas.endShape();
    
    if(comment_x > 0 && comment_x <= 256)        popup_x = comment_x - 50;
    else if(comment_x > 256 && comment_x <= 512) popup_x = comment_x - 300;
    else if(comment_x > 512 && comment_x <= 768) popup_x = comment_x - 400;
    else popup_x = comment_x - 500;
    
    popup_y = comment_y - 37 - popup_heigth;

    canvas.rect(popup_x,popup_y,popup_width,popup_heigth);
    tint(255,f_in_2);
    canvas.image(photo, popup_x+20, popup_y+20);
    noTint();
    fill(0,0,0,f_in_2);
    canvas.textFont(font_comment_header);    
    if(dbData.choice_user_lastName.length() > 0) lastname = dbData.choice_user_lastName.charAt(0);
    else lastname = ' ';
    canvas.text(dbData.choice_user_firstName+" "+lastname+" voted for "+selectedAns+" and said:", popup_x+123, popup_y+20, 425, 65);
    
    
    canvas.textFont(font_comment); 
    for(int countRcSent = 0; countRcSent <= lineNo; countRcSent++) canvas.text(rsentence[countRcSent], popup_x+123, popup_y+65+(countRcSent * 30));   
    
    canvas.textFont(font_comment_sub);    
    canvas.text("* "+(data.choice_constructiveness_rank+1)+getOrdinalFor(data.choice_constructiveness_rank+1)+" MOST CONSTRUCTIVE * out of "+dbData.numTotalChoices+" total votes", popup_x+123, comment_y - 67, 385, 165);
   
     
 
  }
  
  
  public void wrap_text(PApplet canvas) { 
  
    rsentence = wordWrap(dbData.choice_comment_text, 40); 
  }  
  
  public String[] wordWrap (String s, int maxWidth) { 
   
    String sentence[] = {"","","","","","","",
                         "","","","","","","",
                         "","","","","","","",
                         "","","","","","","",
                         "","","","",""};
    float w = 0; 
    int i = 0;
    int j = 0;
    lineNo = 0; 
    int rememberSpace = 0; 
    int space1 = 0;
    int space2 = 0;
    String newS1 = "";
    String newS2 = "";
    
    // ----------------------------
    
    println(s);
    
    if(s.length() > 30) {
     
      for(j=0; j< s.length(); j++) {
      char ch = s.charAt(j);
        if(space1 == 0) {
          if (ch == ' ') space1 = j;       
        }
        else if (ch == ' ') {
          space2 = j;
          if((space2-space1) > 30) 
          {
            newS1 = s.substring(0,((space1+space2)/2));
            newS2 = s.substring(((space1+space2)/2),s.length()); 
            s = newS1+" "+newS2;
          } 
           else {
            space1 = space2;
            space2 = 0;
           }           
        }      
      }
    
    if(space1 == 0 && space1 == 0) {
      newS1 = s.substring(0,30);
      newS2 = s.substring(30,s.length());       
      s = newS1+" "+newS2;      
    }  
    
    println("space1 = "+space1);
    println("space2 = "+space2);  
     
    println("newS1 = "+newS1);
    println("newS2 = "+newS2);  
    }  
    
    
    // ----------------------------    
    
    while (i < s.length()) {
      char c = s.charAt(i);
      w += 1;
      if (c == ' ') rememberSpace = i; 
      if (w > maxWidth) { 
        String sub = s.substring(0,rememberSpace); 
        if (sub.length() > 0 && sub.charAt(0) == ' ') sub = sub.substring(1,sub.length());
        sentence[lineNo] = sub;
        lineNo += 1;     
        s = s.substring(rememberSpace,s.length());
        i = 0;
        w = 0;
      } 
      else {
        i++;  
      }
    }
  
    if (s.length() > 0 && s.charAt(0) == ' ') s = s.substring(1,s.length());
    sentence[lineNo] = s;
    
    return sentence;   
    
  }
  
  public void ani_1(PApplet canvas) {         
       f_in_2 = 0;      
       f_in_2Ani = new Ani(this, 1.0, 0, "f_in_2", 255, Ani.EXPO_IN_OUT);
  }
  
  public void ani_o(PApplet canvas) {  
       f_in_2 = 255;
       f_in_2Ani = new Ani(this, 1.0, 0, "f_in_2", 0, Ani.EXPO_IN_OUT);
  } 
  
  public String getOrdinalFor(int value) {
 int tenRemainder = value % 10;
 switch (tenRemainder) {
  case 1:
   return "ST";
  case 2:
   return "ND";
  case 3:
   return "RD";
  default:
   return "TH";
 }
  }

}

