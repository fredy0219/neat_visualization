void data_refresh(){
  
  for(int i = 0 ; i < species_list.size() ; i++){
    species_list.get(i).reset();
  }
  
  JSONArray json = loadJSONArray("data.json");
  JSONArray j_species[] = new JSONArray[ json.size() ];
  
  int s_size = species_list.size();
  for(int i = 0 ; i<json.size() ; i++){
    
    j_species[i] = json.getJSONArray(i);
    
    if( i < s_size)
      update_species( i , j_species[i]);
    else{
      Species species = create_species( i , j_species[i]);
      species_list.add(species);
    }
  }
  
  //Clean
  for(int i = 0 ; i < species_list.size() ; i++){
    species_list.get(i).clean();
  }
  
}

void update_species(int species_key,  JSONArray j_species){
  JSONObject genomes[] = new JSONObject[j_species.size()];
  
  for(int j = 0 ; j < j_species.size() ;j++){
    genomes[j] = j_species.getJSONObject(j);
    int genome_key = genomes[j].getInt("key");
    JSONArray j_nodes = genomes[j].getJSONArray("nodes");
    JSONArray j_connections = genomes[j].getJSONArray("connections");
    if( species_list.get( species_key ).is_genome_exist(genome_key)){//update genome according by genome key
      species_list.get( species_key ).genomes.get(genome_key).is_register = true;
      update_genome( species_key , genome_key , j_nodes , j_connections);
    }
    else{//create new genome
      Genome genome = create_genome( genome_key , j_nodes , j_connections);
      species_list.get(species_key).add_genome(genome_key , genome );
    }
  }
}

Species create_species(int species_key,  JSONArray j_species){

  JSONObject genomes[] = new JSONObject[j_species.size()];
  
  Species species = new Species();
  
  for(int j = 0 ; j < j_species.size() ;j++){
    genomes[j] = j_species.getJSONObject(j);
    int genome_key = genomes[j].getInt("key");
    JSONArray j_connections = genomes[j].getJSONArray("connections");
    JSONArray j_nodes = genomes[j].getJSONArray("nodes");
    
    //println("new genome : " + genome_key);
    Genome genome = create_genome(genome_key , j_nodes , j_connections);
    species.add_genome( genome_key , genome);
  }
  return species;
}

void update_genome( int species_key , int genome_key , JSONArray j_nodes , JSONArray j_connections){
 
  //Update node
  JSONObject node[] = new JSONObject[j_nodes.size()];
  for(int n = 0 ; n < j_nodes.size() ; n++){
      node[n] = j_nodes.getJSONObject(n);
      int n_key = node[n].getInt("key");
      float bias = node[n].getFloat("bias");
      //println(bias);
      
      if(species_list.get(species_key).genomes.get(genome_key).is_node_exist(n_key))
        species_list.get(species_key).genomes.get(genome_key).node_gene.get(n_key).update(bias * random(-1,1));
      else
        species_list.get(species_key).genomes.get(genome_key).add_node( n_key , new NodeGene(bias));
  }
  
  //Update connection
  JSONObject connection[] = new JSONObject[j_connections.size()];
  for(int c = 0 ; c < j_connections.size() ; c++){
    
    connection[c] = j_connections.getJSONObject(c);
    JSONArray c_key = connection[c].getJSONArray("key");
    ArrayList<Integer> c_key_list = new ArrayList<Integer>();
    c_key_list.add(c_key.getInt(0));
    c_key_list.add(c_key.getInt(1));  
    float connection_weight = connection[c].getFloat("weight");
    
    if(species_list.get(species_key).genomes.get(genome_key).is_connection_exist( c_key_list ))
      species_list.get(species_key).genomes.get(genome_key).connection_gene.get(c_key_list).update(connection_weight);
    else
      species_list.get(species_key).genomes.get(genome_key).add_connection( c_key_list , new ConnectionGene( c_key_list , connection_weight));
    
  }
  

}

Genome create_genome(int genome_key , JSONArray j_nodes , JSONArray j_connections ){
  
  //Create nodes
  JSONObject node[] = new JSONObject[j_nodes.size()];
  Genome new_genome = new Genome();
  
  for(int n = 0 ; n < j_nodes.size() ; n++){
    node[n] = j_nodes.getJSONObject(n);
    int node_key = node[n].getInt("key");
    float node_bias = node[n].getFloat("bias");
    new_genome.add_node( node_key , new NodeGene(node_bias));
  }
  //Create connections
  
  JSONObject connection[] = new JSONObject[j_connections.size()];
  for(int c = 0 ; c < j_connections.size() ; c++){
    connection[c] = j_connections.getJSONObject(c);
    JSONArray c_key = connection[c].getJSONArray("key");
    ArrayList<Integer> c_key_list = new ArrayList<Integer>();
    c_key_list.add(c_key.getInt(0));
    c_key_list.add(c_key.getInt(1));  
    float connection_weight = connection[c].getFloat("weight");
    
    new_genome.add_connection(c_key_list , new ConnectionGene( c_key_list , connection_weight));
  }
  return new_genome;
}

void data_clear(){
  species_list.clear();
}