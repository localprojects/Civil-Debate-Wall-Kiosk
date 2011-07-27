import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import javax.swing.Timer;
import javax.swing.JComponent;
import javax.swing.JFrame;
import JMyron.*;

public class Main {
	
	public JMyron m;//a camera object
	
  public static void main(String[] args) {
    System.out.println("I'm a Simple Program");
    Main main = new Main();
  }
  
  public Main() {
  	m = new JMyron();//make a new instance of the object
//    m.start(320,240);//start a capture at 320x240
//    //m.findGlobs(0);//disable the intelligence to speed up frame rate
//		System.out.println("Myron " + m.version());    
//    
  }
}