class Genome{
  
  boolean is_register = true;
  HashMap<Integer , NodeGene> node_gene = new HashMap<Integer , NodeGene>();
  HashMap<ArrayList<Integer> , ConnectionGene> connection_gene = new HashMap<ArrayList<Integer> , ConnectionGene>();
  
  Genome(){
    node_gene.put(-2,new NodeGene(0));
    node_gene.put(-1,new NodeGene(0));
  }

  boolean is_node_exist( int _key){
    if(node_gene.get( _key ) != null)
      return true;
    return false;
  }
  
  boolean is_connection_exist( ArrayList<Integer> _keys){
    if(connection_gene.get(_keys) != null)
      return true;
    return false;
  }
  
  void add_node(int _key ,NodeGene _node){
    node_gene.put( _key , _node);
  }
  
  void add_connection( ArrayList<Integer> _keys , ConnectionGene _connection){
    connection_gene.put( _keys , _connection);
  }
  
  void display( int p_size ){
    
    
    
    for (Object key : node_gene.keySet()) {
     pattarn_rotate_count++;
     pushMatrix();
     rotateZ(pattarn_rotate_count / p_size * TWO_PI);
     int gk = Integer.parseInt(key.toString());
     PVector start = new PVector(50,0);
     node_gene.get(gk).setPosition(start);
     node_gene.get(gk).display(p_size);
     popMatrix();
     PVector start_to_connection = new PVector(50*cos(pattarn_rotate_count / p_size * TWO_PI) , 50*sin(pattarn_rotate_count / p_size * TWO_PI));
     node_gene.get(gk).setPosition(start_to_connection);  
    }
    
    
    
    for (ArrayList<Integer> c_key : connection_gene.keySet()) {
      
      ArrayList<Integer> ck = connection_gene.get(c_key).get_keys();
      
      PVector start = new PVector();
      PVector end = new PVector();
      
      for (Object key : node_gene.keySet()) {
        int gk = Integer.parseInt(key.toString());
        if( ck.get(0) == gk)
          start = node_gene.get(gk).start_position;
          
        if( ck.get(1) == gk)
          end = node_gene.get(gk).start_position;
      }
      
      PVector temp;
      if(ck.get(0) > ck.get(1)){
        temp = end;
        end = start;
        start = temp;
      }
      
      connection_gene.get(c_key).setPosition(start , end);
      connection_gene.get(c_key).display( p_size );
      
    }
  }
  
  int get_node_size(){
    return node_gene.size();
    
  }
  
  void reset(){
    
    for (Object key : node_gene.keySet()) {
      int gk = Integer.parseInt(key.toString());
      node_gene.get(gk).is_register = false;
    }
    
    for (ArrayList<Integer> c_key : connection_gene.keySet()){
      ArrayList<Integer> ck = connection_gene.get(c_key).get_keys();
      connection_gene.get(ck).is_register = false;
    }
    
  }
  void clean(){
    
    Iterator iterator_n = node_gene.keySet().iterator();
    while(iterator_n.hasNext()){
      Object o = iterator_n.next();
      int gk = Integer.parseInt(o.toString());
      if( !node_gene.get(gk).is_register ){
        iterator_n.remove();
      }
    }
    
    Iterator iterator_c = connection_gene.keySet().iterator();
    while(iterator_c.hasNext()){
      Object o = iterator_c.next();
      ArrayList<Integer> ck = (ArrayList<Integer>)o;
      if( !connection_gene.get(ck).is_register ){
        iterator_c.remove();
      }
    }

  }
  
}