import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class neat_visaulization extends PApplet {

 

JSONArray json;
Client myClient;
String dataIn; 

ArrayList<Species> species_list = new ArrayList<Species>();
NodeGene ng;

int pattarn_size = 0;
float pattarn_rotate_count = 0;
float rrr = 0;

int define_color[];

public void setup(){
  myClient = new Client(this, "127.0.0.1", 12345); 
  //fullScreen(P3D); 
  
  
  
  //println(pattarn_size);
  
  define_color = new int[10];
  
  for( int i = 0 ; i < 10 ; i++)
    define_color[i] = color(random(255),random(255),random(255));
  
  delay(1000);
     
}


public void draw(){
  
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

public void init(){
  
  pattarn_size = 0;
  data_clear();
  data_refresh();
  data_processing();
  
  for(int i = 0 ; i < species_list.size() ; i++){
     
     pattarn_size += species_list.get(i).get_total_node_size();
     species_list.get(i).set_color( define_color[i]);
  }
  
}

public void keyPressed(){
  
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
public void data_refresh(){
  
  json = loadJSONArray("data.json");
  
}

public void data_clear(){
  
  species_list.clear();
  
}
public void data_processing(){
  
  JSONArray j_species[] = new JSONArray[ json.size() ];

  for(int i = 0 ; i<json.size() ; i++){
    
    j_species[i] = json.getJSONArray(i);
    JSONObject members[] = new JSONObject[j_species[i].size()];
    
    Species species = new Species();
    for(int j = 0 ; j < j_species[i].size() ;j++){
      
      members[j] = j_species[i].getJSONObject(j);
      
      JSONArray j_connections = new JSONArray();
      //JSONArray j_connections[] = new JSONArray[members[j].size()];
      JSONArray j_nodes = new JSONArray();

      Genome new_genome = new Genome();
      int genome_key = members[j].getInt("key");
      new_genome.setKey(genome_key);
        
      j_connections = members[j].getJSONArray("connections");
      j_nodes = members[j].getJSONArray("nodes");
        
      JSONObject connection[] = new JSONObject[j_connections.size()];
      for(int c = 0 ; c < j_connections.size() ; c++){
          
        connection[c] = j_connections.getJSONObject(c);

        JSONArray connection_key = new JSONArray();
        connection_key = connection[c].getJSONArray("key");
        int c_key[] = new int[2];
        c_key[0] = connection_key.getInt(0);
        c_key[1] = connection_key.getInt(1);
        
        float weight = connection[c].getFloat("weight");
          
        ConnectionGene new_connection = new ConnectionGene(c_key , weight);
          
        new_genome.add_connection( new_connection );
        }
        
        JSONObject node[] = new JSONObject[j_nodes.size()];
        for(int n = 0 ; n < j_nodes.size() ; n++){
          node[n] = j_nodes.getJSONObject(n);
          
          int n_key = node[n].getInt("key");
          float bias = node[n].getFloat("bias");
          println(bias);
          
          NodeGene new_node = new NodeGene( n_key , bias);
          new_genome.add_node( new_node );
        }

        species.add_genome( new_genome );
    }
    species_list.add( species );
  }
}
class NodeGene{
  
  PVector start_position;
  
  int key = 0;
  float bias;
  NodeGene(int _key , float _bias){
    this.key = _key;
    this.bias = _bias;
  }
  
  public void setPosition( PVector start){
    start_position = start;
  }
  
  public void display( int p_size ){
    
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
  
  public int[] get_keys(){
    return this.keys;
  }
  
  public void setPosition( PVector start , PVector end){
    start_position = start;
    end_position = end;
  }
  
  public void display(int p_size){
    
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
class Genome{
  
  int index;
  //HashMap<Integer , NodeGene> node_gene;
  //HashMap<Integer , ConnectionGene> connection_gene;
  ArrayList <NodeGene> node_gene = new ArrayList <NodeGene>();
  ArrayList <ConnectionGene> connection_gene = new ArrayList <ConnectionGene>();
  
  Genome(){
    node_gene.add(new NodeGene(-2,0));
    node_gene.add(new NodeGene(-1,0));
  }
  
  public void setKey(int _key){
    index = _key;
  }
  
  public void add_node(NodeGene _node){
    node_gene.add(_node);
  }
  
  public void add_connection( ConnectionGene _connection){
    connection_gene.add(_connection);
  }
  
  public void display(int p_size){
    
    for(int i = 0 ; i < node_gene.size() ; i++){
      pattarn_rotate_count++;
      PVector start = new PVector(100*cos(pattarn_rotate_count / p_size * TWO_PI) , 100*sin(pattarn_rotate_count / p_size * TWO_PI));
      node_gene.get(i).setPosition(start);
      node_gene.get(i).display( p_size );
    }
      
    for(int i = 0 ; i < connection_gene.size() ; i++ ){
      int keys[] = connection_gene.get(i).get_keys();
      
      PVector start = new PVector();
      PVector end = new PVector();
      for(int j = 0 ; j < node_gene.size() ; j++){
        
        if(keys[0] == node_gene.get(j).key)
          start = node_gene.get(j).start_position;
          
        if(keys[1] == node_gene.get(j).key)
          end = node_gene.get(j).start_position;
      }
      PVector temp;
      if(keys[0] > keys[1]){
        temp = end;
        end = start;
        start = end;
      }
        
      
      connection_gene.get(i).setPosition(start , end);
      connection_gene.get(i).display( p_size );
    }
    

  }
  
  public int get_node_size(){
    
    return node_gene.size();
    
  }
  
}
class Species{
  
  Genome repersentative;
  ArrayList<Genome> genomes = new ArrayList<Genome>();
  
  int scolor ;
  Species(){
  }
  
  public void set_color( int c){
    
    scolor = c;
  }
  
  public void add_genome(Genome _genome){
    genomes.add( _genome );
  }
  
  public void display( int p_size ){
    
    for(int i = 0 ; i < genomes.size() ; i++){
      pushStyle();
      stroke(scolor);
      genomes.get(i).display( p_size );
      popStyle();
    }

  }
  
  public float get_species_angle_percent( int p_size ){
    
    return this.get_total_node_size() / p_size;
  }
  
  public int get_total_node_size(){
    
    int total = 0;
    for(int i = 0 ; i < genomes.size() ; i++)
      total += genomes.get(i).get_node_size();
    
    return total;
    
  }
  
}

  public void settings() {  size(800,800,P3D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "neat_visaulization" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
