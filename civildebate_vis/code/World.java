import processing.core.*;
import processing.opengl.PGraphicsOpenGL;
import java.io.File;
import java.util.*;
import java.util.Map.Entry;
import javax.media.opengl.GL;

public class World
{
   public static HashMap<String, ArrayList<PImage>> silhouettes;
   public static HashMap<String, ArrayList<Shape>> shapes;
   static String colormap[] = {"Red", "Green", "Blue"}; 
   static int NUM_ANSWERS = 3;
   
   static class ZComparator implements Comparator<Shape>
   {
      public int compare(Shape s1, Shape s2)
      {
         if(s1.origin.z < s2.origin.z)
            return -1;
         else if(s1.origin.z > s2.origin.z)
            return 1;
         else
            return 0;
      }
   }
   
   public static void init(PApplet canvas)
   {
      
      shapes = new HashMap<String, ArrayList<Shape>>();
      
      shapes.put("Blue", new ArrayList<Shape>());
      shapes.put("Red", new ArrayList<Shape>());
      shapes.put("Green", new ArrayList<Shape>());
      
      silhouettes = new HashMap<String, ArrayList<PImage>>();
      
      silhouettes.put("Blue/Androgynous", new ArrayList<PImage>());
      silhouettes.put("Blue/Men", new ArrayList<PImage>());
      silhouettes.put("Blue/Women", new ArrayList<PImage>());
      silhouettes.put("Green/Androgynous", new ArrayList<PImage>());
      silhouettes.put("Green/Men", new ArrayList<PImage>());
      silhouettes.put("Green/Women", new ArrayList<PImage>());
      silhouettes.put("Red/Androgynous", new ArrayList<PImage>());
      silhouettes.put("Red/Men", new ArrayList<PImage>());
      silhouettes.put("Red/Women", new ArrayList<PImage>());
      
      for(Entry<String, ArrayList<PImage>> e : silhouettes.entrySet())
      {
         //File root = new File("../..");
         File f = new File("data/Silhouettes/" + e.getKey());
        //         File f = new File("."); 
          //       canvas.println(f.getAbsolutePath()); 
         canvas.println(f.getAbsolutePath() + " -- " + f.isDirectory());       
         File files[] = f.listFiles();       
         int i = 0;        
         for(File file : files)
         {
           //if(i > 3) break;
            e.getValue().add(canvas.loadImage(file.getPath()));
            i++;
         } 
      }  
   }
   
   public static void generateView(PApplet canvas, DbData data)
   {
      int active = 0; //RED
      int total[] = {0, 10, 4};
      for(int i = 0; i < NUM_ANSWERS; i++)
      {
            ArrayList<PImage> pics = silhouettes.get(colormap[i] + "/Androgynous");
            pics.addAll(silhouettes.get(colormap[i] + "/Men"));
            pics.addAll(silhouettes.get(colormap[i] + "/Women"));
            
            shapes.get(colormap[i]).clear();

            Collections.shuffle(pics);
            // TODO still faking it a bit
            for(int n = 0; n < data.numTotalChoicesPerAnswer[i] + 5; n++)
            {
               Shape s = new Shape(new PVector(canvas.random((i-1)*300 + 350, (i-1)*300 + 700), 650, canvas.random(-400, 0)), 
                     pics.get(n % pics.size()),
                     i);
               shapes.get(colormap[i]).add(s);
           
            }
      }
   }
   
   public static void draw(PApplet canvas, DbData data)
   {
      float aspect = (canvas.width)/(canvas.height);
      //canvas.perspective(canvas.PI/2.0f, (int)(canvas.width/canvas.height), 1.0f, 100000.0f) ; 
     //canvas.camera(.0f, 10.0f, 300.0f,
      //               .0f, .0f, .0f,
     //                .0f, 1.0f, .0f);
     // canvas.camera(canvas.width/2.0, canvas.height/2.0, (canvas.height/2.0), canvas.width/2.0, canvas.height/2.0, 0, 0, 1, 0);
      canvas.color(255);
      canvas.textureMode(PApplet.NORMALIZED);
      float ratio = 2.85f;  
      ArrayList<Shape> allShapes = new ArrayList<Shape> ();    
      for(int i = 0; i < NUM_ANSWERS; i++)
      {
         ArrayList<Shape> shapeList = shapes.get(colormap[i]);     
         allShapes.addAll(shapeList);
      }
      
      Collections.sort(allShapes, new ZComparator()); 
      canvas.noStroke();  
      for(Shape shape : allShapes)
      {
         //canvas.println(shape.origin.z);       
         canvas.pushMatrix();     
         canvas.beginShape(canvas.QUADS);   
            //canvas.colorMode(canvas.HSB);
            int brightness = (int)shape.origin.z/4+100;
            //canvas.tint(shape.answer == 0 ? brightness : 0, shape.answer == 1 ? brightness : 0, shape.answer == 2 ? brightness : 0 );
            canvas.tint(brightness);
            //canvas.colorMode(canvas.RGB);  
            canvas.texture(shape.texture);        
            canvas.normal(.0f, .0f, 1.0f);
            canvas.vertex(shape.origin.x + 50, shape.origin.y + 50 * ratio, shape.origin.z, 0, 1);    
            canvas.normal(.0f, .0f, 1.0f);
            canvas.vertex(shape.origin.x + 50, shape.origin.y - 50 * ratio, shape.origin.z, 0, 0);
            canvas.normal(.0f, .0f, 1.0f);
            canvas.vertex(shape.origin.x - 50, shape.origin.y - 50 * ratio, shape.origin.z, 1, 0);
            canvas.normal(.0f, .0f, 1.0f);
            canvas.vertex(shape.origin.x - 50, shape.origin.y + 50 * ratio, shape.origin.z, 1, 1);
         canvas.endShape();   
         canvas.popMatrix();
      }
   }
}
