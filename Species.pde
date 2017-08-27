class Species{
  
  Genome repersentative;
  
  //Genomes Map -> (Key , Genome)
  HashMap<Integer , Genome> genomes = new HashMap<Integer , Genome>();
  
  color scolor ;
  Species(){
  }
  
  void set_color( color c){
    scolor = c;
  }
  
  void add_genome(int _key , Genome _genome){
    this.genomes.put( _key , _genome);
  }
  
  boolean is_genome_exist( int _key){
    if(genomes.get( _key ) != null)
      return true;
    return false;
  }
  
  
  void display( int p_size ){
    
    for (Object key : genomes.keySet()) {
      int gk = Integer.parseInt(key.toString());
      pushStyle();
      stroke(scolor);
      genomes.get( gk ).display( p_size);
      popStyle();
      
    }
    
  }
  
  int get_total_node_size(){
    
    int total = 0;
    for (Object key : genomes.keySet()) {
      int gk = Integer.parseInt(key.toString());
      total += genomes.get(gk).get_node_size();
    }
    return total;
  }
  
  void reset(){
    
    for (Object key : genomes.keySet()) {
      int gk = Integer.parseInt(key.toString());
      genomes.get(gk).is_register = false;
      genomes.get(gk).reset();
    }
  }
  
  void clean(){
    
    Iterator iterator = genomes.keySet().iterator();
    while(iterator.hasNext()){
      Object o = iterator.next();
      int gk = Integer.parseInt(o.toString());
      if( !genomes.get(gk).is_register )
        iterator.remove();
      else{
        genomes.get(gk).clean();
      }
    }
  }
  

}