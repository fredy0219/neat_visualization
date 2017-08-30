import processing.net.*; 
import java.util.Iterator;
import java.lang.Math;

Client myClient;
String dataIn; 

ArrayList<Species> species_list = new ArrayList<Species>();
NodeGene ng;

int pattarn_size = 0;
float pattarn_rotate_count = 0;
boolean have_new_data = false;
float rrr = 0;

color define_color[];
void setup(){
  myClient = new Client(this, "127.0.0.1", 12345);
  //checkSocketConnection();
  fullScreen(P3D); 
  //size(800,800,P3D);

  
  define_color = new color[10];
  
  for( int i = 0 ; i < 10 ; i++)
    define_color[i] = color(random(255),random(255),random(255));
  
  define_color[0] = #e7dda9;
  define_color[1] = #cac29d;
  define_color[2] = #ada891;
  define_color[3] = #908d85;
  define_color[4] = #747379;
  define_color[5] = #57586d;
  define_color[6] = #3a3e61;
  define_color[7] = #BCD2EE;
  define_color[8] = #AEEEEE;
  define_color[9] = #FFA07A;

  textMode(SHAPE);
  
  init();
  delay(1000);
}
void update(){
  
}

void draw(){
  background(0);
  text(frameRate , 10,10);
  translate(width/2 , height/2);
  
  for(int i = 0 ; i < species_list.size() ; i++){
    species_list.get(i).display( pattarn_size );
  }
  pattarn_rotate_count = 0;

  
  //checkSocketConnection();
  
  String r = "refresh\n";
  if(myClient.available() > 0 ){
    dataIn = myClient.readStringUntil(10);
    if(r.equals(dataIn))
      init();
  }
}

void init(){
  //have_new_data = true;
  pattarn_size = 0;
  data_refresh();
  
  for(int i = 0 ; i < species_list.size() ; i++){
     pattarn_size += species_list.get(i).get_total_node_size();
     species_list.get(i).set_color( define_color[i]);
  }
}

void checkSocketConnection(){
  
  while( !myClient.active() ){
    println("fail connect");
    println("reconnecting...");
    myClient = new Client(this, "127.0.0.1", 12345);
  }
  
}