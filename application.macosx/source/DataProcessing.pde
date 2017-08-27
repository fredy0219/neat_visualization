void data_refresh(){
  
  json = loadJSONArray("data.json");
  
}

void data_clear(){
  
  species_list.clear();
  
}
void data_processing(){
  
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