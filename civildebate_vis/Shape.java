import processing.core.*;
public class Shape
{
   public PVector origin;
   public PImage texture;
   public int answer;
   public float ratio;
   public boolean bg = false;
   
   public Shape(PVector _origin, PImage _texture, int _answer, float _ratio)
   {
      origin = _origin;
      texture = _texture;
      answer = _answer;
      ratio = _ratio;
   }
}
