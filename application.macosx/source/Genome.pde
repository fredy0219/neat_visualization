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
  
  void setKey(int _key){
    index = _key;
  }
  
  void add_node(NodeGene _node){
    node_gene.add(_node);
  }
  
  void add_connection( ConnectionGene _connection){
    connection_gene.add(_connection);
  }
  
  void display(int p_size){
    
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
  
  int get_node_size(){
    
    return node_gene.size();
    
  }
  
}