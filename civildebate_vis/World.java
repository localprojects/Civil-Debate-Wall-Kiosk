import processing.core.*;
import processing.opengl.PGraphicsOpenGL;
import java.io.File;
import java.io.FilenameFilter;
import java.util.*;
import java.util.Map.Entry;
import javax.media.opengl.GL;

public class World
{
   public static HashMap<String, ArrayList<PImage>> silhouettes;
   public static HashMap<String, ArrayList<Shape>> shapes;
   public static float SCALE = 0.8f;
   static String colormap[] = {"Blue", "Green", "Red"}; 
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
   
   static class PNGFilter implements FilenameFilter {
      public boolean accept(File dir, String name) {
          return (name.endsWith(".png"));
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
         File f = new File(canvas.dataPath("") + "/Silhouettes/" + e.getKey());
        //         File f = new File("."); 
          //       canvas.println(f.getAbsolutePath()); 
         //canvas.println(f.getAbsolutePath() + " -- " + f.isDirectory());       
         File files[] = f.listFiles(new PNGFilter());    
         int i = 0;        
         for(File file : files)
         {
           //if(i > 3) break;
            e.getValue().add(canvas.loadImage(file.getPath()));
            i++;
         } 
      }  
   }
   
   public static void generateView(PApplet canvas, DbData data, HashMap<String, PVector> coordinates)
   {
      int active = data.choice_answer_number - 1; //RED
      for(int i = 0; i < NUM_ANSWERS; i++)
      {
            ArrayList<PImage> pics = silhouettes.get(colormap[i] + "/Androgynous");
            pics.addAll(silhouettes.get(colormap[i] + "/Men"));
            pics.addAll(silhouettes.get(colormap[i] + "/Women"));
            
            shapes.get(colormap[i]).clear();

            Collections.shuffle(pics);
            // TODO still faking it a bit
            for(int n = 0; n < data.numPositiveRatingsPerAnswer[i] + 1; n++)
            {
               PImage img;
               if(i != active)
                  img = pics.get(n % pics.size());
               else {
                  String genderKey = "/Androgynous";
                  if(data.choice_user_gender.equals("male"))
                     genderKey = "/Men";
                  else if(data.choice_user_gender.equals("female"))
                     genderKey = "/Women";
                  
                  ArrayList<PImage> genderpics = silhouettes.get(colormap[i] + genderKey);
                  img = genderpics.get(n % genderpics.size());
               }
                  
               
               float ratio = (float)img.height/(float)img.width;
               //canvas.println(ratio);
               Shape s = new Shape(new PVector(
                                          canvas.random((i-1)*350 + (i==active ? 450 : 350), (i-1)*350 + (i==active ? 550 : 650)), 
                                          650,
                                          canvas.random((i==active ? -5 : -200), 0)), 
                                  img, i, ratio);
               shapes.get(colormap[i]).add(s);
               
               if(i == active)
               {
                   PVector o = PVector.add(s.origin, new PVector(-s.texture.width/2*SCALE, -s.texture.height/2*SCALE, .0f));
                   coordinates.put("bubbleOrigin", o);
                   break;
               }
               
           
            }
      }
      
      // now random BG people
      ArrayList<PImage> pics = new ArrayList<PImage>();
      for(ArrayList<PImage> list : silhouettes.values())
      {
         pics.addAll(list);
      }
      
      Collections.shuffle(pics);
      
      for(int i = 0; i < 30; i++)
      {
         PImage img = pics.get(i % pics.size());
         float ratio = (float)img.height/(float)img.width;
         Shape s = new Shape(new PVector(
               canvas.random(-1024, 2048), 
               640,
               canvas.random(-500, -2000)), 
               img, i, ratio);
         s.bg = true;
         shapes.get(colormap[i%3]).add(s);
      }

      
   }
   
   public static void draw(PApplet canvas, DbData data, HashMap<String, PVector> coordinates, int roundTimer)
   {
      float aspect = (canvas.width)/(canvas.height);
    //  canvas.perspective(canvas.PI/2.0f, (int)(canvas.width/canvas.height), 1.0f, 100000.0f) ; 
    // canvas.camera((canvas.width/2.0f), -(canvas.height)/2.0f, 700.0f,
     //      (canvas.width/2.0f), -(canvas.height)/2.0f, .0f,
      //               .0f, 1.0f, .0f);
      //canvas.camera(canvas.width/2.0f, canvas.height/2.0f+200.0f, (canvas.height/2.0f), canvas.width/2.0f, canvas.height/2.0f, 0.0f, 0.0f, 1.0f, 0.0f);
      canvas.color(255);
      canvas.textureMode(PApplet.NORMALIZED);
       
      ArrayList<Shape> allShapes = new ArrayList<Shape> ();    
      for(int i = 0; i < NUM_ANSWERS; i++)
      {
         ArrayList<Shape> shapeList = shapes.get(colormap[i]);     
         allShapes.addAll(shapeList);
      }
      
      Collections.sort(allShapes, new ZComparator()); 
      //canvas.stroke(230);
      canvas.noStroke();
      for(Shape shape : allShapes)
      {   
         float ratio = shape.ratio;
         canvas.pushMatrix();     
         canvas.beginShape(canvas.QUADS);   
            int brightness = !shape.bg ? (int)shape.origin.z/4+100 : (int)canvas.map(shape.origin.z, -500, -2000, 20, 5);
            int alphaVal = 0;
            if(roundTimer < 2000)              
            { alphaVal= (int)canvas.map(roundTimer, 0, 2000, 0, 255); }
            else 
            { alphaVal= (int)canvas.map(roundTimer, 13000, 15000, 255, 0); }
            canvas.tint(brightness, alphaVal);
            
            canvas.texture(shape.texture);        
            float sz = SCALE*(1.0f-(-shape.origin.z/2000.0f));
            canvas.vertex(shape.origin.x + shape.texture.width/2 * sz, shape.origin.y + shape.texture.height/2 * sz, shape.origin.z, 0, 1);    
            canvas.vertex(shape.origin.x + shape.texture.width/2 * sz, shape.origin.y - shape.texture.height/2 * sz, shape.origin.z, 0, 0);           
            canvas.vertex(shape.origin.x - shape.texture.width/2 * sz, shape.origin.y - shape.texture.height/2 * sz, shape.origin.z, 1, 0);
            canvas.vertex(shape.origin.x - shape.texture.width/2 * sz, shape.origin.y + shape.texture.height/2 * sz, shape.origin.z, 1, 1);
         canvas.endShape();   
         
         canvas.popMatrix();
      }
      
      canvas.fill(200);
      PVector o = coordinates.get("bubbleOrigin");
 /*     
      canvas.beginShape(canvas.QUADS);
         canvas.vertex(o.x-10,o.y-10,o.z);
         canvas.vertex(o.x-10,o.y+10,o.z);
         canvas.vertex(o.x+10,o.y+10,o.z);
         canvas.vertex(o.x+10,o.y-10,o.z);
      canvas.endShape(); 
   */   
   }
}
