class NodeGene{
  
  
  PVector start_position = null;
  PVector end_position = new PVector(0,0);
  PVector target_position = new PVector(0,0);
  boolean is_register = true;
  
  float bias = 0;
  float target_bias = 0;
  
  float yoff = 0;
  float xoffappend = 0;
  
  NodeGene(float _bias){
    this.bias = map(_bias , -5,5,1,6);
    xoffappend = random(0,1);
  }
  
  void setPosition( PVector start){
    
    if(start_position == null){
      start_position = start;
      end_position = new PVector(start_position.x* bias,start_position.y* bias);
      target_position = end_position; 
    }else{
      float end_scale = end_position.x / start_position.x;
      start_position = start;
      end_position = new PVector( start_position.x * end_scale , start_position.y * end_scale);
      if(target_bias == 0)
        target_position = end_position;
      else
        target_position = new PVector(start_position.x* target_bias , start_position.y* target_bias);
    }
  }
  
  void setEndPosition(){
    
    float scale = end_position.x / start_position.x;
    end_position = new PVector( start_position.x * scale , start_position.y * scale);
  }
  
  void setTargetPosition(){
    this.target_position = new PVector(start_position.x* target_bias , start_position.y* target_bias);
  }
  
  
  void update( float t_bias){
    this.is_register = true;
    this.target_bias = map(t_bias , -5,5,1,6);
    this.target_position = new PVector(start_position.x* target_bias , start_position.y* target_bias);
  }
  
  void display( int p_size ){
    float s = random( 5 , 10);
    //end_position = PVector.lerp(end_position , PVector.mult(target_position , s) ,0.1 );
    end_position = PVector.lerp(end_position , target_position,0.1 );
    float tempx = 0 , tempy = 0;
    if(bias != 3.5){
      float xoff = 0;
      
    
      noFill();
      if( Math.signum( start_position.x - end_position.x) == 5) {
        beginShape();
        for (float x = start_position.x; x >= end_position.x; x -= 5) {
          float y = map(noise(xoff, yoff), 0, 1, -5 , 5);
          tempx = x;
          tempy = y;
          vertex(x, y); 
          xoff += xoffappend;
        }
        endShape();
      }else{
        beginShape();
        for (float x = start_position.x; x <= end_position.x; x += 5) {
          float y = map(noise(xoff, yoff), 0, 1, -5 , 5); 
          
          tempx = x;
          tempy = y;
          vertex(x, y); 
          xoff += xoffappend;
        }
        endShape();
      }
    pushStyle();
    
    noFill();
    strokeWeight(s);
    if( tempx != 0 && tempy !=0)
      point(tempx ,tempy);
    popStyle();
    textSize(8);
    text(bias , end_position.x *1.2, end_position.y *1.2);
   }
  }
}
  

class ConnectionGene{
  
  PVector start_position;
  PVector end_position;
  
  boolean is_register = true;
  
  ArrayList<Integer> keys;
  float weight = 0;
  float target_weight;
  
  float yoff = 0;
  
  ConnectionGene(ArrayList<Integer> _keys , float _weight){
    this.keys = _keys;
    this.weight = _weight;
    target_weight = _weight;
  }
  
  ArrayList<Integer> get_keys(){
    return this.keys;
  }
  
  void setPosition( PVector start , PVector end){
    start_position = start;
    end_position = end;
  }
  
  void update( float t_weight){
    is_register = true;
    this.target_weight = t_weight;
    
  }
  
  void display(int p_size){

    strokeWeight( weight * 3);
    if(start_position.x != 0)
      point( start_position.x , start_position.y);

  }
}