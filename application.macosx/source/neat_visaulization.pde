import processing.net.*; 

JSONArray json;
Client myClient;
String dataIn; 

ArrayList<Species> species_list = new ArrayList<Species>();
NodeGene ng;

int pattarn_size = 0;
float pattarn_rotate_count = 0;
float rrr = 0;

color define_color[];

void setup(){
  myClient = new Client(this, "127.0.0.1", 12345); 
  //fullScreen(P3D); 
  size(800,800,P3D);
  smooth();
  
  //println(pattarn_size);
  
  define_color = new color[10];
  
  for( int i = 0 ; i < 10 ; i++)
    define_color[i] = color(random(255),random(255),random(255));
  
  delay(1000);
     
}


void draw(){
  
  background(0);
  translate(width/2 , height/2);
  
  for(int i = 0 ; i < species_list.size() ; i++){
    
    species_list.get(i).display( pattarn_size );

  }
  pattarn_rotate_count = 0;
  
  String r = "refresh\n";
  
  //print(r);
  
  if(myClient.available() > 0 ){
    
    dataIn = myClient.readStringUntil(10);
    if(r.equals(dataIn))
      init();
  }
}

void init(){
  
  pattarn_size = 0;
  data_clear();
  data_refresh();
  data_processing();
  
  for(int i = 0 ; i < species_list.size() ; i++){
     
     pattarn_size += species_list.get(i).get_total_node_size();
     species_list.get(i).set_color( define_color[i]);
  }
  
}

void keyPressed(){
  
  println("pressed");
  pattarn_size = 0;
  data_clear();
  data_refresh();
  data_processing();
  
  for(int i = 0 ; i < species_list.size() ; i++){
     
     pattarn_size += species_list.get(i).get_total_node_size();
     species_list.get(i).set_color(define_color[i]);
  }
  
  
}