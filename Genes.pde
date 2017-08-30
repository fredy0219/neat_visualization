class NodeGene{
  
  
  PVector start_position = null;
  PVector end_position = new PVector(0,0);
  PVector target_position = new PVector(0,0);
  boolean is_register = true;
  
  float real_bias = 0;
  float target_real_bias = 0;
  float bias = 0;
  float target_bias = 0;
  
  float yoff = 0;
  float xoffappend = 0;
  
  float bias_min = 0.5;
  float bias_max = 4;
  
  NodeGene(float _bias){
    this.real_bias = _bias;
    this.target_real_bias = this.real_bias;
    this.bias = revise_bias( _bias);
    
    xoffappend = random(0,1);
  }
  
  float revise_bias( float init_bias){
    
    float _bias = map(abs(init_bias)+1   , 0,2,bias_min,bias_max);
    
    if( _bias == bias_min || _bias == bias_max)
      _bias =  _bias+random(-0.5,0.5);
      
    return _bias;
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
  
  void setTargetPosition(){
    this.target_position = new PVector(start_position.x* target_bias , start_position.y* target_bias);
  }
  
  
  void update( float t_bias){
    this.is_register = true;
    
    this.target_real_bias = t_bias;
    this.target_bias = revise_bias( t_bias);
    
    PVector start = new PVector(100,0);
    this.target_position = new PVector(start.x* target_bias , start.y* target_bias);
  }
  
  void display( ){
    float s = random( 10 , 15);
    //end_position = PVector.lerp(end_position , PVector.mult(target_position , s) ,0.1 );
    
    end_position = PVector.lerp(end_position , target_position,0.1 );
    float tempx = 0 , tempy = 0;
    if(bias != (bias_min+bias_max)/2){
      float xoff = 0;
      
      strokeWeight(1);
      noFill();
      if( Math.signum( start_position.x - end_position.x) == 1) {
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
      
      //fill(255,255,0);
      //textSize(15);
      //real_bias = lerp(real_bias , target_real_bias , 0.1);
      //PVector text_vector = new PVector();
      //end_position.normalize(text_vector);
      //text(real_bias , end_position.x +text_vector.x*100, end_position.y+text_vector.x*100);
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