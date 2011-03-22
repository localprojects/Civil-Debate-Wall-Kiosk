import processing.core.*;

public class Shape
{
   public PVector origin;
   public PImage texture;
   public int answer;
   
   public Shape(PVector _origin, PImage _texture, int _answer)
   {
      origin = _origin;
      texture = _texture;
      answer = _answer;
   }
}
