class Species{
  
  Genome repersentative;
  ArrayList<Genome> genomes = new ArrayList<Genome>();
  
  color scolor ;
  Species(){
  }
  
  void set_color( color c){
    
    scolor = c;
  }
  
  void add_genome(Genome _genome){
    genomes.add( _genome );
  }
  
  void display( int p_size ){
    
    for(int i = 0 ; i < genomes.size() ; i++){
      pushStyle();
      stroke(scolor);
      genomes.get(i).display( p_size );
      popStyle();
    }

  }
  
  float get_species_angle_percent( int p_size ){
    
    return this.get_total_node_size() / p_size;
  }
  
  int get_total_node_size(){
    
    int total = 0;
    for(int i = 0 ; i < genomes.size() ; i++)
      total += genomes.get(i).get_node_size();
    
    return total;
    
  }
  
}