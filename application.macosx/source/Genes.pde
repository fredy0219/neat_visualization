class NodeGene{
  
  PVector start_position;
  
  int key = 0;
  float bias;
  NodeGene(int _key , float _bias){
    this.key = _key;
    this.bias = _bias;
  }
  
  void setPosition( PVector start){
    start_position = start;
  }
  
  void display( int p_size ){
    
    //rotateZ( TWO_PI / p_size);
    //line(start_position.x , start_position.y , end_position.x,end_position.y);
    
    float scale= map(bias , -5,5 , 1,4);
    println(bias);
    text(bias , start_position.x*scale, start_position.y*scale);
    line(start_position.x,start_position.y,start_position.x*scale,start_position.y*scale);
  }
  
  
}

class ConnectionGene{
  
  PVector start_position;
  PVector end_position;
  
  int keys[] = {0,0};
  float weight;
  boolean enable;
  
  ConnectionGene(int _keys[] , float _weight){
    this.keys = _keys;
    this.weight = _weight;
    //this.enable = _enable;
  }
  
  int[] get_keys(){
    return this.keys;
  }
  
  void setPosition( PVector start , PVector end){
    start_position = start;
    end_position = end;
  }
  
  void display(int p_size){
    
    PVector middle_point = new PVector( (start_position.x + end_position.x)/2 ,
                                          (start_position.y + end_position.y)/2);
    float diameter = start_position.dist(end_position);
    //float start_angle = PVector.angleBetween( middle_point , start_position);
    //float end_angle =  PVector.angleBetween( middle_point , end_position);
    
    noFill();
    PVector n = new PVector(1,0);
    PVector o_m = PVector.sub(new PVector(0,0) , middle_point);
    o_m.normalize();
    o_m.mult(10);
    //o_m.add(middle_point);
    beginShape();
    curveVertex(start_position.x,start_position.y);
    curveVertex(start_position.x,start_position.y);
    curveVertex(PVector.add(middle_point , o_m).x,PVector.add(middle_point,o_m).y);
    curveVertex(end_position.x,end_position.y);
    curveVertex(end_position.x,end_position.y);
    
    endShape();
    
    //pushMatrix();
    //curve(middle_point.x-50,middle_point.y-50,start_position.x,start_position.y , end_position.x,end_position.y,end_position.x,end_position.y);

    //translate(middle_point.x,middle_point.y);
    
    //ellipse(0,0,diameter,diameter);
    ////rotateZ(rrr);
   
    //rotateZ(PVector.angleBetween(n,o_m)-PI/2);
    //float b = PI - PVector.angleBetween(n,o_m) - PI/4;

    //rotateZ(abs(TWO_PI - abs(PVector.angleBetween(n,o_m)) - PI/2));
    //arc(0 , 0
    //    ,diameter,diameter
    //    ,0,PI);
    //popMatrix();
  }
}